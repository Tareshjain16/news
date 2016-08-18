//
//  NewsViewController.m
//  NewsApp
//
//  Created by Vidvat Joshi on 24/02/16.
//  Copyright © 2016 Vidvat Joshi. All rights reserved.
//

#import "NewsViewController.h"
#import "SWRevealViewController.h"
#import "NewsDetailsViewController.h"
#import "CommentViewController.h"
#import "WebServiceCalling.h"
#import "CommentViewController.h"
#import "SettingViewController.h"

@implementation NewsViewController
@synthesize dictNewsInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getLikedNews];
    [self setImageleftBarItem];
    
    [self.newsDetails   setTitle:NSLocalizedString(@"news_detail", @"")      forState:UIControlStateNormal];
    if ([self.dictNewsInfo objectForKey:@"description"] == [NSNull null]) {
        lblNewDesc.text = @"";
    }
    else
    {
        NSString*str = [self.dictNewsInfo objectForKey:@"description"];
        str = [str stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        lblNewDesc.text = str;
    }
    
    
    lblNewTitle.text = ([self.dictNewsInfo objectForKey:@"title"] == [NSNull null]) ? @"": [[self.dictNewsInfo objectForKey:@"title"] stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    
    lblChannelName.text = ([self.dictNewsInfo objectForKey:@"chanelName"] == [NSNull null]) ? @"": [[self.dictNewsInfo objectForKey:@"chanelName"] stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    __block NSString*newsStringImg;
    newsStringImg = ([self.dictNewsInfo objectForKey:@"img"] == [NSNull null])? @"":[self.dictNewsInfo objectForKey:@"img"];
   
    //Hide ImageView using AutoLayout
    if ([newsStringImg isEqualToString:@""])
    {
        CGFloat labelHT;
        CGFloat labelver;
        labelver = _verticalSpacing.constant;
        
        labelHT = newImgView.constant;
        labelHT = 0;
        
        newImgView.constant = (newImgView.constant == 0) ? !labelHT : 0;
        _verticalSpacing.constant = (_verticalSpacing.constant == 0) ? !labelver : 0;
        _verticalSpacing2.constant = (_verticalSpacing2.constant == 0) ? !labelver : 0;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void) {
        NSURL *url = [NSURL URLWithString:([self.dictNewsInfo objectForKey:@"chanelImgUrl"] == [NSNull null])? @"":[self.dictNewsInfo objectForKey:@"chanelImgUrl"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        NSString * newstring = [newsStringImg stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSURL *newsImgurl = [NSURL URLWithString:newstring];
        NSData *newsImgdata = [NSData dataWithContentsOfURL:newsImgurl];
        
        UIImage* image = [[UIImage alloc] initWithData:data];
        UIImage* newsimage = [[UIImage alloc] initWithData:newsImgdata];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imgChannelImg.image = image;
                newsImg.image = newsimage;
            });
        }
    });

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


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setImagerightBarItem
{
    UIImage* settingImage      = [UIImage imageNamed:@"setting.png"];
    UIImage* editImage   = [UIImage imageNamed:@"edit.png"];
    
    UIImage* favImg;
    if(likedStatus == 1) {
        favImg = [UIImage imageNamed:@"favourite.png"];
    } else {
        favImg = [UIImage imageNamed:@"rate-star.png"];
    }
    
    CGRect frameimg = CGRectMake(0, 0,20,20);
    UIButton *settingButton = [[UIButton alloc] initWithFrame:frameimg];
    [settingButton setBackgroundImage:settingImage forState:UIControlStateNormal];
    UIButton *editButton    = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,20,20)];
    [editButton setBackgroundImage:editImage forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(openSettinView) forControlEvents:UIControlEventTouchUpInside];
    UIButton *favButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,20,20)];
    [favButton setBackgroundImage:favImg forState:UIControlStateNormal];
    // [editButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [favButton addTarget:self action:@selector(addFavourite) forControlEvents:UIControlEventTouchUpInside];
    [editButton addTarget:self action:@selector(addComments) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *setBarButton =[[UIBarButtonItem alloc] initWithCustomView:settingButton];
    UIBarButtonItem *editBarButton =[[UIBarButtonItem alloc] initWithCustomView:editButton];
    UIBarButtonItem *searchBarButton =[[UIBarButtonItem alloc] initWithCustomView:favButton];
    NSArray *barButtonArray= [[NSArray alloc] initWithObjects:setBarButton,editBarButton,searchBarButton,nil];
    self.navigationItem.rightBarButtonItems=barButtonArray;
}

-(void) openSettinView
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SettingViewController"];
   // vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}

//-(void)setImageleftBarItem
//{
//    UIImage* image3 = [UIImage imageNamed:@"menuButton.png"];
//    CGRect frameimg = CGRectMake(0, 0,20,20);
//    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
//    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
//    [someButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
//    self.navigationItem.leftBarButtonItem=mailbutton;
//    
//    // Set the gesture
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//}

-(void) getLikedNews {
    
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
            NSString *newsID;
            if(self.isComingFromfavourite) {
                newsID = [self.dictNewsInfo objectForKey:@"news_id"];
                self.isComingFromfavourite = NO;
            } else {
                newsID = [self.dictNewsInfo objectForKey:@"id"];
            }
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:newsID,@"nid",@"",@"uid",currentDeviceId,@"did",nil];
            NSDictionary *response = [WebServiceCalling getLikedNews:dic];
            if([response count]) {
                likedStatus = [[response objectForKey:@"like"] integerValue];
            }
            [[AppDelegate appDelegate] killHud:self.view];
            [self setImagerightBarItem];
        });
    }
}

-(void)addFavourite
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
            
            UIBarButtonItem *item = (UIBarButtonItem *)[self.navigationItem.rightBarButtonItems objectAtIndex:2];
            UIButton *favBtn;
            
            if([item.customView isKindOfClass:[UIButton class]])
            {
                favBtn = (UIButton*)item.customView;
            }
            
            NSString *status;
            UIImage  *selectedImg = [UIImage imageNamed:@"favourite.png"];
            UIImage  *currentImg = favBtn.currentBackgroundImage;
            if ([self compareImage:selectedImg isEqualTo:currentImg]) {
                status = @"0";
            }
            else {
                status = @"1";
            }
            
            UIDevice *device = [UIDevice currentDevice];
            NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[self.dictNewsInfo objectForKey:@"id"],@"rssid",@"",@"uid",currentDeviceId,@"did",status,@"status",nil];
            NSString *response = [WebServiceCalling AddLikes:dic];
            
            if([response isEqualToString:@"Liked"]) {
                [favBtn setBackgroundImage:[UIImage imageNamed:@"favourite.png"] forState:UIControlStateNormal];
            } else {
                [favBtn setBackgroundImage:[UIImage imageNamed:@"rate-star.png"] forState:UIControlStateNormal];
            }
            
            [[AppDelegate appDelegate] killHud:self.view];
        });
    }
}

- (BOOL)compareImage:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

-(void)addComments
{
    UIStoryboard*storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentViewController*news = [storyboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    news.dictNewInfo = self.dictNewsInfo;
    //[self presentViewController:news animated:NO completion:nil];
    [self.navigationController pushViewController:news animated:NO];

}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"comment"])
    {
        CommentViewController *nextVC = (CommentViewController *)[segue destinationViewController];
        nextVC.dictNewInfo = self.dictNewsInfo;
    }
    else
    {
        NewsDetailsViewController *nextVC = (NewsDetailsViewController *)[segue destinationViewController];
        nextVC.strNewURL = self.dictNewsInfo[@"link"];
    }
}

- (IBAction)onTap_BtnStar:(id)sender
{
}

- (IBAction)onTap_BtnComment:(id)sender {
}

- (IBAction)onTap_BtnShare:(id)sender {
}

- (IBAction)onTap_BtnMail:(id)sender {
}

- (IBAction)onTap_BtnFB:(id)sender {
}

- (IBAction)onTap_BtnGooglePlus:(id)sender {
}

- (IBAction)onTap_BtnWhatsapp:(id)sender {
}

- (IBAction)onTap_BtnNewsDetails:(id)sender {
}

- (IBAction)onTap_BtnTwitter:(id)sender {
}
@end
