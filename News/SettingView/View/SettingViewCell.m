//
//  SettingViewCell.m
//  News
//
//  Created by Vidvat Joshi on 02/04/16.
//  Copyright © 2016 ACS. All rights reserved.
//

#import "SettingViewCell.h"

@implementation SettingViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellImg   = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 25, 25)];
        self.cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cellImg.frame) + 10, 5,self.frame.size.width, 30)];
        [self.cellLabel setTextColor:[UIColor colorWithRed:0.0/255.0 green:126.0/255.0 blue:255.0/255.0 alpha:1.0]];
        self.cellSwitch = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 90, 5,30, 30)];
        [self.cellSwitch setEnabled:YES];
        [self.cellSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.cellSwitch];
        [self.contentView addSubview:self.cellLabel];
        [self.contentView addSubview:self.cellImg];
    }
    return self;
}

-(void)setState:(id)sender
{
    UIUserNotificationType types;
    types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    if ([sender tag] == 1) {
        if([sender isOn]) {
            // Register the supported interaction types.
             types =  UIUserNotificationTypeAlert;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isAlertOn"];
        } else {
            types = UIUserNotificationTypeBadge |
            UIUserNotificationTypeSound;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isAlertOn"];
        }
    } else if([sender tag] == 2) {
        if([sender isOn]) {
            types =  UIUserNotificationTypeSound;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isSoundOn"];
        } else {
            types = UIUserNotificationTypeBadge |
            UIUserNotificationTypeAlert;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isSoundOn"];
        }
    } else if([sender tag] == 3) {
        if([sender isOn]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"ar" forKey:@"Language"];
            [NSBundle setLanguage:@"ar"];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"Language"];
            [NSBundle setLanguage:@"en"];
        }
    }
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SETLOCALIZABLETEXT" object:nil];
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
