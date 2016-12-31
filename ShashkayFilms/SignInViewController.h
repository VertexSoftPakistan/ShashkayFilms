//
//  SignInViewController.h
//  ShashkayFilms
//
//  Created by Nauman on 30/11/2016.
//  Copyright © 2016 VertexSoft. All rights reserved.
//

#import "ViewController.h"
#import <AWSCognitoIdentityProvider/AWSCognitoIdentityProvider.h>


@interface SignInViewController : ViewController <AWSCognitoIdentityPasswordAuthentication>

@property (nonatomic, strong) NSString * usernameText;

@end
