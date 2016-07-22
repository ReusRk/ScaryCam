//
//  AppDelegate.h
//  assiDemo
//
//  Created by Fluxtech_MacMini1 on 6/23/16.
//  Copyright © 2016 Fluxtech_MacMini1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
//#import "FMDatabase.h"

#import <GoogleMobileAds/GoogleMobileAds.h>
#import "Reachability.h"
#define DELEGATE ((AppDelegate*)[[UIApplication sharedApplication]delegate])
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_4 (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define ADMOB_ID @"ca-app-pub-3133172200494813/3395105682" // intersitial
#define ADMOB_ID2 @"ca-app-pub-3133172200494813/5011439683" //banner
# define Questions_URL @"http://fluxtechsolutions.com/scarycam/ScaryCam.plist"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
    __block Reachability *internetReachableFoo;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSString *databaseName,*databasePath;
@property (nonatomic) BOOL isCancel;
@property (nonatomic) int imageCount;

typedef void(^connection)(BOOL);
- (void)checkInternet:(connection)block;
-(BOOL)isAdsRemove;
-(void)removeAds;

-(NSMutableArray*)getdataFromPlist;
-(NSInteger)totalCoins;

-(NSMutableDictionary *)getdata;

-(void)increaseCoins:(NSInteger)coins;
-(void)decreaseCoins:(NSInteger)coins;
-(void)uploadPlistToServer;
@end


