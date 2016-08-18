//
//  EditSorcesTableViewCell.h
//  News
//
//  Created by user1 on 11/03/16.
//  Copyright © 2016 ACS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditSorcesTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *sourceChanelNmeLbl;
@property (strong, nonatomic) IBOutlet UIImageView *sourceImg;

//For Channel List View
@property (strong, nonatomic) IBOutlet UIImageView *ChanelImg;
@property (strong, nonatomic) IBOutlet UIButton *AddBtn;

@end
