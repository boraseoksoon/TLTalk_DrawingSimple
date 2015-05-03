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

@interface UIDropdownMenu : UIView

- (instancetype)initWithViewController:(UIViewController *)vc titles:(NSArray *)titles icons:(NSArray *)icons actions:(NSArray *)actions;

@property (nonatomic) CGFloat height;

- (void)toggleMenu;
- (void)showMenu;
- (void)hideMenu;
@end
