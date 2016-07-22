//
//  ChangeMaskViewController.h
//  ChangeMask
//
//  Created by Fluxtech_MacMini1 on 6/7/16.
//  Copyright © 2016 Fluxtech_MacMini1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

//#import "DLSFTPConnection.h"
//#import "DLDocumentsDirectoryPath.h"


#import <GoogleMobileAds/GoogleMobileAds.h>

@protocol imageName <NSObject>

@optional
- (void) imageName :(NSString *)imgName;

@end
@interface ChangeMaskViewController : UIViewController
{
    NSMutableArray *maskImages;
    NSMutableArray *CoinPrice;

    NSMutableData *downloadData;
   
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,retain) id deleget;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *previosBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *coinsLbl;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *adsView;
@property (weak, nonatomic) IBOutlet UIView *removeAdsView;
@property (weak, nonatomic) IBOutlet UILabel *cnlbl;
@property (strong, nonatomic) NSMutableArray *userDeatilArray;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
