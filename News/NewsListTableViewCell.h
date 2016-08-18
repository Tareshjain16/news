//
//  NewsListTableViewCell.h
//  News
//
//  Created by user1 on 27/02/16.
//  Copyright © 2016 ACS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *newsStringLbl;
@property (strong, nonatomic) IBOutlet UILabel *newsChannelNameLbl;
@property (strong, nonatomic) IBOutlet UIImageView *channelImg;
@property (strong, nonatomic) IBOutlet UIView *cellView;
@property (strong, nonatomic) IBOutlet UIImageView *newsImg;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong, nonatomic) IBOutlet UIButton *btnComment;

@end
