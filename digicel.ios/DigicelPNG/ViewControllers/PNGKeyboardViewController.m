//
//  PNGKeyboardViewController.m
//  DigicelPNG
//
//  Created by Shane Henderson on 18/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGKeyboardViewController.h"

@interface PNGKeyboardViewController ()

@end

@implementation PNGKeyboardViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.screenName = @"Keyboard";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    
}

@end
