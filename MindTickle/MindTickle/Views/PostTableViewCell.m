//
//  PostTableViewCell.m
//  MindTickle
//
//  Created by Gamandeep Sethi on 21/09/17.
//  Copyright © 2017 Gamandeep Sethi. All rights reserved.
//

#import "PostTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "TextPost.h"
#import "LinkPost.h"
#import "PicturePost.h"

@interface PostTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation PostTableViewCell

- (void)setPostData:(Post *)post {
    self.nameLabel.text = post.userName;
    self.dateLabel.text = post.createdTime;
    self.typeLabel.text = post.type;
    NSString *type = post.type;
    if ([type isEqualToString:@"status"]) {
        self.messageLabel.text = ((TextPost *)post).message;
        [self.pictureImageView setImage:nil];
    }
    else if ([type isEqualToString:@"photo"]) {
        if (((PicturePost *)post).picture.length) {
            [self.pictureImageView setImageWithURL:[NSURL URLWithString:((PicturePost *)post).picture]];
        }
        else {
            [self.pictureImageView setImage:nil];
        }
        [self.messageLabel setText:nil];
    }
    else if ([type isEqualToString:@"link"]) {
        self.messageLabel.text = ((LinkPost *)post).link;
        [self.pictureImageView setImage:nil];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.pictureImageView setImage:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
