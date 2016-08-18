//
//  ChannelViewController.m
//  News
//
//  Created by Taresh Jain on 12/03/16.
//  Copyright © 2016 ACS. All rights reserved.
//

#import "ChannelViewController.h"
#import "WebServiceCalling.h"
#import "EditSorcesTableViewCell.h"

@interface ChannelViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate>
{
    CGFloat labelHT;
    CGFloat labelver;
    NSString *channelValue;
}
@property (nonatomic,strong)NSMutableArray * chanelListAry;
@property (strong, nonatomic) IBOutlet UITableView *chanelTbl;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *searchBarTableVerSpacing;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *searchConsHeight;
@property (strong, nonatomic) IBOutlet UISearchBar *searchChannel;
@property (nonatomic,strong)NSMutableArray          *channelFilterListArray;

@end

@implementation ChannelViewController
@synthesize sourceId;
- (void)viewDidLoad {
    [super viewDidLoad];
    //Hide and Show With AutoLayout
    labelver = _searchBarTableVerSpacing.constant;
    labelHT = _searchConsHeight.constant;
   // labelHT = 0;
    _searchConsHeight.constant = (_searchConsHeight.constant == 0) ? !labelHT : 0;
    _searchBarTableVerSpacing.constant = (_searchBarTableVerSpacing.constant == 0) ? !labelver : 0;
    
    [self getSourceList];
    [self setImageleftBarItem];
    [self setImagerightBarItem];
    
    [self setTitleLabelForNavigationbar:NSLocalizedString(@"channel", @"")];
    // Do any additional setup after loading the view.
    _chanelTbl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

-(void)getSourceList
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UIDevice *device = [UIDevice currentDevice];
            NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[USERDEFAULT objectForKey:@"Language"],@"lang",@"",@"uid",currentDeviceId,@"did",[NSNumber numberWithInt:[sourceId intValue]],@"sid",nil];
            NSArray*array_response=[WebServiceCalling ChanelList:dic];
            if ([array_response isKindOfClass:[NSArray class]])
            {
               // _chanelListAry = [[NSMutableArray alloc] init];
              _chanelListAry  = [NSMutableArray arrayWithArray:array_response];
              _channelFilterListArray= [NSMutableArray arrayWithArray:_chanelListAry];
             [[AppDelegate appDelegate] killHud:self.view];
             [_chanelTbl reloadData];
            } else {
                [[AppDelegate appDelegate] killHud:self.view];
            }
        });
    }
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
    
    // Set the gesture
    // [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
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

-(void)setImagerightBarItem
{
    UIImage* settingImage      = [UIImage imageNamed:@"setting.png"];
    UIImage* editImage   = [UIImage imageNamed:@"edit.png"];
    UIImage* searchImage = [UIImage imageNamed:@"search.png"];
    CGRect frameimg = CGRectMake(0, 0,20,20);
    UIButton *settingButton = [[UIButton alloc] initWithFrame:frameimg];
    [settingButton setBackgroundImage:settingImage forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(openSettinView) forControlEvents:UIControlEventTouchUpInside];
    UIButton *editButton    = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,20,20)];
    [editButton setBackgroundImage:editImage forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(showEditView) forControlEvents:UIControlEventTouchUpInside];
    UIButton *searchButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,20,20)];
    [searchButton setBackgroundImage:searchImage forState:UIControlStateNormal];
     [searchButton addTarget:self action:@selector(showHideSearchView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *setBarButton =[[UIBarButtonItem alloc] initWithCustomView:settingButton];
    UIBarButtonItem *editBarButton =[[UIBarButtonItem alloc] initWithCustomView:editButton];
    UIBarButtonItem *searchBarButton =[[UIBarButtonItem alloc] initWithCustomView:searchButton];
    NSArray *barButtonArray= [[NSArray alloc] initWithObjects:setBarButton,editBarButton,searchBarButton,nil];
    self.navigationItem.rightBarButtonItems=barButtonArray;
}

-(void) openSettinView
{
    [AppDelegate appDelegate].isSettingViewFrameUpdated = NO;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SettingViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) showEditView
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"EditSourcesViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showHideSearchView
{
    //Hide and Show With AutoLayout
        _searchConsHeight.constant = (_searchConsHeight.constant == 0) ? labelHT : 0;
        _searchBarTableVerSpacing.constant = (_searchBarTableVerSpacing.constant == 0) ? labelver : 0;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    NewsListViewController*news = [storyboard instantiateViewControllerWithIdentifier:@"NewsListViewController"];
//    
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:news];
//    [navController setViewControllers: @[news] animated: YES];
//    
//    [self.revealViewController setFrontViewController:navController];
//    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
}

#pragma - mark UITableView DataSource Method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _chanelListAry.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditSorcesTableViewCell *cell = (EditSorcesTableViewCell *)[_chanelTbl dequeueReusableCellWithIdentifier:@"SourceCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.imageView.image = [UIImage imageNamed:@"editBlue"];
    cell.sourceChanelNmeLbl.text  = [[_chanelListAry objectAtIndex:indexPath.row]objectForKey:@"name"];
    // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.AddBtn addTarget:self action:@selector(addChannel:) forControlEvents:UIControlEventTouchUpInside];
    cell.tag = indexPath.row;
    if ([[[_chanelListAry objectAtIndex:indexPath.row] objectForKey:@"added"] isEqual:@1])
    {
        channelValue = @"0";
        //[cell.AddBtn setTitle:@"Added" forState:UIControlStateNormal];
        [cell.AddBtn setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
        [cell.AddBtn setTitle:@"" forState:UIControlStateNormal];
    }
    else
    {
        channelValue = @"1";
        [cell.AddBtn setTitle:[NSString stringWithFormat:@"%@ +",NSLocalizedString(@"add", @"")] forState:UIControlStateNormal];
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void) {
        
        //Get Channel Image
        NSURL *url = [NSURL URLWithString:([[_chanelListAry objectAtIndex:indexPath.row] objectForKey:@"chanel_img"] == [NSNull null])? @"":[[_chanelListAry objectAtIndex:indexPath.row] objectForKey:@"chanel_img"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage* image = [[UIImage alloc] initWithData:data];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (cell.tag == indexPath.row) {
                    cell.ChanelImg.image = image;
                    [cell setNeedsLayout];
                }
            });
        }
    });
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIStoryboard*storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ChannelViewController*chanel = [storyboard instantiateViewControllerWithIdentifier:@"ChannelViewController"];
//    chanel.sourceId = [[_channelAry objectAtIndex:indexPath.row]objectForKey:@"source_id"];
//    [self.navigationController pushViewController:chanel animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//Get Current row index Path
-(NSIndexPath*)GetIndexPathFromSender:(id)sender{
    
    if(!sender) { return nil; }
    
    if([sender isKindOfClass:[UITableViewCell class]])
    {
        EditSorcesTableViewCell *cell = sender;
        return [self.chanelTbl indexPathForCell:cell];
    }
    
    return [self GetIndexPathFromSender:((UIView*)[sender superview])];
}

-(void)addChannel:(id)sender
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
            
            NSIndexPath*indexPath = [self GetIndexPathFromSender:sender];
            NSString*channelId = [[_chanelListAry objectAtIndex:indexPath.row] objectForKey:@"id"];
            UIDevice *device = [UIDevice currentDevice];
            NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
            if([AppDelegate appDelegate].deviceToken == nil) {
                [AppDelegate appDelegate].deviceToken = @"";
            }
            channelValue = @"";
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:channelValue,@"action",[AppDelegate appDelegate].deviceToken,@"uid",currentDeviceId,@"did",[NSNumber numberWithInt:[sourceId intValue]],@"sid",[NSNumber numberWithInt:[channelId intValue]],@"cid",nil];
            NSDictionary*response=[WebServiceCalling AddDeleteChanel:dic];
            //NSLog(@"Err'")
            if ([response isKindOfClass:[NSDictionary class]]&& [[response objectForKey:@"error"] isEqual:@1])
            {
                [[AppDelegate appDelegate] killHud:self.view];
                 DLog(@"Error");
            }
            else
            {
                [[AppDelegate appDelegate] killHud:self.view];
                [self getSourceList];
            }
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search Bar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterArrayWithSearchTextWithsearchBar:searchBar andSearchText:searchText];
}


-(void)filterArrayWithSearchTextWithsearchBar:(UISearchBar *)searchBar andSearchText:(NSString*)searchText {
    
    searchText = [searchText stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    // Filter the array using NSPredicate
    NSMutableArray *predicateArray = [NSMutableArray array];
    
    [predicateArray addObject:[NSPredicate predicateWithFormat:@"name CONTAINS[c] %@" , searchText]];
    
    NSPredicate *filterPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicateArray];
    
    _chanelListAry = [NSMutableArray arrayWithArray:[_channelFilterListArray filteredArrayUsingPredicate:filterPredicate]];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [_chanelTbl reloadData];
    });
    
    if([searchText isEqualToString:@""]) {
        [searchBar resignFirstResponder];
        _chanelListAry = _channelFilterListArray;
        [_chanelTbl reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchChannel resignFirstResponder];
    [self.view endEditing:YES];
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
