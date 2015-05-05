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
#import <SMPageControl/SMPageControl.h>
#import <QuartzCore/QuartzCore.h>

#pragma mark DEFINES

#define kActionSheetColor       100
#define kActionSheetTool        101
#define STARTING_POINT_OF_STACKCOUNT      -1
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#pragma mark RootViewController Class Extension
@interface RootViewController (){
    UIView *rootView;
    EAIntroView* intro;
}
@end

@implementation RootViewController

#pragma mark UIViewController Life-Cycle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];

    /********************************************************************
     To Check initial loading or not
     ********************************************************************/
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        // app already launched
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        // This is the first launch ever
        self.navigationController.navigationBarHidden = YES;

        // for introduction scrollView at app initial-launching.
        rootView = self.view;
        [self showIntroWithCrossDissolve];
    }
    
    /********************************************************************
     Set up the Image Stack to redo or undo
     ********************************************************************/
    stackCounter = STARTING_POINT_OF_STACKCOUNT;
    imageStack = [[NSMutableArray alloc]init];
    
    // for the initial image
    self.mainImage.image = [[UIImage alloc]init];
    [imageStack addObject:self.mainImage.image];
    stackCounter += 1;
    

    /**************************************************************************************************
     Neccessary variables Initializion : Flags  / AppDelegate / observers and so on
     **************************************************************************************************/
    
    // AppDelegate
    AppDelegate* appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate leftMenu].delegate = self;
    
    // Bool flag
    isDrawModeOn = YES;
    isRedColorOn = YES;
    isBlueColorOn = NO;
    self.drawingView.isBlueColorOn = NO;
    self.drawingView.isRedColorOn = YES;
    self.drawingView.isDrawModeOn = YES;
    self.drawingView.userInteractionEnabled = YES;

    // ViewController's Title
    self.title = @"TLTalk";
    
    
    // To validate whether or not camera is available
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }

    
    /********************************************************************
     UINavigation Configuration
     ********************************************************************/
    self.navigationController.navigationBar.topItem.title = @"TLTalk";


    /********************************************************************
     Dropdown Menu configuration
     ********************************************************************/
    UIImage *takingPhotoIcon = [UIImage imageNamed:@"takingPicture_blue"];
    UIImage *selectFromPhotoalbumIcon = [UIImage imageNamed:@"from_album_blue"];
    UIImage *saveImageToPhotoalbumIcon = [UIImage imageNamed:@"save_image_to_iOS_album_blue"];
    UIImage *undoImage = [UIImage imageNamed:@"redoIcon"];
    UIImage *redoImage = [UIImage imageNamed:@"undoIcon"];
    
    self.menu = [[UIDropdownMenu alloc] initWithViewController:self
                                                        titles:[NSArray arrayWithObjects:NSLocalizedString(@"Take a photo", nil), NSLocalizedString(@"From PhtoAlbum", nil), NSLocalizedString(@"Save Image", nil),NSLocalizedString(@"Undo Image", nil),NSLocalizedString(@"Redo Image", nil),nil]
                                                         icons:[NSArray arrayWithObjects:takingPhotoIcon, selectFromPhotoalbumIcon, saveImageToPhotoalbumIcon, undoImage, redoImage, nil]
                                                       actions:[NSArray arrayWithObjects:@"takingPhotoToUseAsBackground", @"selectImageFromiOSPhotoAlbum", @"saveImageToPhotoAlbum", @"undoImage", @"redoImage", nil]];
    
    
    // UITapGestureRecognizer for dismiss DropDownMenu when tapping the entire self.view area.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissMenu)];
    [self.view addGestureRecognizer:tap];
    
    /********************************************************************
     Drawing configuration
     ********************************************************************/
    // set the delegate
    self.drawingView.delegate = self;
    // set the width of brush
    self.lineWidthSlider.value = self.drawingView.lineWidth;
}

#pragma mark DropDownMenu methods
-(void)takingPhotoToUseAsBackground{
    
    // if no camera available is,
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
    
    // Otherwise,
    else{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
    // always hide dropdown menu after button is clicked
    [self.menu hideMenu];
}

-(void)selectImageFromiOSPhotoAlbum{
    // To use UIImagePicker Apple provides
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    // always hide dropdown menu after button is clicked
    [self.menu hideMenu];
}


// Image Undo / Redo using imageStack, NSMutableArray
-(void)undoImage{

    // If imageStack has more stack-index to go back,
    if(stackCounter > 0){
        stackCounter-=1;
        self.mainImage.image = [imageStack objectAtIndex:stackCounter];
    }
    
    // Otherwise,
    else{
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"WARNING"
                                     message:@"Your Image Stack is already 0."
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 // do your job necessary if needed
                             }];
        
        [view addAction:ok];
        [self presentViewController:view animated:YES completion:nil];
        [self.menu hideMenu];
    }
}

-(void)redoImage{
    
    // If ImageStack has more stack index to go forward
    if([imageStack count] > stackCounter + 1){
        stackCounter+=1;
        self.mainImage.image = [imageStack objectAtIndex:stackCounter];
    }
    
    // Otherwise,
    else{
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"WARNING"
                                     message:@"Your Image Stack is already Full."
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 // do undo job related here
                                 // [view dismissViewControllerAnimated:YES completion:nil];
                             }];
        
        [view addAction:ok];
        [self presentViewController:view animated:YES completion:nil];
        [self.menu hideMenu];
    }
}


-(void)saveImageToPhotoAlbum{
    
    // for the modified one image
    // merge two image necessary, DrawingView,which is in front of ImageView and ImageView, which is in back of drawingImage and save it to iOS PhotoAlbum using C function(UIImageWriteToSavedPhotosAlbum) Apple Provides
    UIImage *drawingView = self.drawingView.image;
    UIImage *backgroundImageView = self.mainImage.image;
    CGSize drawinViewfinalSize = [drawingView size];
    UIGraphicsBeginImageContext(drawinViewfinalSize);
    [backgroundImageView drawInRect:CGRectMake(0,0,drawinViewfinalSize.width,drawinViewfinalSize.height)];
    [drawingView drawInRect:CGRectMake(0,0,drawinViewfinalSize.width,drawinViewfinalSize.height)];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImageWriteToSavedPhotosAlbum(newImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
}

-(void)dismissMenu{
     [self.menu hideMenu];
}

#pragma mark - Image Picker Controller delegate methods

// when you load image from your iOS Photo Album, this message will be sent as the delegate method.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // WHEN USUAL SITUATION IS IN ACTION
    // store image to the imageStack in common situation
    if([imageStack count] == stackCounter + 1){
        
        // Get the UIImage instance user selects from iOS PhotoAlbum.
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        
        // Get the Image Added to imageStack
        [imageStack addObject:chosenImage];
        // For sure, stackCounter also increases up +1
        stackCounter+=1;
        
        // Use Image Instance from imageStack using stackCounter.
        self.mainImage.image = [imageStack objectAtIndex:stackCounter];
    }
    
    // WHEN UNDO / REDO IS IN ACTION
    // store image to the imageStack while redo / undo is on the progress
    else{
        // Get the UIImage instance user selects from iOS PhotoAlbum.
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];

        // iterate to remove all object until inside the current stackCounter + 1, which is the current index.
        while([imageStack count] > stackCounter + 1){
            [imageStack removeLastObject];
        }
        
        // add Image to imageStack array
        [imageStack addObject:chosenImage];
        
        // make stackCount equal to imageStack count
        stackCounter = [imageStack count] -1 ;

        // use background image using last index image object of imageStack
        self.mainImage.image = [imageStack objectAtIndex:stackCounter];
    }

    // after loading image, to prevent undo/redo button from being hidden, do it again
    [self.view addSubview:undoButton];
    [self.view addSubview:redoButton];
    
    // image selection viewcontroller will dismiss.
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

#pragma mark DrawToolViewController Delegate
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
                              // self.mainImage.image = [UIImage imageNamed:@""];
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
    self.drawingView.isDrawModeOn = YES;
}
-(void)didDrawModeOff{
    self.drawingView.isDrawModeOn = NO;
}
-(void)didChangeToBlueColor{
    self.drawingView.isBlueColorOn = YES;
    self.drawingView.isRedColorOn = NO;
}
-(void)didChangeToRedColor{
    self.drawingView.isBlueColorOn = NO;
    self.drawingView.isRedColorOn = YES;
}

#pragma mark - IBActions
// Drawing Undo / Redo
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

#pragma mark - ACEDrawing
- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;
{
    [self updateButtonStatus];
}

- (void)updateButtonStatus
{
    self.undoButton.enabled = [self.drawingView canUndo];
    self.redoButton.enabled = [self.drawingView canRedo];
}

// it actually executes Drawing Clear.
- (void)clearDraw
{
    // self.mainImage.image = nil;
    [self.drawingView clear];
    [self updateButtonStatus];
}


#pragma mark Introduction Setup : EAIntroView Opensource
// OpenSource Introduction ScorllViewController
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

#pragma mark - SlideNavigationController Methods -
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return NO;
}


@end
