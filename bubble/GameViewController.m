//
//  GameViewController.m
//  bubble
//
//  Created by Zzy on 11/25/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "GameViewController.h"
#import "MenuScene.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.counter = 0;
    self.ts = [[NSDate date] timeIntervalSince1970];
    self.interstitial = [self createAndLoadInterstitial];
    SKView *skView = (SKView *)self.view;
//    if (DEBUG) {
//        skView.showsFPS = YES;
//        skView.showsNodeCount = YES;
//    }
    skView.ignoresSiblingOrder = YES;
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    MenuScene *menuScene = [[MenuScene alloc] initWithSize:size];
    menuScene.gvc = self;
    menuScene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:menuScene];
    
    self.adVView.adUnitID = @"ca-app-pub-8217481143192443/2696887011";
    self.adVView.rootViewController = self;
    [self.adVView loadRequest:[GADRequest request]];
    
    [self showX];
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-8217481143192443/4173620212"];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.interstitial = [self createAndLoadInterstitial];
}

- (void)showX {
    NSLog(@"-------- showX");
    self.counter++;
    NSInteger ts0 = [[NSDate date] timeIntervalSince1970];
    NSInteger tsCheck = ts0 - self.ts;
    NSLog(@"---%ld", tsCheck);
    NSLog(@"---%ld", self.counter);
    self.ts = ts0;
    if (self.counter % 10 == 0 || tsCheck > 60 * 5){
        NSLog(@"--------- can showX");
    }
    else{
        NSLog(@"--------- can not showX yet");
        return;
    }
    
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
        self.interstitial = [self createAndLoadInterstitial];
        NSLog(@"-------- show ad");
    }else{
        NSLog(@"-------- no ad");
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
