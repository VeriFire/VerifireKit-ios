# VerifireKit-ios


## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like AFNetworking in your projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

#### Podfile

To integrate VerifireKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'VerifireKit'
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage

#### Request Verification

```objective-c

self.verifire = [[VFVerifire alloc] initWithKey:<YOUR SDK KEY>];

[self.verifire verifyNumber:phoneNumberString method:VFVerifireMethodSMS completion:^(NSError * _Nullable error) {

    if (! error)
    {
        // Number verification successfylly requested
    }
}];

```


#### Complete Verification

```objective-c

[self.verifire confirmWithCode:PINCode completion:^(NSString * _Nullable phoneNumber, NSString * _Nullable requestId, NSError * _Nullable error) {

    if (! error)
    {
        // Phone number successfully verified
    }

}];
```

