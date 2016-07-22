//
//  SettingViewController.h
//  ChangeMask
//
//  Created by Fluxtech_MacMini1 on 6/7/16.
//  Copyright © 2016 Fluxtech_MacMini1. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GoogleMobileAds/GoogleMobileAds.h>

@interface SettingViewController : UIViewController
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *coinsLbl;

@end
