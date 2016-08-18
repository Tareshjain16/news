//
//  PrivacyPolicyViewController.m
//  News
//
//  Created by Divyaprakash.Soni on 13/05/16.
//  Copyright © 2016 ACS. All rights reserved.
//

#import "PrivacyPolicyViewController.h"

@interface PrivacyPolicyViewController ()
{
    IBOutlet UIView      *mainView;
    IBOutlet UIImageView *logoImg;
}

@end

@implementation PrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitleLabelForNavigationbar:NSLocalizedString(@"privacy_policy", @"")];
    
    [self setImageleftBarItem];
    [self loadTextView];
    
   /* self.view.translatesAutoresizingMaskIntoConstraints = YES;
    mainView.translatesAutoresizingMaskIntoConstraints = YES;
    _privacyTextView.translatesAutoresizingMaskIntoConstraints = YES;
    logoImg.translatesAutoresizingMaskIntoConstraints = YES;

    CGFloat yLoc = self.navigationController.navigationBar.frame.size.height + 20;

    [mainView   setFrame:CGRectMake(10, yLoc, self.view.frame.size.width - 20, self.view.frame.size.height - 50)];
    [logoImg    setFrame:CGRectMake(mainView.frame.size.width / 2 - 40, 10, 80, 70)];
    [self.privacyTextView setFrame:CGRectMake(10, CGRectGetMaxY(logoImg.frame) + 10, self.view.frame.size.width - 20, mainView.frame.size.height - 20)];*/
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

-(void) loadTextView
{
    NSString *path;
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Language"]isEqualToString: @"en"]){
        path = [[NSBundle mainBundle] pathForResource:@"PrivacyPolicy_En" ofType:@"txt"];
    } else {
        path = [[NSBundle mainBundle] pathForResource:@"PrivacyPolicy_Ar" ofType:@"txt"];
    }

    NSString *privacyText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.privacyTextView setText:privacyText];
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
