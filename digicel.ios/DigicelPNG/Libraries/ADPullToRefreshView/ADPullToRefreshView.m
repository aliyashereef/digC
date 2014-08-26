//
//  ADPullToRefreshView.m
//  PullToRefresh
//
//  Created by Arundev K S on 26/05/14.
//  Copyright (c) 2014 Arundev K S. All rights reserved.
//

#import "ADPullToRefreshView.h"

#define kDefaultViewBg	 [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0]
#define kSearchViewBg	 [UIColor colorWithRed:25.0/255.0 green:150.0/255.0 blue:220.0/255.0 alpha:1.0]
#define kRefreshViewBg	 [UIColor colorWithRed:170.0/255.0 green:0.0 blue:2.0/255.0 alpha:1.0]


@implementation ADPullToRefreshView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //  Adding the icon image view.
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(145, frame.size.height - 35, 30, 30)];
        [self addSubview:iconView];
        //  Setting default colors.
        self.defaultColor = kDefaultViewBg;
        self.searchColor = kSearchViewBg;
        self.refreshColor = kRefreshViewBg;
    }
    return self;
}

//  Setter method for search icon
- (void)setSearchIcon:(UIImage *)searchIcon {
    _searchIcon = searchIcon;
    iconView.image = searchIcon;
}

//  changing the view background color.
- (void)setViewBg:(UIColor *)color {
    self.backgroundColor = color;
    iconView.image = self.searchIcon;
}

#pragma mark - ScrollView Methods

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView {
	
    BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate refreshTableHeaderDataSourceIsLoading:self];
	}
    if (scrollView.contentOffset.y <= - kSecondLevel && !_loading) {
        self.backgroundColor = self.refreshColor;
        iconView.image = self.refreshIcon;
	} else if (scrollView.contentOffset.y <= - kFirstLevel && !_loading) {
		self.backgroundColor = self.searchColor;
        iconView.image = self.searchIcon;
    }
    
	if (_state == ADPullRefreshLoading) {
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, kSecondLevel);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
	} else if (scrollView.isDragging) {
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate refreshTableHeaderDataSourceIsLoading:self];
	}
    if (scrollView.contentOffset.y <= - kSecondLevel && !_loading) {
		if ([_delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate refreshTableHeaderDidTriggerRefresh:self];
		}
//        [self performSelector:@selector(setViewBg:) withObject:kDefaultViewBg afterDelay:0.7];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(kSecondLevel, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	} else if (scrollView.contentOffset.y <= - kFirstLevel && !_loading) {
		if ([_delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerSearch:)]) {
			[_delegate refreshTableHeaderDidTriggerSearch:self];
		}
        [self performSelector:@selector(setViewBg:) withObject:kDefaultViewBg afterDelay:0.7];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(kFirstLevel, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
    [self setViewBg:kDefaultViewBg];
}

@end
