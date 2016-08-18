//
//  SigninViewController.h
//  AYN
//
//  Created by MacbookAir on 05/01/01.
//  Copyright © 2001 MacbookAir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>

@interface SigninViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIButton *btn_RememberMe;
    IBOutlet UIButton *btn_ChkBoxbtn_RememberMe;
    IBOutlet UIButton *btn_Google;
    IBOutlet UIButton *btn_Twitter;
    IBOutlet UIButton *btn_facebook;
    UIWebView *webview;
    NSMutableData *receivedData; //For Google Login Inside App
    AppDelegate *appDelegate;
    IBOutlet UIButton *btn_Back;
    UIButton *btn_closeGoogleView;
}

-(IBAction)onTap_btn_RememberMe:(id)sender;
-(IBAction)onTap_btn_ChkBoxbtn_RememberMe:(id)sender;
- (IBAction)onTap_Twitter:(id)sender;
- (IBAction)onTap_Google:(id)sender;
- (IBAction)onTap_Facebook:(id)sender;
- (IBAction)onTap_Btn_Back:(id)sender;



@end
