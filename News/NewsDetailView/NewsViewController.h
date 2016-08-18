//
//  NewsViewController.h
//  NewsApp
//
//  Created by Vidvat Joshi on 24/02/16.
//  Copyright © 2016 Vidvat Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController
{
    IBOutlet NSLayoutConstraint *channelImgConstant;
    IBOutlet NSLayoutConstraint *lblConstant;
    IBOutlet UIView *detailView;
    IBOutlet UIImageView *newsImg;
    IBOutlet UILabel *lblNewTitle;
    IBOutlet UIImageView *imgChannelImg;
    IBOutlet UILabel *lblChannelName;
    IBOutlet UILabel *lblNewDesc;
    IBOutlet NSLayoutConstraint *newImgView;
    NSInteger likedStatus;
}

@property (nonatomic, weak) IBOutlet UIButton    * newsDetails;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacing;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacing2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topcons;

@property (nonatomic, assign) BOOL isComingFromfavourite;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleCons;
@property (nonatomic, strong)NSDictionary *dictNewsInfo;
- (IBAction)onTap_BtnStar:(id)sender;
- (IBAction)onTap_BtnComment:(id)sender;
- (IBAction)onTap_BtnShare:(id)sender;
- (IBAction)onTap_BtnMail:(id)sender;
- (IBAction)onTap_BtnFB:(id)sender;
- (IBAction)onTap_BtnGooglePlus:(id)sender;
- (IBAction)onTap_BtnTwitter:(id)sender;
- (IBAction)onTap_BtnWhatsapp:(id)sender;
- (IBAction)onTap_BtnNewsDetails:(id)sender;
@end
