//
//  PNGStoryboardManager.m
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGStoryboardManager.h"
#import "UIColor+PNGColor.h"

NSString * const PNGStoryboard = @"Main";

NSString * const PNGStoryboardSegueToArticle = @"PNGSegueToArticle";
NSString * const PNGStoryboardSegueToRegister = @"PNGSegueToRegister";

NSString * const PNGStoryboardImageArticleColumn = @"ArticlePlaceholderColumn";
NSString * const PNGStoryboardImageArticleFeatured = @"ArticlePlaceholderFeatured";
NSString * const PNGStoryboardImageArticleList = @"ArticlePlaceholderList";
NSString * const PNGStoryboardImageNavigationComments = @"NavComments";
NSString * const PNGStoryboardImageNavigationLogo = @"NavLogo";
NSString * const PNGStoryboardImageWeatherCloudy = @"WeatherCloudy";
NSString * const PNGStoryboardImageWeatherDrizzle = @"WeatherDrizzle";
NSString * const PNGStoryboardImageWeatherHail = @"WeatherHail";
NSString * const PNGStoryboardImageWeatherLightning = @"WeatherLightning";
NSString * const PNGStoryboardImageWeatherOvercast = @"WeatherOvercast";
NSString * const PNGStoryboardImageWeatherShowers = @"WeatherShowers";
NSString * const PNGStoryboardImageWeatherSunny = @"WeatherSunny";
NSString * const PNGStoryboardImageWeatherWindy = @"WeatherWindy";
NSString * const PNGStoryboardImageRemoveMedia = @"RemoveMedia";
NSString * const PNGStoryboardImagePlayVideo = @"PlayVideo";

NSString * const PNGStoryboardTitleRegister = @"Register";

NSString * const PNGStoryboardViewWeather = @"PNGWeatherIconView";

NSString * const PNGStoryboardNavViewControllerLogin = @"PNGStoryboardNVCLoginId";
NSString * const PNGStoryboardNavViewControllerProfile = @"PNGStoryboardNVCProfileId";
NSString * const PNGStoryboardViewControllerArticle = @"PNGStoryboardVCArticleId";
NSString * const PNGStoryboardViewControllerArticles = @"PNGStoryboardVCArticlesId";
NSString * const PNGStoryboardViewControllerComments = @"PNGStoryboardVCCommentsId";
NSString * const PNGStoryboardViewControllerSignIn = @"PNGStoryboardVCSignInId";
NSString * const PNGStoryboardViewControllerWeather = @"PNGStoryboardVCWeatherId";
NSString * const PNGStoryboardViewControllerChangePassword = @"PNGStoryboardVCChangePasswordId";
NSString * const PNGStoryboardViewControllerArticleDetail = @"PNGStoryboardVCArticleDetailId";
NSString * const PNGStoryboardViewControllerArticlesTable = @"PNGStoryboardVCArticlesTableId";
NSString * const PNGStoryboardViewControllerSearchResults = @"PNGStoryboardVCSearchResultsId";
NSString * const PNGStoryboardViewControllerAddComment = @"PNGStoryboardVCAddCommentId";
NSString * const PNGStoryboardViewControllerSubcategoryList = @"PNGStoryboardSubCategoryList";
NSString * const PNGStoryboardViewControllerClassifieds = @"PNGStoryboardClassifieds";

NSString * const PNGStoryboardProfilePlaceholder = @"ProfilePicture";

@implementation PNGStoryboardManager

+ (PNGStoryboardManager*) sharedInstance
{
    static dispatch_once_t _singletonPredicate;
    static PNGStoryboardManager *_singleton = nil;
    
    dispatch_once(&_singletonPredicate, ^{
        _singleton = [[super allocWithZone:nil] init];
    });
    
    return _singleton;
}

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}


#pragma mark - Properties

- (UIStoryboard *)mainStoryboard
{
    return [UIStoryboard storyboardWithName:PNGStoryboard bundle:[NSBundle mainBundle]];
}



@end
