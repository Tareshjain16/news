//
//  FavoriteTableViewCell.h
//  News
//
//  Created by Taresh Jain on 05/03/16.
//  Copyright © 2016 ACS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *newsStringLbl;
@property (strong, nonatomic) IBOutlet UILabel *newsChannelNameLbl;
@property (strong, nonatomic) IBOutlet UIImageView *channelImg;
@property (strong, nonatomic) IBOutlet UIView *cellView;
@property (strong, nonatomic) IBOutlet UIImageView *newsImg;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong, nonatomic) IBOutlet UIButton *btnComment;


@end
