//
//  HomeViewController.m
//  MindTickle
//
//  Created by Gamandeep Sethi on 19/09/17.
//  Copyright © 2017 Gamandeep Sethi. All rights reserved.
//

#import "HomeViewController.h"
#import "MTAPIManager.h"
#import <CoreData/CoreData.h>
#import "Post.h"
#import "AppDelegate.h"
#import "PostTableViewCell.h"
#import "AccountViewController.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, atomic) NSMutableArray *posts;
@property BOOL isInitialLoadDone;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.posts = [[NSMutableArray alloc] init];
    [self getCachedData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData {
    [[MTAPIManager sharedManager] loadPostsWithCompletionBlock:^(NSArray *posts, NSError *error) {
        if (posts && !error) {
            @synchronized(self) {
                if (!self.isInitialLoadDone) {
                    [self.posts removeAllObjects];
                    self.isInitialLoadDone = YES;
                }
                [self.posts addObjectsFromArray:posts];
            }
            [self.tableView reloadData];
        }
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Something went wrong" message:@"Either check your access token or internet connection" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okay = [UIAlertAction actionWithTitle:@"okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:okay];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)getCachedData {
    [[MTDataImporter sharedManager] loadPostsWithCompletionBlock:^(NSArray *posts, NSError *error) {
        [self.posts addObjectsFromArray:posts];
        [self.tableView reloadData];
        [self getData];
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return self.posts.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    Post *object = (Post *)[self objectAtIndexPath:indexPath];
    PostTableViewCell *cell;
    if ([object.type isEqualToString:@"photo"]) {
        cell = (PostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
    }
    else {
        cell = (PostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"statusCell" forIndexPath:indexPath];
    }
    [cell setPostData:object];
    return cell;
}

- (id)objectAtIndexPath:(NSIndexPath*)indexPath {
    return [self.posts objectAtIndex:indexPath.row];
}

#pragma mark UITableViewDataSource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger totalCount = self.posts.count;
    if (indexPath.row == totalCount - 1) {
        [self getData];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AccountViewController *vc = (AccountViewController *)segue.destinationViewController;
    PostTableViewCell *cell = (PostTableViewCell *)sender;
    if ([cell isKindOfClass:[PostTableViewCell class]]) {
        Post *post = [self objectAtIndexPath:[self.tableView indexPathForCell:cell]];
        [vc setUserId:post.userId];
    }
}


@end
