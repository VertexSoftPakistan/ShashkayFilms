//
//  MFAViewController.h
//  ShashkayFilms
//
//  Created by Nauman on 07/12/2016.
//  Copyright © 2016 VertexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSCognitoIdentityProvider/AWSCognitoIdentityProvider.h>

@interface MFAViewController : UIViewController<AWSCognitoIdentityMultiFactorAuthentication>

@end
