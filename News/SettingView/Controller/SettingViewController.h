//
//  SettingViewController.h
//  News
//
//  Created by Vidvat Joshi on 02/04/16.
//  Copyright © 2016 ACS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SettingViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *settingViewTbl;

@property (nonatomic, weak) IBOutlet UIButton *userPic;
@property (nonatomic, weak) IBOutlet UIButton *btnRegister;
@property (nonatomic, weak) IBOutlet UIButton *btnSignin;
@property (nonatomic, weak) IBOutlet UIView   *userInfoView;

@property (nonatomic, weak) IBOutlet UILabel *lblProfile;
@property (nonatomic, weak) IBOutlet UILabel *lblSignInOrRegister;

@end
