//
//  PNGCommentsViewController.m
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGCommentsViewController.h"
#import "PNGAddCommentViewController.h"
#import "PNGLoadMoreCell.h"

static int const RepliesPerPage = 10;
static int const ResultsPerPage = 10;
static int const LoadMoreCellHeight = 52;
static int const TopSpace = 18;
static int const CommentsSection = 0;
static int const LoadMoreButtonSection = 1;

#define TopHeaderBgColor [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1.0f];

@interface PNGCommentsViewController () {
    IBOutlet UITableView *commentsTableView;
    
    NSMutableArray *contentArray;
    NSMutableArray *commentsArray;
    NSMutableArray *expandedCommentsArray;
    
    NSMutableDictionary *fetchedRepliesCount; //Count of Replies Fetched (CommentID : FetchedCount)
    NSMutableDictionary *allRepliesCount; //Total Count of Replies of a comment
    
    BOOL showAddCommentView;
    
    int commentsCount;
    BOOL showLoadMoreCommentsButton;
    
    PNGComment *lastExpandedComment;
    
    NSInteger indexOfCommentRepliedTo;
    NSInteger parentCommentId;
    
    NSInteger queryLimit;
    NSInteger querySkip;
}

@property (nonatomic, strong) PNGCommentCell *commentPrototypeCell;
@property (nonatomic, strong) PNGCommentReplyCell *replyPrototypeCell;

@end

@implementation PNGCommentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Comments";
    contentArray = [[NSMutableArray alloc] init];       // Array to hold comments & replies.
    commentsArray = [[NSMutableArray alloc] init];
    expandedCommentsArray = [[NSMutableArray alloc] init];
    
    fetchedRepliesCount = [[NSMutableDictionary alloc] init];
    allRepliesCount = [[NSMutableDictionary alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // If the user was trying to add a comment, show add comment view.
    //    PNGUser *user = [PNGUser currentUser];
    
    if (showAddCommentView && [[NSUserDefaults standardUserDefaults] boolForKey:kLoginStatus]) {
        showAddCommentView = NO;
        PNGAddCommentViewController *addCommentViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:PNGStoryboardViewControllerAddComment];
        addCommentViewController.postId = self.postId;
        
        if (parentCommentId) {
            addCommentViewController.parentCommentId = [NSString stringWithFormat:@"%ld", (long)parentCommentId];
            parentCommentId = 0;
        }
        [self.navigationController pushViewController:addCommentViewController animated:YES];
    } else {
        [self setupView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    // Check for restoring the state of last expanded row if the view was already loaded
    if (expandedCommentsArray.count > 0) {
        lastExpandedComment = [expandedCommentsArray lastObject];
        
        if (indexOfCommentRepliedTo != -1) {    // If a comment was replied to, it should be the one that should be shown expanded.
            lastExpandedComment = [contentArray objectAtIndex:indexOfCommentRepliedTo];
            indexOfCommentRepliedTo = -1;
        }
        
        if (lastExpandedComment.parent) {   // If its a reply, expand the parent comment first
            PNGComment *parentComment = [[commentsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"wpCommentId == %d", lastExpandedComment.parent]] objectAtIndex:0];
            lastExpandedComment = parentComment;
        }
        
        [expandedCommentsArray removeAllObjects];
        [expandedCommentsArray addObject:lastExpandedComment];
    } else {
        lastExpandedComment = nil;
        indexOfCommentRepliedTo = -1;
    }
    
    parentCommentId = 0;
    showLoadMoreCommentsButton = NO;
    
    // Fetch all comments upto which user has loaded
    if (commentsArray.count) {
        queryLimit = commentsArray.count;
    } else {
        queryLimit = ResultsPerPage;        // Initially limited no. of comments are loaded
    }
    
    querySkip = 0;
    [self fetchComments];
}

#pragma mark - Fetch Comment Methods

- (PFQuery*)queryForComments {
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query whereKey:@"postId" equalTo:self.postId];
    [query whereKey:@"parent" equalTo:[NSNumber numberWithInt:0]];      // Fetching only the top-level comments initially
    return query;
}

- (void)fetchComments {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    PFQuery *query = [self queryForComments];
    query.limit = queryLimit;
    query.skip = querySkip;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [query orderBySortDescriptor:sortDescriptor];
    
    __weak PNGCommentsViewController *weakSelf = self;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        BOOL hideHUD = YES;
        
        if (!error) {
            if (objects.count > 0) {
                showLoadMoreCommentsButton = NO;
                
                if (!querySkip) {
                    [contentArray removeAllObjects];
                    [commentsArray removeAllObjects];
                }
                [contentArray addObjectsFromArray:objects];
                [commentsArray addObjectsFromArray:objects];
                
                // Load up replies if comment was previously expanded
                if (lastExpandedComment) {
                    hideHUD = NO;   // Hide Loading indicator after loading replies
                    
                    lastExpandedComment = [[commentsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"wpCommentId == %d", lastExpandedComment.wpCommentId]] objectAtIndex:0];
                    [expandedCommentsArray removeAllObjects];
                    [expandedCommentsArray addObject:lastExpandedComment];
                    [commentsTableView reloadData];
                    
                    [allRepliesCount setObject:@(0) forKey:[@(lastExpandedComment.wpCommentId) stringValue]];
                    [fetchedRepliesCount setObject:@(0) forKey:[@(lastExpandedComment.wpCommentId) stringValue]];
                    [weakSelf fetchRepliesForCommentWithId:lastExpandedComment.wpCommentId andLoadAtIndex:[contentArray indexOfObject:lastExpandedComment]];
                    lastExpandedComment = nil;
                } else {
                    [commentsTableView reloadData];
                }
                
                // Comment count is not needed if comments fetched are less than ResultsPerPage
                // Fetch comments count only if its not already fetched
                if ((objects.count == ResultsPerPage && commentsCount == 0) || commentsArray.count < commentsCount) {
                    showLoadMoreCommentsButton = YES;
                    [self fetchCommentsCount];
                }
            }
        } else {
            [PNGUtilities showAlertWithTitle:NSLocalizedString(@"FAILED", @"") message:error.localizedDescription];
        }
        
        if (hideHUD) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

// Will return total no of comments
- (void)fetchCommentsCount {
    PFQuery *query = [self queryForComments];
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!error) {
            commentsCount = count;          // The count request succeeded, set the count
            
            if (commentsArray.count == count) {
                showLoadMoreCommentsButton = NO;
            }
            [commentsTableView reloadData];
        } else {
            commentsCount = 0;              // Request failed
        }
    }];
}

- (PFQuery*)queryForReplyWithId:(NSInteger)commentId {
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query whereKey:@"parent" equalTo:[NSNumber numberWithInteger:commentId]];
    return query;
}

- (void)fetchRepliesForCommentWithId:(NSInteger)commentId andLoadAtIndex:(NSInteger)index {
    PFQuery *query = [self queryForReplyWithId:commentId];
    NSInteger count = [[fetchedRepliesCount valueForKey:[@(commentId) stringValue]] intValue];
    query.limit = RepliesPerPage;
    query.skip = count;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    [query orderBySortDescriptor:sortDescriptor];
    
    __weak PNGCommentsViewController *weakSelf = self;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // Remove Load more button if its already shown
        if (count >= RepliesPerPage) {
            PNGComment *lastExpandedCommentObject = [expandedCommentsArray lastObject];
            [self removeLoadMoreButtonForComment:commentId andIndex:[contentArray indexOfObject:lastExpandedCommentObject]];
        }
        if (!error) {
            if (objects.count > 0) {
                [contentArray insertObjects:objects atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index+1, objects.count)]];
                [commentsTableView reloadData];
            }
            [fetchedRepliesCount setObject:@(objects.count + count) forKey:[@(commentId) stringValue]];     // Current loaded replies count set for load more action
            
            // Fetch the replies count from server
            if (objects.count == RepliesPerPage) {
                [weakSelf fetchReplyCountWithId:commentId];
            } else {
                [weakSelf updateLoadMoreRepliesButtonForComment:commentId];
            }
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)fetchReplyCountWithId:(NSInteger)commentId {
    PFQuery *query = [self queryForReplyWithId:commentId];
    __weak PNGCommentsViewController *weakSelf = self;
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            [allRepliesCount setObject:@(count) forKey:[@(commentId) stringValue]];
            [weakSelf updateLoadMoreRepliesButtonForComment:commentId];
        } else {
            [allRepliesCount setObject:@(0) forKey:[@(commentId) stringValue]];     // The request failed
        }
    }];
}

// Will Add/Remove the LoadMore Replies button
// Decision based on FetchedRepliesCount and RepliesCount
- (void)updateLoadMoreRepliesButtonForComment:(NSInteger)commentId {
    PNGComment *lastExpandedCommentObject = [expandedCommentsArray lastObject];
    NSInteger lastExpandedCommentIndex = [contentArray indexOfObject:lastExpandedCommentObject];
    NSInteger fetchedCount = [[fetchedRepliesCount valueForKey:[@(commentId) stringValue]] intValue];
    NSInteger totalCount = [[allRepliesCount valueForKey:[@(commentId) stringValue]] intValue];
    
    // Compare TotalCount with FetchedCount, and add Load More button if neceessary
    // For showing Load more button insert a NULL object to the corresponding index in contentArray and reload table
    if (fetchedCount < totalCount) {
        NSInteger indexOfLoadMorebutton = lastExpandedCommentIndex + fetchedCount + 1;
        [contentArray insertObject:[NSNull null] atIndex:indexOfLoadMorebutton];                // Show Load More Button
    } else {
        [self removeLoadMoreButtonForComment:commentId andIndex:lastExpandedCommentIndex];  // Remove Load More Button
    }
    [commentsTableView reloadData];
}

// Will remove the load more button placeholder if exists
- (void)removeLoadMoreButtonForComment:(NSInteger)commentId andIndex:(NSInteger)index {
    NSInteger fetchedCount = [[fetchedRepliesCount valueForKey:[@(commentId) stringValue]] intValue];
    NSInteger loadMoreButtonIndex = index + fetchedCount + 1;
    
    if (loadMoreButtonIndex < contentArray.count && [[contentArray objectAtIndex:loadMoreButtonIndex] isKindOfClass:[NSNull class]]) {
        //Remove placeholder for loadmore button
        [contentArray removeObjectAtIndex:loadMoreButtonIndex];
    }
}

#pragma mark - IBActions

- (IBAction)addComment:(id)sender {
    // Show add comment view if user is logged in, otherwise show sign in view.
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kLoginStatus]) {
        PNGAddCommentViewController *addCommentViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:PNGStoryboardViewControllerAddComment];
        addCommentViewController.postId = self.postId;
        [self.navigationController pushViewController:addCommentViewController animated:YES];
    } else {
        showAddCommentView = YES;
        UINavigationController *signInController = [STORY_BOARD instantiateViewControllerWithIdentifier:PNGStoryboardNavViewControllerLogin];
        [self.navigationController presentViewController:signInController animated:YES completion:nil];
    }
}

#pragma mark - PNGCommentCellDelegate methods

- (void)shareButtonSelectedForCommentWithText:(NSString *)text {
    NSString *shareText = text;
    NSArray *activityItems = @[shareText];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[]];
    [activityController setValue:@"Keeping you in the Loop" forKey:@"subject"];
    //items to be excluded from activity view controller
    NSArray *excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    activityController.excludedActivityTypes = excludeActivities;
    [self.navigationController presentViewController:activityController animated:YES completion:nil];
}

- (void)replyButtonSelectedForCommentAtIndex:(NSInteger)index {
    indexOfCommentRepliedTo = index;
    PNGComment *commentRepliedTo = [contentArray objectAtIndex:index];
    
    // Show add comment view if user is logged in, otherwise show sign in view.
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kLoginStatus]) {
        PNGAddCommentViewController *addCommentViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:PNGStoryboardViewControllerAddComment];
        addCommentViewController.postId = self.postId;
        addCommentViewController.parentCommentId = [NSString stringWithFormat:@"%ld", (long)commentRepliedTo.wpCommentId];
        [self.navigationController pushViewController:addCommentViewController animated:YES];
    } else {
        showAddCommentView = YES;
        parentCommentId = commentRepliedTo.wpCommentId;
        UINavigationController *signInController = [STORY_BOARD instantiateViewControllerWithIdentifier:PNGStoryboardNavViewControllerLogin];
        [self.navigationController presentViewController:signInController animated:YES completion:nil];
    }
}

#pragma mark - TableView methods

- (PNGCommentCell *)commentPrototypeCell {
    if (!_commentPrototypeCell) {
        _commentPrototypeCell = [commentsTableView dequeueReusableCellWithIdentifier:@"PNGCommentCell"];
    }
    return _commentPrototypeCell;
}

- (PNGCommentReplyCell *)replyPrototypeCell {
    if (!_replyPrototypeCell) {
        _replyPrototypeCell = [commentsTableView dequeueReusableCellWithIdentifier:@"PNGCommentReplyCell"];
    }
    return _replyPrototypeCell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    PNGComment *comment = [contentArray objectAtIndex:indexPath.row];
    
    if (comment.parent) {
        PNGCommentReplyCell *commentCell = (PNGCommentReplyCell *)cell;
        
        PNGComment *parentComment = [[commentsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"wpCommentId == %d", comment.parent]] objectAtIndex:0];
        commentCell.index = [commentsArray indexOfObject:parentComment];
        
        if ([expandedCommentsArray containsObject:comment]) {
            commentCell.isExpanded = YES;
        } else {
            commentCell.isExpanded = NO;
        }
        
        commentCell.reply = comment;
    } else {
        PNGCommentCell *commentCell = (PNGCommentCell *)cell;
        commentCell.index = [commentsArray indexOfObject:comment];
        
        if ([expandedCommentsArray containsObject:comment]) {
            commentCell.isExpanded = YES;
        } else {
            commentCell.isExpanded = NO;
        }
        
        commentCell.comment = comment;
    }
}

#pragma mark - TableViewController DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (showLoadMoreCommentsButton) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == CommentsSection) {
        return contentArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == CommentsSection) {
        return TopSpace;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (section == CommentsSection) {
        view.tintColor = TopHeaderBgColor;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = TopSpace;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == LoadMoreButtonSection) {
        return LoadMoreCellHeight;
    } else {
        if ([[contentArray objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {    // Return constant height for load more cell
            return LoadMoreCellHeight;
        } else {
            PNGComment *comment = [contentArray objectAtIndex:indexPath.row];
            
            if (comment.parent) {
                [self configureCell:self.replyPrototypeCell forRowAtIndexPath:indexPath];
                [self.replyPrototypeCell layoutIfNeeded];
                CGSize size = [self.replyPrototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
                return (size.height + 1);
            } else {
                [self configureCell:self.commentPrototypeCell forRowAtIndexPath:indexPath];
                [self.commentPrototypeCell layoutIfNeeded];
                CGSize size = [self.commentPrototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
                return (size.height + 1);
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.section == CommentsSection) {
        if (![[contentArray objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
            PNGComment *comment = [contentArray objectAtIndex:indexPath.row];
            
            if (comment.parent) {
                static NSString *cellIdentifier = @"PNGCommentReplyCell";
                PNGCommentReplyCell *cell = (PNGCommentReplyCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                [self configureCell:cell forRowAtIndexPath:indexPath];
                cell.delegate = self;
                return cell;
            } else {
                static NSString *cellIdentifier = @"PNGCommentCell";
                PNGCommentCell *cell = (PNGCommentCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                [self configureCell:cell forRowAtIndexPath:indexPath];
                cell.delegate = self;
                return cell;
            }
        } else {
            cell = [self loadViewMoreRepliesCell:tableView cellForRowAtIndexPath:indexPath];
        }
    } else {
        cell = [self loadViewMoreCommentsCell:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}

- (PNGLoadMoreCell *)loadViewMoreRepliesCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Show Load more replies cell
    static NSString *cellIdentifier = @"PNGLoadMoreCell";
    PNGLoadMoreCell *cell = (PNGLoadMoreCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PNGComment *aReply = [contentArray objectAtIndex:indexPath.row - 1];
    PNGComment *parentComment = [[commentsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"wpCommentId == %d", aReply.parent]] objectAtIndex:0];
    NSIndexPath *parentCommentIndex = [NSIndexPath indexPathForRow:[contentArray indexOfObject:parentComment] inSection:0];
    
    // Align load more replies option according to parent comment's alignment
    if (parentCommentIndex.row % 2 == 0) {
        cell.cellAlignment = Right;
    } else {
        cell.cellAlignment = Left;
    }
    
    NSInteger fetchedCount = [[fetchedRepliesCount valueForKey:[@(parentComment.wpCommentId) stringValue]] intValue];
    NSInteger totalCount = [[allRepliesCount valueForKey:[@(parentComment.wpCommentId) stringValue]] intValue];
    long remainingCount = totalCount - fetchedCount;
    
    if (remainingCount > RepliesPerPage) {
        remainingCount = RepliesPerPage;
    }
    
    cell.loadMoreButton.tag = indexPath.row;
    [cell.loadMoreButton removeTarget:self action:@selector(loadMoreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.loadMoreButton addTarget:self action:@selector(loadMoreRepliesButtonAction:) forControlEvents:UIControlEventTouchUpInside];  // For loading next set of replies
    
    NSString *loadMoreText = [NSString stringWithFormat:@"View %ld more Replies", remainingCount];
    
    if (remainingCount == 1) {
        loadMoreText = @"View 1 more reply";
    }
    [cell.loadMoreTextLabel setText:loadMoreText];
    
    return cell;
}

- (PNGLoadMoreCell *)loadViewMoreCommentsCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PNGLoadMoreCell";
    PNGLoadMoreCell *cell = (PNGLoadMoreCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.cellAlignment = Centered;
    [cell.loadMoreButton removeTarget:self action:@selector(loadMoreRepliesButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.loadMoreButton addTarget:self action:@selector(loadMoreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    long remainingCommentsCount = commentsCount - commentsArray.count;
    
    if (remainingCommentsCount > ResultsPerPage) {
        remainingCommentsCount = ResultsPerPage;
    }
    
    NSString *loadMoreText = [NSString stringWithFormat:@"View %ld more comments", remainingCommentsCount];
    
    if (remainingCommentsCount == 1) {
        loadMoreText = @"View 1 more comment";
    }
    [cell.loadMoreTextLabel setText:loadMoreText];
    return cell;
}

// Fetch More Replies button action
- (void)loadMoreRepliesButtonAction:(UIButton*)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSInteger buttonIndex = sender.tag;
    PNGComment *previousComment = [contentArray objectAtIndex:buttonIndex - 1];
    [self fetchRepliesForCommentWithId:previousComment.parent andLoadAtIndex:buttonIndex - 1];
}

// Fetch More comments button action
- (void)loadMoreButtonAction:(id)sender {
    queryLimit = ResultsPerPage;
    querySkip = commentsArray.count;
    [self fetchComments];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //No Action for Load More button cell
    if (indexPath.section == LoadMoreButtonSection || [[contentArray objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
        return;
    }
    
    PNGComment *comment = [contentArray objectAtIndex:indexPath.row];
    // Adding & removing selected cells to an array to handle the ones which are to be expanded/contracted.
    if ([expandedCommentsArray containsObject:comment]) {
        [expandedCommentsArray removeObject:comment];   // Reset cell to normal size, remove replies
        
        if (!comment.parent) {
            [self removeLoadMoreButtonForComment:comment.wpCommentId andIndex:indexPath.row];
            
            NSArray *repliesArray = [contentArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"parent == %d", comment.wpCommentId]];
            
            if (repliesArray.count) {
                [contentArray removeObjectsInArray:repliesArray];     // Remove replies
            }
            [allRepliesCount setObject:@(0) forKey:[@(comment.wpCommentId) stringValue]];
            [fetchedRepliesCount setObject:@(0) forKey:[@(comment.wpCommentId) stringValue]];
        }
        
        [UIView transitionWithView:commentsTableView duration:kAnimationDuration options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void) {
            [commentsTableView reloadData];
        } completion:^(BOOL finished) {}];
    } else {
        [expandedCommentsArray addObject:comment];  // Expand this cell, load replies
        
        [UIView transitionWithView:commentsTableView duration:kAnimationDuration options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void) {
            [commentsTableView reloadData];
        } completion:^(BOOL finished) {
            if (!comment.parent) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self fetchRepliesForCommentWithId:comment.wpCommentId andLoadAtIndex:indexPath.row];   // Load replies
            }
        }];
    }
}

@end
