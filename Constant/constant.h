
//
//  constant.h
//  ParkLineApp
//
//  Copyright (c) 2013 Systematixindia. All rights reserved.
//

// Debug, Release and Distribution mode configuration

#ifdef DEBUG
// Debug Mode : Development Mode
#elif RELEASE
// Release Mode : QA Mode / Testing Mode / Device Mode
#else
// Distribuion Mode : App Store Mode
#endif

// Application Delegate Object

// Check iOS Version
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define PUSH_NOTIFICATION_TOKEN     @"push_notification_token"
#define PUSH_NOTIFICATION_ID     @"push_notification_id"
#define IS_NOTIFICATION     @"is_notification"
#define IS_SOCIAL           @"isSocialUser"
#define DEVICETOKEN         @"deviceToken"
#define PUSHBADGE           @"pushBadge"
#define PUSHALERT           @"pushAlert"
#define PUSHSOUND           @"pushSound"
#define DEVICENAME          @"deviceName"
#define DEVICEMODEL         @"deviceModel"
#define DEVICESYSTEMVERSION @"deviceSystemVersion"
#define DEVICENOTIFICATIONOBJECT    @"deviceNotificationObject"
#define DEVICE              @"device"
#define NOTIFICATIONPAYLOAD @"notificationPayload"

/////////////////////////// Device Dimensions ///////////////////////////////

#define SCREEN_BOUNDS_X [UIScreen mainScreen].bounds.origin.x
#define SCREEN_BOUNDS_Y [UIScreen mainScreen].bounds.origin.y
#define SCREEN_BOUNDS_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_BOUNDS_HEIGHT [UIScreen mainScreen].bounds.size.height

// IPHONE SCREEN WIDTH AND HEIGHT BOUND CONDITION
#define IS_IPHONE_4_OR_5_WIDTH (fabs((double)[[UIScreen mainScreen]bounds].size.width-(double)320) < DBL_EPSILON)
#define IS_IPHONE_4_HEIGHT (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)480) < DBL_EPSILON)
#define IS_IPHONE_5_HEIGHT (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)568) < DBL_EPSILON)
#define IS_IPHONE_6_WIDTH (fabs((double)[[UIScreen mainScreen]bounds].size.width-(double)375) < DBL_EPSILON)
#define IS_IPHONE_6_HEIGHT (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS_WIDTH (fabs((double)[[UIScreen mainScreen]bounds].size.width-(double)414) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS_HEIGHT (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)736) < DBL_EPSILON)

#define IS_DEVICE_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

// IOS version check
#define IS_OS_7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0))
#define IS_OS_7_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0))
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

// IPHONE SCREEN WIDTH AND HEIGHT
#define SCREEN_SIZE self.view.frame.size
#define SCREEN_ORIGIN self.view.frame.origin

#define SCREEN_X [UIApplication sharedApplication].keyWindow.frame.origin.x
#define SCREEN_Y [UIApplication sharedApplication].keyWindow.frame.origin.y
#define SCREEN_WIDTH [UIApplication sharedApplication].keyWindow.frame.size.width
#define SCREEN_HEIGHT [UIApplication sharedApplication].keyWindow.frame.size.height


#define RATIO_WIDTH_4 0.85
#define RATIO_HEIGHT_4 0.72
#define RATIO_5 0.85
#define RATIO_6 1.0
#define RATIO_6_PLUS 1.10

#define USERDEFAULT [NSUserDefaults standardUserDefaults]
#define SELECTEDLANG [NSUserDefaults standardUserDefaults] valueForKey:@"Language"]


// Debug and Release Mode Logs
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(__unused ...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

//------------ Alert Title and Messages----------//
#define ALERTTITLEMESSAGE @"Message"
#define ALERTTITLEERROR @"Error"
#define ALERTTITLECONFIRM @"Confirm"

#define ALERTMSG_SERVERERROR @"\nOops. Something went wrong. Please try again later.."
#define ALERTMSG_INTERNETNOTAVAILABEL @"\nInternet connection is not available."
#define ALERTMSG_SERVERORNETWORKERROR @"\nUnable to connect server.\nOR\nInternet connection is slow."


//Alert conntent
#define alertTitle  NSLocalizedStringFromTableInBundle(@"error_header", nil,[Appdelegate getNSbundlePathLocalizableString], nil)
#define alertOk  NSLocalizedStringFromTableInBundle(@"OK", nil,[Appdelegate getNSbundlePathLocalizableString], nil)
#define alertSucess NSLocalizedStringFromTableInBundle(@"Alert", nil,[Appdelegate getNSbundlePathLocalizableString], nil)


//WebService variable
#define Image_Base_Url @"http://aindroidapi.coolpage.biz/app_login_api/Ω"
#define Base_URl  @"http://3aynapp.com/app_login_api/"
#define ImgageUpload_URl  @"http://3aynapp.com/app_login_api/upload/"
#define LoginWs @"login.php"
#define RegisterWs @"register.php"
#define SocialLogin @"register_fb.php"
#define ForgotPassword  @"forgot.php"
#define UrgentNews @"urgent_news.php"
#define Latest @"rss.php"
#define LikeNews @"rss_by_news_id.php"
#define Comment @"comment.php"
#define AddComment @"add_comment.php"
#define Like @"likes.php"
#define Suggestion @"add_suggesition.php"
#define Sources @"SourceChanel.php"
#define Chanel @"source_chanel.php"
#define AddSource @"add_source.php"
#define AddLike @"add_likes.php"
#define MostVisit @"most_visit_rss.php"
#define District @"district"
#define BookingUrl @"allbookings"
#define ADBooking @"booking"
#define EmailCheck @"emailcheck"
#define ResetPassword @"resetpassword"
#define SingleBooking @"singlebooking"
#define Privacy @"privacy"
#define TOS @"service"
#define CreditCardCheck @"creditcardcheck"
#define GetHourlyHireSetting @"getHourlyOnHireSettings"
#define HourlyOnHireService @"hourlyOnHireService"
#define GetPriceForPointToPoint @"GetPriceForPointToPoint"
#define AdhocPointToPointService @"adhocPointToPointService"
#define PromotionList @"getPromotionList"
#define ABOUT @"about"
#define Contact @"contact"
#define AddDeviceToken @"addDeviceToken"
#define DeleteDeviceToken @"deleteDeviceToken"
#define GetPriceForAirportTransfer @"getPriceForAirportTransfer"
#define ShowProfile @"showProfile"
#define editProfile @"editProfile"
#define updateProfile @"updateprofile.php"

#define kClientID_ForGoogle  @"562290301413-t7378822i7ebiat7bujidt3qo573nkbo.apps.googleusercontent.com"
#define ClientSecret_ForGoogle @""


#define Set_Font(Size) [UIFont fontWithName:@"DroidKufi-Regular" size:Size]


