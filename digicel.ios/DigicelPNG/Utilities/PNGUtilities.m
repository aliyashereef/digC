//
//  PNGUtilities.m
//  DigicelPNG
//
//  Created by Arundev K S on 19/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGUtilities.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import "PNGVersionView.h"

@implementation PNGUtilities

//  Shows version number and build on the status bar.
+ (void)showVersionNumberOnWindow {
#ifdef ENVIRONMENT_STAGING
    NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    PNGVersionView *versionView = [[[NSBundle mainBundle] loadNibNamed:@"PNGVersionView" owner:nil options:nil] firstObject];
    versionView.frame = CGRectMake(190, 0, 70, 20);
    versionView.versionLabel.text = [NSString stringWithFormat:@"v%@ %@",appVersionString,appBuildString];
    versionView.userInteractionEnabled = NO;
    [[[UIApplication sharedApplication] delegate].window addSubview:versionView];
#endif
}

//  Removes blank space and new line characters from the begining and end of a string;
+ (NSString *)cleanString:(NSString *)string {
    return[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//  Shows an alert view with the given title and message.
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

//  Email validation.
+ (BOOL)isValidEmail:(NSString *)email {
    BOOL result;
    NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    result = [emailTest evaluateWithObject:email];
    return result;
}

// Alphabetic string validation.
+ (BOOL)isValidAlphaNumericString:(NSString *)string {
    BOOL result;
    NSString* nameRegex = @"[A-Z0-9a-z._%+-]+([\\s]+[A-Z0-9a-z._%+-]*)?";
    NSPredicate* nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    result = [nameTest evaluateWithObject:string];
    return result;
}

//Parse Error display
+ (void)displayParseErrorInAlert:(NSError *)error {
    NSString *errorString = [error.userInfo valueForKey:@"error"];
    [PNGUtilities showAlertWithTitle:@"" message:errorString];
}

//check the screen has 3.5 inch size
+ (BOOL)hasThreeAndHalfInchDisplay {
    return ([UIScreen mainScreen].bounds.size.height == 480.0);
    
}

//generate thumbnailImage for url
+ (UIImage *)generateThumbNailImageForUrl:(NSURL *)url {
    //generate thumbnail images
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = [asset duration];
    time.value = 5;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbnail;
}

//generate thumnailImage for image
+ (UIImage *)generateThumbNailForImage:(UIImage *)image {
    UIImage *originalImage = image;
    CGSize destinationSize = CGSizeMake(70, 70);
    UIGraphicsBeginImageContext(destinationSize);
    [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//  Returns color for the category item.
+ (UIColor *)getColorForCategoryItem:(CategoryItem)item {
    switch (item) {
        case PNGNews:
            return kPNGNewsColor;
            break;
        
        case Regional:
            return kRegionalColor;
            break;
        
        case Encompass:
            return kEncompassColor;
            break;
        
        case Business:
            return kBusinessColor;
            break;
        
        case Entertainment:
            return kEntertainmentColor;
            break;
        
        case Sports:
            return kSportsColor;
            break;
            
        case World:
            return kWorldColor;
            break;
            
        case Classifieds:
            return kClassifiedsColor;
            break;
            
        case SentStory:
            return kSentStoryColor;
            break;
            
        default:
            return kPNGNewsColor;
            break;
    }
}

//  Returns required size for text with max width and font.
+ (CGSize)getRequiredSizeForText:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)width {
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:font}
                                             context:nil];
    return textRect.size;
}

//  Setting border color for view
+ (void)setBorderColor:(UIColor *)color forView:(UIView *)view {
    view.layer.cornerRadius = 0.0f;
    view.layer.masksToBounds = YES;
    view.layer.borderColor = [color CGColor];
    view.layer.borderWidth = 1.0f;
}

//convert date to string
+ (NSString *)getDateStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy-HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}

//get data for image file
+ (NSData *)getDataForImage:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.0);
    return data;
}

//get data for url
+ (NSData *)getDataForUrl:(NSURL *)url {
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    return data;
}

@end
