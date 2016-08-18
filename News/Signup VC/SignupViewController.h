//
//  SignupViewController.h
//  AYN
//
//  Created by MacbookAir on 04/01/01.
//  Copyright © 2001 MacbookAir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>

#import "AppDelegate.h"

@interface SignupViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIButton *btn_Google;
    IBOutlet UIButton *btn_Twitter;
    IBOutlet UIButton *btn_facebook;
    UIWebView *webview;
    UIButton *btn_closeGoogleView;
    NSMutableData *receivedData; //For Google Login Inside App
    AppDelegate *appDelegate;
    IBOutlet UIButton *btn_Back;
}
- (IBAction)onTap_Twitter:(id)sender;
- (IBAction)onTap_Google:(id)sender;
- (IBAction)onTap_Facebook:(id)sender;
- (IBAction)onTap_Btn_Back:(id)sender;


@end
