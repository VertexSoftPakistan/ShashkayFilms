//
//  MFAViewController.m
//  ShashkayFilms
//
//  Created by Nauman on 07/12/2016.
//  Copyright © 2016 VertexSoft. All rights reserved.
//

#import "MFAViewController.h"

@interface MFAViewController ()

@property (weak, nonatomic) IBOutlet UITextField *confirmationCode;
@property (weak, nonatomic) IBOutlet UILabel *sentTo;
@property (strong, nonatomic) NSString *destination;
@property (nonatomic,strong) AWSTaskCompletionSource<NSString *>* mfaCodeCompletionSource;

@end

@implementation MFAViewController

- (void) viewWillAppear:(BOOL)animated {
    self.sentTo.text = [NSString stringWithFormat:@"Code sent to: %@", self.destination];
    self.confirmationCode.text = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getMultiFactorAuthenticationCode: (AWSCognitoIdentityMultifactorAuthenticationInput *)authenticationInput mfaCodeCompletionSource: (AWSTaskCompletionSource<NSString *> *) mfaCodeCompletionSource {
    self.mfaCodeCompletionSource = mfaCodeCompletionSource;
    self.destination = authenticationInput.destination;
}


-(void) didCompleteMultifactorAuthenticationStepWithError:(NSError*) error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(error){
            [[[UIAlertView alloc] initWithTitle:error.userInfo[@"__type"]
                                        message:error.userInfo[@"message"]
                                       delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"Retry", nil] show];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    });
}
@end
