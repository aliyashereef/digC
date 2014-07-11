//
//  PNGStoryboardManager.h
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const PNGStoryboardSegueToArticle;
extern NSString * const PNGStoryboardSegueToRegister;

extern NSString * const PNGStoryboardImageArticleColumn;
extern NSString * const PNGStoryboardImageArticleFeatured;
extern NSString * const PNGStoryboardImageArticleList;
extern NSString * const PNGStoryboardImageNavigationComments;
extern NSString * const PNGStoryboardImageNavigationComments;
extern NSString * const PNGStoryboardImageNavigationComments;
extern NSString * const PNGStoryboardImageNavigationLogo;
extern NSString * const PNGStoryboardImageWeatherCloudy;
extern NSString * const PNGStoryboardImageWeatherDrizzle;
extern NSString * const PNGStoryboardImageWeatherHail;
extern NSString * const PNGStoryboardImageWeatherLightning;
extern NSString * const PNGStoryboardImageWeatherOvercast;
extern NSString * const PNGStoryboardImageWeatherShowers;
extern NSString * const PNGStoryboardImageWeatherSunny;
extern NSString * const PNGStoryboardImageWeatherWindy;
extern NSString * const PNGStoryboardImageRemoveMedia;
extern NSString * const PNGStoryboardImagePlayVideo;

extern NSString * const PNGStoryboardTitleRegister;

extern NSString * const PNGStoryboardViewWeather;

extern NSString * const PNGStoryboardNavViewControllerLogin;
extern NSString * const PNGStoryboardNavViewControllerProfile;
extern NSString * const PNGStoryboardViewControllerArticle;
extern NSString * const PNGStoryboardViewControllerArticles;
extern NSString * const PNGStoryboardViewControllerComments;
extern NSString * const PNGStoryboardViewControllerSignIn;
extern NSString * const PNGStoryboardViewControllerWeather;
extern NSString * const PNGStoryboardViewControllerChangePassword;
extern NSString * const PNGStoryboardViewControllerArticleDetail;
extern NSString * const PNGStoryboardViewControllerArticlesTable;
extern NSString * const PNGStoryboardViewControllerSearchResults;
extern NSString * const PNGStoryboardViewControllerAddComment;
extern NSString * const PNGStoryboardViewControllerSubcategoryList;
extern NSString * const PNGStoryboardViewControllerClassifieds;

extern NSString * const PNGStoryboardProfilePlaceholder;

@interface PNGStoryboardManager : NSObject

@property (nonatomic, readonly) UIStoryboard *mainStoryboard;

+ (PNGStoryboardManager *)sharedInstance;

@end
