//
//  CommentCell.h
//  News
//
//  Created by Vidvat Joshi on 03/03/16.
//  Copyright © 2016 ACS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *userPic;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblTimestamp;
@property (strong, nonatomic) IBOutlet UILabel *lblComment;

@end
