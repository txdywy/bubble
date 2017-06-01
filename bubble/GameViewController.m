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

    SKView *skView = (SKView *)self.view;
//    if (DEBUG) {
//        skView.showsFPS = YES;
//        skView.showsNodeCount = YES;
//    }
    skView.ignoresSiblingOrder = YES;
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    MenuScene *menuScene = [[MenuScene alloc] initWithSize:size];
    menuScene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:menuScene];
    
    self.adVView.adUnitID = @"ca-app-pub-8217481143192443/2696887011";
    self.adVView.rootViewController = self;
    [self.adVView loadRequest:[GADRequest request]];
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
