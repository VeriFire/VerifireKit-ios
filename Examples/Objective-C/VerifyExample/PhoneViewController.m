//
//  ViewController.m
//  VerifyExample
//
//  Created by Sergey P on 22.09.17.
//  Copyright © 2017 Sergey Popov. All rights reserved.
//

#import "PhoneViewController.h"
#import "AppDelegate.h"

#import <VerifireKit/VerifireKit.h>

@interface PhoneViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation PhoneViewController

#pragma mark - Actions

- (IBAction)actionGo:(id)sender
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    VFVerifire *verifire = delegate.veriFire;
    
    __weak __typeof(self) weakSelf = self;
    [verifire verifyNumber:self.phoneField.text method:[self selectedVerificationMethod] completion:^(NSError * _Nullable error) {
       
        if (! error)
        {
            [self performSegueWithIdentifier:@"PINSegue" sender:sender];
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [weakSelf.navigationController presentViewController:alert animated:YES completion:nil];
        }
        
    }];
}

#pragma mark - Private

- (NSString *)selectedVerificationMethod
{
    switch (self.segmentedControl.selectedSegmentIndex)
    {
        case 0:
            return VFVerifireMethodSMS;
            
        case 1:
            return VFVerifireMethodVoice;
            
        default:
            return VFVerifireMethodCall;
    }
}

@end
