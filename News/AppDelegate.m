//
//  AppDelegate.m
//  News
//
//  Created by user1 on 23/02/16.
//  Copyright © 2016 ACS. All rights reserved.
//

#import "AppDelegate.h"
#import "constant.h"

static MBProgressHUD *hudView;

@interface AppDelegate ()

@end

@implementation AppDelegate

//[UIColor colorWithRed:52.0/255.0 green:135.0/255.0 blue:197.0/255.0 alpha:1.0]
@synthesize navController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //Set NavigationBar Background Image
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"navBarImage@2x.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    // To grant push notification permission
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isAlertOn"];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isSoundOn"];
//    [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"Language"];
        [NSBundle setLanguage:[[NSUserDefaults standardUserDefaults] valueForKey:@"Language"]];
    
    [self getPermissionForRemoteNotificationFromUser:application];
     //Set Bar Button Item Text color
//    [[UIBarButtonItem appearance] setTintColor:[UIColor redColor]];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -- Push Notification Methods --

-(void) getPermissionForRemoteNotificationFromUser:(UIApplication*)application {
    @try {
        //-- Set Notification
        if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
        {
            // iOS 8 Notifications
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            [application registerForRemoteNotifications];
        }
        else
        {
            // iOS < 8 Notifications
            [application registerForRemoteNotificationTypes:
             (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
        }
    }
    @catch(NSException *exception)
    {
        NSLog(@"Exception from getPermissionForRemoteNotificationFromUser at PushNotification AppDeledate : %@", [exception description]);
    }
    
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    @try {
         NSLog(@"My token is: %@", deviceToken);
        NSMutableDictionary *results = [NSMutableDictionary dictionary];
        self.deviceToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString: @" " withString: @""];
        [results setValue:self.deviceToken forKey:DEVICETOKEN];
        
#if !TARGET_IPHONE_SIMULATOR
        // Get Bundle Info for Remote Registration (handy if you have more than one app)
        [results setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"] forKey:@"appName"];
        [results setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"appVersion"];
        // Check what Notifications the user has turned on.  We registered for all three, but they may have manually disabled some or all of them.
        //NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        NSUInteger rntypes;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        rntypes = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
#else
        rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
#endif
        
        // Set the defaults to disabled unless we find otherwise...
        NSString *pushBadge = @"disabled";
        NSString *pushAlert = @"disabled";
        NSString *pushSound = @"disabled";
        
        // Check what Registered Types are turned on. This is a bit tricky since if two are enabled, and one is off, it will return a number 2... not telling you which
        // one is actually disabled. So we are literally checking to see if rnTypes matches what is turned on, instead of by number. The "tricky" part is that the
        // single notification types will only match if they are the ONLY one enabled.  Likewise, when we are checking for a pair of notifications, it will only be
        // true if those two notifications are on.  This is why the code is written this way
        if(rntypes & UIRemoteNotificationTypeBadge){
            pushBadge = @"enabled";
        }
        if(rntypes & UIRemoteNotificationTypeAlert) {
            pushAlert = @"enabled";
        }
        if(rntypes & UIRemoteNotificationTypeSound) {
            pushSound = @"enabled";
        }
        
        [results setValue:pushBadge forKey:PUSHBADGE];
        [results setValue:pushAlert forKey:PUSHALERT];
        [results setValue:pushSound forKey:PUSHSOUND];
        
        // Get the users Device Model, Display Name, Token & Version Number
        UIDevice *dev = [UIDevice currentDevice];
        [results setValue:dev.name forKey:DEVICENAME];
        [results setValue:dev.model forKey:DEVICEMODEL];
        [results setValue:dev.systemVersion forKey:DEVICESYSTEMVERSION];
#endif
        
        [[NSUserDefaults standardUserDefaults] setObject:results forKey:DEVICENOTIFICATIONOBJECT];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    @catch(NSException *exception)
    {
        NSLog(@"Exception from didRegisterForRemoteNotificationsWithDeviceToken at PushNotification AppDeledate : %@", [exception description]);
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    
    @try {
        NSLog(@"Failed to get token, error: %@", error);
        
#if TARGET_IPHONE_SIMULATOR
        NSMutableDictionary *results = [NSMutableDictionary dictionary];
        NSString *token = @""; //@"SimulatorNotificationToken"
        [results setValue:token forKey:DEVICETOKEN];
        
        UIDevice *dev = [UIDevice currentDevice];
        [results setValue:dev.name forKey:DEVICENAME];
        [results setValue:dev.model forKey:DEVICEMODEL];
        [results setValue:dev.systemVersion forKey:DEVICESYSTEMVERSION];
        
        [[NSUserDefaults standardUserDefaults] setObject:results forKey:DEVICENOTIFICATIONOBJECT];
        [[NSUserDefaults standardUserDefaults] synchronize];
#endif
        
    }
    @catch(NSException *exception)
    {
        NSLog(@"Exception from didFailToRegisterForRemoteNotificationsWithError at PushNotification AppDeledate : %@", [exception description]);
    }
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    @try {
        application.applicationIconBadgeNumber = 0;
        
        UIApplicationState state = [application applicationState];
        
        NSLog(@"userInfo %@", userInfo);
        NSDictionary *dictInfo = [[NSDictionary alloc] initWithDictionary:[self parseDictionary:userInfo]];
        NSLog(@"dictInfo %@", dictInfo);
        // go to screen relevant to Notification content
        [[NSUserDefaults standardUserDefaults] setObject:dictInfo forKey:NOTIFICATIONPAYLOAD];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // user tapped notification while app was in background
        if (state == UIApplicationStateInactive || state == UIApplicationStateBackground)
        {
            
        }
        else
        {
            // App is in UIApplicationStateActive (running in foreground)
            [self performSelector:@selector(showNotificationViewForAWhile) withObject:nil afterDelay:0.2];
        }
    }
    @catch(NSException *exception)
    {
        NSLog(@"Exception from didReceiveRemoteNotification at PushNotification AppDeledate : %@", [exception description]);
    }
}

#pragma -mark
#pragma -Other Notification Methods
-(void)setNotificationViewFrame_IsShow:(BOOL)isShow {
    
    @try {
        CGFloat viewX = SCREEN_BOUNDS_X;
        CGFloat viewY = -90;
        CGFloat viewWidth = SCREEN_BOUNDS_WIDTH;
        CGFloat viewHeight = 80;
        
        if (isShow) {
            viewY = SCREEN_BOUNDS_Y;
            viewNotification.frame=CGRectMake(viewX, viewY, viewWidth, viewHeight);
            
            viewX = viewX+20;
            viewY = viewNotification.frame.origin.y+20;
            viewWidth = 50;
            viewHeight = 50;
            imgNotificationLogo.frame=CGRectMake(viewX, viewY, viewWidth, viewHeight);
            
            viewX = viewX+imgNotificationLogo.frame.size.width+10;
            viewWidth = SCREEN_BOUNDS_WIDTH-viewX-10;
            viewHeight = 20;
            lblNotificationTitle.frame=CGRectMake(viewX, viewY, viewWidth, viewHeight);
            
            viewY = viewY+lblNotificationTitle.frame.size.height;
            viewWidth = SCREEN_BOUNDS_WIDTH-viewX-10;
            viewHeight = 40;
            lblNotificationMessage.frame=CGRectMake(viewX, viewY, viewWidth, viewHeight);
            
        } else {
            viewNotification.frame=CGRectMake(viewX, viewY, viewWidth, viewHeight);
            
            viewX = viewX+10;
            viewY = viewNotification.frame.origin.y+10;
            viewWidth = 50;
            viewHeight = 50;
            imgNotificationLogo.frame=CGRectMake(viewX, viewY, viewWidth, viewHeight);
            
            viewX = viewX+imgNotificationLogo.frame.size.width+10;
            viewWidth = SCREEN_BOUNDS_WIDTH-viewX-10;
            viewHeight = 20;
            lblNotificationTitle.frame=CGRectMake(viewX, viewY, viewWidth, viewHeight);
            
            viewY = viewY+lblNotificationTitle.frame.size.height+10;
            viewWidth = SCREEN_BOUNDS_WIDTH-viewX-10;
            viewHeight = 40;
            lblNotificationMessage.frame=CGRectMake(viewX, viewY, viewWidth, viewHeight);
            
            lblNotificationTitle.text = @"";
            lblNotificationMessage.text = @"";
        }
        
    }
    @catch(NSException *exception)
    {
        NSLog(@"Exception from setNotificationViewFrame_IsShow at PushNotification AppDeledate : %@", [exception description]);
    }
}

-(void)showNotificationViewForAWhile{
    
    @try {
        [self setNotificationViewFrame_IsShow:TRUE];
        [self performSelector:@selector(closeNotificationViewWithoutTap) withObject:nil afterDelay:3.0];
    }
    @catch(NSException *exception)
    {
        NSLog(@"Exception from showNotificationViewForAWhile at PushNotification AppDeledate : %@", [exception description]);
    }
    
}

-(void)closeNotificationViewWithoutTap{
    
    @try {
        [self setNotificationViewFrame_IsShow:FALSE];
    }
    @catch(NSException *exception)
    {
        NSLog(@"Exception from closeNotificationViewWithoutTap at PushNotification AppDeledate : %@", [exception description]);
    }
}

-(void)closeNotificationViewWithTap:(UITapGestureRecognizer*)tap{
    @try {
        [self setNotificationViewFrame_IsShow:FALSE];
        [self performSelector:@selector(pushToMessageClass:) withObject:@"TAP" afterDelay:0.3];
    }
    @catch(NSException *exception)
    {
        NSLog(@"Exception from closeNotificationViewWithTap at PushNotification AppDeledate : %@", [exception description]);
    }
    
}

-(void)pushToMessageClass:(NSString*)str{
    @try {
        if (![str isEqualToString:@"TAP"]) {
            return;
        }
        [self closeNotificationViewWithoutTap];
       // Action on Tap
    }
    @catch(NSException *exception)
    {
        NSLog(@"Exception from pushToMessageClass at PushNotification AppDeledate : %@", [exception description]);
    }
    
}

-(NSMutableDictionary *)parseDictionary:(NSDictionary *)inDictionary
{
    NSMutableDictionary *dictParsed = [[NSMutableDictionary alloc] init];
    
    @try {
        NSArray         *keys = [inDictionary allKeys];
        NSString        *key;
        
        for (key in keys)
        {
            id thisObject = [inDictionary objectForKey:key];
            
            if ([thisObject isKindOfClass:[NSDictionary class]]) {
                [dictParsed addEntriesFromDictionary:[[self parseDictionary:thisObject] mutableCopy]];
            }
            else if ([thisObject isKindOfClass:[NSString class]]) {
                [dictParsed setObject:[inDictionary objectForKey:key] forKey:key];
            } else {
                [dictParsed setObject:[inDictionary objectForKey:key] forKey:key];
            }
        }
        
    }
    @catch(NSException *exception)
    {
        NSLog(@"Exception from parseDictionary at UtilityClass : %@", [exception description]);
    }
    
    return dictParsed;
}

+(AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark -- Global App Delegate instance custom methods--

/*----------*/
/*Created By :  Vidvat */
/*Date : 14-Sept-2015 */
/*description : shows loader with or without message */
/*Update by : */
/*Reason : Method to show loading or processing some thing, display message can also be added with loader and it restricts user to interact with the app.*/
/*----------*/

- (void)showHud:(id)sender withText:(NSString *)loadingText {
    
    [self killHud:self.window];
    if ([NSThread isMainThread]) {
        hudView = [MBProgressHUD showHUDAddedTo:sender animated:YES];
        
        if ([loadingText length]) {
            hudView.labelText = loadingText;
        }
        
        hudView.dimBackground = YES;
        hudView.animationType = MBProgressHUDAnimationFade;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        [hudView bringSubviewToFront:self.window];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            hudView = [MBProgressHUD showHUDAddedTo:sender animated:YES];
            
            if ([loadingText length]) {
                hudView.labelText = loadingText;
            }
            hudView.dimBackground = YES;
            hudView.animationType = MBProgressHUDAnimationFade;
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            [hudView bringSubviewToFront:self.window];
            
        });
    }
}

- (void)killHud:(id)sender
{
    if ([NSThread isMainThread]) {
        [hudView hide:TRUE];
        [MBProgressHUD hideAllHUDsForView:sender animated:YES];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hudView hide:TRUE];
            
            [MBProgressHUD hideAllHUDsForView:sender animated:YES];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    }
}

@end
