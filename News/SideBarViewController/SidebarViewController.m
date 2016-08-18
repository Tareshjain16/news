//
//  SidebarViewController.m
//  Queue
//
//  Created by user1 on 14/09/15.
//  Copyright (c) 2015 ACS. All rights reserved.
//

#import "SidebarViewController.h"
#import "SideBarTableViewCell.h"
#import "SWRevealViewController.h"
#import "InitialViewController.h"
#import "FavoriteTableViewCell.h"
#import "FavoriteViewController.h"
#import "WebServiceCalling.h"
#import "EditSourcesViewController.h"
#import "SettingViewController.h"
#import "NewsListViewController.h"


@interface SidebarViewController ()<UITableViewDataSource,UITableViewDelegate>
{
     NSArray *menuItems;
     NSArray *imageItems;
     NSMutableData *jsonData;
}

@property (weak, nonatomic) IBOutlet UITableView *sideBartableView;
@property (weak, nonatomic) IBOutlet UIImageView *sideBarUserImg;

@end

@implementation SidebarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createLocalizableTextArray];
    
    NSData *pngData = [NSData dataWithContentsOfFile:[[self getDocumentPath] stringByAppendingPathComponent:@"userPic.png"]];
    UIImage *image = [UIImage imageWithData:pngData];
    
    if(image != nil) {
        [_sideBarUserImg setImage:image];
    } else {
        [_sideBarUserImg setImage:[UIImage imageNamed:@"dummyicon"]];
    }
    _sideBartableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_sideBartableView reloadData];
}

-(NSString*)getDocumentPath {
    
    __autoreleasing NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void) createLocalizableTextArray
{
    menuItems  = @[NSLocalizedString(@"latest_news", @""),NSLocalizedString(@"favorites", @""),NSLocalizedString(@"edit_sources", @""),NSLocalizedString(@"share_application", @""),NSLocalizedString(@"settings", @""),NSLocalizedString(@"logout", @"")];
    imageItems = @[@"clock",@"favourite",@"editBlue",@"share-symbol",@"settingBlue",@"logout"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   /* NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    //cell = UITableViewCellSeparatorStyleSingleLine;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:88.0/255.0 green:180.0/255.0 blue:93.0/255.0 alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];*/
    
    NSString * CellIdentifire = @"sideBarCell";
    SideBarTableViewCell*cell = [_sideBartableView dequeueReusableCellWithIdentifier:CellIdentifire forIndexPath:indexPath];
    cell.selectionStyle       = UITableViewCellSelectionStyleDefault;
    cell.headingLbl.text      = [menuItems objectAtIndex:indexPath.row];
    cell.headingImage.image   = [UIImage imageNamed:[imageItems objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [AppDelegate appDelegate].isSettingViewFrameUpdated = YES;
    if (indexPath.row == 3)
    {
        [AppDelegate appDelegate].isSettingViewFrameUpdated = NO;
        [self shareText:@"done" andImage:[UIImage imageNamed:@"clock"] andUrl:[NSURL URLWithString:@"http://www.google.com"]];
    }
    
    else if (indexPath.row == 0)
    {
        UIStoryboard*storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NewsListViewController*news = [storyboard instantiateViewControllerWithIdentifier:@"NewsListViewController"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:news];
        [navController setViewControllers: @[news] animated: YES];
        
        [self.revealViewController setFrontViewController:navController];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];

       // [self.navigationController pushViewController:news animated:NO];

    }
    
    else if (indexPath.row == 1)
     {
         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         FavoriteViewController*news = [storyboard instantiateViewControllerWithIdentifier:@"FavoriteViewController"];

         UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:news];
         [navController setViewControllers: @[news] animated: YES];
         
         [self.revealViewController setFrontViewController:navController];
         [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
     }
    
    else if (indexPath.row == 2)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        EditSourcesViewController*news = [storyboard instantiateViewControllerWithIdentifier:@"EditSourcesViewController"];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:news];
        [navController setViewControllers: @[news] animated: YES];
        
        [self.revealViewController setFrontViewController:navController];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        
       /* UIStoryboard*storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NewsListViewController*news = [storyboard instantiateViewControllerWithIdentifier:@"NewsListViewController"];
        [self.navigationController pushViewController:news animated:NO];*/
    }
    else if (indexPath.row == 4)
    {
        SettingViewController *SettingViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"SettingViewController"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:SettingViewController];
        [navController setViewControllers: @[SettingViewController] animated: YES];
        [self.revealViewController setFrontViewController:navController];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];

        //
    }
    
    else if (indexPath.row == 5)
    {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:[[self getDocumentPath] stringByAppendingPathComponent:@"UserInfo"] error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:[[self getDocumentPath] stringByAppendingPathComponent:@"userPic.png"] error:&error];
        
        InitialViewController *initialVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"InitialViewController"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:initialVC];
        [navController setViewControllers: @[initialVC] animated: YES];
        [self.revealViewController setFrontViewController:navController];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"title_activity_dashboard", @"") message:NSLocalizedString(@"logout", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
        [alert show];
    }
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
            if ([[dict_response objectForKey:@"news"] isKindOfClass:[NSArray class]])
            {
               NSArray*resArray = [NSArray arrayWithArray:[dict_response objectForKey:@"news"]];
                [[AppDelegate appDelegate] killHud:self.view];
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


#pragma mark - Share App Method

- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if (text) {
        [sharingItems addObject:text];
    }
    if (image) {
        [sharingItems addObject:image];
    }
    if (url) {
        [sharingItems addObject:url];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

#pragma mark - Alert View Delegate
-(void)dismissResetAlert:(UIAlertView *) alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [_sideBartableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    // Set the photo if it navigates to the PhotoView
   /* if ([segue.identifier isEqualToString:@"showPhoto"]) {
          PhotoViewController *photoController = (PhotoViewController*)segue.destinationViewController;
         NSString *photoFilename = [NSString stringWithFormat:@"%@_photo.jpg", [menuItems objectAtIndex:indexPath.row]];
         photoController.photoFilename = photoFilename;
    }*/
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
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
