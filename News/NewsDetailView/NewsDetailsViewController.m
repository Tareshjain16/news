//
//  NewsDetailsViewController.m
//  NewsApp
//
//  Created by Vidvat Joshi on 24/02/16.
//  Copyright © 2016 Vidvat Joshi. All rights reserved.
//

#import "NewsDetailsViewController.h"
#import "SWRevealViewController.h"

@implementation NewsDetailsViewController

@synthesize strNewsTitle,strNewURL;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitleLabelForNavigationbar:NSLocalizedString(@"news_detail", @"")];
    
    [self setImageleftBarItem];
    [wvNewsDetails loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strNewURL]]];
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
