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

#import "RootViewController.h"
#import "UIDropdownMenu.h"
#import "SWFrameButton.h"
#import "BButton.h"
#import "AppDelegate.h"
//

#import <SMPageControl/SMPageControl.h>
#import <QuartzCore/QuartzCore.h>

#define kActionSheetColor       100
#define kActionSheetTool        101

@interface RootViewController (){
    UIView *rootView;
    EAIntroView* intro;
}
@end

@implementation RootViewController

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (UIImage *)blendImage
{
    UIImage *bottomImage = self.mainImage.image;
    UIImage *image = self.drawingView.image;
    
    UIGraphicsBeginImageContext( bottomImage.size );
    CGRect imageFrame = CGRectMake(0.0f, 0.0f, bottomImage.size.width, bottomImage.size.height);
    
    // Use existing opacity as is
    [bottomImage drawInRect:imageFrame];
    
    // Apply supplied opacity
    [image drawInRect:imageFrame blendMode:kCGBlendModeNormal alpha:0.8];
    
    UIImage *blendImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return blendImage;
}


#pragma mark - SlideNavigationController Methods -
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return NO;
}


#pragma mark UIViewController Life-Cycle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        // app already launched
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // This is the first launch ever
        self.navigationController.navigationBarHidden = YES;
        
        rootView = self.view;
        [self showIntroWithCrossDissolve];
    }
    

    self.drawingView.isBlueColorOn = NO;
    self.drawingView.isRedColorOn = YES;
    self.drawingView.isDrawModeOn = YES;
    self.drawingView.userInteractionEnabled = YES;
    
    
    /*
    self.navigationController.navigationBarHidden = YES;

    rootView = self.view;
    [self showIntroWithCrossDissolve];
     */
    
    
    
    
    /**************************************************************************************************
     Neccessary variables Initializion : Flags  / AppDelegate / observers and so on
     **************************************************************************************************/
    
    AppDelegate* appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate leftMenu].delegate = self;
    
    isDrawModeOn = YES;
    isRedColorOn = YES;
    isBlueColorOn = NO;

    // datas for drawing
    // RGB color of brush
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    // width of brush
    brush = 5.0;
    // opacity = 1.0;
    

    // Do any additional setup after loading the view.
    self.title = @"TLTalk";
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
    /********************************************************************
     Adding Two bottom buttons(Redo, Undo)
     ********************************************************************/
    
    
    /*
    BButton *btn2 = [[BButton alloc] initWithFrame:CGRectMake(30, 100, 300, 40) type:BButtonTypeTwitter style:BButtonStyleBootstrapV3];
    [btn2 setTitle:@"Are you gonna Undo? :)" forState:UIControlStateNormal];
    // [btn2 addAwesomeIcon:FAArrowCircleLeft beforeTitle:YES];
    // btn2 = [BButton awesomeButtonWithOnlyIcon:FAArrowCircleLeft type:BButtonTypeDefault style:BButtonStyleBootstrapV3];
    btn2.center = CGPointMake(self.view.center.x, self.view.center.y + 250);
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(toUndoOrToRedo) forControlEvents:UIControlEventTouchUpInside];
     */
    
    /*
    BButton *btn3 = [[BButton alloc] initWithFrame:CGRectMake(30, 100, 150, 50) type:BButtonTypeDefault style:BButtonStyleBootstrapV3];
    [btn3 setTitle:@">" forState:UIControlStateNormal];
    // [btn3 addAwesomeIcon:FAArrowCircleRight beforeTitle:NO];
    // btn3 = [BButton awesomeButtonWithOnlyIcon:FAArrowCircleRight type:BButtonTypeDefault style:BButtonStyleBootstrapV3];
    btn3.frame = CGRectMake(160, 518, 30, 30);
    [self.view addSubview:btn3];
    [btn3 addTarget:self action:@selector(redoPressed:) forControlEvents:UIControlEventTouchUpInside];
    */
    
    /*
    undoButton = [[SWFrameButton alloc] init];
    [undoButton setTitle:@"UNDO" forState:UIControlStateNormal];
    [undoButton sizeToFit];
    undoButton.tintColor = [UIColor redColor];
    undoButton.center = CGPointMake(self.view.center.x - 50, self.view.center.y + 250);
    [undoButton addTarget:self action:@selector(undoPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:undoButton];
    
    
    redoButton = [[SWFrameButton alloc] init];
    [redoButton setTitle:@"REDO" forState:UIControlStateNormal];
    [redoButton sizeToFit];
    redoButton.tintColor = [UIColor blueColor];
    redoButton.center = CGPointMake(self.view.center.x + 50, self.view.center.y + 250);
    [redoButton addTarget:self action:@selector(redoPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:redoButton];
    */
    
    
    
    /********************************************************************
     UINavigation Configuration
     ********************************************************************/
    self.navigationController.navigationBar.topItem.title = @"TLTalk";

    
    /*
    UIView *naviTitleView = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toplogo"]];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"";
    int naviTitleViewWidth = imageView.image.size.width + titleLabel.intrinsicContentSize.width;
    [naviTitleView setFrame:CGRectMake(0, 0, naviTitleViewWidth, 44)];
    naviTitleView.center = CGPointMake(self.navigationController.navigationBar.center.x + self.navigationController.navigationItem.rightBarButtonItem.width, 22);
    [imageView setFrame:CGRectMake(0, 22-imageView.image.size.height/2, imageView.image.size.width, imageView.image.size.height)];
    [titleLabel setFrame:CGRectMake(imageView.image.size.width+5, 22-titleLabel.intrinsicContentSize.height/2, titleLabel.intrinsicContentSize.width, titleLabel.intrinsicContentSize.height)];
    [naviTitleView addSubview:imageView];
    [naviTitleView addSubview:titleLabel];
    self.navigationItem.titleView = naviTitleView;
     */
    
    UIImage *takingPhotoIcon = [UIImage imageNamed:@"takingPicture_blue"];
    UIImage *selectFromPhotoalbumIcon = [UIImage imageNamed:@"from_album_blue"];
    UIImage *saveImageToPhotoalbumIcon = [UIImage imageNamed:@"save_image_to_iOS_album_blue"];
    self.menu = [[UIDropdownMenu alloc] initWithViewController:self
                                                        titles:[NSArray arrayWithObjects:NSLocalizedString(@"Take a photo", nil), NSLocalizedString(@"From PhtoAlbum", nil), NSLocalizedString(@"Save Image", nil),nil]
                                                         icons:[NSArray arrayWithObjects:takingPhotoIcon, selectFromPhotoalbumIcon, saveImageToPhotoalbumIcon, nil]
                                                       actions:[NSArray arrayWithObjects:@"takingPhotoToUseAsBackground", @"selectImageFromiOSPhotoAlbum", @"saveImageToPhotoAlbum", nil]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissMenu)];
    [self.view addGestureRecognizer:tap];
    
    
    
    
    
    
    
    // set the delegate
    self.drawingView.delegate = self;
    
    // start with a black pen
    self.lineWidthSlider.value = self.drawingView.lineWidth;
    
    // init the preview image
    // self.previewImageView.layer.borderColor = [[UIColor blackColor] CGColor];
    // self.previewImageView.layer.borderWidth = 2.0f;
}


#pragma mark UINavigation + DropDown methods
-(void)takingPhotoToUseAsBackground{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
    
    
    else{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
    [self.menu hideMenu];
}

-(void)selectImageFromiOSPhotoAlbum{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    [self.menu hideMenu];
}

-(void)saveImageToPhotoAlbum{
    
    // for the single one.
    /*
    UIGraphicsBeginImageContextWithOptions(self.drawingView.bounds.size, NO, 0.0);
    [self.drawingView.image drawInRect:CGRectMake(0, 0, self.drawingView.frame.size.width, self.drawingView.frame.size.height)];
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    */
    
    // modified one
    UIImage *personImage = self.drawingView.image;
    UIImage *hatImage = self.mainImage.image;
    CGSize finalSize = [personImage size];
    CGSize hatSize = [hatImage size];
    UIGraphicsBeginImageContext(finalSize);
    [hatImage drawInRect:CGRectMake(0,0,finalSize.width,finalSize.height)];
    [personImage drawInRect:CGRectMake(0,0,finalSize.width,finalSize.height)];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    
    
    
    UIImageWriteToSavedPhotosAlbum(newImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    

    
}


-(UIImage *) addImageToImage:(UIImage *)img withImage2:(UIImage *)img2 andRect:(CGRect)cropRect withImageWidth:(int) width
{
    CGSize size = CGSizeMake(width,40);
    UIGraphicsBeginImageContext(size);
    
    CGPoint pointImg1 = CGPointMake(0,0);
    [img drawAtPoint:pointImg1];
    
    CGPoint pointImg2 = cropRect.origin;
    [img2 drawAtPoint: pointImg2];
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
    
}



-(void)dismissMenu{
     [self.menu hideMenu];
}

#pragma mark undo / redo buttons method
-(void)toUndoOrToRedo{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"To undo or redo"
                                 message:@"That is problem."
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* undo = [UIAlertAction
                           actionWithTitle:@"Undo"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                               [self undoDrawing];
                               // do undo job related here
                               // [view dismissViewControllerAnimated:YES completion:nil];
                               
                           }];
    UIAlertAction* redo = [UIAlertAction
                           actionWithTitle:@"Redo"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                               [self redoDrawing];
                               // do redo job related here.
                               // [view dismissViewControllerAnimated:YES completion:nil];
                           }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    
    
    [view addAction:undo];
    [view addAction:redo];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}


#pragma mark IBActions
- (IBAction)openDrawTools:(id)sender {
    /* do something you need */
    NSLog(@"open up!");
}

- (IBAction)undoAction:(id)sender{
    NSLog(@"undoAction");
}
- (IBAction)redoAction:(id)sender{
    NSLog(@"redoAction");
}

#pragma mark - Image Picker Controller delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.mainImage.image = chosenImage;
    [self.view addSubview:undoButton];
    [self.view addSubview:redoButton];
 
    [self clearDraw];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
 
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Image could not be saved.Please try again"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image was successfully saved in photoalbum"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
}

#pragma mark basic instance methods
-(void)redoDrawing{
    NSLog(@"redoDrawing");
}

-(void)undoDrawing{
    NSLog(@"undoDrawing");
}
#pragma mark basic class methods




#pragma mark basic class methods


#pragma mark overriding viewController touches methods
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(isDrawModeOn){
        mouseSwiped = NO;
        UITouch *touch = [touches anyObject];
        lastPoint = [touch locationInView:self.view];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(isDrawModeOn){
        mouseSwiped = YES;
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self.view];
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.drawingView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
        
        // for blueColor
        if(isBlueColorOn){
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 1.0, 1.0);
            // CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor blueColor] CGColor]);
        }
        // for redColor
        else{
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
        }
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
        // [self.mainImage setAlpha:opacity];
        UIGraphicsEndImageContext();
        
        lastPoint = currentPoint;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    if(isDrawModeOn){
        if(!mouseSwiped) {
            UIGraphicsBeginImageContext(self.view.frame.size);
            [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
            
            // blue
            if(isBlueColorOn){
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 1.0, 1.0);
            }
            // red
            else{
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
            }
            
            
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            CGContextFlush(UIGraphicsGetCurrentContext());
            self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
        
        // [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
        
        self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

    }
     
}
*/
#pragma mark DrawTollViewController Delegate
-(void)didEraseAll{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"WARNING"
                                 message:@"Are you sure to erase all image?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yes = [UIAlertAction
                          actionWithTitle:@"YES"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              self.mainImage.image = [UIImage imageNamed:@""];
                              // do something you need
                              [self clearDraw];
                              
                          }];
    UIAlertAction* no = [UIAlertAction
                         actionWithTitle:@"NO"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             // do something you need
                         }];
    
    [view addAction:yes];
    [view addAction:no];
    [self presentViewController:view animated:YES completion:nil];
}

-(void)didDrawModeOn{
    // NSLog(@"DrawMode On!");
    self.drawingView.isDrawModeOn = YES;
}
-(void)didDrawModeOff{
    // NSLog(@"DrawMode Off!");
    self.drawingView.isDrawModeOn = NO;
}
-(void)didChangeToBlueColor{
    // NSLog(@"Blue On!");
    self.drawingView.isBlueColorOn = YES;
    self.drawingView.isRedColorOn = NO;
}
-(void)didChangeToRedColor{
    // NSLog(@"Red On!");
    self.drawingView.isBlueColorOn = NO;
    self.drawingView.isRedColorOn = YES;
}


#pragma mark - Actions

- (void)updateButtonStatus
{
    self.undoButton.enabled = [self.drawingView canUndo];
    self.redoButton.enabled = [self.drawingView canRedo];
}

- (IBAction)undo:(id)sender
{
    [self.drawingView undoLatestStep];
    [self updateButtonStatus];
}

- (IBAction)redo:(id)sender
{
    [self.drawingView redoLatestStep];
    [self updateButtonStatus];
}

// it actually executes clear.
- (void)clearDraw
{
    // self.mainImage.image = nil;
    [self.drawingView clear];
    [self updateButtonStatus];
}


#pragma mark - ACEDrawing View Delegate
- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;
{
    [self updateButtonStatus];
}





#pragma mark Introduction : EAIntroView Opensource
- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    // page1.title = @"Hello world";
    // page1.titleColor = UIColorFromRGB(0x0080FF);
    page1.desc = @"Welcome!";
    page1.descColor = UIColorFromRGB(0x0080FF);
    page1.bgImage = [UIImage imageNamed:@"white.jpg"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro1"]];
    
    
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.desc = @"Draw the image that you feel in it!";
    page2.descColor = UIColorFromRGB(0x0080FF);
    page2.bgImage = [UIImage imageNamed:@"white.jpg"];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro2"]];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = @"select photos and save it in your iPhone.";
    page3.descColor = UIColorFromRGB(0x0080FF);
    page3.bgImage = [UIImage imageNamed:@"white.jpg"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro3"]];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"This is page 4";
    page4.descColor = UIColorFromRGB(0x0080FF);
    page4.desc = @"Choose brush color, style and more!";
    page4.bgImage = [UIImage imageNamed:@"white.jpg"];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro4"]];
    
    
    EAIntroPage *page5 = [EAIntroPage page];
    page5.title = @"Drawing Simple where you can draw.";
    page5.titleColor = UIColorFromRGB(0x0080FF);
    page5.descColor = UIColorFromRGB(0x0080FF);
    // page5.desc = @"Drawing Simple where you can draw.";
    page5.bgImage = [UIImage imageNamed:@"white.jpg"];
    page5.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro5"]];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4, page5]];
    [intro setDelegate:self];
    [intro showInView:rootView animateDuration:0.3];
}
#pragma mark - EAIntroView delegate

- (void)introDidFinish:(EAIntroView *)introView {
    NSLog(@"introDidFinish callback");
    self.navigationController.navigationBarHidden = NO;
    // [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end
