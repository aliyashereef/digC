//
//  PNGSubCategoryViewController.h
//  DigicelPNG
//
//  Created by Arundev K S on 02/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNGSubCategoryCell.h"

/*
 Subclass of UIViewController. Lists all the available subcategories of a category item.
 Contains a table view with transparent background. Category item selection data is passed
 to the parent viewcontroller via NSNotification.
 */

@interface PNGSubCategoryViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    
    IBOutlet UITableView *subCategoryTable;
    IBOutlet NSLayoutConstraint *tableHeight;
}

@property (nonatomic, strong) NSArray *subCategories;

@end
