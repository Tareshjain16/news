//
//  SettingViewController.m
//  News
//
//  Created by Vidvat Joshi on 02/04/16.
//  Copyright © 2016 ACS. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingViewCell.h"
#import "SigninViewController.h"
#import "SignupViewController.h"
#import "PrivacyPolicyViewController.h"
#import "SuggestionViewController.h"
#import "EditSourcesViewController.h"
#import "NewsListViewController.h"
#import "WebServiceCalling.h"
#import "JSON.h"

@interface SettingViewController ()
{
    NSMutableArray *settingView1;
    NSMutableArray *settingView2;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     _settingViewTbl.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLocalizableText) name:@"SETLOCALIZABLETEXT" object:nil];
    [self setLocalizableText]; //
    _settingViewTbl.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _settingViewTbl.separatorColor = [UIColor grayColor];
    _settingViewTbl.separatorInset = UIEdgeInsetsZero;
    NSData *pngData = [NSData dataWithContentsOfFile:[[self getDocumentPath] stringByAppendingPathComponent:@"userPic.png"]];
    UIImage *image = [UIImage imageWithData:pngData];
    

    if(image != nil) {
        [_userPic setImage:image forState:UIControlStateNormal];
        [_btnRegister setHidden:YES],[_btnSignin setHidden:YES];
    } else {
        [_btnRegister setHidden:NO],[_btnSignin setHidden:NO];
        [_userPic setImage:[UIImage imageNamed:@"user_icon.png"] forState:UIControlStateNormal];
    }
    [self setImageleftBarItem];
    //[self setViewFrame];
    _settingViewTbl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void) setLocalizableText
{

    [settingView1 removeAllObjects];
    [settingView2 removeAllObjects];
    
    [self setTitleLabelForNavigationbar:NSLocalizedString(@"settings", @"")];
    [self.lblProfile setText:NSLocalizedString(@"profile", @"")];
    [self.lblSignInOrRegister setText:NSLocalizedString(@"setting_text", @"")];
    
    self.btnRegister.layer.cornerRadius = 4; // this value vary as per your desire
    self.btnRegister.clipsToBounds = YES;
    [self.btnRegister.layer setBorderWidth:1.0];
    [self.btnRegister.layer setBorderColor:[UIColor colorWithRed:111.0/255.0 green:113.0/255.0 blue:121.0/255.0 alpha:1.0].CGColor];

    self.btnSignin.layer.cornerRadius = 4; // this value vary as per your desire
    self.btnSignin.clipsToBounds = YES;
    
    [self.btnRegister  setTitle:NSLocalizedString(@"register", @"")      forState:UIControlStateNormal];
    [self.btnSignin    setTitle:NSLocalizedString(@"sign_in", @"")      forState:UIControlStateNormal];

    settingView1 = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"edit_sources", @""),NSLocalizedString(@"latest_news_alert", @""),NSLocalizedString(@"alert_sound", @""),NSLocalizedString(@"arabic_english", @""), nil];
    settingView2 = [[NSMutableArray alloc] initWithObjects:@"3AynApp",@"@AynApp",@"@AynApp",NSLocalizedString(@"rate_us", @""),NSLocalizedString(@"suggestions", @""),NSLocalizedString(@"reports", @""),NSLocalizedString(@"privacy_policy", @""), nil];
    
    // Read dictionary
    NSString *strPath = [NSString stringWithFormat:@"%@/UserInfo.plist",[self getDocumentPath]];
    NSDictionary *userInfoDict = [NSDictionary dictionaryWithContentsOfFile:strPath];
    NSString *email;
    if([userInfoDict count]) {
        [_lblSignInOrRegister setFont:[UIFont systemFontOfSize:20.0]];
        email = [NSString stringWithFormat:@"%@",userInfoDict[@"user"][@"email"]];
        [_lblSignInOrRegister setText:email];
    }
    
    [_settingViewTbl reloadData];
}

-(void) setViewFrame
{
    CGFloat xPos = 30.0;
    self.lblProfile.translatesAutoresizingMaskIntoConstraints = YES;
    self.userInfoView.translatesAutoresizingMaskIntoConstraints = YES;
    self.settingViewTbl.translatesAutoresizingMaskIntoConstraints = YES;
    self.userPic.translatesAutoresizingMaskIntoConstraints = YES;
    self.lblSignInOrRegister.translatesAutoresizingMaskIntoConstraints = YES;
    self.btnRegister.translatesAutoresizingMaskIntoConstraints = YES;
    self.btnSignin.translatesAutoresizingMaskIntoConstraints = YES;

    CGFloat yLoc = self.navigationController.navigationBar.frame.size.height + 20;
    if([AppDelegate appDelegate].isSettingViewFrameUpdated) {
        yLoc = 0;
    }
    [self.lblProfile   setFrame:CGRectMake(10, yLoc, 150, 30)];
    [self.userInfoView setFrame:CGRectMake(10, CGRectGetMaxY(self.lblProfile.frame) + 10, self.view.frame.size.width - 20, 145)];
    [self.settingViewTbl setFrame:CGRectMake(10, CGRectGetMaxY(self.userInfoView.frame) + 10, self.view.frame.size.width - 20, self.view.frame.size.height - 250)];
    
    [self.userPic setFrame:CGRectMake(5, 5, 100, 100)];
    [self.btnSignin setFrame:CGRectMake((self.userInfoView.frame.size.width - self.btnSignin.frame.size.width) - 30, 5, 100, 34)];

    CGFloat xToMinus = 40.0;
    if(self.view.frame.size.height == 568) {
        xToMinus = -10.0;
    }
    
    [self.btnRegister setFrame:CGRectMake((CGRectGetMinX(self.btnSignin.frame) - self.btnSignin.frame.size.width) - xToMinus, 5, 83, 34)];
    if(self.view.frame.size.height == 568) {
        xPos = 0.0;
    }
    [self.lblSignInOrRegister setFrame:CGRectMake(CGRectGetMaxX(self.userPic.frame) + xPos, CGRectGetHeight(self.btnRegister.frame) + 10, 180, 84)];

}

-(NSString*)getDocumentPath {
    
    __autoreleasing NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

#pragma - mark UITableView DataSource Method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return 4;
    } else if(section == 1) {
        return 7;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"SettingCell";
    
    // Similar to UITableViewCell, but
    SettingViewCell *cell = (SettingViewCell *)[_settingViewTbl dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SettingViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // Just want to test, so I hardcode the data
    if(indexPath.section == 0) {
        cell.cellLabel.text = [settingView1 objectAtIndex:indexPath.row];
    } else if(indexPath.section == 1) {
        cell.cellLabel.text = [settingView2 objectAtIndex:indexPath.row];
    }
    cell.cellImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld_%ld",(long)indexPath.section,(long)indexPath.row]];
    [cell setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.cellSwitch setOn:YES];
    if(indexPath.section == 0 && indexPath.row != 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        if(indexPath.row == 1) {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAlertOn"] boolValue]){
                [cell.cellSwitch setOn:YES];
            } else {
                [cell.cellSwitch setOn:NO];
            }
        } else if(indexPath.row == 2) {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isSoundOn"]boolValue]){
                [cell.cellSwitch setOn:YES];
            } else {
                [cell.cellSwitch setOn:NO];
            }
        } else if(indexPath.row == 3) {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Language"] isEqualToString:@"ar"]){
                [cell.cellSwitch setOn:YES];
            } else {
                [cell.cellSwitch setOn:NO];
            }
        }
        
        [cell.cellSwitch setHidden:NO];
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.cellSwitch setHidden:YES];
    }
    cell.tintColor = [UIColor colorWithRed:(0.0/255.0) green:(122.0/255.0) blue:(255.0/255.0) alpha:1.0];
    cell.cellSwitch.tag = indexPath.row;
    
    return cell;
}

#pragma - mark Navigation Bar Method
- (void)setTitleLabelForNavigationbar:(NSString*)title {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,45,45)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"GoodTimesRg-Regular" size:15.0];
    self.navigationItem.titleView = label;
    label.text = title; //CUSTOM TITLE
    [label sizeToFit];
}

-(void)setImageleftBarItem
{
    UIImage* image3 = [UIImage imageNamed:@"left_arrow.png"];
    CGRect frameimg = CGRectMake(0, 0,20,20);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget: self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.leftBarButtonItem=mailbutton;
}

-(void)back
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"NewsListViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma - mark UITableView Delegate Method

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %ld row", (long)indexPath.row);
    NSString *strUrl = @"";
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"EditSourcesViewController"];
            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            strUrl = @"https://www.facebook.com/3aynapp/";
        } else if(indexPath.row == 1) {
            strUrl = @"https://twitter.com/3aynapp/";
        } else if(indexPath.row == 2) {
            strUrl = @"https://www.instagram.com/3aynapp/";
        } else if(indexPath.row == 3) {
            strUrl = @"https://itunes.apple.com/in/app/";
        } else if(indexPath.row == 4) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SuggestionViewController"];
            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.navigationController pushViewController:vc animated:YES];
        } else if(indexPath.row == 5) {
            [self launchMailAppOnDevice];
        } else if(indexPath.row == 6) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"PrivacyPolicyViewController"];
            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    NSURL *socialMediaUrl = [NSURL URLWithString:strUrl];
    if ([[UIApplication sharedApplication] canOpenURL:socialMediaUrl]) {
        [[UIApplication sharedApplication] openURL:socialMediaUrl];
    } else {
        [[UIApplication sharedApplication] openURL:socialMediaUrl];
    }
    
    
}

-(void)launchMailAppOnDevice
{
    NSString *strDeviceName = [[UIDevice currentDevice] name];
    NSString *recipients = @"mailto:info@3aynapp.com?subject=3Ayn";
    NSString *body = [NSString stringWithFormat:@"&body=%@",strDeviceName];
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(section == 0) {
        return NSLocalizedString(@"settings", @"");
    } else if(section == 1) {
        return NSLocalizedString(@"application", @"");
    }
    return @"";
} 

-(IBAction)clickOnSignInBtn:(id)sender
{
    SigninViewController *signinVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"SigninViewController"];
    [self.navigationController pushViewController:signinVC animated:NO];

}

-(IBAction)clickOnSignUpBtn:(id)sender
{
    SignupViewController *signinVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"SignupViewController"];
    [self.navigationController pushViewController:signinVC animated:NO];
    
}

-(IBAction)userPicClicked:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    chosenImage = [self imageWithImage:chosenImage scaledToSize:CGSizeMake(100, 100)];
    NSData *pngData = UIImagePNGRepresentation(chosenImage);
    [self.userPic setImage:chosenImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self performSelector:@selector(UpdateUserImage:) withObject:pngData afterDelay:0.5];
}

-(void) UpdateUserImage:(NSData *)pngData
{
    if ([Reachability sharedReachability].internetConnectionStatus==NotReachable)
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"network_check_title", @"") message:NSLocalizedString(@"network_check_msg", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles: nil];
        [alert show];
        return;
    }
    else
    {
        [[AppDelegate appDelegate] showHud:self.view withText:NSLocalizedString(@"loading", @"")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableDictionary *dict_info = [[NSMutableDictionary alloc]init];
            
            // Read dictionary
            NSString *strPath = [NSString stringWithFormat:@"%@/UserInfo.plist",[self getDocumentPath]];
            NSDictionary *userInfoDict = [NSDictionary dictionaryWithContentsOfFile:strPath];
            
            if([userInfoDict count]) {
                
                if(userInfoDict[@"uid"] == nil) {
                    [dict_info setObject:[NSString stringWithFormat:@"%@",userInfoDict[@"user"][@"uid"]] forKey:@"id"];
                } else {
                    [dict_info setObject:[NSString stringWithFormat:@"%@",userInfoDict[@"uid"]] forKey:@"id"];
                }
                
                [dict_info setObject:[NSString stringWithFormat:@"%@",userInfoDict[@"user"][@"name"]]    forKey:@"name"];
                [dict_info setObject:[NSString stringWithFormat:@"%@",userInfoDict[@"user"][@"email"]]   forKey:@"email"];
                [dict_info setObject:[NSData dataWithData:pngData]     forKey:@"profile_pic"];
                [dict_info setObject:[NSString stringWithFormat:@"%@",userInfoDict[@"user"][@"contact"]] forKey:@"contact"];
                
                NSDictionary *dict_response = [WebServiceCalling updateUserProfile:dict_info];
                if([dict_response isKindOfClass:[NSError class]]) {
                    [[AppDelegate appDelegate] killHud:self.view];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"title_activity_dashboard", @"") message:[dict_response objectForKey:@"error_msg"] delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
                    [alert show];
                } else {
                    
                    NSError *error;
                    [[NSFileManager defaultManager] removeItemAtPath:[[self getDocumentPath] stringByAppendingPathComponent:@"UserInfo"] error:&error];
                    [[NSFileManager defaultManager] removeItemAtPath:[[self getDocumentPath] stringByAppendingPathComponent:@"userPic.png"] error:&error];
                    
                    // Write dictionary
                    NSMutableDictionary *userInfoDict = [[NSMutableDictionary alloc] initWithDictionary:[dict_response mutableCopy]];
                    userInfoDict = [self dictionaryByReplacingNullsWithStrings:userInfoDict];
                    NSString *strPath = [NSString stringWithFormat:@"%@/UserInfo.plist",[self getDocumentPath]];
                    if ([userInfoDict writeToFile:strPath atomically:YES]) {
                        DLog(@"Success ");
                    }
                    
                    UIImage * userImage;
                    NSString *imgUrl = [NSString stringWithFormat:@"%@%@",ImgageUpload_URl,dict_response[@"user"][@"image"]];
                    NSData * userImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
                    userImage = [UIImage imageWithData:userImageData];
                    
                    // Write image
                    [userImageData writeToFile:[[self getDocumentPath] stringByAppendingPathComponent:@"userPic.png"] atomically:YES];
                    [[AppDelegate appDelegate] killHud:self.view];
                }
            }
        });
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];

}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (NSMutableDictionary *)dictionaryByReplacingNullsWithStrings : (NSMutableDictionary *)inputDict {
    
    const NSMutableDictionary *replaced = [inputDict mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    for(NSString *key in inputDict) {
        @autoreleasepool {
            const id object = [inputDict objectForKey:key];
            if(object == nul) {
                //pointer comparison is way faster than -isKindOfClass:
                //since [NSNull null] is a singleton, they'll all point to the same
                //location in memory.
                [replaced setObject:blank
                             forKey:key];
            }else if ([object isKindOfClass: [NSDictionary class]]) {
                [replaced setObject:[self dictionaryByReplacingNullsWithStrings:object] forKey: key];
            }
        }
    }
    
    return [replaced mutableCopy];
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
