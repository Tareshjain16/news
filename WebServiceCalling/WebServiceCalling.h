//
//  WebServiceCalling.h
//  FTP_Project
//
//  Created by cis on 10/7/14.
//  Copyright (c) 2014 cis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface WebServiceCalling : NSObject

+ (NSDictionary*)Forget_Password:(NSDictionary *)dict;
+ (NSDictionary*)Signin:(NSDictionary *)dict;
+ (NSDictionary*)getComments:(NSDictionary *)dict;
+ (NSDictionary*)postComments:(NSDictionary *)dict;
+ (NSDictionary*)SignUp:(NSDictionary *)dict;
+ (NSDictionary*)UregentNews:(NSDictionary *)dict;
+ (NSDictionary*)MostVisitNews:(NSDictionary *)dict;
+ (NSDictionary*)LatestNews:(NSDictionary *)dict;
+ (NSDictionary*)LikesNews:(NSDictionary *)dict;
+ (NSString *)AddLikes:(NSDictionary *)dict;
+ (NSDictionary *)getLikedNews:(NSDictionary *)dict;
+ (NSDictionary*)EditSources:(NSDictionary *)dict;
+ (NSArray*)ChanelList:(NSDictionary *)dict;
+ (NSDictionary*)AddDeleteChanel:(NSDictionary *)dict;
+ (NSDictionary*)submitSuggestion:(NSDictionary *)dict;
+ (NSDictionary *)updateUserProfile:(NSDictionary *)dict;
+ (NSDictionary*)sociallogin:(NSDictionary *)dict;

@end
