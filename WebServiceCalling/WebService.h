//
//  WebService.h
//  Municipality
//
//  Created by CIS MacMini3 on 2/25/14.
//  Copyright (c) 2014 CIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^WebServiceCalled)(NSDictionary*,NSError*, BOOL);
typedef void (^WebDataReceived) (UIImage*,BOOL);

@interface WebService : NSObject

@property(nonatomic,strong)NSString * strCustomerID;
@property(nonatomic,strong)NSString * strLatitude;
@property(nonatomic,strong)NSString * strLongitude;
@property(nonatomic,strong)NSString * strCategoryID;
@property(nonatomic,strong)NSString * strFilter;
@property(nonatomic, assign) BOOL isSearching;

+(WebService*)getInstance;
- (void)getDataFromJson:(NSData *)postString WebMethod:(NSString *)methodName requestType:(NSString *)methodType getData:(WebServiceCalled) consumer;
- (void)getImageDataForCategory:(NSString *)name getData:(WebDataReceived) consumer;
@end
