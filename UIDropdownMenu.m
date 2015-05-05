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

#import "UIDropdownMenu.h"
#import "FAKIonIcons.h"
#import "UIDropdownItem.h"

@implementation UIDropdownMenu

@synthesize height;

- (instancetype)initWithViewController:(UIViewController *)vc titles:(NSArray *)titles icons:(NSArray *)icons actions:(NSArray *)actions {
	self = [super init];
	if (!self)
		return nil;

	// Basic setting-up
	self.translatesAutoresizingMaskIntoConstraints = NO;
	self.backgroundColor = [UIColor clearColor];
	self.hidden = YES;

	// layout configuration prior
	extern const CGFloat DROPDOWN_ITEM_HEIGHT;
	self.height = DROPDOWN_ITEM_HEIGHT * titles.count + titles.count - 1;

	// Setup layout
	UIView *v = vc.view;
	[v addSubview:self];
    
    int dropDownMenuWidth = 80 + ( 80 * [[UIScreen mainScreen] bounds].size.width/320);
	[v addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:v attribute:NSLayoutAttributeWidth multiplier:0 constant:dropDownMenuWidth]];
	[v addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:v attribute:NSLayoutAttributeHeight multiplier:0 constant:self.height]];
	[v addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:v attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
	[v addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:v attribute:NSLayoutAttributeTop multiplier:1.0 constant:64]];

    // Set up image
    UIImage *image = [UIImage imageNamed:@"DropdownBox"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(2, 3, 3, 2)]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:imageView];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

	// Add Item
	for (int i = 0; i < titles.count; ++i) {
		UIDropdownItem *item = [[UIDropdownItem alloc] initWithViewController:vc menu:self title:titles[i] icon:icons[i] action:NSSelectorFromString(actions[i]) index:i];
		(void)item;
	}

	// Setup Menu
	FAKIonIcons *navIcon = [FAKIonIcons naviconIconWithSize:30];
	vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[navIcon imageWithSize:CGSizeMake(15, 15)] style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenu)];
    // added for dropdown navigation item style
    // vc.navigationItem.rightBarButtonItem.style = UIBarButtonSystemItemCamera;
    
    
	return self;
}

- (void)toggleMenu {
	if (self.hidden) {
		[self showMenu];
	}
	else {
		[self hideMenu];
	}
}

- (void)showMenu {
	self.hidden = NO;
	[UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:4.0 options:UIViewAnimationOptionCurveEaseInOut animations: ^{
	    self.transform = CGAffineTransformMakeTranslation(0, self.height);
	} completion: ^(BOOL finished) {
	}];

	[UIView commitAnimations];
}

- (void)hideMenu {
	[UIView animateWithDuration:0.3 delay:0.05 usingSpringWithDamping:1.0 initialSpringVelocity:4.0 options:UIViewAnimationOptionCurveEaseInOut animations: ^{
	    self.transform = CGAffineTransformMakeTranslation(0, -self.height);
	} completion: ^(BOOL finished) {
	    self.hidden = YES;
	}];

	[UIView commitAnimations];
}

@end
