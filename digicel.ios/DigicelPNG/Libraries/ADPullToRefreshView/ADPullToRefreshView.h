//
//  ADPullToRefreshView.h
//  PullToRefresh
//
//  Created by Arundev K S on 26/05/14.
//  Copyright (c) 2014 Arundev K S. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	ADPullRefreshPulling = 0,
	ADPullRefreshNormal,
	ADPullRefreshLoading,
} ADPullRefreshState;

#define kFirstLevel     40.0
#define kSecondLevel    70.0

@protocol ADPullToRefreshViewDelegate;

/*
 Subclass of UIView. Used as a pull to refresh header view. Customized version of EGORefreshTableHeaderView.
 Included two level triggering. Set kFirstLevel & kSecondLevel macro values to use two level triggering.
 Header view contains only a single imageview for displaying a small icon. Icon images can be changed 
 at each levels by setting the searchIcon & refreshIcon.
 */

@interface ADPullToRefreshView : UIView {
    
	ADPullRefreshState _state;
    UIImageView *iconView;
}

@property (nonatomic, assign) id <ADPullToRefreshViewDelegate> delegate;
@property (nonatomic, strong) UIColor *defaultColor;
@property (nonatomic, strong) UIColor *searchColor;
@property (nonatomic, strong) UIColor *refreshColor;
@property (nonatomic, strong) UIImage *searchIcon;
@property (nonatomic, strong) UIImage *refreshIcon;

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

@protocol ADPullToRefreshViewDelegate <NSObject>

- (void)refreshTableHeaderDidTriggerRefresh:(ADPullToRefreshView*)view;
- (void)refreshTableHeaderDidTriggerSearch:(ADPullToRefreshView*)view;
- (BOOL)refreshTableHeaderDataSourceIsLoading:(ADPullToRefreshView*)view;

@end