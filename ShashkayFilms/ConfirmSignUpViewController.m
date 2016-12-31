//
//  ConfirmSignUpViewController.m
//  ShashkayFilms
//
//  Created by Nauman on 01/12/2016.
//  Copyright © 2016 VertexSoft. All rights reserved.
//

#import "ConfirmSignUpViewController.h"
#import "SignInViewController.h"

@interface ConfirmSignUpViewController ()

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *code;
@property (strong, nonatomic) IBOutlet UILabel *sendToLabel;

@end

@implementation ConfirmSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.username.text = self.user.username;
    self.sendToLabel.text = [NSString stringWithFormat:@"Code sent to: %@", self.sentTo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)confirm:(id)sender {
    
    [self.code resignFirstResponder];
    
    [[self.user confirmSignUp:self.code.text forceAliasCreation:YES] continueWithBlock: ^id _Nullable(AWSTask<AWSCognitoIdentityUserConfirmSignUpResponse *> * _Nonnull task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(task.error){
                if(task.error){
                    [[[UIAlertView alloc] initWithTitle:task.error.userInfo[@"__type"]
                                                message:task.error.userInfo[@"message"]
                                               delegate:nil
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil] show];
                }
            }else {
                //return to signin screen
                ((SignInViewController *)self.navigationController.viewControllers[0]).usernameText = self.user.username;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        });
        return nil;
    }];
    
}

- (IBAction)resend:(id)sender {
    
    //resend the confirmation code
    [[self.user resendConfirmationCode] continueWithBlock:^id _Nullable(AWSTask<AWSCognitoIdentityUserResendConfirmationCodeResponse *> * _Nonnull task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(task.error){
                [[[UIAlertView alloc] initWithTitle:task.error.userInfo[@"__type"]
                                            message:task.error.userInfo[@"message"]
                                           delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil] show];
            }else {
                [[[UIAlertView alloc] initWithTitle:@"Code Resent"
                                            message:[NSString stringWithFormat:@"Code resent to: %@", task.result.codeDeliveryDetails.destination]
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }
        });
        return nil;
    }];
    
}


@end
