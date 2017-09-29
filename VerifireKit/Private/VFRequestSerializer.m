//
//  VFRequestSerializer.m
//  Verifire
//
//  Created by Sergey P on 15.08.17.
//  Copyright © 2017 verifire.io. All rights reserved.
//

#import "VFRequestSerializer.h"

#import "VFMacros.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation VFRequestSerializer

#pragma mark - Properties

- (NSString *)userAgent
{
    return [[self valueForHTTPHeaderField:VF_USER_AGENT_HEADER] copy];
}

- (void)setUserAgent:(NSString *)userAgent
{
    if (userAgent)
    {
        if (! [userAgent canBeConvertedToEncoding:NSASCIIStringEncoding])
        {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false))
            {
                userAgent = mutableUserAgent;
            }
        }
        [self setValue:userAgent.copy forHTTPHeaderField:VF_USER_AGENT_HEADER];
    }
}

#pragma mark - Lifecycle

- (instancetype)initWithPublicKey:(NSString *)publicKey privateKey:(NSString *)privateKey
{
    NSParameterAssert(publicKey);
    NSParameterAssert(privateKey);
    
    self = [super init];
    if (self)
    {
        _publicKey = [publicKey copy];
        _privateKey = [privateKey copy];
        
        // Set user agent
        // Yolla/1.9.9 (iPhone; iOS 11.0; Scale/2.00) VerifireKit/1.0
        
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"VerifireKit" withExtension:@"bundle"];
        NSParameterAssert(bundleURL);
        NSBundle *verifireBundle = [NSBundle bundleWithURL:bundleURL];
        NSParameterAssert(verifireBundle);
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSParameterAssert(mainBundle);
        
        NSString *userAgent = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
#if TARGET_OS_IOS
        
        // Defice
        UIDevice *device = [UIDevice currentDevice];
        // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
        userAgent = [NSString stringWithFormat:@"%@ (%@; iOS %@; Scale/%0.2f) %@", BundleNameSlashVersionString(mainBundle), device.model, device.systemVersion, [[UIScreen mainScreen] scale], BundleNameSlashVersionString(verifireBundle)];
        
#elif TARGET_OS_WATCH
        
        // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
        userAgent = [NSString stringWithFormat:@"%@ (%@; watchOS %@; Scale/%0.2f) %@", BundleNameSlashVersionString(mainBunle), [[WKInterfaceDevice currentDevice] model], [[WKInterfaceDevice currentDevice] systemVersion], [[WKInterfaceDevice currentDevice] screenScale], BundleNameSlashVersionString(verifireBundle)];

#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
        
        userAgent = [NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", BundleNameSlashVersionString(mainBunle), [[NSProcessInfo processInfo] operatingSystemVersionString], BundleNameSlashVersionString(verifireBundle)];

#endif
#pragma clang diagnostic pop
        self.userAgent = userAgent;
    }
    return self;
}

#pragma mark - AFHTTPRequestSerializer

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters error:(NSError *__autoreleasing  _Nullable *)error
{
    NSMutableURLRequest *request = [super requestWithMethod:method URLString:URLString parameters:parameters error:error];
    
    // Set public key
    [request setValue:self.publicKey forHTTPHeaderField:VF_AUTHORIZATION_HEADER];
    
    // Set timestamp
    NSString *timestamp = [NSString stringWithFormat:@"%lld", (long long)[NSDate date].timeIntervalSince1970];
    [request setValue:timestamp forHTTPHeaderField:VF_TIMESTAMPT_HEADER];
    
    // Set algo
    [request setValue:@"VF-HMAC256-1" forHTTPHeaderField:VF_ALGORITHM_HEADER];
    
    // Set sign
    [request setValue:SignatureForRequest(request, self.privateKey) forHTTPHeaderField:VF_SIGNATURE_HEADER];
    
    return request;
}

#pragma mark - Functions

static inline NSString *BundleNameSlashVersionString(NSBundle *bundle)
{
    NSDictionary *infoDictionary = [bundle infoDictionary];
    return [NSString stringWithFormat:@"%@/%@", infoDictionary[(__bridge NSString *)kCFBundleExecutableKey] ?: infoDictionary[(__bridge NSString *)kCFBundleIdentifierKey], infoDictionary[@"CFBundleShortVersionString"] ?: infoDictionary[(__bridge NSString *)kCFBundleVersionKey]];
}

static NSData * HMACSHA256dDataFromDataWithKey(NSData *data, NSString *key)
{
    CCHmacContext context;
    const char *keyCString = [key cStringUsingEncoding:NSASCIIStringEncoding];
    CCHmacInit(&context, kCCHmacAlgSHA256, keyCString, strlen(keyCString));
    CCHmacUpdate(&context, [data bytes], [data length]);
    unsigned char digestRaw[CC_SHA256_DIGEST_LENGTH];
    NSUInteger digestLength = CC_SHA256_DIGEST_LENGTH;
    CCHmacFinal(&context, digestRaw);
    return [NSData dataWithBytes:digestRaw length:digestLength];
}

static NSString * SignatureForRequest(NSURLRequest *request, NSString *key)
{
    NSMutableString *mutableString = [NSMutableString string];
    
    // Append method
    [mutableString appendFormat:@"%@\n", request.HTTPMethod ? : @""];
    
    // Append Path
    [mutableString appendFormat:@"%@\n", request.URL.path];
    
    // Append headers
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [[request allHTTPHeaderFields] enumerateKeysAndObjectsUsingBlock:^(NSString *field, id value, __unused BOOL *stop) {
        field = [field lowercaseString];
        if ([field hasPrefix:@"x-"])
        {
            if ([headerFields objectForKey:field])
            {
                value = [[headerFields objectForKey:field] stringByAppendingFormat:@",%@", value];
            }
            [headerFields setObject:value forKey:field];
        }
    }];
    
    NSMutableString *canonicalizedHeaderStrings = [NSMutableString string];
    for (NSString *field in [[headerFields allKeys] sortedArrayUsingSelector:@selector(compare:)])
    {
        id value = [headerFields objectForKey:field];
        [canonicalizedHeaderStrings appendFormat:@"%@:%@\n", field, value];
    }
    [mutableString appendFormat:@"%@", canonicalizedHeaderStrings];
    
    // Data to sign
    NSMutableData *data = [[mutableString dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    
    // Append body
    [data appendData:request.HTTPBody];
    
    // Make signature
    NSString *signature = [HMACSHA256dDataFromDataWithKey(data, key) base64EncodedStringWithOptions:0];
    return signature;
}

@end
