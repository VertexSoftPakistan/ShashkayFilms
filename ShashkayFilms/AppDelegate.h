//
//  AppDelegate.h
//  ShashkayFilms
//
//  Created by Nauman on 16/11/2016.
//  Copyright © 2016 VertexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSCognitoIdentityProvider/AWSCognitoIdentityProvider.h>
#import "SignInViewController.h"
#import "MFAViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, AWSCognitoIdentityInteractiveAuthenticationDelegate, AWSCognitoIdentityRememberDevice, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIStoryboard *storyboard;
@property(nonatomic,strong) UINavigationController *navigationController;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property(nonatomic,strong) SignInViewController* signInViewController;
@property(nonatomic,strong) MFAViewController* mfaViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

