//
//  CommentViewController.m
//  NewsApp
//
//  Created by Vidvat Joshi on 24/02/16.
//  Copyright © 2016 Vidvat Joshi. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentCell.h"
#import "WebServiceCalling.h"

@implementation CommentViewController
@synthesize dictNewInfo;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"%@",[self.dictNewInfo description]);
    
    newsStringLbl.text = ([self.dictNewInfo objectForKey:@"title"] == [NSNull null]) ? @"": [[self.dictNewInfo objectForKey:@"title"] stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    
    newsChannelNameLbl.text = ([self.dictNewInfo objectForKey:@"chanelName"] == [NSNull null]) ? @"": [[self.dictNewInfo objectForKey:@"chanelName"] stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    
    timeLbl.text = ([self.dictNewInfo objectForKey:@"date"] == [NSNull null]) ? @"": [[self.dictNewInfo objectForKey:@"date"] stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    
    NSURL *url = [NSURL URLWithString:([self.dictNewInfo objectForKey:@"chanelImgUrl"] == [NSNull null])? @"":[self.dictNewInfo objectForKey:@"chanelImgUrl"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if(data != nil)
        newsImg.image = [UIImage imageWithData:data];
    else
        newsImg.hidden = YES;
        
    [self setImageleftBarItem];
    [self setTitleLabelForNavigationbar:NSLocalizedString(@"comments", @"")];
    [tblComments registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
    [btnPostComment setImage:[UIImage imageNamed:@"postcomment.png"] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
    responseArray = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [self getComments];
}

#pragma -mark Navigation Bar methods
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

- (void)setTitleLabelForNavigationbar:(NSString*)title {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,45,45)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"GoodTimesRg-Regular" size:15.0];
    self.navigationItem.titleView = label;
    label.text = title; //CUSTOM TITLE
    [label sizeToFit];
}


-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
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
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //    viewComment.frame = CGRectMake(viewComment.frame.origin.x, viewComment.frame.origin.y-200, viewComment.frame.size.width, viewComment.frame.size.height);
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tfComment resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [tfComment resignFirstResponder];
    //    viewComment.frame = CGRectMake(viewComment.frame.origin.x, viewComment.frame.origin.y+200, viewComment.frame.size.width, viewComment.frame.size.height);
    
}
- (void)keyboardWasShown:(NSNotification *)notification
{
    
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Given size may not account for screen rotation
    int height = MIN(keyboardSize.height,keyboardSize.width);
    //    int width = MAX(keyboardSize.height,keyboardSize.width);
    
    //your other code here..........
    if(self.view.frame.origin.y>=0)
    {
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-height, self.view.frame.size.width, self.view.frame.size.height);
    }
}


- (void)keyboardWillHide:(NSNotification *)notification
{
    
    // Get the size of the keyboard.
    
    //Given size may not account for screen rotation
    //    int width = MAX(keyboardSize.height,keyboardSize.width);
    
    //your other code here..........
    if(self.view.frame.origin.y<0)
    {
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}

#pragma - mark UITableView DataSource Method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return responseArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = (CommentCell *)[tblComments dequeueReusableCellWithIdentifier:@"CommentCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.lblUserName.text = ([[responseArray objectAtIndex:indexPath.row] objectForKey:@"user_name"] == [NSNull null]) ? @"": [[[responseArray objectAtIndex:indexPath.row] objectForKey:@"user_name"] stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    
    cell.lblTimestamp.text = ([[responseArray objectAtIndex:indexPath.row] objectForKey:@"created_at"] == [NSNull null]) ? @"": [[responseArray objectAtIndex:indexPath.row] objectForKey:@"created_at"];
    
    [cell.lblComment setText:[NSString stringWithFormat:@" %@",([[responseArray objectAtIndex:indexPath.row] objectForKey:@"comment"] == [NSNull null]) ? @"": [[[responseArray objectAtIndex:indexPath.row] objectForKey:@"comment"] stringByReplacingOccurrencesOfString:@"<p>" withString:@""]]];
    
    return cell;
}

-(void)getComments
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
            
            // Read dictionary
            NSString *strPath = [NSString stringWithFormat:@"%@/UserInfo.plist",[self getDocumentPath]];
            NSDictionary *userInfoDict = [NSDictionary dictionaryWithContentsOfFile:strPath];
            NSString *userId;
            if([userInfoDict count]) {
                
                if(userInfoDict[@"uid"] == nil) {
                    userId = [NSString stringWithFormat:@"%@",userInfoDict[@"user"][@"uid"]];
                } else {
                    userId = [NSString stringWithFormat:@"%@",userInfoDict[@"uid"]];
                }
            }

            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: [self.dictNewInfo objectForKey:@"id"],@"id",nil];
            NSDictionary*dict_response=[WebServiceCalling getComments:dic];
            if ([[dict_response objectForKey:@"total"] intValue] > 0)
            {
                NSDictionary  *dict = [dict_response objectForKey:@"comment"];
                for (int count = 0; count < [dict count]; count++) {
                    NSString *key = [NSString stringWithFormat:@"%d",count];
                    if(dict[key] != nil) {
                        [responseArray addObject:dict[key]];
                    }
                }
                
                [tblComments reloadData];
                pageIndex = pageIndex+1;
                [[AppDelegate appDelegate] killHud:self.view];
                //        [_indicator stopAnimating];
    //            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
            else
            {
                [[AppDelegate appDelegate] killHud:self.view];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"title_activity_dashboard", @"") message:NSLocalizedString(@"no_comments", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
                [alert show];
                [responseArray removeAllObjects];
                [tblComments reloadData];
            }
        });
    }
                       
}

#pragma - mark UITableView Delegate Method

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[responseArray objectAtIndex:indexPath.row] objectForKey:@"img"] isEqualToString:@""]) {
        return 150;
    }
    return 250;
}

- (IBAction)onTap_BtnPostComment:(id)sender
{
    if(tfComment.text.length)
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
                
                // Read dictionary
                NSString *strPath = [NSString stringWithFormat:@"%@/UserInfo.plist",[self getDocumentPath]];
                NSDictionary *userInfoDict = [NSDictionary dictionaryWithContentsOfFile:strPath];
                NSString *userId;
                if([userInfoDict count]) {
                    
                    if(userInfoDict[@"uid"] == nil) {
                       userId = [NSString stringWithFormat:@"%@",userInfoDict[@"user"][@"uid"]];
                    } else {
                        userId = [NSString stringWithFormat:@"%@",userInfoDict[@"uid"]];
                    }
                }
                
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: tfComment.text,@"comment",[self.dictNewInfo objectForKey:@"id"],@"rssid",[NSString stringWithFormat:@"%@",userId],@"uid",nil];
                NSDictionary*dict_response=[WebServiceCalling postComments:dic];
                if ([[dict_response objectForKey:@"error"] intValue] != 1)
                {
                    
                    NSDictionary  *dict = [dict_response objectForKey:@"comment"];
                    for (int count = 0; count < [dict count]; count++) {
                        NSString *key = [NSString stringWithFormat:@"%d",count];
                        if(dict[key] != nil) {
                            [responseArray addObject:dict[key]];
                        }
                    }
                    
                    [[AppDelegate appDelegate] killHud:self.view];
                    [tblComments reloadData];
                    pageIndex = pageIndex+1;
                }
                else
                {
                    [[AppDelegate appDelegate] killHud:self.view];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"title_activity_dashboard", @"") message:dict_response[@"error_msg"] delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil];
                    [alert show];
                }
                tfComment.text = @"";
                
            });
        }
    }
    else
        return;
}

-(NSString*)getDocumentPath {
    
    __autoreleasing NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

@end
