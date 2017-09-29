//
//  VFResponseSerializer.m
//  Verifire
//
//  Created by Sergey P on 15.08.17.
//  Copyright © 2017 verifire.io. All rights reserved.
//

#import "VFResponseSerializer.h"

#import "NSObject+VFKeyValueCoding.h"
#import "VFVerifire.h"

@implementation VFResponseSerializer

- (BOOL)validateResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error
{
    BOOL result = [super validateResponse:response data:data error:error];
    
    // Parse the custom server errors
    if (! result && error && (*error).code == NSURLErrorBadServerResponse && [(*error).domain isEqualToString:AFURLResponseSerializationErrorDomain])
    {
        NSError *validationError = nil;
        
        // Workaround for behavior of Rails to return a single space for `head :ok` (a workaround for a bug in Safari), which is not interpreted as valid input by NSJSONSerialization.
        // See https://github.com/rails/rails/issues/1742
        NSStringEncoding stringEncoding = self.stringEncoding;
        if (response.textEncodingName)
        {
            CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)response.textEncodingName);
            if (encoding != kCFStringEncodingInvalidId)
            {
                stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
            }
        }
        
        @autoreleasepool
        {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:stringEncoding];
            if (responseString && ! [responseString isEqualToString:@" "])
            {
                // Workaround for a bug in NSJSONSerialization when Unicode character escape codes are used instead of the actual character
                // See http://stackoverflow.com/a/12843465/157142
                data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
                if (data && data.length > 0)
                {
                    NSError *serializationError = nil;
                    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:self.readingOptions error:&serializationError];
                    if (! serializationError && responseObject)
                    {
                        NSNumber *code = [responseObject numberForKeyPath:@"errorCode"];
                        NSString *reason = [responseObject stringForKeyPath:@"errorReason"];
                        
                        if (code && reason)
                        {
                            NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
                            userInfo[NSLocalizedDescriptionKey] = reason;
                            validationError = [[NSError alloc] initWithDomain:VFVerifireErrorDomain code:code.integerValue userInfo:userInfo];
                        }
                    }
                }
            }
        }
        
        if (validationError && error)
        {
            *error = validationError;
        }
    }
    
    return result;
}

@end
