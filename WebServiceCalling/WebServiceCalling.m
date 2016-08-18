//
//  WebServiceCalling.m
//  FTP_Project
//
//  Created by cis on 10/7/14.
//  Copyright (c) 2014 cis. All rights reserved.
//

#import "WebServiceCalling.h"
#import "Constant.h"


@interface WebServiceCalling()
{
}
@end
@implementation WebServiceCalling

+ (NSDictionary*)Forget_Password:(NSDictionary *)dict
{
    @try
    {
        NSString *str_UrlParameter = [NSString stringWithFormat:@"email=%@",dict[@"email"]];
        str_UrlParameter = [str_UrlParameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data_Body = [str_UrlParameter dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Base_URl,ForgotPassword]]];
        [mRequest setHTTPMethod:@"POST"];
        [mRequest setHTTPBody:data_Body];
        [mRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data  = [NSURLConnection sendSynchronousRequest:mRequest returningResponse:&response error:&error];
        {
            NSDictionary*dict;
            NSDictionary *dict_Response = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
            dict = dict_Response;
            return dict;
        };
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error from defaultTasks in Cls_Common_Logic.m : %@",exception);
    }
}

+ (NSDictionary*)Signin:(NSDictionary *)dict
{
    @try
    {
        NSString *str_UrlParameter = [NSString stringWithFormat:@"email=%@&password=%@",dict[@"email"],dict[@"password"]];
        
        str_UrlParameter = [str_UrlParameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data_Body = [str_UrlParameter dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Base_URl,LoginWs]]];
        [mRequest setHTTPMethod:@"POST"];
        [mRequest setHTTPBody:data_Body];
        [mRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data  = [NSURLConnection sendSynchronousRequest:mRequest returningResponse:&response error:&error];
        {
            NSDictionary *dict_responce;
            NSDictionary *dict_Response = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
            dict_responce = dict_Response;
            return dict_responce;
        };
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error from defaultTasks in Cls_Common_Logic.m : %@",exception);
    }
}

+ (NSDictionary*)SignUp:(NSDictionary *)dict
{
    @try
    {
        NSString *str_UrlParameter =
        [NSString stringWithFormat:@"name=%@&email=%@&password=%@&contact=%@",dict[@"name"],dict[@"email"],dict[@"password"],dict[@"contact"]];
        str_UrlParameter = [str_UrlParameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data_Body = [str_UrlParameter dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Base_URl,RegisterWs]]];
        [mRequest setHTTPMethod:@"POST"];
        [mRequest setHTTPBody:data_Body];
        [mRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data  = [NSURLConnection sendSynchronousRequest:mRequest returningResponse:&response error:&error];
        {
            NSDictionary *dict_responce;
            NSDictionary *dict_Response = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
            dict_responce = dict_Response;
            return dict_responce;
        };
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error from defaultTasks in Cls_Common_Logic.m : %@",exception);
    }
}

+ (NSDictionary*)UregentNews:(NSDictionary *)dict
{
    @try
    {
        NSString *str_UrlParameter =
        [NSString stringWithFormat:@"page=%@&lang=%@&uid=%@&did=%@",dict[@"page"],dict[@"lang"],dict[@"uid"],dict[@"did"]];
        str_UrlParameter = [str_UrlParameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data_Body = [str_UrlParameter dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Base_URl,UrgentNews]]];
        [mRequest setHTTPMethod:@"POST"];
        [mRequest setHTTPBody:data_Body];
        [mRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data  = [NSURLConnection sendSynchronousRequest:mRequest returningResponse:&response error:&error];
        {
            NSDictionary *dict_responce;
            NSDictionary *dict_Response = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
            dict_responce = dict_Response;
            return dict_responce;
        };
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error from defaultTasks in Cls_Common_Logic.m : %@",exception);
    }
}

+ (NSDictionary*)MostVisitNews:(NSDictionary *)dict
{
    @try
    {
        NSString *str_UrlParameter =
        [NSString stringWithFormat:@"page=%@&lang=%@&uid=%@&did=%@",dict[@"page"],dict[@"lang"],dict[@"uid"],dict[@"did"]];
        str_UrlParameter = [str_UrlParameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data_Body = [str_UrlParameter dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Base_URl,MostVisit]]];
        [mRequest setHTTPMethod:@"POST"];
        [mRequest setHTTPBody:data_Body];
        [mRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data  = [NSURLConnection sendSynchronousRequest:mRequest returningResponse:&response error:&error];
        {
            NSDictionary *dict_responce;
            NSDictionary *dict_Response = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
            dict_responce = dict_Response;
            return dict_responce;
        };
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error from defaultTasks in Cls_Common_Logic.m : %@",exception);
    }
}

+ (NSDictionary*)LatestNews:(NSDictionary *)dict
{
    @try
    {
        NSString *str_UrlParameter =
        [NSString stringWithFormat:@"page=%@&lang=%@&uid=%@&did=%@",dict[@"page"],dict[@"lang"],dict[@"uid"],dict[@"did"]];
        str_UrlParameter = [str_UrlParameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data_Body = [str_UrlParameter dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Base_URl,Latest]]];
        [mRequest setHTTPMethod:@"POST"];
        [mRequest setHTTPBody:data_Body];
        [mRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data  = [NSURLConnection sendSynchronousRequest:mRequest returningResponse:&response error:&error];
        {
            NSDictionary *dict_responce = [[NSDictionary alloc] init];
            if(data != nil) {
                NSDictionary *dict_Response = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
                dict_responce = dict_Response;
            }
            return dict_responce;
        };
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error from defaultTasks in Cls_Common_Logic.m : %@",exception);
    }
}

+ (NSDictionary*)getComments:(NSDictionary *)dict
{
    @try
    {
        NSString *str_UrlParameter =
        [NSString stringWithFormat:@"id=%@",dict[@"id"]];
        str_UrlParameter = [str_UrlParameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data_Body = [str_UrlParameter dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Base_URl,Comment]]];
        [mRequest setHTTPMethod:@"POST"];
        [mRequest setHTTPBody:data_Body];
        [mRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data  = [NSURLConnection sendSynchronousRequest:mRequest returningResponse:&response error:&error];
        {
            NSDictionary *dict_responce;
            NSDictionary *dict_Response = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
            dict_responce = dict_Response;
            return dict_responce;
        };
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error from defaultTasks in Cls_Common_Logic.m : %@",exception);
    }
}

+ (NSDictionary*)postComments:(NSDictionary *)dict
{
    @try
    {
        NSString *str_UrlParameter =
        [NSString stringWithFormat:@"rssid=%ld&uid=%@&comment=%@",[dict[@"rssid"] integerValue],dict[@"uid"],dict[@"comment"]];
        str_UrlParameter = [str_UrlParameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data_Body = [str_UrlParameter dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Base_URl,AddComment]]];
        [mRequest setHTTPMethod:@"POST"];
        [mRequest setHTTPBody:data_Body];
        [mRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data  = [NSURLConnection sendSynchronousRequest:mRequest returningResponse:&response error:&error];
        {
            NSDictionary *dict_responce;
            NSDictionary *dict_Response = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
            dict_responce = dict_Response;
            return dict_responce;
        };
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error from defaultTasks in Cls_Common_Logic.m : %@",exception);
    }
}

+ (NSDictionary*)LikesNews:(NSDictionary *)dict
{
    @try
    {
        NSString *str_UrlParameter =
        [NSString stringWithFormat:@"page=%@&lang=%@&uid=%@&did=%@",dict[@"page"],dict[@"lang"],dict[@"uid"],dict[@"did"]];
        str_UrlParameter = [str_UrlParameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data_Body = [str_UrlParameter dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Base_URl,Like]]];
        [mRequest setHTTPMethod:@"POST"];
        [mRequest setHTTPBody:data_Body];
        [mRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data  = [NSURLConnection sendSynchronousRequest:mRequest returningResponse:&response error:&error];
        {
            NSDictionary *dict_responce;
            NSDictionary *dict_Response = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
            dict_responce = dict_Response;
            return dict_responce;
        };
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error from defaultTasks in Cls_Common_Logic.m : %@",exception);
    }

}

+ (NSString *)AddLikes:(NSDictionary *)dict
{
    @try
    {
        NSString *str_UrlParameter =
        [NSString stringWithFormat:@"rssid=%ld&uid=%@&did=%@&status=%@",[dict[@"rssid"] integerValue],dict[@"uid"],dict[@"did"],dict[@"status"]];
        str_UrlParameter = [str_UrlParameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data_Body = [str_UrlParameter dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Base_URl,AddLike]]];
        [mRequest setHTTPMethod:@"POST"];
        [mRequest setHTTPBody:data_Body];
        [mRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data  = [NSURLConnection sendSynchronousRequest:mRequest returningResponse:&response error:&error];
        {
            NSDictionary *dict_responce;
          //  NSString*str= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dict_Response = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
            dict_responce = dict_Response;
            return dict_responce;
        };
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error from defaultTasks in Cls_Common_Logic.m : %@",exception);
    }
    
}

+ (NSDictionary *)getLikedNews:(NSDictionary *)dict
{
    @try
    {
        NSString *str_UrlParameter =
        [NSString stringWithFormat:@"nid=%ld&uid=%@&did=%@",[dict[@"nid"] integerValue],dict[@"uid"],dict[@"did"]];
        str_UrlParameter = [str_UrlParameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data_Body = [str_UrlParameter dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Base_URl,LikeNews]]];
        [mRequest setHTTPMethod:@"POST"];
        [mRequest setHTTPBody:data_Body];
        [mRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data  = [NSURLConnection sendSynchronousRequest:mRequest returningResponse:&response error:&error];
        {
            NSDictionary *dict_responce;
            //  NSString*str= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dict_Response = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
            dict_responce = dict_Response;
            return dict_responce;
        };
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error from defaultTasks in Cls_Common_Logic.m : %@",exception);
    }
}

+ (NSDictionary*)EditSources:(NSDictionary *)dict
{
    @try
    {
        NSString *str_UrlParameter =
        [NSString stringWithFormat:@"uid=%@&did=%@&lang=%@",dict[@"uid"],dict[@"did"],dict[@"lang"]];
        str_UrlParameter = [str_UrlParameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data_Body = [str_UrlParameter dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Base_URl,Sources]]];
        [mRequest setHTTPMethod:@"POST"];
        [mRequest setHTTPBody:data_Body];
        [mRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data  = [NSURLConnection sendSynchronousRequest:mRequest returningResponse:&response error:&error];
        {
            NSDictionary *dict_responce;
          //  NSString*str= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dict_Response = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
            dict_responce = dict_Response;
            return dict_responce;
        };
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error from defaultTasks in Cls_Common_Logic.m : %@",exception);
    }
    
}

+ (NSDictionary *)updateUserProfile:(NSDictionary *)dict
{
    @try
    {
        
        
        NSData *imageData       = [NSData dataWithData:dict[@"profile_pic"]];
        NSString *filename      = @"userProfilePic.jpg";
        NSString *userId        = dict[@"id"];
        NSString *userName      = dict[@"name"];
        NSString *userEmail     = dict[@"email"];
        NSString *userContact   = dict[@"contact"];

        NSString *urlString = [NSString stringWithFormat:@"%@/%@",Base_URl,updateProfile];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"-----------------99882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData   * body    = [NSMutableData data];
        NSMutableString * string  = [[NSMutableString alloc] init];
        
        [string appendFormat:@"\r\n\r\n--%@\r\n", boundary];
        [string appendFormat:@"Content-Disposition: form-data; name=\"id\"\r\n\r\n"];
        [string appendFormat:@"%@",userId]; //value
        [body appendData:[string dataUsingEncoding:NSUTF8StringEncoding]]; // encrypt the entire body
        
        
        [string appendFormat:@"\r\n\r\n--%@\r\n", boundary];
        [string appendFormat:@"Content-Disposition: form-data; name=\"name\"\r\n\r\n"];
        [string appendFormat:@"%@",userName]; //value
        [body appendData:[string dataUsingEncoding:NSUTF8StringEncoding]]; // encrypt the entire body
        
        
        [string appendFormat:@"\r\n\r\n--%@\r\n", boundary];
        [string appendFormat:@"Content-Disposition: form-data; name=\"email\"\r\n\r\n"];
        [string appendFormat:@"%@",userEmail]; //value
        [body appendData:[string dataUsingEncoding:NSUTF8StringEncoding]]; // encrypt the entire body
        
        [string appendFormat:@"\r\n\r\n--%@\r\n", boundary];
        [string appendFormat:@"Content-Disposition: form-data; name=\"contact\"\r\n\r\n"];
        [string appendFormat:@"%@",userContact]; //value
        [body appendData:[string dataUsingEncoding:NSUTF8StringEncoding]]; // encrypt the entire body
        
        
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profile_pic\"; filename=\"%@\"\r\n",filename]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jasonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        DLog(@"%@", jsonString);
        return jasonDict;
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error from defaultTasks in Cls_Common_Logic.m : %@",exception);
    }
    
}



+ (NSArray*)ChanelList:(NSDictionary *)dict
{
    @try
    {
        NSString *str_UrlParameter =
        [NSString stringWithFormat:@"uid=%@&did=%@&lang=%@&sid=%@",dict[@"uid"],dict[@"did"],dict[@"lang"],dict[@"sid"]];
        str_UrlParameter = [str_UrlParameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data_Body = [str_UrlParameter dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Base_URl,Chanel]]];
        [mRequest setHTTPMethod:@"POST"];
        [mRequest setHTTPBody:data_Body];
        [mRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data  = [NSURLConnection sendSynchronousRequest:mRequest returningResponse:&response error:&error];
        {
            NSArray *dict_responce;
            //  NSString*str= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSArray *dict_Response = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
            dict_responce = dict_Response;
            return dict_responce;
        };
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error from defaultTasks in Cls_Common_Logic.m : %@",exception);
    }
    
}

+ (NSDictionary*)submitSuggestion:(NSDictionary *)dict
{
    @try
    {
        NSString *str_UrlParameter =
        [NSString stringWithFormat:@"name=%@&suggest=%@",dict[@"name"],dict[@"suggest"]];
        str_UrlParameter = [str_UrlParameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data_Body = [str_UrlParameter dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Base_URl,Suggestion]]];
        [mRequest setHTTPMethod:@"POST"];
        [mRequest setHTTPBody:data_Body];
        [mRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data  = [NSURLConnection sendSynchronousRequest:mRequest returningResponse:&response error:&error];
        {
            NSDictionary *dict_responce;
            NSDictionary *dict_Response = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
            dict_responce = dict_Response;
            return dict_responce;
        };
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error from defaultTasks in Cls_Common_Logic.m : %@",exception);
    }
}

+ (NSDictionary*)AddDeleteChanel:(NSDictionary *)dict
{
    @try
    {
        NSString *str_UrlParameter =
        [NSString stringWithFormat:@"uid=%@&did=%@&sid=%@&action=%@&cid=%@",dict[@"uid"],dict[@"did"],dict[@"sid"],dict[@"action"],dict[@"cid"]];
        str_UrlParameter = [str_UrlParameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data_Body = [str_UrlParameter dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Base_URl,AddSource]]];
        [mRequest setHTTPMethod:@"POST"];
        [mRequest setHTTPBody:data_Body];
        [mRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data  = [NSURLConnection sendSynchronousRequest:mRequest returningResponse:&response error:&error];
        {
            //  NSString*str= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dict_Response = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
            return dict_Response;
        };
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error from defaultTasks in Cls_Common_Logic.m : %@",exception);
    }
}

+ (NSDictionary*)sociallogin:(NSDictionary *)dict
{
    @try
    {
        NSString *str_UrlParameter =
        [NSString stringWithFormat:@"name=%@&email=%@&fbid=%@",dict[@"name"],dict[@"email"],dict[@"id"]];
        str_UrlParameter = [str_UrlParameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data_Body = [str_UrlParameter dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Base_URl,SocialLogin]]];
        [mRequest setHTTPMethod:@"POST"];
        [mRequest setHTTPBody:data_Body];
        [mRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data  = [NSURLConnection sendSynchronousRequest:mRequest returningResponse:&response error:&error];
        {
            NSDictionary *dict_responce;
            NSDictionary *dict_Response = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
            dict_responce = dict_Response;
            return dict_responce;
        };
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error from defaultTasks in Cls_Common_Logic.m : %@",exception);
    }
}


@end
