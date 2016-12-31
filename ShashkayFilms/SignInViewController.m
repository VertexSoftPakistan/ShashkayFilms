//
//  SignInViewController.m
//  ShashkayFilms
//
//  Created by Nauman on 30/11/2016.
//  Copyright © 2016 VertexSoft. All rights reserved.
//

#import "SignInViewController.h"
#import "PlayerViewController.h"

@interface SignInViewController ()
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (nonatomic, strong) AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails*>* passwordAuthenticationCompletion;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void) viewWillAppear:(BOOL)animated {
    self.password.text = nil;
    self.username.text = self.usernameText;
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SignInButton:(id)sender {
    
    if ([_username.text isEqualToString:@""] && [_password.text isEqualToString:@""]) {
        
        NSLog(@"Enter Username and password");
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter Username and Password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        
    }
    
   else{
        
        NSLog(@"fields not empty");

        [self.username resignFirstResponder];
        [self.password resignFirstResponder];
    
        self.passwordAuthenticationCompletion.result = [[AWSCognitoIdentityPasswordAuthenticationDetails alloc] initWithUsername:self.username.text password:self.password.text];
        [self performSegueWithIdentifier:@"videoPlayer" sender:self];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([@"videoPlayer" isEqualToString:segue.identifier]){
        PlayerViewController *cvc = segue.destinationViewController;
        
        cvc.user.text = self.username.text;
    }
}



-(void) getPasswordAuthenticationDetails: (AWSCognitoIdentityPasswordAuthenticationInput *) authenticationInput  passwordAuthenticationCompletionSource: (AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails *> *) passwordAuthenticationCompletionSource {
    
    self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.usernameText)
            self.usernameText = authenticationInput.lastKnownUsername;
    });
    
}

-(void) didCompletePasswordAuthenticationStepWithError:(NSError*) error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(error){
            [[[UIAlertView alloc] initWithTitle:error.userInfo[@"__type"]
                                        message:error.userInfo[@"message"]
                                       delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"Retry", nil] show];
        }else{
            self.usernameText = nil;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    });
}

@end
