//
//  PNGConstants.h
//  DigicelPNG
//
//  Created by Arundev K S on 19/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#ifndef DigicelPNG_PNGConstants_h
#define DigicelPNG_PNGConstants_h



#define ENVIRONMENT_STAGING   //Please comment out for Production environment


#ifdef ENVIRONMENT_STAGING

    //Staging_PNGLoop
    #define PARSE_APPLICATION_ID @"fcssVKlIto7zLfTuVzbRSiC9pubQirZ7z6GLBs3k"
    #define PARSE_CLIENT_KEY @"ZNg50PBLMBBsXGaIR9MP7GwonTcBXnQopjv1UTGj"
    #define kBaseUrl    @"http://loop.mkr.st/"

#else

    //  Production
    #define PARSE_APPLICATION_ID @"4PNUp50419SBQfDV3RzjBm2juZr3Xan5PttGR5LU"
    #define PARSE_CLIENT_KEY @"M8OfhGldgkoIWpjftrWkFurrLaWiUaPZibdEsLAh"
    #define kBaseUrl    @"http://www.pngloop.com/"

#endif


//Google Analytics
#define GA_TRACKING_ID @"UA-51195592-1" //Test account

//  MADS ad keys
#define kMadsInlineAdZone @"1435905558"
//#define kMadsInlineAdZone @"4435717320"

#define kMadsInlineAdSecret @"0"

//Raygun
#define RAYGUN_API_KEY @"prSbV0lDCBTTWAzkd8pNzA=="

//Facebook
#define FACEBOOK_APP_ID @"763040457080073"


//  Animation duration
#define kAnimationDuration                0.3
#define kSignInViewAnimationDuration      0.45f

//  Animation delay
#define kAnimationDelay         0.0

//  Menu view leading space
#define kMenuViewVisibleLeadingSpace        0
#define kMenuViewHiddenLeadingSpace         -220

// Overlay view leading space
#define kOverLayViewVisibleLeadingSpace        220
#define kOverLayViewHiddenLeadingSpace         0

//  Keybaord height
#define kKeyboardHeight     216

//  navigation bar height
#define kNavBarHeight       64

//  user info view height in menu
#define kUserInfoViewheight 60

//  Zero value
#define kZeroValue          0
#define kCommentInterval    120

typedef enum {
    PNGNews = 187,
    Regional = 183,
    Encompass = 181,
    Business = 185,
    Entertainment = 184,
    Sports = 180,
    World = 182,
    Classifieds = 0,
    SentStory = 1
} CategoryItem;

typedef enum {
    ListTypeArticle,
    PromotedArticle,
    FeaturedArticle
} ArticleType;


//  Colors

//  Theme green color
#define kThemeGreen             [UIColor colorWithRed:32.0/255.0 green:158.0/255.0 blue:144.0/255.0 alpha:1.0]

#define kPNGNewsColor           [UIColor colorWithRed:0.0/255.0 green:172.0/255.0 blue:162.0/255.0 alpha:1.0]

#define kRegionalColor          [UIColor colorWithRed:10.0/255.0 green:112.0/255.0 blue:115.0/255.0 alpha:1.0]

#define kEncompassColor         [UIColor colorWithRed:237.0/255.0 green:196.0/255.0 blue:7.0/255.0 alpha:1.0]

#define kBusinessColor          [UIColor colorWithRed:132.0/255.0 green:189.0/255.0 blue:0.0/255.0 alpha:1.0]

#define kEntertainmentColor     [UIColor colorWithRed:255.0/255.0 green:116.0/255.0 blue:23.0/255.0 alpha:1.0]

#define kSportsColor            [UIColor colorWithRed:0.0/255.0 green:169.0/255.0 blue:225.0/255.0 alpha:1.0]

#define kWorldColor             [UIColor colorWithRed:200.0/255.0 green:40.0/255.0 blue:114.0/255.0 alpha:1.0]

#define kClassifiedsColor       [UIColor colorWithRed:130.0/255.0 green:201.0/255.0 blue:195.0/255.0 alpha:1.0]

#define kSentStoryColor         [UIColor colorWithRed:0.0/255.0 green:172.0/255.0 blue:162.0/255.0 alpha:1.0]


#define kMenuDefaultColor       [UIColor colorWithRed:132.0/255.0 green:132.0/255.0 blue:132.0/255.0 alpha:1.0]


//  Logged in status key
#define kLoginStatus    @"user_login_status"

// Logged in with Facebook key
#define kLoggedInWithFacebook @"facebook_user_login"

//  Article swipe status
#define kSwipeArticleStatus     @"swipe_article_status"

//  notification names

//  Login button action notifications
#define kLoginButtonPressed     @"login_button_pressed"

//  User info button action notification in menu view
#define kUserInfoButtonPressed  @"user_info_button_pressed"

//  Menu item selection notification
#define kMenuSelectionNotification  @"menu_item_selected_from_side_menu"

//  Category icon selection notification in side menu
#define kCategorySelectionNotification  @"category_selected_from_side_menu"

//  Search feature triggering by pulling the table view
#define kSearchTriggeredNotification    @"search_feature_triggered_in_home_view"

//  Refresh feature triggering by pulling the table view
#define kRefreshTriggeredNotification    @"refresh_feature_triggered_in_home_view"

//  Show or hide subcategories table view.
#define kFilterSelectionNotification    @"filter_selection_in_articles_view"

//  Sub category item selected notification.
#define kSubCategoryItemSelected    @"sub_category_item_selected_from_articles_view"


// itunes link of the application
#define kITunesLink @"itms-apps://itunes.apple.com/us/app/whatsapp-messenger/id310633997?mt=8"

//  Feedback email address
#define kFeedBackEmailID    @"test@test.co.nz"


#define HTTP_METHOD_POST        @"POST"
#define HTTP_METHOD_GET         @"GET"

// Strings
#define ERROR @"Error"

#define ERROR_MESSAGE           @"error_message"
#define ERROR_STATUS            @"error"
#define RESULT_STATUS           @"result"
#define MESSAGE                 @"message"
#define STATUS                  @"status"
#define DATE_FORMAT             @"dd MM yyyy HH mm ss"

#define ME @"me"
#define EMAIL_KEY @"email"
#define FIRST_NAME_KEY @"first_name"
#define LAST_NAME_KEY @"last_name"
#define ID_KEY @"id"
#define NULL_STRING @""
#define IMAGE_TYPE @"image"
#define VIDEO_TYPE @"video"
#define DATA_KEY @"data"
#define TYPE_KEY @"type"

#define IMAGE_FILE_NAME @"image.png"
#define IMAGE_FILE_NAME_JPG @"image.jpg"
#define VIDEO_FILE_NAME @"video.mp4"
#define IMAGE_MIME_TYPE @"image/jpeg"
#define VIDEO_MIME_TYPE @"video/mp4"

#define kUserInfo   @"user_info"
#define kAuthCookie @"cookie"

#define kLastCommentTime @"last_comment_time"
#endif
