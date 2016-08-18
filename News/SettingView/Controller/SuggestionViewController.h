//
//  SuggestionViewController.h
//  News
//
//  Created by Divyaprakash.Soni on 13/05/16.
//  Copyright © 2016 ACS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestionViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton    * submitBtn;
@property (nonatomic, weak) IBOutlet UITextField * userNameTextField;
@property (nonatomic, weak) IBOutlet UITextField * suggestionTextField;
@property (nonatomic, weak) IBOutlet UILabel * lblUserName;
@property (nonatomic, weak) IBOutlet UILabel * lblSuggestion;

@end
