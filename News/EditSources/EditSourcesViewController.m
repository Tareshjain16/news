//
//  EditSourcesViewController.m
//  News
//
//  Created by Taresh Jain on 10/03/16.
//  Copyright © 2016 ACS. All rights reserved.
//

#import "EditSourcesViewController.h"
#import "WebServiceCalling.h"
#import "EditSorcesTableViewCell.h"
#import "NewsListViewController.h"
#import "SWRevealViewController.h"
#import "ChannelViewController.h"

@interface EditSourcesViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    BOOL isSearchOn;
}

@property (strong, nonatomic) IBOutlet UITableView *souceTbl;
@property  (strong,nonatomic)  NSMutableArray *channelAry;
@property  (strong,nonatomic)  NSMutableArray *filterChannelAry;

@end

@implementation EditSourcesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getSourceList];
    [self setImageleftBarItem];
    [self setImagerightBarItem];
    
    [self setTitleLabelForNavigationbar:NSLocalizedString(@"edit_sources", @"")];
    _souceTbl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view.
}

#pragma -mark Call api methods
-(void)getSourceList
{
    [[AppDelegate appDelegate] showHud:self.view withText:NSLocalizedString(@"loading", @"")];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIDevice *device = [UIDevice currentDevice];
        NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[USERDEFAULT objectForKey:@"Language"],@"lang",@"",@"uid",currentDeviceId,@"did",nil];
        NSDictionary*dict_response=[WebServiceCalling EditSources:dic];
            _channelAry  = [NSMutableArray arrayWithArray:[dict_response objectForKey:@"source"]];
            _filterChannelAry = [NSMutableArray arrayWithArray:_channelAry];
        [[AppDelegate appDelegate] killHud:self.view];
        [_souceTbl reloadData];
    });
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
 
 // Set the gesture
 // [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
 }

-(void)setImagerightBarItem
{
  //  UIImage* editImage   = [UIImage imageNamed:@"edit.png"];
    UIImage* searchImage = [UIImage imageNamed:@"search.png"];
    UIButton *editButton    = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,40,20)];
    [editButton setBackgroundColor:[UIColor clearColor]];
    editButton.layer.borderColor = [UIColor whiteColor].CGColor;
    editButton.layer.borderWidth = 1;
    
    [editButton setTitle:NSLocalizedString(@"news", @"") forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editButton.titleLabel setFont:[UIFont systemFontOfSize:9.0]];
    [editButton addTarget:self action:@selector(willShowNewsView) forControlEvents:UIControlEventTouchUpInside];
   // [editButton setBackgroundImage:editImage forState:UIControlStateNormal];
    UIButton *searchButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,20,20)];
    [searchButton setBackgroundImage:searchImage forState:UIControlStateNormal];
    UIBarButtonItem *editBarButton =[[UIBarButtonItem alloc] initWithCustomView:editButton];
    UIBarButtonItem *searchBarButton =[[UIBarButtonItem alloc] initWithCustomView:searchButton];
    NSArray *barButtonArray= [[NSArray alloc] initWithObjects:editBarButton,nil];
    self.navigationItem.rightBarButtonItems=barButtonArray;
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

#pragma mark - SearchBar Delgates
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar  // called when text starts editing
{
    searchBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;   // called when text changes (including clear)
{
    if(searchText.length == 0)
    {
        isSearchOn = NO;
        [_filterChannelAry removeAllObjects];
    }
    else
    {
        isSearchOn = YES;
        [_filterChannelAry removeAllObjects];        
        for (int count = 0; count < [_channelAry count]; count++) {
            NSString *channelName;
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"Language"] isEqualToString:@"ar"]) {
                channelName = [[_channelAry objectAtIndex:count] objectForKey:@"source_name"];
            } else {
                channelName = [[_channelAry objectAtIndex:count] objectForKey:@"source_name_en"];
            }
            NSRange nameRange = [channelName rangeOfString:searchBar.text options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
            if(nameRange.location != NSNotFound)
            {
                [_filterChannelAry addObject:_channelAry[count]];
            }
        }
    }
    [_souceTbl reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar           // called when keyboard search button pressed
{
    [_filterChannelAry removeAllObjects];
    [_filterChannelAry addObjectsFromArray:_channelAry];
    [_souceTbl reloadData];
    searchBar.showsCancelButton = NO;
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

#pragma -mark Private methods
-(void)willShowNewsView
{

    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:NSLocalizedString(@"message", @"")
                                  message:NSLocalizedString(@"edit_news_message", @"")
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"yes", @"")
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self back];
                                    //Handel your yes please button action here
                                }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"no", @"")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   //Handel no, thanks button
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

 -(void)back
 {
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     NewsListViewController*news = [storyboard instantiateViewControllerWithIdentifier:@"NewsListViewController"];
     
     UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:news];
     [navController setViewControllers: @[news] animated: YES];
     
     [self.revealViewController setFrontViewController:navController];
     [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
//     UIStoryboard*storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//     NewsListViewController*news = [storyboard instantiateViewControllerWithIdentifier:@"NewsListViewController"];
//     [self.navigationController pushViewController:news animated:NO];
 }

#pragma - mark UITableView DataSource Method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isSearchOn) {
        return _filterChannelAry.count;
    } else {
       return _channelAry.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditSorcesTableViewCell*cell = [_souceTbl dequeueReusableCellWithIdentifier:@"SourceCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.imageView.image = [UIImage imageNamed:@"editBlue"];
    if(isSearchOn) {
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"Language"] isEqualToString:@"ar"]) {
            cell.sourceChanelNmeLbl.text  = [[_filterChannelAry objectAtIndex:indexPath.row]objectForKey:@"source_name"];
        } else {
            cell.sourceChanelNmeLbl.text  = [[_filterChannelAry objectAtIndex:indexPath.row]objectForKey:@"source_name_en"];
        }
    } else {
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"Language"] isEqualToString:@"ar"]) {
            cell.sourceChanelNmeLbl.text  = [[_channelAry objectAtIndex:indexPath.row]objectForKey:@"source_name"];
        } else {
            cell.sourceChanelNmeLbl.text  = [[_channelAry objectAtIndex:indexPath.row]objectForKey:@"source_name_en"];
        }
    }
   // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.tag = indexPath.row;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void) {
        
        //Get Channel Image
        NSURL *url;
        if(isSearchOn) {
            url = [NSURL URLWithString:([[_filterChannelAry objectAtIndex:indexPath.row] objectForKey:@"source_img"] == [NSNull null])? @"":[[_filterChannelAry objectAtIndex:indexPath.row] objectForKey:@"source_img"]];
        } else {
            url = [NSURL URLWithString:([[_channelAry objectAtIndex:indexPath.row] objectForKey:@"source_img"] == [NSNull null])? @"":[[_channelAry objectAtIndex:indexPath.row] objectForKey:@"source_img"]];
        }
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage* image = [[UIImage alloc] initWithData:data];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (cell.tag == indexPath.row) {
                    cell.sourceImg.image = image;
                    [cell setNeedsLayout];
                }
            });
        }
    });
    return cell;
}

#pragma - mark UITableView Delegate Method
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UIStoryboard*storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChannelViewController*chanel = [storyboard instantiateViewControllerWithIdentifier:@"ChannelViewController"];
    chanel.sourceId = [[_channelAry objectAtIndex:indexPath.row]objectForKey:@"source_id"];
    [self.navigationController pushViewController:chanel animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
