//
//  PNGClassifieds.m
//  DigicelPNG
//
//  Created by Subins Jose on 02/09/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGClassifieds.h"
#import <Parse/PFObject+Subclass.h>

@implementation PNGClassifieds
@dynamic ad_category;
@dynamic ad_category_id;
@dynamic ad_category_parent_id;
@dynamic ad_city;
@dynamic ad_contact_email;
@dynamic ad_contact_name;
@dynamic ad_contact_phone;
@dynamic ad_country;
@dynamic ad_country_village;
@dynamic ad_details;
@dynamic ad_enddate;
@dynamic ad_fee_paid;
@dynamic ad_id;
@dynamic ad_images;
@dynamic ad_item_prize;
@dynamic ad_key;
@dynamic ad_last_updated;
@dynamic ad_parent_category;
@dynamic ad_postdate;
@dynamic ad_startdate;
@dynamic ad_state;
@dynamic ad_title;
@dynamic ad_transaction_id;
@dynamic ad_url;
@dynamic ad_views;
@dynamic adterm_id;
@dynamic attach_cv;
@dynamic contact_address;
@dynamic disabled;
@dynamic display_name;
@dynamic flagged;
@dynamic is_featured_ad;
@dynamic payer_email;
@dynamic payment_gateway;
@dynamic payment_status;
@dynamic payment_term_type;
@dynamic posterip;
@dynamic renew_email_sent;
@dynamic user_email;
@dynamic user_id;
@dynamic user_login;
@dynamic user_nicename;
@dynamic verified;
@dynamic verified_at;
@dynamic websiteutl;

+ (NSString *)parseClassName {
    return @"Classifieds";
}

@end
