//
//  SettingViewController.m
//  ChangeMask
//
//  Created by Fluxtech_MacMini1 on 6/7/16.
//  Copyright © 2016 Fluxtech_MacMini1. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
@interface SettingViewController ()<GADBannerViewDelegate>



@end

@implementation SettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self setRemainingHint:nil];

    
    
    if ([DELEGATE isAdsRemove]) {
        
        [_bannerView removeFromSuperview];
        
    }else{
        
        [self createAndLoadBannerAds];
        
    }
}

#pragma wav file play...

- (void)playSound :(NSString *)fName :(NSString *) ext{
    SystemSoundID audioEffect;
    NSString *path = [[NSBundle mainBundle] pathForResource : fName ofType :ext];
    if ([[NSFileManager defaultManager] fileExistsAtPath : path]) {
        NSURL *pathURL = [NSURL fileURLWithPath: path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
    }
    else {
        NSLog(@"error, file not found: %@", path);
    }
}



- (void)createAndLoadBannerAds {
    
    self.bannerView.adUnitID = ADMOB_ID2;
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID ];
    [self.bannerView loadRequest:request];
    
}
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView;{
    NSLog(@"adViewDidReceiveAd");
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"DidFailToReceiveAdWithError: %@", [error localizedDescription]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    
//    [self oggSetup];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.player play];
//    });
    [self playSound:@"bloop" :@"wav"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma Ogg Setup..


-(void)setRemainingHint:(NSNotification*)notification{
    
    if (notification.object&&[notification.object isKindOfClass:[NSNumber class]]) {
        
        [_coinsLbl setText:[NSString stringWithFormat:@"COINS : %ld",(long)([DELEGATE totalCoins]+[notification.object intValue])]];
//          [_coinsLbl2 setText:[NSString stringWithFormat:@"COINS : %ld",(long)([DELEGATE totalCoins]+[notification.object intValue])]];
    
        
    }else{
        [_coinsLbl setText:[NSString stringWithFormat:@"COINS : %ld",(long)([DELEGATE totalCoins])]];
    }
    
}

#pragma OGG Player Delegate..


- (IBAction)rate:(id)sender {
    
    [self playSound:@"bloop" :@"wav"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://fluxtechsolutions.com"]];

}

- (IBAction)removeAds:(id)sender {
    
    [DELEGATE removeAds];
}


@end
