//
//  PNGKeyboardViewController.h
//  DigicelPNG
//
//  Created by Shane Henderson on 18/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@protocol PNGKeyboardDelegate <NSObject>

- (void)keyboardWillHide:(NSNotification *)notification;
- (void)keyboardWillShow:(NSNotification *)notification;

@end

@interface PNGKeyboardViewController : GAITrackedViewController <PNGKeyboardDelegate>

@property (nonatomic, strong) NSArray *keyboardConstraints;

@end
