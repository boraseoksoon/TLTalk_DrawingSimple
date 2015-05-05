
//  Created by SeoksoonJang on 5/1/15.
//  Copyright (c) 2015 SeoksoonJang. All rights reserved.
//
// https://github.com/boraseoksoon/TLTalk
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION

#import "DrawToolViewController.h"
#import "SWFrameButton.h"
#import "SlideNavigationController.h"

@implementation DrawToolViewController
@synthesize delegate;

#pragma mark ViewController LifeCycle

-(void)viewDidLoad{
    [super viewDidLoad];
    
    // initial flags
    isRedColorDrawModeOn = YES;
    isBlueColorDrawModeOn = NO;

    // basic UI Setup
    [self uiSetup];
}

#pragma mark instance methods
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

-(void)uiSetup{
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


#pragma mark IBActions
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
