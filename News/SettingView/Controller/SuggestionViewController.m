//
//  SuggestionViewController.m
//  News
//
//  Created by Divyaprakash.Soni on 13/05/16.
//  Copyright © 2016 ACS. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SuggestionViewController.h"
#import "WebServiceCalling.h"

@interface SuggestionViewController ()
{
    NSMutableArray*responseArray;

}

@end

@implementation SuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.submitBtn.layer.cornerRadius = 10; // this value vary as per your desire
    self.submitBtn.clipsToBounds = YES;
    // Do any additional setup after loading the view from its nib.
    [self setTitleLabelForNavigationbar:NSLocalizedString(@"suggestions", @"")];
    [self setImageleftBarItem];
    [self setLocalizableText];
    
}

-(void) setLocalizableText
{
    [self.lblUserName   setText:NSLocalizedString(@"user_name", @"")];
    [self.lblSuggestion setText:NSLocalizedString(@"suggestion_text", @"")];
    [self.submitBtn     setTitle:NSLocalizedString(@"submit", @"")      forState:UIControlStateNormal];
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)clickOnSubmitBtn:(id)sender
{
    NSLog(@"Submit button click");
    [self submitSuggestion];
    
}

-(void)submitSuggestion
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
            
            UIDevice *device = [UIDevice currentDevice];
            NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_userNameTextField.text] ,@"name",[NSString stringWithFormat:@"%@",_suggestionTextField.text] ,@"suggest",nil];
            NSDictionary*dict_response = [WebServiceCalling submitSuggestion:dic];
            if ([dict_response isKindOfClass:[NSError class]])
            {
                [[AppDelegate appDelegate] killHud:self.view];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"title_activity_dashboard", @"") message:[dict_response objectForKey:@"error"] delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                [[AppDelegate appDelegate] killHud:self.view];
                _suggestionTextField.text = @"";
                _userNameTextField.text = @"";
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"title_activity_dashboard", @"") message:NSLocalizedString(@"submit", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
                [alert show];
            }
        });
    }
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
