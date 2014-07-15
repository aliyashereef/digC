//
//  PNGUtilities.h
//  DigicelPNG
//
//  Created by Arundev K S on 19/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNGUtilities : NSObject

//  Shows version number and build on the status bar.
+ (void)showVersionNumberOnWindow;

//  Removes blank space and new line characters from the begining and end of a string;
+ (NSString *)cleanString:(NSString *)string;

//  Shows an alert view with the given title and message.
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

//  Email validation.
+ (BOOL)isValidEmail:(NSString *)email;

// Alphabetic string validation.
+ (BOOL)isValidAlphaNumericString:(NSString *)string;

//Parse Error display
+ (void)displayParseErrorInAlert:(NSError *)error;

//check the screen has 3.5 inch size
+ (BOOL)hasThreeAndHalfInchDisplay;

//generate thumbnailImage for url
+ (UIImage *)generateThumbNailImageForUrl:(NSURL *)url;

//generate thumnailImage for image
+ (UIImage *)generateThumbNailForImage:(UIImage *)image;

//  Returns color for the category item.
+ (UIColor *)getColorForCategoryItem:(CategoryItem)item;

//  Returns required size for text with max width and font.
+ (CGSize)getRequiredSizeForText:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)width;

//  Setting border color for view
+ (void)setBorderColor:(UIColor *)color forView:(UIView *)view;

//convert date to string
+ (NSString *)getDateStringFromDate:(NSDate *)date;

//convert string to date
+ (NSDate *)getDateFromDateString:(NSString *)string;

//get data for image file
+ (NSData *)getDataForImage:(UIImage *)image;

//get data for url
+ (NSData *)getDataForUrl:(NSURL *)url;

@end
