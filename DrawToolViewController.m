//
//  DrawToolViewController.m
//  TLTalk
//
//  Created by SeoksoonJang on 5/2/15.
//  Copyright (c) 2015 SeoksoonJang. All rights reserved.
//

#import "DrawToolViewController.h"
#import "SWFrameButton.h"
#import "SlideNavigationController.h"


@implementation DrawToolViewController
@synthesize delegate;

-(void)viewDidLoad{
    [super viewDidLoad];
    isRedColorDrawModeOn = YES;
    isBlueColorDrawModeOn = NO;
    
    
    blueButton = [[SWFrameButton alloc] init];
    [blueButton setTitle:@"BLUE" forState:UIControlStateNormal];
    [blueButton sizeToFit];
    // button.center = self.view.center;
    blueButton.center = CGPointMake(self.view.center.x - 12, self.view.center.y - 60);
    [blueButton setSelected:NO];
    blueButton.tintColor = [UIColor blueColor];
    [blueButton addTarget:self action:@selector(blueColorDrawMode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:blueButton];
    

    redButton = [[SWFrameButton alloc] init];
    [redButton setTitle:@"RED" forState:UIControlStateNormal];
    [redButton sizeToFit];
    // button.center = self.view.center;
    redButton.center = CGPointMake(self.view.center.x + 48, self.view.center.y - 60);
    [redButton setSelected:YES];
    redButton.tintColor = [UIColor redColor];
    [redButton addTarget:self action:@selector(redColorDrawMode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redButton];
}


-(void)blueColorDrawMode{
    
    if(isBlueColorDrawModeOn) {
        isBlueColorDrawModeOn = NO;
        [blueButton setTitle:@"BLUE" forState:UIControlStateNormal];
        [blueButton setSelected:NO];
        
        isRedColorDrawModeOn = YES;
        [redButton setSelected:YES];
        NSLog(@"isBlueColorDrawModeOn : NO");
        
        if([delegate respondsToSelector:@selector(didChangeToRedColor)]){
            [delegate performSelector:@selector(didChangeToRedColor) withObject:nil];
        }
    }
    
    else{
        isBlueColorDrawModeOn = YES;
        [blueButton setTitle:@"BLUE" forState:UIControlStateNormal];
        [blueButton setSelected:YES];
        
        isRedColorDrawModeOn = NO;
        [redButton setSelected:NO];
        NSLog(@"isBlueColorDrawModeOn : NO");
        
        if([delegate respondsToSelector:@selector(didChangeToBlueColor)]){
            [delegate performSelector:@selector(didChangeToBlueColor) withObject:nil];
        }
    }
}

-(void)redColorDrawMode{
    if(isRedColorDrawModeOn){
        isRedColorDrawModeOn = NO;
        [redButton setTitle:@"RED" forState:UIControlStateNormal];
        [redButton setSelected:NO];

        isBlueColorDrawModeOn = YES;
        [blueButton setSelected:YES];
        NSLog(@"isRedColorDrawModeOn : NO");
        if([delegate respondsToSelector:@selector(didChangeToBlueColor)]){
            [delegate performSelector:@selector(didChangeToBlueColor) withObject:nil];
        }
    }
    
    else{
        isRedColorDrawModeOn = YES;
        [redButton setTitle:@"RED" forState:UIControlStateNormal];
        [redButton setSelected:YES];
        
        isBlueColorDrawModeOn = NO;
        [blueButton setSelected:NO];
        if([delegate respondsToSelector:@selector(didChangeToRedColor)]){
            [delegate performSelector:@selector(didChangeToRedColor) withObject:nil];
        }
        
        
        NSLog(@"isRedColorDrawModeOn : YES");
        
    }
}

- (IBAction)goToDevelopersGitHubAction:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://github.com/boraseoksoon"]];
}

- (IBAction)drawModeSwitchAction:(id)sender {
    if(_drawModeSwitch.on){
        NSLog(@"drawMode On!");
        if([delegate respondsToSelector:@selector(didDrawModeOn)]){
            [delegate performSelector:@selector(didDrawModeOn) withObject:nil];
        }
    }
    
    else{
        NSLog(@"drawMode Off!");
        if([delegate respondsToSelector:@selector(didDrawModeOff)]){
            [delegate performSelector:@selector(didDrawModeOff) withObject:nil];
        }
    }
}
- (IBAction)eraseAllAction:(id)sender {
    [[SlideNavigationController sharedInstance]closeMenuWithCompletion:nil];
    
    
    if([delegate respondsToSelector:@selector(didEraseAll)]){
        [delegate performSelector:@selector(didEraseAll) withObject:nil];
    }    
}

@end
