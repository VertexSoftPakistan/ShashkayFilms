//
//  PlayerViewController.h
//  ShashkayFilms
//
//  Created by Nauman on 19/12/2016.
//  Copyright © 2016 VertexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JWPlayer-iOS-SDK/JWPlayerController.h>


@interface PlayerViewController : UIViewController

@property JWPlayerController * player;
@property (strong, nonatomic) IBOutlet UITextField *user;


@end
