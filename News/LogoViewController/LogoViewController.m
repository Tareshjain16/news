//
//  LogoViewController.m
//  News
//
//  Created by Kalpit Jain on 2/26/16.
//  Copyright © 2016 ACS. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LogoViewController.h"
#import "InitialViewController.h"

@interface LogoViewController ()

@end

@implementation LogoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UIView animateWithDuration:2.0f
                     animations:^
     {
         img_Animated.center = CGPointMake(img_Animated.center.x, img_Animated.center.y + self.view.frame.size.height/2+30);
     }
                     completion:^(BOOL finished)
     {
         }];

      [self performSelector:@selector(nextView) withObject:nil afterDelay:2.0];
}

-(void)nextView
{
    InitialViewController *initialVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"InitialViewController"];
    [self.navigationController pushViewController:initialVC animated:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
