//
//  FavoriteViewController.m
//  News
//
//  Created by Taresh Jain on 05/03/16.
//  Copyright © 2016 ACS. All rights reserved.
//

#import "FavoriteViewController.h"
#import "FavoriteTableViewCell.h"
#import "WebServiceCalling.h"
#import "NewsViewController.h"
#import "NewsListViewController.h"
#import "SWRevealViewController.h"
#import "CommentViewController.h"

@interface FavoriteViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray*responseArray;
    NSMutableArray*responseSearchArray;
    CGFloat searchBarheight;
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *favTbl;
@property (strong, nonatomic) IBOutlet NSMutableDictionary *saveServerImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sesrchBarHeightConstant;

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _saveServerImage = [[NSMutableDictionary alloc] init];
    responseArray    = [[NSMutableArray alloc] init];
    responseSearchArray    = [[NSMutableArray alloc] init];
    [self getLikesNews];
    [self setImageleftBarItem];
    [self setImagerightBarItem];
    
    [self setTitleLabelForNavigationbar:NSLocalizedString(@"favorites", @"")];
    _favTbl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    searchBarheight = self.sesrchBarHeightConstant.constant;
    self.sesrchBarHeightConstant.constant =0;
}

/*-(void)setImageleftBarItem
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
-(void)back
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewsListViewController*news = [storyboard instantiateViewControllerWithIdentifier:@"NewsListViewController"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:news];
    [navController setViewControllers: @[news] animated: YES];
    
    [self.revealViewController setFrontViewController:navController];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
}*/

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
    UIImage* favImg = [UIImage imageNamed:@"search.png"];
    CGRect frameimg = CGRectMake(0, 0,20,20);
    UIButton *settingButton = [[UIButton alloc] initWithFrame:frameimg];
    [settingButton addTarget:self action:@selector(openSettinView) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setBackgroundImage:settingImage forState:UIControlStateNormal];
    UIButton *editButton    = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,20,20)];
    [editButton addTarget:self action:@selector(goToEditSources) forControlEvents:UIControlEventTouchUpInside];
    [editButton setBackgroundImage:editImage forState:UIControlStateNormal];
    UIButton *favButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,20,20)];
    [favButton setBackgroundImage:favImg forState:UIControlStateNormal];
    // [editButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [favButton addTarget:self action:@selector(showHideSearchView) forControlEvents:UIControlEventTouchUpInside];
   // [editButton addTarget:self action:@selector(addComments) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *setBarButton =[[UIBarButtonItem alloc] initWithCustomView:settingButton];
    UIBarButtonItem *editBarButton =[[UIBarButtonItem alloc] initWithCustomView:editButton];
    UIBarButtonItem *searchBarButton =[[UIBarButtonItem alloc] initWithCustomView:favButton];
    NSArray *barButtonArray= [[NSArray alloc] initWithObjects:setBarButton,editBarButton,searchBarButton,nil];
    self.navigationItem.rightBarButtonItems=barButtonArray;
}

-(void)showHideSearchView
{
    //Hide and Show With AutoLayout
    self.sesrchBarHeightConstant.constant = (self.sesrchBarHeightConstant.constant ==0) ? searchBarheight:0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                     }];
}



-(void)setImageleftBarItem
{
    UIImage* image3 = [UIImage imageNamed:@"menuButton.png"];
    CGRect frameimg = CGRectMake(0, 0,20,20);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.leftBarButtonItem=mailbutton;
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void)goToEditSources
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *news = [storyboard instantiateViewControllerWithIdentifier:@"EditSourcesViewController"];
    [self.navigationController pushViewController:news animated:YES];
}

-(void) openSettinView
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SettingViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)getLikesNews
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
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",1] ,@"page",[USERDEFAULT objectForKey:@"Language"],@"lang",@"",@"uid",currentDeviceId,@"did",nil];
            NSDictionary*dict_response=[WebServiceCalling LikesNews:dic];
            if ([[dict_response objectForKey:@"likes"] isKindOfClass:[NSArray class]])
            {
                NSArray*resArray = [NSArray arrayWithArray:[dict_response objectForKey:@"likes"]];
                [responseArray addObjectsFromArray:resArray];
                [responseSearchArray addObjectsFromArray:resArray];
                [[AppDelegate appDelegate] killHud:self.view];
                [_favTbl reloadData];
            }
            else
            {
                [[AppDelegate appDelegate] killHud:self.view];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"title_activity_dashboard", @"") message:NSLocalizedString(@"no_fav", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
                [alert show];
            }
        });
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
    FavoriteTableViewCell*cell = [_favTbl dequeueReusableCellWithIdentifier:@"FavCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.newsStringLbl.text = ([[responseArray objectAtIndex:indexPath.row] objectForKey:@"title"] == [NSNull null]) ? @"": [[[responseArray objectAtIndex:indexPath.row] objectForKey:@"title"] stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    
    cell.newsChannelNameLbl.text = ([[responseArray objectAtIndex:indexPath.row] objectForKey:@"chanelName"] == [NSNull null]) ? @"": [[[responseArray objectAtIndex:indexPath.row] objectForKey:@"chanelName"] stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    
    cell.timeLbl.text = ([[responseArray objectAtIndex:indexPath.row] objectForKey:@"date"] == [NSNull null]) ? @"": [[[responseArray objectAtIndex:indexPath.row] objectForKey:@"date"] stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    
    [cell.shareBtn   addTarget:self action:@selector(shareNews:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnComment addTarget:self action:@selector(onTap_BtnComment:) forControlEvents:UIControlEventTouchUpInside];

    cell.tag = indexPath.row;
    __block NSString *row = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    __block NSString*newsStringImg;
    newsStringImg = ([[responseArray objectAtIndex:indexPath.row] objectForKey:@"img"] == [NSNull null])? @"":[[responseArray objectAtIndex:indexPath.row] objectForKey:@"img"];
    if(![[_saveServerImage allKeys] containsObject:row])
    {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^(void) {
            
            //Get Channel Image
            NSURL *url = [NSURL URLWithString:([[responseArray objectAtIndex:indexPath.row] objectForKey:@"chanelImgUrl"] == [NSNull null])? @"":[[responseArray objectAtIndex:indexPath.row] objectForKey:@"chanelImgUrl"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            //Get News Image Image
            NSString * newstring = [newsStringImg stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSURL *newsImgurl = [NSURL URLWithString:newstring];
            NSData *newsImgdata = [NSData dataWithContentsOfURL:newsImgurl];
            
            
            UIImage* image = [[UIImage alloc] initWithData:data];
            UIImage* newsimage = [[UIImage alloc] initWithData:newsImgdata];
            if (image|| newsimage) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (cell.tag == indexPath.row) {
                        // (newsimage == nil)? [_saveServerImage setObject:@"" forKey:row] : [_saveServerImage setObject:newsimage forKey:row];
                        if ((newsimage != nil)) {
                            [_saveServerImage setObject:newsimage forKey:row];
                            cell.newsImg.image = newsimage;
                        }
                        cell.channelImg.image = image;
                        [cell setNeedsLayout];
                    }
                });
            }
        });
    }
    else
    {
        cell.newsImg.image = [_saveServerImage objectForKey:row];
    }
    cell.newsImg.contentMode = UIViewContentModeScaleToFill;
    ([newsStringImg isEqualToString:@""]) ? [cell.newsImg setHidden:YES]: [cell.newsImg setHidden:NO];
    
   /* if (indexPath.row == responseArray.count-1)
    {
        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.frame = CGRectMake(0.0, 0.0, 150.0, 150.0);
        _indicator.transform = CGAffineTransformMakeScale(2.5, 2.5);
        _indicator.color=[UIColor blueColor];
        _indicator.center = self.newsViewTbl.center;
        _indicator.hidesWhenStopped = YES;
        [self.view addSubview: _indicator];
        [_indicator startAnimating];
        switch (_segmentControl.selectedSegmentIndex)
        {
            case 0:
                [self performSelector:@selector(getLatestNews) withObject:nil afterDelay:1.0];
                break;
            case 1:
                [self performSelector:@selector(getUrgentNews) withObject:nil afterDelay:1.0];
                break;
            case 2:
                [self performSelector:@selector(getMostVistNews) withObject:nil afterDelay:1.0];
                break;
                
            default:
                break;
        }
    }*/
    return cell;
}

#pragma - mark UITableView Delegate Method

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UIStoryboard*storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewsViewController*news = [storyboard instantiateViewControllerWithIdentifier:@"NewsViewController"];
    news.dictNewsInfo = responseArray[indexPath.row];
    news.isComingFromfavourite = YES;
    [self.navigationController pushViewController:news animated:NO];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[responseArray objectAtIndex:indexPath.row] objectForKey:@"img"] isEqualToString:@""]) {
        return 150;
    }
    return 250;
}

- (void)onTap_BtnComment:(id)sender {
    
    UIStoryboard*storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentViewController *news = [storyboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    news.dictNewInfo = responseArray[[sender tag]];
    //[self presentViewController:news animated:NO completion:nil];
    [self.navigationController pushViewController:news animated:NO];
}

-(void) shareNews:(id )sender
{
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"current Row=%ld",(long)senderButton.tag);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:senderButton.tag inSection:0];
    
    NSString* text = [[[responseArray objectAtIndex:indexPath.row] objectForKey:@"title"] stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    NSURL *myWebsite = [NSURL URLWithString:[[responseArray objectAtIndex:indexPath.row] objectForKey:@"link"]];
    //  UIImage * myImage =[UIImage imageNamed:@"myImage.png"];
    NSArray* sharedObjects = @[text,myWebsite];
    UIActivityViewController * activityViewController=[[UIActivityViewController alloc]initWithActivityItems:sharedObjects applicationActivities:nil];
    
    activityViewController.popoverPresentationController.sourceView = self.view;
    [self presentViewController:activityViewController animated:YES completion:nil];
}


#pragma mark - Search Bar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterArrayWithSearchTextWithsearchBar:searchBar andSearchText:searchText];
}


-(void)filterArrayWithSearchTextWithsearchBar:(UISearchBar *)searchBar andSearchText:(NSString*)searchText {
    
    searchText = [searchText stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    // Filter the array using NSPredicate
    NSMutableArray *predicateArray = [NSMutableArray array];
    
    [predicateArray addObject:[NSPredicate predicateWithFormat:@"chanelName CONTAINS[c] %@" , searchText]];
    
    NSPredicate *filterPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicateArray];
    
    responseArray= [NSMutableArray arrayWithArray:[responseSearchArray filteredArrayUsingPredicate:filterPredicate]];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.favTbl reloadData];
    });
    
    if([searchText isEqualToString:@""]) {
        [searchBar resignFirstResponder];
        responseArray = responseSearchArray;
        [self.favTbl reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
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
