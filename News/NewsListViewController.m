//
//  ViewController.m
//  News
//
//  Created by user1 on 23/02/16.
//  Copyright © 2016 ACS. All rights reserved.
//

#import "NewsListViewController.h"
#import "SWRevealViewController.h"
#import "NewsViewController.h"
#import "WebServiceCalling.h"
#import "NewsListTableViewCell.h"
#import "EditSourcesViewController.h"
#import "SettingViewController.h"
#import "CommentViewController.h"

@interface NewsListViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate>
{
    NSMutableData *jsonData;
    NSMutableArray*responseArray;
    NSMutableArray*responseSearchArray;
    NSInteger pageIndex;
    CGFloat searchBarheight;
    
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UITableView *newsViewTbl;
@property (strong, nonatomic) IBOutlet NSMutableDictionary *saveServerImage;
@property (strong, nonatomic) UIRefreshControl*refreshControl;

@property (strong, nonatomic) UIActivityIndicatorView*indicator;
- (IBAction)segmentControlAction:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *searchBarTopConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *searchBarHeightConstant;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end


@implementation NewsListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    pageIndex = 1;
    _saveServerImage       = [[NSMutableDictionary alloc] init];
    responseArray          = [[NSMutableArray alloc] init];
    responseSearchArray    = [[NSMutableArray alloc] init];
    _segmentControl.selectedSegmentIndex =0;
    
    [self addSwipeGestureInSegmentControl];
    [self setTitleLabelForNavigationbar:NSLocalizedString(@"title_activity_dashboard", @"")];
    [self setImageleftBarItem];
    [self setImagerightBarItem];
    [self getLatestNews];
    
    //Pull to refresh tableview
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:52.0/255.0 green:135.0/255.0 blue:197.0/255.0 alpha:1.0];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self  action:@selector(getLatestNews) forControlEvents:UIControlEventValueChanged];
    [self.newsViewTbl addSubview:self.refreshControl];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setLocalizableText];
    _newsViewTbl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    searchBarheight = self.searchBarHeightConstant.constant;
    self.searchBarHeightConstant.constant =0;
}

-(void) setLocalizableText
{
    
    [_segmentControl setTitle:NSLocalizedString(@"latest", @"") forSegmentAtIndex:0];
    [_segmentControl setTitle:NSLocalizedString(@"urgent", @"") forSegmentAtIndex:1];
    [_segmentControl setTitle:NSLocalizedString(@"most_read", @"") forSegmentAtIndex:2];
}

-(void) addSwipeGestureInSegmentControl
{

    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [recognizer setDelegate:self];
    [recognizer setCancelsTouchesInView:NO];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [_newsViewTbl addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [recognizer setDelegate:self];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [_newsViewTbl addGestureRecognizer:recognizer];
}

- (void) handleSwipe:(UISwipeGestureRecognizer *)swipeRecogniser{
    
    NSInteger index = self.segmentControl.selectedSegmentIndex;
    if ([swipeRecogniser direction] == UISwipeGestureRecognizerDirectionLeft) {
        ++index;
    } else if ([swipeRecogniser direction] == UISwipeGestureRecognizerDirectionRight) {
        --index;
    }
    
    if (0 <= index && index < self.segmentControl.numberOfSegments) {
        self.segmentControl.selectedSegmentIndex = index;
        
        switch (_segmentControl.selectedSegmentIndex)
        {
            case 0:
                [self getLatestNews];
                break;
            case 1:
                [self getUrgentNews];
                break;
            case 2:
                [self getMostVistNews];
                break;
                
            default:
                break;
        }
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

#pragma - mark api  Method

-(void)getLatestNews
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
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)pageIndex] ,@"page",[USERDEFAULT objectForKey:@"Language"],@"lang",@"",@"uid",currentDeviceId,@"did",nil];
            NSDictionary*dict_response=[WebServiceCalling LatestNews:dic];
            if ([[dict_response objectForKey:@"news"] isKindOfClass:[NSArray class]])
            {
                NSArray*resArray = [NSArray arrayWithArray:[dict_response objectForKey:@"news"]];
                [responseArray addObjectsFromArray:resArray];
                [responseSearchArray addObjectsFromArray:resArray];
                [[AppDelegate appDelegate] killHud:self.view];
                [_newsViewTbl reloadData];
                pageIndex = pageIndex+1;
                [_indicator stopAnimating];
                [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
            else
            {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"title_activity_dashboard", @"") message:NSLocalizedString(@"no_latest", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
                [alert show];
                [responseArray removeAllObjects];
                [[AppDelegate appDelegate] killHud:self.view];
                [_newsViewTbl reloadData];
            }
        });
    }
}

-(void)getUrgentNews
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
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)pageIndex] ,@"page",[USERDEFAULT objectForKey:@"Language"],@"lang",@"",@"uid",currentDeviceId,@"did",nil];
            NSDictionary*dict_response=[WebServiceCalling UregentNews:dic];
            if ([[dict_response objectForKey:@"news"] isKindOfClass:[NSArray class]])
            {
                NSArray*resArray = [NSArray arrayWithArray:[dict_response objectForKey:@"news"]];
                [responseArray addObjectsFromArray:resArray];
                [responseSearchArray addObjectsFromArray:resArray];
                [[AppDelegate appDelegate] killHud:self.view];
                [_newsViewTbl reloadData];
                pageIndex = pageIndex+1;
                [_indicator stopAnimating];
                [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
            else
            {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"title_activity_dashboard", @"") message:NSLocalizedString(@"no_urgent", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
                [alert show];
                [responseArray removeAllObjects];
                [_indicator stopAnimating];
                [[AppDelegate appDelegate] killHud:self.view];
                [_newsViewTbl reloadData];
            }
        });
    }
}

-(void)getMostVistNews
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
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)pageIndex] ,@"page",[USERDEFAULT objectForKey:@"Language"],@"lang",@"",@"uid",currentDeviceId,@"did",nil];
            NSDictionary*dict_response=[WebServiceCalling MostVisitNews:dic];
            if ([[dict_response objectForKey:@"news"] isKindOfClass:[NSArray class]])
            {
                NSArray*resArray = [NSArray arrayWithArray:[dict_response objectForKey:@"news"]];
                [responseArray addObjectsFromArray:resArray];
                [responseSearchArray addObjectsFromArray:resArray];
                [[AppDelegate appDelegate] killHud:self.view];
                [_newsViewTbl reloadData];
                pageIndex = pageIndex+1;
                [_indicator stopAnimating];
                [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"title_activity_dashboard", @"") message:NSLocalizedString(@"no_most_read", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
                [alert show];
                [responseArray removeAllObjects];
                [_indicator stopAnimating];
                [[AppDelegate appDelegate] killHud:self.view];
                [_newsViewTbl reloadData];
            }
        });
    }
}

#pragma - mark Pull to refresh tableview method
- (void)reloadData
{
    // Reload table data
    [self.newsViewTbl reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        [self.refreshControl endRefreshing];
    }
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

-(void)setImagerightBarItem
{
    UIImage* settingImage      = [UIImage imageNamed:@"setting.png"];
    UIImage* editImage   = [UIImage imageNamed:@"edit.png"];
    UIImage* searchImage = [UIImage imageNamed:@"search.png"];
    CGRect frameimg = CGRectMake(0, 0,20,20);
    UIButton *settingButton = [[UIButton alloc] initWithFrame:frameimg];
    [settingButton setBackgroundImage:settingImage forState:UIControlStateNormal];
    UIButton *editButton    = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,20,20)];
    [settingButton addTarget:self action:@selector(openSettinView) forControlEvents:UIControlEventTouchUpInside];
    [editButton setBackgroundImage:editImage forState:UIControlStateNormal];
    UIButton *searchButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,20,20)];
    [searchButton setBackgroundImage:searchImage forState:UIControlStateNormal];
     [searchButton addTarget:self action:@selector(showHideSearchView) forControlEvents:UIControlEventTouchUpInside];
     [editButton addTarget:self action:@selector(goToEditSources) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *setBarButton =[[UIBarButtonItem alloc] initWithCustomView:settingButton];
    UIBarButtonItem *editBarButton =[[UIBarButtonItem alloc] initWithCustomView:editButton];
    UIBarButtonItem *searchBarButton =[[UIBarButtonItem alloc] initWithCustomView:searchButton];
    NSArray *barButtonArray= [[NSArray alloc] initWithObjects:setBarButton,editBarButton,searchBarButton,nil];
    self.navigationItem.rightBarButtonItems=barButtonArray;
}

-(void)showHideSearchView
{
    //Hide and Show With AutoLayout
    self.searchBarHeightConstant.constant = (self.searchBarHeightConstant.constant ==0) ? searchBarheight:0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
            }];
}


-(void)goToEditSources
{
    [AppDelegate appDelegate].isSettingViewFrameUpdated = YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditSourcesViewController*news = [storyboard instantiateViewControllerWithIdentifier:@"EditSourcesViewController"];
    [self.navigationController pushViewController:news animated:YES];
}

-(void) openSettinView
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SettingViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
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
    NewsListTableViewCell*cell = [_newsViewTbl dequeueReusableCellWithIdentifier:@"NewsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.btnComment.tag = indexPath.row;
    cell.newsStringLbl.text = ([[responseArray objectAtIndex:indexPath.row] objectForKey:@"title"] == [NSNull null]) ? @"": [[[responseArray objectAtIndex:indexPath.row] objectForKey:@"title"] stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    
    cell.newsChannelNameLbl.text = ([[responseArray objectAtIndex:indexPath.row] objectForKey:@"chanelName"] == [NSNull null]) ? @"": [[[responseArray objectAtIndex:indexPath.row] objectForKey:@"chanelName"] stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    
    cell.timeLbl.text = ([[responseArray objectAtIndex:indexPath.row] objectForKey:@"date"] == [NSNull null]) ? @"": [[[responseArray objectAtIndex:indexPath.row] objectForKey:@"date"] stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    [cell.shareBtn addTarget:self action:@selector(shareNews:) forControlEvents:UIControlEventTouchUpInside];
    cell.shareBtn.tag = indexPath.row;
    
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
    
    if (indexPath.row == responseArray.count-1)
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
    }
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    return UITableViewCellEditingStyleNone;
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

#pragma - mark UITableView Delegate Method

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*  UIAlertController * alert=   [UIAlertController
     alertControllerWithTitle:@"Message"
     message:[NSString stringWithFormat:@"Selected Row %ld",(long)indexPath.row]
     preferredStyle:UIAlertControllerStyleAlert];
     [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
     //Handel your yes Ok button action here
     }]];
     [self presentViewController:alert animated:YES completion:nil];*/
    UIStoryboard*storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewsViewController*news = [storyboard instantiateViewControllerWithIdentifier:@"NewsViewController"];
    news.dictNewsInfo = responseArray[indexPath.row];
    //[self presentViewController:news animated:NO completion:nil];
    [self.navigationController pushViewController:news animated:NO];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[responseArray objectAtIndex:indexPath.row] objectForKey:@"img"] isEqualToString:@""]) {
        return 150;
    }
    return 250;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - IBAction Method

- (IBAction)segmentControlAction:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    _saveServerImage = [[NSMutableDictionary alloc] init];
    responseArray    = [[NSMutableArray alloc] init];
    pageIndex=1;
    [self.refreshControl removeTarget:self  action:@selector(getLatestNews)  forControlEvents:UIControlEventValueChanged];
    [self.refreshControl removeTarget:self  action:@selector(getUrgentNews)  forControlEvents:UIControlEventValueChanged];
    [self.refreshControl removeTarget:self  action:@selector(getMostVistNews)  forControlEvents:UIControlEventValueChanged];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //[_newsViewTbl scrollToRowAtIndexPath:indexPath  atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    switch (selectedSegment) {
        case  0:
            [self getLatestNews];
            [self.refreshControl addTarget:self  action:@selector(getLatestNews)  forControlEvents:UIControlEventValueChanged];
            break;
            
        case  1:
            [self getUrgentNews];
            [self.refreshControl addTarget:self  action:@selector(getUrgentNews)  forControlEvents:UIControlEventValueChanged];
            break;
        case  2:
            [self getMostVistNews];
            [self.refreshControl addTarget:self  action:@selector(getMostVistNews)  forControlEvents:UIControlEventValueChanged];
            break;
            
        default:
            break;
    }
}
- (IBAction)onTap_BtnComment:(id)sender {
    
    UIStoryboard*storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentViewController *news = [storyboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    news.dictNewInfo = responseArray[[sender tag]];
    //[self presentViewController:news animated:NO completion:nil];
    [self.navigationController pushViewController:news animated:NO];
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
        [self.newsViewTbl reloadData];
    });
    
    if([searchText isEqualToString:@""]) {
        [searchBar resignFirstResponder];
        responseArray = responseSearchArray;
        [self.newsViewTbl reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

@end
