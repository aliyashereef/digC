//
//  PNGArticlePageViewController.h
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNGArticle.h"

@interface PNGArticlePageViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
    
    NSInteger currentIndex;
    NSInteger nextIndex;
}

@property (nonatomic, strong) NSArray *articles;
@property (nonatomic, strong) PNGArticle *selectedArticle;
@property (nonatomic, strong) NSDictionary *selectedCategory;

@end
