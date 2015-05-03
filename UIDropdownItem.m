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





#import "UIDropdownItem.h"
#import "FAKIonIcons.h"
#import "UIDropdownMenu.h"

@implementation UIDropdownItem

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (instancetype)initWithViewController:(UIViewController *)vc menu:(UIDropdownMenu *)menu title:(NSString *)title icon:(UIImage *)icon action:(SEL)action index:(int)index {
	self = [super init];
	if (!self)
		return nil;

	// 기본 설정
	self.translatesAutoresizingMaskIntoConstraints = NO;

	// 레이아웃 선행 설정
	extern const CGFloat DROPDOWN_ITEM_HEIGHT;
	CGFloat top = DROPDOWN_ITEM_HEIGHT * index + index;

	// 레이아웃 설정
	UIView *v = vc.view;
	[menu addSubview:self];
	[v addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:menu attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
	[v addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:menu attribute:NSLayoutAttributeHeight multiplier:0 constant:DROPDOWN_ITEM_HEIGHT]];
	[v addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:menu attribute:NSLayoutAttributeTop multiplier:1.0 constant:top]];
	[v addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:menu attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];

    if (index) {
        UIView *borderView = [UIView new];
        borderView.translatesAutoresizingMaskIntoConstraints = NO;
        borderView.backgroundColor = [UIColor colorWithRed:202/255.f green:211/255.f blue:215/255.f alpha:1.f];
        [menu addSubview:borderView];
        [v addConstraint:[NSLayoutConstraint constraintWithItem:borderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:menu attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-10]];
        [v addConstraint:[NSLayoutConstraint constraintWithItem:borderView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:menu attribute:NSLayoutAttributeHeight multiplier:0 constant:1]];
        [v addConstraint:[NSLayoutConstraint constraintWithItem:borderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:menu attribute:NSLayoutAttributeTop multiplier:1.0 constant:top - 1]];
        [v addConstraint:[NSLayoutConstraint constraintWithItem:borderView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:menu attribute:NSLayoutAttributeRight multiplier:1.0 constant:-5]];
    }

	// 아이템 자체 설정
	// 아이템 내부 레이아웃 설정
	UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
	iconView.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:iconView];
	[v addConstraint:[NSLayoutConstraint constraintWithItem:iconView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:23]];
	[v addConstraint:[NSLayoutConstraint constraintWithItem:iconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:23]];
	[v addConstraint:[NSLayoutConstraint constraintWithItem:iconView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:10]];
	[v addConstraint:[NSLayoutConstraint constraintWithItem:iconView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];

	UILabel *label = [UILabel new];
	label.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:label];
	[label setText:title];
	[label setFont:[UIFont systemFontOfSize:14.f]];
    // changed color of dropdown text
    [label setTextColor:UIColorFromRGB(0x0080FF)];
	[v addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
	[v addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
	[v addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.00 constant:0]];
	[v addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:iconView attribute:NSLayoutAttributeRight multiplier:1.0 constant:5]];

	// 클릭 이벤트
	[self addTarget:vc action:action forControlEvents:UIControlEventTouchDown];

	return self;
}

@end
