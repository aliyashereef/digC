//
//  PNGVersionView.h
//  DigicelPNG
//
//  Created by Arundev K S on 03/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 Subclass of UIView. Contains only a sinlge label to show the version number & build number.
 */

@interface PNGVersionView : UIView

@property (nonatomic, strong) IBOutlet PNGLatoLabel *versionLabel;


@end
