//
//  GameViewController.h
//  bubble
//

//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
@import GoogleMobileAds;

@interface GameViewController : UIViewController

@property (weak, nonatomic) IBOutlet GADBannerView *adVView;
@property (nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, assign) NSInteger ts;
- (void)showX;

@end
