//
//  GameCenterService.m
//  bubble
//
//  Created by Zzy on 11/28/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "GameCenterService.h"
#import <GameKit/GameKit.h>

@interface GameCenterService () <GKGameCenterControllerDelegate>

@end

@implementation GameCenterService

+ (GameCenterService *)sharedSingleton
{
    static GameCenterService *sharedSingleton;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        if (!sharedSingleton) {
            sharedSingleton = [[self alloc] init];
        }
    });
    
    return sharedSingleton;
}

- (instancetype)init
{
    self = [super init];
    return self;
}

- (void)authUserWithBlock:(AuthUserBlock)block
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    if (localPlayer.authenticated == NO) {
        localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
            if (!error) {
                block(YES, nil);
            } else {
                block(NO, viewController);
            }
        };
    } else {
        block(YES, nil);
    }
}

- (void)reportBestScore:(NSInteger)score block:(ReportScoreBlock)block
{
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: @"Bubble_BestScore"];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    NSArray *scores = @[scoreReporter];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        if (block) {
            if (!error) {
                block(YES);
            } else {
                block(NO);
            }
        }
    }];
}

- (void)showLeaderboardWithTarget:(UIViewController *)target
{
    GKGameCenterViewController *leaderboardViewController = [[GKGameCenterViewController alloc] init];
    __weak __typeof(self) wself = self;
    leaderboardViewController.gameCenterDelegate = wself;
    leaderboardViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    leaderboardViewController.leaderboardIdentifier = @"Bubble_BestScore";
    [target presentViewController:leaderboardViewController animated:YES completion:nil];
}

#pragma mark - GKGameCenterControllerDelegate

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
