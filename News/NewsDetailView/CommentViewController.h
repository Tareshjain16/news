//
//  CommentViewController.h
//  NewsApp
//
//  Created by Vidvat Joshi on 24/02/16.
//  Copyright © 2016 Vidvat Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UILabel *timeLbl;
    IBOutlet UILabel *newsStringLbl;
    IBOutlet UILabel *newsChannelNameLbl;
    IBOutlet UIImageView *newsImg;
    IBOutlet UITextField *tfComment;
    IBOutlet UITableView *tblComments;
    IBOutlet UIButton *btnPostComment;
    IBOutlet UIView *viewComment;
    NSMutableArray *responseArray;
    int pageIndex;
}
@property (nonatomic, strong)NSDictionary *dictNewInfo;
- (IBAction)onTap_BtnPostComment:(id)sender;
@end
