//
//  ResultScene.m
//  bubble
//
//  Created by Zzy on 12/4/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "ResultScene.h"
#import "GameScene.h"
#import "MenuScene.h"
#import "GameCenterService.h"
#import "GlobalHolder.h"
#import "WXApi/WXApi.h"

@interface ResultScene ()

@property (strong, nonatomic) SKSpriteNode *menuBackground;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (strong, nonatomic) SKLabelNode *bestScoreLabel;
@property (strong, nonatomic) SKSpriteNode *restartButton;
@property (strong, nonatomic) SKSpriteNode *homeButton;
@property (strong, nonatomic) SKSpriteNode *leaderboardButton;
@property (strong, nonatomic) SKSpriteNode *shareButton;
@property (strong, nonatomic) SKAction *playPopSoundAction;

@end

@implementation ResultScene

- (void)didMoveToView:(SKView *)view
{
    self.playPopSoundAction = [SKAction playSoundFileNamed:@"PopSound.mp3" waitForCompletion:YES];
    
    [self addChildren];
}

- (void)addChildren
{
    SKNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
    backgroundNode.position = CGPointMake(CGRectGetMidX(self.scene.frame), CGRectGetMidY(self.scene.frame));
    backgroundNode.zPosition = 10;
    
    SKSpriteNode *gameOverTitle = [SKSpriteNode spriteNodeWithImageNamed:@"TitleGameOver"];
    gameOverTitle.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 160);
    gameOverTitle.zPosition = 15;
    gameOverTitle.size = CGSizeMake(233, 65);
    
    self.menuBackground = [SKSpriteNode spriteNodeWithImageNamed:@"MenuBackground"];
    self.menuBackground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50);
    self.menuBackground.zPosition = 20;
    self.menuBackground.size = CGSizeMake(254, 298);
    
    SKLabelNode *scoreTitleLabel = [SKLabelNode labelNodeWithFontNamed:@"STHeitiTC-Light"];
    scoreTitleLabel.text = @"Score";
    scoreTitleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    scoreTitleLabel.fontColor = [SKColor colorWithRed:85 / 255.0f green:85 / 255.0f blue:85 / 255.0f alpha:1];
    scoreTitleLabel.fontSize = 22;
    scoreTitleLabel.position = CGPointMake(-80, 80);
    scoreTitleLabel.zPosition = 21;
    
    SKLabelNode *boardTitleLabel = [SKLabelNode labelNodeWithFontNamed:@"STHeitiTC-Light"];
    boardTitleLabel.text = @"Best";
    boardTitleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    boardTitleLabel.fontColor = [SKColor colorWithRed:85 / 255.0f green:85 / 255.0f blue:85 / 255.0f alpha:1];
    boardTitleLabel.fontSize = 22;
    boardTitleLabel.position = CGPointMake(-80, 40);
    boardTitleLabel.zPosition = 21;
    
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.score];
    self.scoreLabel.fontColor = [SKColor colorWithRed:85 / 255.0f green:163 / 255.0f blue:79 / 255.0f alpha:1];
    self.scoreLabel.fontSize = 28;
    self.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    self.scoreLabel.position = CGPointMake(80, 80);
    self.scoreLabel.zPosition = 22;
    
    self.bestScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
    if ([GlobalHolder sharedSingleton].bestScore > 0) {
        self.bestScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)[GlobalHolder sharedSingleton].bestScore];
    } else {
        self.bestScoreLabel.text = @"----";
    }
    self.bestScoreLabel.fontColor = [SKColor colorWithRed:85 / 255.0f green:163 / 255.0f blue:79 / 255.0f alpha:1];
    self.bestScoreLabel.fontSize = 28;
    self.bestScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    self.bestScoreLabel.position = CGPointMake(80, 40);
    self.bestScoreLabel.zPosition = 22;
    
    self.restartButton = [SKSpriteNode spriteNodeWithImageNamed:@"ButtonRestart"];
    self.restartButton.position = CGPointMake(0, -30);
    self.restartButton.zPosition = 23;
    self.restartButton.size = CGSizeMake(120, 120);
    
    /*
    self.homeButton = [SKSpriteNode spriteNodeWithImageNamed:@"ButtonHome"];
    self.homeButton.position = CGPointMake(-60, -90);
    self.homeButton.zPosition = 24;
    self.homeButton.size = CGSizeMake(27, 28);
    
    self.leaderboardButton = [SKSpriteNode spriteNodeWithImageNamed:@"ButtonLeaderboard"];
    self.leaderboardButton.position = CGPointMake(0, -95);
    self.leaderboardButton.zPosition = 25;
    self.leaderboardButton.size = CGSizeMake(30, 30);
    
    self.shareButton = [SKSpriteNode spriteNodeWithImageNamed:@"ButtonShare"];
    self.shareButton.position = CGPointMake(60, -90);
    self.shareButton.zPosition = 26;
    self.shareButton.size = CGSizeMake(20, 30);
    */
    
    [self addChild:backgroundNode];
    [self addChild:gameOverTitle];
    [self addChild:self.menuBackground];
    [self.menuBackground addChild:scoreTitleLabel];
    [self.menuBackground addChild:boardTitleLabel];
    [self.menuBackground addChild:self.scoreLabel];
    [self.menuBackground addChild:self.bestScoreLabel];
    [self.menuBackground addChild:self.restartButton];
    
    //[self.menuBackground addChild:self.homeButton];
    //[self.menuBackground addChild:self.leaderboardButton];
    //[self.menuBackground addChild:self.shareButton];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self.menuBackground];
        SKNode *node = [self.menuBackground nodeAtPoint:touchLocation];
        if (node == self.restartButton) {
            [self playPopSoundWithBlock:^{
                CGSize size = [UIScreen mainScreen].bounds.size;
                GameScene *gameScene = [[GameScene alloc] initWithSize:size];
                gameScene.scaleMode = SKSceneScaleModeAspectFill;
                [self.scene.view presentScene:gameScene];
            }];
        } else if (node == self.homeButton) {
            [self playPopSoundWithBlock:^{
                CGSize size = [UIScreen mainScreen].bounds.size;
                MenuScene *menuScene = [[MenuScene alloc] initWithSize:size];
                menuScene.scaleMode = SKSceneScaleModeAspectFill;
                [self.scene.view presentScene:menuScene];
            }];
        } else if (node == self.leaderboardButton) {
            [self playPopSoundWithBlock:^{
                [[GameCenterService sharedSingleton] showLeaderboardWithTarget:self.view.window.rootViewController];
            }];
        } else if (node == self.shareButton) {
            [self playPopSoundWithBlock:^{
                [self shareAskWithWeChat:WXSceneTimeline];
            }];
        }
    }
}

- (void)playPopSoundWithBlock:(void (^)())block
{
    [self runAction:self.playPopSoundAction completion:^{
        if (block) {
            block();
        }
    }];
}

#pragma mark ShareWeChat

- (void)shareAskWithWeChat:(int)scene
{
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://mp.weixin.qq.com/mp/redirect?url=https://itunes.apple.com/cn/app/id946285061?src=weixinshare";
    
    NSInteger score = self.scoreLabel.text.integerValue;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.mediaObject = ext;
    if (score > 100) {
        message.title = [NSString stringWithFormat:@"一口气捏了%ld个泡泡，我就是任性", (long)score];
    } else {
        message.title = @"我爱捏泡泡，我就是任性";
    }
    [message setThumbImage:[UIImage imageNamed:@"ShareIcon"]];
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

@end
