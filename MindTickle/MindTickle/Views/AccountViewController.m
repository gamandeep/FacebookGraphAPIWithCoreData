//
//  AccountViewController.m
//  MindTickle
//
//  Created by Gamandeep Sethi on 19/09/17.
//  Copyright © 2017 Gamandeep Sethi. All rights reserved.
//

#import "AccountViewController.h"
#import <UIImageView+AFNetworking.h>
#import "MTDataImporter.h"
#import "MTCommons.h"

@interface AccountViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) User *userObj;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.userId) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [self setUserId:[prefs objectForKey:kPrefsUserIDKey]];
    }
    else {
        [self updateUIWithUserData];
    }
    // Do any additional setup after loading the view.
}

- (void)setUserId:(NSString *)userId {
    _userId = userId;
    [[MTDataImporter sharedManager] loadProfileForUserId:userId completion:^(User *user, NSError *error) {
        [self setUserData:user];
        [self updateUIWithUserData];
    }];
}

- (void)setUserData:(User *)userObj {
    _userObj = userObj;
}

- (void)updateUIWithUserData {
    [self.coverImageView setImageWithURL:[NSURL URLWithString:self.userObj.cover]];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.userObj.picture]];
    self.nameLabel.text = self.userObj.name;
    self.genderLabel.text = self.userObj.gender;
    self.birthdayLabel.text = self.userObj.birthday;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
