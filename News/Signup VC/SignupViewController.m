//
//  SignupViewController.m
//  AYN
//
//  Created by MacbookAir on 04/01/01.
//  Copyright © 2001 MacbookAir. All rights reserved.
//

#import "SignupViewController.h"
#import "constant.h"
#import "JSON.h"
#import "InitialViewController.h"
#import "NewsListViewController.h"
#import "WebServiceCalling.h"

@interface SignupViewController ()<UITextFieldDelegate> {
    
    __weak IBOutlet UIButton *_buttonSignUp;
    __weak IBOutlet UITextField *txtUserName;
    __weak IBOutlet UITextField *txtPassword;
    __weak IBOutlet UITextField *txtEmail;
    __weak IBOutlet UITextField *txtContactNumber;
    __weak IBOutlet UILabel  *_appName;
    
    NSMutableData *jsonData;
}

@end

@implementation SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"openApp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setImageleftBarItem];
    
    //Setting borders of button
    [_buttonSignUp.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_buttonSignUp.layer setBorderWidth:1.5];
  
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"google"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }//For Google Login Inside App
    [self setLocalizableText];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void) setLocalizableText
{
    [_appName        setText:NSLocalizedString(@"app_name_show", @"")];
    [_buttonSignUp    setTitle:NSLocalizedString(@"sign_up", @"")     forState:UIControlStateNormal];
    [txtEmail         setPlaceholder:NSLocalizedString(@"email", @"")];
    [txtUserName      setPlaceholder:NSLocalizedString(@"user_name", @"")];
    [txtPassword      setPlaceholder:NSLocalizedString(@"password", @"")];
    [txtContactNumber setPlaceholder:NSLocalizedString(@"contact_number", @"")];
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
    
    // Set the gesture
    // [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Textfield Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark - Custom methods

//Check for email validation
- (BOOL)validateEmailWithString:(NSString*)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark -
#pragma mark - All user's actions

- (IBAction)button_Signup_Pressed:(id)sender
{
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedStringEmail = [txtEmail.text stringByTrimmingCharactersInSet:charSet];
    NSString *trimmedStringPwd = [txtPassword.text stringByTrimmingCharactersInSet:charSet];
    NSString *trimmedStringName = [txtUserName.text stringByTrimmingCharactersInSet:charSet];
    NSString *trimmedStringContact = [txtContactNumber.text stringByTrimmingCharactersInSet:charSet];
    
    //Check for null string
    if ([trimmedStringEmail isEqualToString:@""] || [trimmedStringPwd isEqualToString:@""] || [trimmedStringName isEqualToString:@""] || [trimmedStringContact isEqualToString:@""]) {
        // it's empty or contains only white spaces
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"title_activity_dashboard", @"") message:NSLocalizedString(@"mandaory_field", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles: nil];
        [alert show];
    }
    else if ([trimmedStringPwd length] < 6) {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"title_activity_dashboard", @"") message:NSLocalizedString(@"password_validation", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles: nil];
        [alert show];
        
    }
    else if ([self validateEmailWithString:trimmedStringEmail] == NO) {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"title_activity_dashboard", @"") message:NSLocalizedString(@"valid_email_text", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles: nil];
        [alert show];

    }
    
    else
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
                
                NSMutableDictionary *dict_info = [[NSMutableDictionary alloc]init];
                [dict_info setObject:txtUserName.text forKey:@"name"];
                [dict_info setObject:txtEmail.text forKey:@"email"];
                [dict_info setObject:txtPassword.text forKey:@"password"];
                [dict_info setObject:txtContactNumber.text forKey:@"contact"];
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:txtEmail.text,@"email",txtUserName.text,@"name",txtPassword.text,@"password",txtContactNumber.text,@"contact",nil];
                NSDictionary *dict_response=[WebServiceCalling SignUp:dic];
                if([dict_response isKindOfClass:[NSError class]]) {
                    [[AppDelegate appDelegate] killHud:self.view];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"title_activity_dashboard", @"") message:[dict_response objectForKey:@"error_msg"] delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
                    [alert show];
                } else {

                    NSError *error;
                    [[NSFileManager defaultManager] removeItemAtPath:[[self getDocumentPath] stringByAppendingPathComponent:@"UserInfo"] error:&error];
                    [[NSFileManager defaultManager] removeItemAtPath:[[self getDocumentPath] stringByAppendingPathComponent:@"userPic.png"] error:&error];
                    
                    // Write dictionary
                    NSMutableDictionary *userInfoDict = [[NSMutableDictionary alloc] initWithDictionary:[dict_response mutableCopy]];
                    userInfoDict = [self dictionaryByReplacingNullsWithStrings:userInfoDict];
                    NSString *strPath = [NSString stringWithFormat:@"%@/UserInfo.plist",[self getDocumentPath]];
                    if ([userInfoDict writeToFile:strPath atomically:YES]) {
                        DLog(@"Success ");
                    }
                    
                    UIImage * userImage;
                    NSString *imgUrl = [NSString stringWithFormat:@"%@/%@",ImgageUpload_URl,dict_response[@"user"][@"image"]];
                    NSData * userImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
                    userImage = [UIImage imageWithData:userImageData];
                    
                    // Write image
                    [userImageData writeToFile:[[self getDocumentPath] stringByAppendingPathComponent:@"userPic.png"] atomically:YES];
                    [[AppDelegate appDelegate] killHud:self.view];
                    UIStoryboard*storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    NewsListViewController*news = [storyboard instantiateViewControllerWithIdentifier:@"NewsListViewController"];
                    [self.navigationController pushViewController:news animated:NO];
                }
            });
        }
    }
}
- (NSMutableDictionary *)dictionaryByReplacingNullsWithStrings : (NSMutableDictionary *)inputDict {
    
    const NSMutableDictionary *replaced = [inputDict mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    for(NSString *key in inputDict) {
        @autoreleasepool {
            const id object = [inputDict objectForKey:key];
            if(object == nul) {
                //pointer comparison is way faster than -isKindOfClass:
                //since [NSNull null] is a singleton, they'll all point to the same
                //location in memory.
                [replaced setObject:blank
                             forKey:key];
            }else if ([object isKindOfClass: [NSDictionary class]]) {
                [replaced setObject:[self dictionaryByReplacingNullsWithStrings:object] forKey: key];
            }
        }
    }
    
    return [replaced mutableCopy];
}


#pragma mark -
#pragma mark - Web service delegate

//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    NSLog(@"Error");
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    
//}
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    [jsonData appendData:data];
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    NSDictionary *dicJson = [NSJSONSerialization
//                             JSONObjectWithData:jsonData
//                             options:NSJSONReadingMutableLeaves
//                             error:nil];
//    NSLog(@"%@",dicJson);
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    
//    if ([[dicJson objectForKey:@"error"] integerValue] == 0) {
//        
//        HomeViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
//        [self.navigationController pushViewController:homeVC animated:NO];
//        
//    }
//}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    jsonData = [[NSMutableData alloc] init];
}
- (IBAction)onTap_Twitter:(id)sender
{
}

- (IBAction)onTap_Google:(id)sender
{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[[self getDocumentPath] stringByAppendingPathComponent:@"UserInfo"] error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:[[self getDocumentPath] stringByAppendingPathComponent:@"userPic.png"] error:&error];
    
    webview = [[UIWebView alloc]init];
    webview.frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height);
    btn_closeGoogleView = [[UIButton alloc]initWithFrame:CGRectMake(webview.frame.origin.x+370, webview.frame.origin.y-70, 30, 30)];
    [btn_closeGoogleView addTarget:self action:@selector(onTap_CloseGoogle) forControlEvents:UIControlEventTouchUpInside];
    [btn_closeGoogleView  setImage:[UIImage imageNamed:@"close_icon.png"] forState:UIControlStateNormal];
    [webview addSubview:btn_closeGoogleView];
    [webview bringSubviewToFront: btn_closeGoogleView];
    [self.view addSubview:webview];
    webview.delegate  = self;
    NSString *url = [NSString stringWithFormat:@"https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=%@&redirect_uri=%@&scope=%@&data-requestvisibleactions=%@", kClientID_ForGoogle, @"http://localhost", @"https://www.googleapis.com/auth/userinfo.email+https://www.googleapis.com/auth/userinfo.profile+https://www.google.com/reader/api/0/subscription", @"http://schemas.google.com/AddActivity"];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark - For Google Login Inside App //For Google Login Inside App
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(!webview.hidden)
    {
    
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[[request URL] host] isEqualToString:@"localhost"])
    {
        // Extract oauth_verifier from URL query
        NSString* verifier = nil;
        NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
        for (NSString* param in urlParams)
        {
            NSArray* keyValue = [param componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            if ([key isEqualToString:@"code"])
            {
                verifier = [keyValue objectAtIndex:1];
                break;
            }
        }
        
        if (verifier)
        {
            NSString *data = [NSString stringWithFormat:@"code=%@&client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code", verifier,kClientID_ForGoogle,ClientSecret_ForGoogle,@"http://localhost"];
            NSString *url = [NSString stringWithFormat:@"https://accounts.google.com/o/oauth2/token"];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
            [[NSURLConnection alloc] initWithRequest:request delegate:self];
            receivedData = [[NSMutableData alloc] init];
        }
        else
        {
            DLog(@"ERROR");
            // ERROR!
        }
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            NSString* domainName = [cookie domain];
            NSRange domainRange = [domainName rangeOfString:@"google"];
            if(domainRange.length > 0)
            {
                [storage deleteCookie:cookie];
            }
        }
        webview.hidden = YES;
        return NO;
    }
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"")
                                                    message:[NSString stringWithFormat:@"%@", error]
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"")
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSDictionary *dicJson = [NSJSONSerialization
                             JSONObjectWithData:jsonData
                             options:NSJSONReadingMutableLeaves
                             error:nil];
    NSLog(@"%@",dicJson);
    
    if ([[dicJson objectForKey:@"error"] integerValue] == 0) {
        
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"title_activity_dashboard", @"") message:[dicJson objectForKey:@"error_msg"] delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    SBJsonParser *jResponse = [[SBJsonParser alloc]init];
    NSDictionary *tokenData = [jResponse objectWithString:response];
    NSString*str_access_token = [tokenData objectForKey:@"access_token"];
    NSString*strbaseurl = @"https://www.googleapis.com/oauth2/v1/userinfo?access_token=";
    NSURL*url_base=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",strbaseurl,str_access_token]];
    NSMutableURLRequest *murlRequest_Reg = [NSMutableURLRequest requestWithURL:url_base];
    NSError *error = nil;
    NSData *data  = [NSURLConnection sendSynchronousRequest:murlRequest_Reg returningResponse:nil error:&error];
    {
        if (error!=nil)
        {
        }
        NSDictionary *dict_loginDetails = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"%@",dict_loginDetails);
        
        NSDictionary *dict_Responce= [WebServiceCalling sociallogin:dict_loginDetails];
        
        if ([[dict_Responce objectForKey:@"error"] integerValue] == 0)
        {
            UIStoryboard*storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NewsListViewController*news = [storyboard instantiateViewControllerWithIdentifier:@"NewsListViewController"];
            [self.navigationController pushViewController:news animated:NO];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"title_activity_dashboard", @"") message:[dict_Responce objectForKey:@"error_msg"] delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
            [alert show];
            
        }
    };
}


- (IBAction)onTap_Facebook:(id)sender
{
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended)
    {
        [FBSession.activeSession closeAndClearTokenInformation];
        
    }
    else
    {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             [self makeRequestForUserData];
         }];
    }
}

- (void) makeRequestForUserData
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         NSDictionary *dict_Responce;
         if (!error)
         {
             NSDictionary*dict_loginDetails= [NSDictionary dictionaryWithObjectsAndKeys:
                                              [result objectForKey:@"name"],@"name",
                                              [result objectForKey:@"email"],@"email",
                                              [result objectForKey:@"id"],@"fbid", nil];
             dict_Responce = [WebServiceCalling sociallogin:dict_loginDetails];
             
             
         }
         
         if ([[dict_Responce objectForKey:@"error"] integerValue] == 0)
         {
             UIStoryboard*storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             NewsListViewController*news = [storyboard instantiateViewControllerWithIdentifier:@"NewsListViewController"];
             [self.navigationController pushViewController:news animated:NO];
             
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"title_activity_dashboard", @"") message:[dict_Responce objectForKey:@"error_msg"] delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
             [alert show];
             
         }
         
         
     }];
}
- (IBAction)onTap_Btn_Back:(id)sender
{
    InitialViewController *obj_initialView = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"InitialViewController"];
    [self.navigationController pushViewController:obj_initialView animated:NO];
}

-(NSString*)getDocumentPath {
    
    __autoreleasing NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

@end
