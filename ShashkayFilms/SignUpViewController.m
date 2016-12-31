//
//  SignUpViewController.m
//  ShashkayFilms
//
//  Created by Nauman on 30/11/2016.
//  Copyright © 2016 VertexSoft. All rights reserved.
//

#import "SignUpViewController.h"
#import <AWSCognitoIdentityProvider/AWSCognitoIdentityProvider.h>
#import "ConfirmSignUpViewController.h"

@interface SignUpViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *Password;
@property (strong, nonatomic) IBOutlet UITextField *Phone;
@property (strong, nonatomic) IBOutlet UITextField *Email;



@property (nonatomic, strong) AWSCognitoIdentityUserPool * pool;
@property (nonatomic, strong) NSString* sentTo;
@end

@implementation SignUpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.pool = [AWSCognitoIdentityUserPool CognitoIdentityUserPoolForKey:@"UserPool"];
    
    [TermsAgreement setImage:[UIImage imageNamed:@"Term and Conditions 2.png"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)TermsConditions:(id)sender {
    
    NSLog(@"buttonpressed");
    
  //  [_TermsAgreement setBackgroundImage:[UIImage imageNamed:@"Term and Conditions.png"] forState:UIControlStateSelected];
    [TermsAgreement setImage:[UIImage imageNamed:@"Term and Conditions.png"] forState:UIControlStateNormal];
    
}


- (IBAction)SignUp:(id)sender {
    
    NSLog(@"Register button pressed");
    
    UIImage *image1 = [UIImage imageNamed:@"Term and Conditions 2.png"];
    UIImage *image2 = [UIImage imageNamed:@"Term and Conditions.png"];
    
    NSLog(@"current image on TermsAgreement Button %@",TermsAgreement.currentBackgroundImage);
    NSLog(@"current image on TermsAgreement Button %@",TermsAgreement.currentBackgroundImage.images);
    NSLog(@"current image on TermsAgreement Button %@",TermsAgreement.currentImage);
    NSLog(@"current image on TermsAgreement Button %@",TermsAgreement.currentImage.images);
    NSLog(@"current image on image1 %@",image1);
    NSLog(@"current image on image1 %@",image1.images);
    NSLog(@"current image on image2 %@",image2);
    NSLog(@"current image on image1 %@",image2.images);
    
    if ([TermsAgreement.currentImage isEqual:image1]){
        
        NSLog(@"terms and conditions not selected");
        
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Accept the Terms and conditions" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
        
    }
    
    else if ([TermsAgreement.currentImage isEqual:image2]) {

        NSMutableArray *attributes = [NSMutableArray new];
    
        AWSCognitoIdentityUserAttributeType *phone = [AWSCognitoIdentityUserAttributeType new];
        phone.name = @"phone_number";
        phone.value = self.Phone.text;
    
        AWSCognitoIdentityUserAttributeType *email = [AWSCognitoIdentityUserAttributeType new];
        email.name = @"email";
        email.value = self.Email.text;
    


        if (![@"" isEqualToString:phone.value]) {
            [attributes addObject:phone];
        }
    
        if (![@"" isEqualToString:email.value]) {
            [attributes addObject:email];
        }
    

        //sign up the user
    
        [self.username resignFirstResponder];
        [self.Password resignFirstResponder];
        [self.Email resignFirstResponder];
    
        [[self.pool signUp:self.username.text password:self.Password.text userAttributes:attributes validationData:nil] continueWithBlock:^id _Nullable(AWSTask<AWSCognitoIdentityUserPoolSignUpResponse *> * _Nonnull task) {
            NSLog(@"Successful signUp user: %@",task.result.user.username);
            dispatch_async(dispatch_get_main_queue(), ^{
                if(task.error){
                    [[[UIAlertView alloc] initWithTitle:task.error.userInfo[@"__type"]
                                            message:task.error.userInfo[@"message"]
                                           delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil] show];
                }else if(task.result.user.confirmedStatus != AWSCognitoIdentityUserStatusConfirmed){
                    self.sentTo = task.result.codeDeliveryDetails.destination;
                    [self performSegueWithIdentifier:@"confirmSignUpSegue" sender:self];
                }
                else{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }});
            return nil;
        }];
    
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([@"confirmSignUpSegue" isEqualToString:segue.identifier]){
        ConfirmSignUpViewController *cvc = segue.destinationViewController;
        cvc.sentTo = self.sentTo;
        cvc.user = [self.pool getUser:self.username.text];
    }
}


/**
 Ensure phone number starts with country code i.e. (+1)
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string; {
    if(textField == self.Phone){
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\+(|\\d)*$" options:0 error:nil];
        NSString *proposedPhone = [self.Phone.text stringByReplacingCharactersInRange:range withString:string];
        if(proposedPhone.length != 0){
            return [regex numberOfMatchesInString:proposedPhone options:NSMatchingAnchored range:NSMakeRange(0, proposedPhone.length)]== 1;
        }
    }
    return YES;
}

@end
