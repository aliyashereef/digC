//
//  PNGSubCategoryViewController.m
//  DigicelPNG
//
//  Created by Arundev K S on 02/06/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGSubCategoryViewController.h"

#define kCellHeight     44

@interface PNGSubCategoryViewController ()

@end

@implementation PNGSubCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter methods

//  Setter method for subcategories.
- (void)setSubCategories:(NSArray *)subCategories {
    _subCategories = subCategories;
    [subCategoryTable reloadData];
    if(subCategories.count > 0) {
        [subCategoryTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    CGFloat height = kCellHeight * subCategories.count;
    tableHeight.constant = (height < self.view.frame.size.height?height:self.view.frame.size.height);
}

#pragma mark - IB Actions

//  Hide subcategories list on background touch.
- (IBAction)hideSubCategoryList:(id)sender {
    self.view.hidden = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _subCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PNGSubCategoryCell";
    PNGSubCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PNGSubCategoryCell" owner:nil options:nil] firstObject];
    }
    cell.titleLabel.text = [[_subCategories objectAtIndex:indexPath.row] valueForKey:@"title"];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSubCategoryItemSelected
                                                        object:[_subCategories objectAtIndex:indexPath.row]];
}

@end
