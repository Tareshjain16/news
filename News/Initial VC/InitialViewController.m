//
//  InitialViewController.m
//  AYN
//
//  Created by MacbookAir on 04/01/01.
//  Copyright © 2001 MacbookAir. All rights reserved.
//

#import "InitialViewController.h"
#import "SignupViewController.h"
#import "SigninViewController.h"
#import "NewsListViewController.h"
#import "SWRevealViewController.h"



@interface InitialViewController () {
    
    __weak IBOutlet UIButton *_buttonSignin;
    __weak IBOutlet UIButton *_buttonSkip;
    __weak IBOutlet UIButton *_buttonSignup;
    __weak IBOutlet UILabel  *_appName;
}

@end

@implementation InitialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"openApp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Setting borders of button
    [_buttonSignin.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_buttonSignin.layer setBorderWidth:1.5];
    
    [_buttonSkip.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_buttonSkip.layer setBorderWidth:1.5];
    
    [_buttonSignup.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_buttonSignup.layer setBorderWidth:1.5];
   
    _buttonSignin.layer .cornerRadius = _buttonSkip.layer .cornerRadius = _buttonSignup.layer .cornerRadius = 5.0;

    [_appName        setText:NSLocalizedString(@"app_name_show", @"")];
    [_buttonSignin setTitle:NSLocalizedString(@"sign_in", @"")      forState:UIControlStateNormal];
    [_buttonSkip   setTitle:NSLocalizedString(@"skip_for_now", @"") forState:UIControlStateNormal];
    [_buttonSignup setTitle:NSLocalizedString(@"sign_up", @"")      forState:UIControlStateNormal];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSData *pngData = [NSData dataWithContentsOfFile:[[self getDocumentPath] stringByAppendingPathComponent:@"userPic.png"]];
    UIImage *image = [UIImage imageWithData:pngData];
    
    if(image != nil) {
        
        UIStoryboard*storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NewsListViewController*news = [storyboard instantiateViewControllerWithIdentifier:@"NewsListViewController"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:news];
        [navController setViewControllers: @[news] animated: YES];
        
        [self.revealViewController setFrontViewController:navController];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    }
}

-(void)setImageleftBarItem
{
    UIImage* image3 = [UIImage imageNamed:@""];
    CGRect frameimg = CGRectMake(0, 0,20,20);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.leftBarButtonItem=mailbutton;
    
    // Set the gesture
    //  [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - All user's actions

- (IBAction)button_Signin_Pressed:(id)sender {
    
    SigninViewController *signinVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"SigninViewController"];
    [self.navigationController pushViewController:signinVC animated:NO];
    
}

- (IBAction)button_Skip_Pressed:(id)sender {
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[[self getDocumentPath] stringByAppendingPathComponent:@"UserInfo"] error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:[[self getDocumentPath] stringByAppendingPathComponent:@"userPic.png"] error:&error];
    
   /* UIStoryboard*storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewsListViewController*news = [storyboard instantiateViewControllerWithIdentifier:@"NewsListViewController"];
     [self.navigationController pushViewController:news animated:NO];*/
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewsListViewController*news = [storyboard instantiateViewControllerWithIdentifier:@"NewsListViewController"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:news];
    [navController setViewControllers: @[news] animated: YES];
    
    [self.revealViewController setFrontViewController:navController];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    
}

- (IBAction)button_Signup_Pressed:(id)sender {
    
    SignupViewController *signupVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"SignupViewController"];
    [self.navigationController pushViewController:signupVC animated:NO];
    
}

-(NSString*)getDocumentPath {
    
    __autoreleasing NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

@end
