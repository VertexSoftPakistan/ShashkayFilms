//
//  ConfirmSignUpViewController.h
//  ShashkayFilms
//
//  Created by Nauman on 01/12/2016.
//  Copyright © 2016 VertexSoft. All rights reserved.
//

#import "ViewController.h"
#import <AWSCognitoIdentityProvider/AWSCognitoIdentityProvider.h>

@interface ConfirmSignUpViewController : ViewController

@property (nonatomic, strong) AWSCognitoIdentityUser * user;
@property (nonatomic, strong) NSString * sentTo;

@end
