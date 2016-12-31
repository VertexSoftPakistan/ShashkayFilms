//
//  PlayerViewController.m
//  ShashkayFilms
//
//  Created by Nauman on 19/12/2016.
//  Copyright © 2016 VertexSoft. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()


@property (strong, nonatomic) IBOutlet UILabel *playbackTime;
@property (strong, nonatomic) IBOutlet UIButton *playButton;

@end

@implementation PlayerViewController
@synthesize player;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JWConfig *config = [[JWConfig alloc] init];
    
    config.file = @"https://content.jwplatform.com/manifests/AOl1vTrt.m3u8";
    config = [JWConfig configWithContentURL:@"https://content.jwplatform.com/manifests/AOl1vTrt.m3u8"];
    
    player = [[JWPlayerController alloc] initWithConfig:config];
    
    config.size = CGSizeMake(1024, 768);
    
    player.view.frame = CGRectMake(0, 0, 1024, 768);
    
    [self.view addSubview:player.view];
    
    [player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


////MARK: JW Player Delegates
//-(void)onTime:(double)position ofDuration:(double)duration
//{
//    NSString *playbackPosition = [NSString stringWithFormat:@"%.01f/.01%f", position, duration];
//    self.playbackTime.text = playbackPosition;
//}
//-(void)onPlay
//{
//    [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
//}
//
//-(void)onPause
//{
//    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
//}
//
//-(void)onBuffer
//{
//    [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
//}
//
//-(void)onIdle
//{
//    [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
//}
//
//-(void)onReady
//{
//    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
//}
//
//-(void)onComplete
//{
//    [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
//}
//
//-(void)onAdSkipped:(NSString *)tag
//{
//    [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
//}
//
//-(void)onAdComplete:(NSString *)tag
//{
//    [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
//}
//
//-(void)onAdImpression:(NSString *)tag
//{
//    [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
//}
//
//-(void)onBeforePlay
//{
//    [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
//}
//
//-(void)onBeforeComplete
//{
//    [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
//}
//
//-(void)onAdPlay:(NSString *)tag
//{
//    [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
//}
//
//-(void)onAdPause:(NSString *)tag
//{
//    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
//}
//
//-(void)onAdError:(NSError *)error
//{
//    [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
//}
//
//- (IBAction)play:(id)sender
//{
//    NSLog(@"state %@", self.player.playerState);
//    if([self.player.playerState isEqualToString:@"PAUSED"] ||
//       [self.player.playerState isEqualToString:@"IDLE"]) {
//        [self.player play];
//        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
//    } else {
//        [self.player pause];
//        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
//    }
//}
//
//- (void)playerStateChanged:(NSNotification*)info
//{
//    NSDictionary *userInfo = info.userInfo;
//    if([userInfo[@"event"] isEqualToString:@"onPause"] ||
//       [userInfo[@"event"] isEqualToString:@"onReady"] ||
//       [userInfo[@"event"] isEqualToString:@"onAdPause"]) {
//        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
//    } else {
//        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
//    }
//}
//
//#pragma mark - callback notification handling
//
//
//- (void)updatePlaybackTimer:(NSNotification*)notification
//{
//    NSDictionary *userinfo = notification.userInfo;
//    if([userinfo[@"event"] isEqualToString:@"onTime"]) {
//        NSString *position = [NSString stringWithFormat:@"%@/%@", userinfo[@"position"], userinfo[@"duration"]];
//        self.playbackTime.text = position;
//    }
//}

@end
