//
//  AppDelegate.h
//  News
//
//  Created by user1 on 23/02/16.
//  Copyright © 2016 ACS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HudView.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    // Push Notification Variables
    UIView *viewNotification;
    UIImageView *imgNotificationLogo;
    UILabel *lblNotificationTitle;
    UILabel *lblNotificationMessage;
}

@property (strong, nonatomic) UINavigationController *navController;

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) BOOL isSettingViewFrameUpdated;

@property (nonatomic, assign) NSString *deviceToken;

#pragma -- Class methods --

+(AppDelegate *)appDelegate;

#pragma -- Instance methods --

- (void)showHud:(id)sender withText:(NSString *)loadingText;
- (void)killHud:(id)sender;

@end

