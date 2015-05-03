//
//  DrawToolViewController.h
//  TLTalk
//
//  Created by SeoksoonJang on 5/2/15.
//  Copyright (c) 2015 SeoksoonJang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SWFrameButton;

@protocol DrawToolViewControllerDelegate <NSObject>
@required
-(void)didEraseAll;
-(void)didDrawModeOn;
-(void)didDrawModeOff;
-(void)didChangeToBlueColor;
-(void)didChangeToRedColor;
@end

@interface DrawToolViewController : UIViewController{
    BOOL isRedColorDrawModeOn;
    BOOL isBlueColorDrawModeOn;
    SWFrameButton *redButton;
    SWFrameButton *blueButton;
}

/********************************************************************
 Properties
 ********************************************************************/
// delegate to RootViewController
@property (assign, nonatomic) id <DrawToolViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UISwitch *drawModeSwitch;

/********************************************************************
 IBActions
 ********************************************************************/
- (IBAction)goToDevelopersGitHubAction:(id)sender;
- (IBAction)drawModeSwitchAction:(id)sender;


@end
