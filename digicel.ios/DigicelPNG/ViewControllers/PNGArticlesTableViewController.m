//
//  PNGArticlesTableViewController.m
//  DigicelPNG
//
//  Created by Arundev K S on 28/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGArticlesTableViewController.h"

@interface PNGArticlesTableViewController ()
{
    int indexForLoadMore;
    BOOL articlesFinished;
}
@end

@implementation PNGArticlesTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    articlesFinished = NO;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter methods

//  Setter method for articles.
- (void)setArticles:(NSArray *)articles {
    _articles =[[NSMutableArray alloc]initWithArray:articles];
    [self.tableView reloadData];
    if(articles.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _articles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PNGListArticleCell";
    PNGListArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PNGListArticleCell" owner:nil options:nil] firstObject];
    }
    cell.article = [_articles objectAtIndex:indexPath.row];
    if(indexPath.row == _articles.count-1 && !articlesFinished) {
        indexForLoadMore++;
        [self loadMoreButtonAction:nil];
    }
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_delegate && [_delegate respondsToSelector:@selector(articlesTableSelection:didSelectArticle:)]) {
        [_delegate articlesTableSelection:self didSelectArticle:[_articles objectAtIndex:indexPath.row]];
    }
}

//Fetching next set of search results from the DB .
- (void)loadMoreButtonAction:(id)sender {
    PFQuery *titleQuery = [PNGArticle query];
    [titleQuery whereKey:@"title" containsString:_searchFieldText.lowercaseString];
    PFQuery *contentQuery = [PNGArticle query];
    [contentQuery whereKey:@"content" containsString:_searchFieldText.lowercaseString];
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[titleQuery,contentQuery]];
    [query whereKey:@"category" containsAllObjectsInArray:@[_category]];
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"publishedDate" ascending:NO];
    [query orderBySortDescriptor:sortDesc];
    query.limit = 10;
    query.skip = 10*indexForLoadMore;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [_articles addObjectsFromArray:objects];
            if (objects.count%10 > 0) {
                articlesFinished=YES;
            }
            [self.tableView reloadData];
        }
    }];
}
    

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
