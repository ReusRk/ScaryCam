//
//  EditScreenViewController.h
//  ChangeMask
//
//  Created by Fluxtech_MacMini1 on 6/6/16.
//  Copyright © 2016 Fluxtech_MacMini1. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GoogleMobileAds/GoogleMobileAds.h>

@interface EditScreenViewController : UIViewController

@property (strong, nonatomic) UIImage *selectImage;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImage;
@property (weak, nonatomic) IBOutlet UIImageView *maskImage;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageremoveads;
@property (weak, nonatomic) IBOutlet UIImageView *setimageRemoveAds;
@property (weak, nonatomic) IBOutlet UIView *screenShotView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *share;
@property (weak, nonatomic) IBOutlet UIView *removeAdsView;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *removeAdScreenShotView;
@property (strong, nonatomic) NSMutableArray *userDetailArray;
@end
