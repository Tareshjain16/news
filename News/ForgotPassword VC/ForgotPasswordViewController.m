//
//  ForgotPasswordViewController.m
//  AYN
//
//  Created by MacbookAir on 07/01/01.
//  Copyright © 2001 MacbookAir. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "SignupViewController.h"
#import "constant.h"
#import "WebServiceCalling.h"
#import "InitialViewController.h"


@interface ForgotPasswordViewController () {
    
    __weak IBOutlet UIButton *_buttonSubmit;
    __weak IBOutlet UITextField *_txtEmail;
    __weak IBOutlet UIButton *_buttonCancel;
    __weak IBOutlet UIButton *_buttonSignUp;
    __weak IBOutlet UILabel  *lblForgotPass;
    __weak IBOutlet UILabel  *lblEnterPassword;


    NSMutableData *jsonData;
}

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setImageleftBarItem];
    //Setting borders of button
    [_buttonSubmit.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_buttonSubmit.layer setBorderWidth:1.5];
    
    [_buttonCancel.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_buttonCancel.layer setBorderWidth:1.5];
    
    [_buttonCancel.layer setBorderWidth:1.0];
    [_buttonSubmit.layer setBorderWidth:1.0];
    _buttonCancel.layer .cornerRadius = _buttonSubmit.layer .cornerRadius = 5.0;
    [self setLocalizableText];
}

-(void) setLocalizableText
{
    [_buttonSubmit    setTitle:NSLocalizedString(@"submit", @"")      forState:UIControlStateNormal];
    [_buttonCancel    setTitle:NSLocalizedString(@"cancel", @"")      forState:UIControlStateNormal];
    [_buttonSignUp    setTitle:NSLocalizedString(@"sign_up", @"")     forState:UIControlStateNormal];
    [_txtEmail        setPlaceholder:NSLocalizedString(@"email", @"")];
    [lblForgotPass    setText:NSLocalizedString(@"r_u_forgot", @"")];
    [lblEnterPassword setText:NSLocalizedString(@"enter_forgot", @"")];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark - Web service delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    DLog(@"Error");
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [jsonData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *dicJson = [NSJSONSerialization
                             JSONObjectWithData:jsonData
                             options:NSJSONReadingMutableLeaves
                             error:nil];
    NSLog(@"%@",dicJson);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"title_activity_dashboard", @"") message:[dicJson objectForKey:@"success_msg"] delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
    [alert show];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    jsonData = [[NSMutableData alloc] init];
}


#pragma mark -
#pragma mark - All user's actions

- (IBAction)button_SignUp_Pressed:(id)sender
{
    SignupViewController *signupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
    [self.navigationController pushViewController:signupVC animated:NO];
}

- (IBAction)button_Cancel_Pressed:(id)sender
{
    InitialViewController *obj_initialView = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"InitialViewController"];
    [self.navigationController pushViewController:obj_initialView animated:NO];
}

- (IBAction)button_Submit_Pressed:(id)sender
{
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedStringEmail = [_txtEmail.text stringByTrimmingCharactersInSet:charSet];
    //Check for null string
    if ([trimmedStringEmail isEqualToString:@""])
    {
        // it's empty or contains only white spaces
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"title_activity_dashboard", @"") message:NSLocalizedString(@"mandaory_field", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles: nil];
        [alert show];
        

    }
    else if ([self validateEmailWithString:trimmedStringEmail] == NO)
    {
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
                [dict_info setObject:_txtEmail.text forKey:@"email"];
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_txtEmail.text,@"email",nil];
                NSDictionary*dict_response=[WebServiceCalling Forget_Password:dic];
                if([dict_response isKindOfClass:[NSError class]]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"title_activity_dashboard", @"") message:[dict_response objectForKey:@"error_msg"] delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
                    [alert show];
                }
                [[AppDelegate appDelegate] killHud:self.view];
            });
        }
    }
}

- (IBAction)onTap_Btn_Back:(id)sender
{
    InitialViewController *obj_initialView = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"InitialViewController"];
    [self.navigationController pushViewController:obj_initialView animated:NO];
}

@end