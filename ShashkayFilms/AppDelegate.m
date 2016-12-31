//
//  AppDelegate.m
//  ShashkayFilms
//
//  Created by Nauman on 16/11/2016.
//  Copyright © 2016 VertexSoft. All rights reserved.
//

#import "AppDelegate.h"
#import <AWSCore/AWSCore.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionEUCentral1
//                                                                                                    identityPoolId:@"eu-central-1:ed74363e-3af2-4e83-823f-553e11f9f0f1"];
//    
//    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionEUCentral1
//                                                                         credentialsProvider:credentialsProvider];
//    
//    
//    AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
    
    //setup logging
    [AWSLogger defaultLogger].logLevel = AWSLogLevelVerbose;
    
    //setup service config
    AWSServiceConfiguration *serviceConfiguration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionEUCentral1 credentialsProvider:nil];
    

    
    //create a pool
    AWSCognitoIdentityUserPoolConfiguration *configuration = [[AWSCognitoIdentityUserPoolConfiguration alloc] initWithClientId:@"6hhfrnt86matgvhhc7qc9f0s1s"  clientSecret:@"9orf92n6um0oejic0tc7qmcntgu2nrfc1v5o4pdmu245phu5tat" poolId:@"eu-central-1:ed74363e-3af2-4e83-823f-553e11f9f0f1"];
    
    [AWSCognitoIdentityUserPool registerCognitoIdentityUserPoolWithConfiguration:serviceConfiguration userPoolConfiguration:configuration forKey:@"UserPool"];
    
    AWSCognitoIdentityUserPool *pool = [AWSCognitoIdentityUserPool CognitoIdentityUserPoolForKey:@"UserPool"];
    
    self.storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    pool.delegate = self;
    
    
    return YES;
}


//set up password authentication ui to retrieve username and password from the user
-(id<AWSCognitoIdentityPasswordAuthentication>) startPasswordAuthentication {
    
    if(!self.navigationController){
        self.navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"signinController"];
    }
    if(!self.signInViewController){
        self.signInViewController = self.navigationController.viewControllers[0];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //rewind to login screen
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        //display login screen if it isn't already visibile
        if(!(self.navigationController.isViewLoaded && self.navigationController.view.window))
        {
            [self.window.rootViewController presentViewController:self.navigationController animated:YES completion:nil];
        }
    });
    return self.signInViewController;
}


//set up mfa ui to retrieve mfa code from end user
-(id<AWSCognitoIdentityMultiFactorAuthentication>) startMultiFactorAuthentication {
    if(!self.mfaViewController){
        self.mfaViewController = [MFAViewController new];
        self.mfaViewController.modalPresentationStyle = UIModalPresentationPopover;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        //if mfa view isn't already visible, display it
        if (!(self.mfaViewController.isViewLoaded && self.mfaViewController.view.window)) {
            //display mfa as popover on current view controller
            UIViewController *vc = self.window.rootViewController;
            [vc presentViewController:self.mfaViewController animated: YES completion: nil];
            
            //configure popover vc
            UIPopoverPresentationController *presentationController =
            [self.mfaViewController popoverPresentationController];
            presentationController.permittedArrowDirections =
            UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight;
            presentationController.sourceView = vc.view;
            presentationController.sourceRect = vc.view.bounds;
        }
    });
    return self.mfaViewController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.vertex.ShashkayFilms" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ShashkayFilms" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ShashkayFilms.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
