//
//  CodeViewController.m
//  VerifyExample
//
//  Created by Sergey P on 22.09.17.
//  Copyright © 2017 Sergey Popov. All rights reserved.
//

#import "CodeViewController.h"
#import "AppDelegate.h"

#import <VerifireKit/VerifireKit.h>

@interface CodeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *codeField;

@end

@implementation CodeViewController

#pragma mark - Actions

- (IBAction)actionCheckCode:(id)sender
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    VFVerifire *verifire = delegate.veriFire;
    
    __weak __typeof(self) weakSelf = self;
    [verifire confirmWithCode:self.codeField.text completion:^(NSString * _Nullable phoneNumber, NSString * _Nullable requestId, NSError * _Nullable error) {
        
        if (! error)
        {
            [self performSegueWithIdentifier:@"SuccessSegue" sender:sender];
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

@end
