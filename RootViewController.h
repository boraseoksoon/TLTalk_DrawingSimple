//
//  RootViewController.m
//  TLTalk
//
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

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "DrawToolViewController.h"
#import "ACEDrawingView.h"
#import <EAIntroView/EAIntroView.h>

// Forward Declarations
@class BButton;
@class SWFrameButton;
@class UIDropdownMenu;

@interface RootViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, DrawToolViewControllerDelegate, UIActionSheetDelegate, ACEDrawingViewDelegate, EAIntroDelegate>{
    
    // Image Stack for Image Undo / Redo
    int stackCounter;
    NSMutableArray* imageStack;
    
    // SWFrameButton
    SWFrameButton* undoButton;
    SWFrameButton* redoButton;
    
    // instance variables related to Drawing
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    
    
    // BOOL flags
    BOOL mouseSwiped;
    BOOL isDrawModeOn;
    BOOL isBlueColorOn;
    BOOL isRedColorOn;
}

@property (strong, nonatomic) UIDropdownMenu *menu;

/********************************************************************
    IBOutlet
 ********************************************************************/
@property (strong, nonatomic) IBOutlet UIButton *drawButton;
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;

@property (nonatomic, unsafe_unretained) IBOutlet ACEDrawingView *drawingView;

@property (nonatomic, unsafe_unretained) IBOutlet UISlider *lineWidthSlider;
@property (nonatomic, unsafe_unretained) IBOutlet UISlider *lineAlphaSlider;

@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *undoButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *redoButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *colorButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *toolButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *alphaButton;


/********************************************************************
    IBAction
 ********************************************************************/

- (IBAction)openDrawTools:(id)sender;
- (IBAction)undoAction:(id)sender;
- (IBAction)redoAction:(id)sender;

@end
