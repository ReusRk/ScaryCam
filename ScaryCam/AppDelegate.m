//
//  AppDelegate.m
//  assiDemo
//
//  Created by Fluxtech_MacMini1 on 6/23/16.
//  Copyright © 2016 Fluxtech_MacMini1. All rights reserved.
//

#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "QueueFTP.h"

@interface AppDelegate ()<GADBannerViewDelegate,GADInterstitialDelegate,QueueFTPDelegate>
{
    
    BOOL interstitialAdsReady;
    QueueFTP* ftp;
    QueueFTPSettings* ftpSettings;
}


@property(nonatomic, strong) GADInterstitial *interstitial;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    interstitialAdsReady=NO;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
   
    
    
    
    
#pragma save plist in bundle file..
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //
    //    NSFileManager *mgr = [NSFileManager defaultManager];
    //
    //    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"ChangeMask.plist"];
    //    if (![mgr fileExistsAtPath: plistPath])
    //    {
    //        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ChangeMask" ofType:@"plist"];
    //        NSLog(@"path:%@",plistPath);
    //        //        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    //        //        [dict writeToFile:plistPath atomically: YES];
    //        NSMutableArray *dict = [[NSMutableArray alloc]initWithContentsOfFile:filePath];
    //        [dict writeToFile:plistPath atomically:YES];
    //        NSLog(@"Dict : %@",dict);
    //    }
    
    //    [self checkInternet:^(BOOL internet)
    //     {
    //         if (internet)
    //  [self performSelectorInBackground:@selector(loadQuetionsFromServer) withObject:nil];
    //         else [self savedictionaryPlist];
    //     }];
    
    
    
    _isCancel = NO;
    _imageCount = 0;
    if (IS_IPHONE) {
        
        if (IS_IPHONE_6) {
            
            UIStoryboard *storyboard;
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil];
            self.window.rootViewController = [storyboard instantiateInitialViewController];
            
        }else if(IS_IPHONE_6P){
            
            UIStoryboard *storyboard;
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone6p" bundle:nil];
            self.window.rootViewController = [storyboard instantiateInitialViewController];
            
        }else if (IS_IPHONE_4){
            
            UIStoryboard *storyboard;
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.window.rootViewController = [storyboard instantiateInitialViewController];
            
        }else{
            
            UIStoryboard *storyboard;
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone5" bundle:nil];
            self.window.rootViewController = [storyboard instantiateInitialViewController];
            
        }
        
    }else{
        
        UIStoryboard *storyboard;
        storyboard = [UIStoryboard storyboardWithName:@"Main_ipad" bundle:nil];
        self.window.rootViewController = [storyboard instantiateInitialViewController];
        
    }
    
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self savedictionaryPlist];
    }
    else
    {
      //  [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfURL:
                                     [NSURL URLWithString:Questions_URL]];
        
        [self SaveQuetionsLocally:dict];
        
    }
    
    
    [self createAndLoadInterstitial];
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
#pragma Initial Coins Setup...
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Coins"]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:[NSNumber numberWithInteger:30] forKey:@"Coins"];
        [userDefaults synchronize];
    }
    
#pragma Remove ads setup..
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isAdsRemove"]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:[NSNumber numberWithBool:NO] forKey:@"isAdsRemove"];
        [userDefaults synchronize];
    }
    
    return YES;
}


-(void)savedictionaryPlist{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"ScaryCam.plist"];
    if (![mgr fileExistsAtPath: plistPath])
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ScaryCam" ofType:@"plist"];
        NSLog(@"path:%@",plistPath);
        //        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        //        [dict writeToFile:plistPath atomically: YES];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
        [dict writeToFile:plistPath atomically:YES];
        // NSLog(@"Dict : %@",dict);
    }
    
}


#pragma Interstial Ads...


//// intertial ads
- (void)createAndLoadInterstitial {
    
    if (!_interstitial) {
        self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:ADMOB_ID];
    }
    self.interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    //request.testDevices = @[ kGADSimulatorID ];
    [self.interstitial loadRequest:request];
}
-(void)loadInterstitialAds{
    [self.interstitial presentFromRootViewController:self.window.rootViewController];
}


- (void)interstitial:(GADInterstitial *)interstitial
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"interstitialDidFailToReceiveAdWithError: %@", [error localizedDescription]);
    [self performSelector:@selector(createAndLoadInterstitial) withObject:nil afterDelay:10];
}


- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    NSLog(@"interstitialDidReceiveAd");
    [self.interstitial presentFromRootViewController:self.window.rootViewController];
    interstitialAdsReady=YES;
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad{
    NSLog(@"interstitialWillPresentScreen");
    interstitialAdsReady=NO;
    
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    NSLog(@"interstitialDidDismissScreen");
    interstitialAdsReady=NO;
    
}


#pragma upload plist to sever...


-(void)uploadPlistToServer{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"ScaryCam.plist"];
    
    ftpSettings=[[QueueFTPSettings alloc]init:@"http://fluxtechsolutions.com/scarycam/upload.php" :@"ftp.fluxtechsolutions.com" :@"rameshwar@fluxtechsolutions.com" :@"2_QClLfUC%}p"];
    ftp=[[QueueFTP alloc]init:ftpSettings];
    [ftp setDelegate:self];
    // NSString *file1 = [[NSBundle mainBundle] pathForResource:@"0" ofType:@"png"];
    [ftp addFile:plistPath :@""];
    // [ftp addFile:@"file2" :@"ftppath"];
    [ftp beginExecution];
    
    
}

-(void) fileUploadResponse:(BOOL)success:(int)responseCode:(NSString*)responseString{
    
    NSLog(@"Bool value: %d",success);
    NSLog(@"Response : %d ",responseCode);
    NSLog(@"REsponse String : %@",responseString);
    
}

//When all files have been uploaded this is called
-(void) allFilesUploaded{
    
    
    // NSLog(@"File Upload SuccessFully..");
    
}

//Exact progress of file being uploaded (currently does not support which file it is)
-(void) progress:(float)progress{
    
    NSLog(@"Uploading : %.02f ",progress);
}


#pragma Coins Increase and decrease..

-(NSInteger)totalCoins{
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"Coins"] integerValue];
    
}

-(void)increaseCoins:(NSInteger)coins{
    
    NSInteger currentValue = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Coins"] integerValue];
    currentValue+=coins;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSNumber numberWithInteger:currentValue] forKey:@"Coins"];
    [userDefaults synchronize];
    
}

-(void)decreaseCoins:(NSInteger)coins{
    
    NSInteger currentValue = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Coins"] integerValue];
    currentValue-=coins;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSNumber numberWithInteger:currentValue] forKey:@"Coins"];
    [userDefaults synchronize];
    
}

-(BOOL)isAdsRemove{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAdsRemove"] boolValue]) {
        return YES;
    }else{
        return NO;
    }
    
}

-(void)removeAds{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSNumber numberWithBool:YES] forKey:@"isAdsRemove"];
    [userDefaults synchronize];
}



#pragma DataFrom Plist

-(NSMutableArray*)getdataFromPlist{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"ChangeMask.plist"];
    if ([mgr fileExistsAtPath: plistPath])
    {
        NSLog(@"Geeting Plist:%@",[[NSMutableArray alloc]initWithContentsOfFile:plistPath]);
        return [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        
    }
    
    return nil;
}


-(NSMutableDictionary *)getdata{
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"ScaryCam.plist"];
    if ([mgr fileExistsAtPath: plistPath])
    {
        NSLog(@"Geeting Plist:%@",[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath]);
        return [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        
    }
    
    return nil;
    
}


#pragma mark Check for Network

- (void)checkInternet:(connection)block
{
    
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    __block Reachability *netReachability = internetReachableFoo;
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [netReachability stopNotifier];
            block(YES);
            
        });
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Someone broke the internet :(");
            [netReachability stopNotifier];
            block(NO);
        });
    };
    
    [internetReachableFoo startNotifier];
    
}


-(void)loadQuetionsFromServer{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfURL:
                                 [NSURL URLWithString:Questions_URL]];
    if (dict) {
        [self SaveQuetionsLocally:dict];
    }
}


-(void)SaveQuetionsLocally:(NSMutableDictionary *)dict{
    
  //  [SVProgressHUD showWithStatus:@"Loading items..." maskType:SVProgressHUDMaskTypeClear];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"ScaryCam.plist"];
    
    [dict writeToFile:plistPath atomically: YES];
    //[SVProgressHUD dismiss];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    //       [self checkInternet:^(BOOL internet)
    //     {
    //     if (internet)
    //     [self performSelectorInBackground:@selector(loadQuetionsFromServer) withObject:nil];
    //     }];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
