//
//  PNGClassifieds.h
//  DigicelPNG
//
//  Created by Subins Jose on 02/09/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <Parse/Parse.h>

@interface PNGClassifieds : PFObject<PFSubclassing>

@property (retain) NSString *ad_category;
@property (retain) NSString *ad_category_id;
@property (retain) NSString *ad_category_parent_id;
@property (retain) NSString *ad_city;
@property (retain) NSString *ad_contact_email;
@property (retain) NSString *ad_contact_name;
@property (retain) NSString *ad_contact_phone;
@property (retain) NSString *ad_country;
@property (retain) NSString *ad_country_village;
@property (retain) NSString *ad_details;
@property (retain) NSString *ad_enddate;
@property (retain) NSString *ad_fee_paid;
@property (retain) NSString *ad_id;
@property (retain) NSArray  *ad_images;
@property (retain) NSString *ad_item_prize;
@property (retain) NSString *ad_key;
@property (retain) NSString *ad_last_updated;
@property (retain) NSString *ad_parent_category;
@property (retain) NSString *ad_postdate;
@property (retain) NSString *ad_startdate;
@property (retain) NSString *ad_state;
@property (retain) NSString *ad_title;
@property (retain) NSString *ad_transaction_id;
@property (retain) NSString *ad_url;
@property (retain) NSString *ad_views;
@property (retain) NSString *adterm_id;
@property (retain) NSString *attach_cv;
@property (retain) NSString *contact_address;
@property (retain) NSString *disabled;
@property (retain) NSString *display_name;
@property (retain) NSString *flagged;
@property (retain) NSString *is_featured_ad;
@property (retain) NSString *payer_email;
@property (retain) NSString *payment_gateway;
@property (retain) NSString *payment_status;
@property (retain) NSString *payment_term_type;
@property (retain) NSString *posterip;
@property (retain) NSString *renew_email_sent;
@property (retain) NSString *user_email;
@property (retain) NSString *user_id;
@property (retain) NSString *user_login;
@property (retain) NSString *user_nicename;
@property (retain) NSString *verified;
@property (retain) NSString *verified_at;
@property (retain) NSString *websiteutl;

+ (NSString *)parseClassName;

@end
