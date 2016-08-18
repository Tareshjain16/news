//
//  NewsDetailsViewController.h
//  NewsApp
//
//  Created by Vidvat Joshi on 24/02/16.
//  Copyright © 2016 Vidvat Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailsViewController : UIViewController
{
    
    IBOutlet UINavigationItem *navItemNewsDetails;
    IBOutlet UIWebView *wvNewsDetails;
}
@property (nonatomic, strong)NSString *strNewsTitle;
@property (nonatomic, strong)NSString *strNewURL;
@end
