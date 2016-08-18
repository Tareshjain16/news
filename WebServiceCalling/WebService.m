//
//  WebService.m
//  Municipality
//
//  Created by CIS MacMini3 on 2/25/14.
//  Copyright (c) 2014 CIS. All rights reserved.
//

#import "WebService.h"

//#define MAIN_URL @"http://talapp.rt.cisinlive.com/webservice/"
//#define IMAGE_URL @"http://talapp.rt.cisinlive.com"

#define MAIN_URL @"http://aindroidapi.coolpage.biz/app_login_api/"
#define IMAGE_URL @""


static WebService *staticObject;

@implementation WebService

@synthesize strCustomerID;
@synthesize strLatitude;
@synthesize strLongitude;
@synthesize isSearching;
@synthesize strCategoryID;
@synthesize strFilter;


#pragma mark-
#pragma mark- Web Serivce Method

//HTTP Web service method
- (void)getDataFromJson:(NSData *)postString WebMethod:(NSString *)methodName requestType:(NSString *)methodType getData:(WebServiceCalled) consumer{
    
    NSString* temp = [methodName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",temp);
    NSString *strWebServiceURL = [MAIN_URL stringByAppendingString:temp];
    NSLog(@"%@",strWebServiceURL);
    
    NSURL *url = [NSURL URLWithString:strWebServiceURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:methodType];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postString];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        NSInteger statusCode = [HTTPResponse statusCode];
        
        if (statusCode == 200)
        {
            NSString *charlieSendString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",charlieSendString);
             NSLog(@"From getDataFromJson2");
            
            NSError* error;
            
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&error];
            
            if (json) {
                
                if (![[json valueForKey:@"error"] boolValue]) {
                    
                    consumer(json,nil,TRUE);
                    
                }
                else
                {
                    NSLog(@"%@",[error localizedDescription]);
                    NSLog(@"From getDataFromJson");
                    consumer(nil,error,FALSE);
                    
                }
            }
            else
            {
                NSLog(@"%@",[error localizedDescription]);
                 NSLog(@"From getDataFromJson1");
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"network_check_title", @"") message:NSLocalizedString(@"network_check_msg", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles: nil];
                [alert show];
                consumer(nil,error,FALSE);
                
            }
        }
        else
        {
            consumer(nil,error,FALSE);
        }
    }];
}

//Method to get Image from URL
- (void)getImageDataForCategory:(NSString *)name getData:(WebDataReceived) consumer{
    {
        NSString *strWebServiceURL = [IMAGE_URL stringByAppendingPathComponent:name];
        NSURL *url = [NSURL URLWithString:strWebServiceURL];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
            NSInteger statusCode = [HTTPResponse statusCode];
            
            if (statusCode == 200)
            {
                UIImage * image =[UIImage imageWithData:data];
                consumer(image,TRUE);
            }
            else
            {
                consumer(nil,FALSE);
            }
        }];
    }
}

//Singelton Method
+(WebService*)getInstance{
    
    @synchronized (self)
    {
        if (staticObject == nil) {
            
            staticObject = [[WebService alloc]init];
            
        }
    }
    return staticObject;
    
}
@end
