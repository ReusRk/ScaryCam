//
//  ChangeMaskViewController.m
//  ChangeMask
//
//  Created by Fluxtech_MacMini1 on 6/7/16.
//  Copyright © 2016 Fluxtech_MacMini1. All rights reserved.
//

#import "ChangeMaskViewController.h"
#import "ChangeMaskCollectionViewCell.h"
//#import "FMDatabase.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIImageView+WebCache.h"
//#import <NMSSH/NMSSH.h>
//#import "DLSFTPConnection.h"
#import "QueueFTP.h"

@interface ChangeMaskViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,GADBannerViewDelegate,GADInterstitialDelegate,QueueFTPDelegate>
{
    int getNo;
    BOOL interstitialAdsReady, isUpdate;
    NSMutableArray *dataFromPlist,*contentArray;
    NSMutableDictionary *CurrentUserDict;
    NSNumber* unlock;
    NSString *currentVendorId ;
    NSString *uniqueIdentifier;
    NSMutableDictionary *addingDict;
    QueueFTP* ftp;
    QueueFTPSettings* ftpSettings;
}

@property (nonatomic, strong) GADInterstitial *interstitial;
//@property (strong, nonatomic) DLSFTPConnection *connection;
@property (nonatomic, copy) NSString *remoteBasePath;
@property (nonatomic, copy) NSString *localPath;


@end

@implementation ChangeMaskViewController
@synthesize cnlbl = _cnlbl;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRemainingHint:) name:@"coinsAdded" object:nil];
    isUpdate = NO;
    
    if (!contentArray) {
        contentArray = [[NSMutableArray alloc]init];
    }
    
    
    
    /*  NMSSHSession *session = [NMSSHSession connectToHost:@"162.215.253.110:21"
     withUsername:@"rameshwar@fluxtechsolutions.com"];
     
     if (session.isConnected) {
     [session authenticateByPassword:@"2_QClLfUC%}p"];
     
     if (session.isAuthorized) {
     NSLog(@"Authentication succeeded");
     }
     }
     
     NSError *error = nil;
     NSString *response = [session.channel execute:@"ls -l /var/www/" error:&error];
     NSLog(@"List of my sites: %@", response);*/
    
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
    [self.interstitial presentFromRootViewController:self];
}


- (void)interstitial:(GADInterstitial *)interstitial
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"interstitialDidFailToReceiveAdWithError: %@", [error localizedDescription]);
    [self performSelector:@selector(createAndLoadInterstitial) withObject:nil afterDelay:10];
}


- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    NSLog(@"interstitialDidReceiveAd");
    [self.interstitial presentFromRootViewController:self];
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



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


#pragma wav file play on btn click..


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

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
  
    //[self setRemainingHint:nil];
    
    if (IS_IPHONE) {
        if (IS_IPHONE_6P) {
            _pageControl.transform = CGAffineTransformMakeScale(0.6, 0.6);
            
        }else if (IS_IPHONE_6){
            _pageControl.transform = CGAffineTransformMakeScale(0.54, 0.54);
        }else {
            
            _pageControl.transform = CGAffineTransformMakeScale(0.45, 0.45);
            
        }

    }
    
    if ([DELEGATE isAdsRemove]) {
        
        [_bannerView removeFromSuperview];
        [_removeAdsView setHidden:NO];
        [_adsView setHidden:YES];
    }else{
        
        [_removeAdsView setHidden:YES];
        [_adsView setHidden:NO];
        [self createAndLoadBannerAds];
        
    }
    
    NSLog(@"User Detail Array : %@ ",_userDeatilArray);
    
    
    [_coinsLbl setText:[NSString stringWithFormat:@"Coins : %@",[[_userDeatilArray objectAtIndex:0] objectForKey:@"totalCoins"]]];
    
    [_cnlbl setText:[NSString stringWithFormat:@"Coins : %@",[[_userDeatilArray objectAtIndex:0] objectForKey:@"totalCoins"]]];
    
    uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
}

-(void)setRemainingHint:(NSNotification*)notification{
    
    if (notification.object&&[notification.object isKindOfClass:[NSNumber class]]) {
        
        [_coinsLbl setText:[NSString stringWithFormat:@"COINS : %ld",(long)([DELEGATE totalCoins]+[notification.object intValue])]];
        
        [_cnlbl setText:[NSString stringWithFormat:@"COINS : %ld",(long)([DELEGATE totalCoins]+[notification.object intValue])]];
    }else{
        [_coinsLbl setText:[NSString stringWithFormat:@"COINS : %ld",(long)([DELEGATE totalCoins])]];
        [_cnlbl setText:[NSString stringWithFormat:@"COINS : %ld",(long)([DELEGATE totalCoins]+[notification.object intValue])]];
    }
    
}

-(void)uploadToServer{
    
    
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



-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"coinsAdded" object:nil];
    
    //  [self performSelector:@selector(uploadToServer) withObject:self afterDelay:3.0];
    
}




#pragma collecionView Delegate


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    // return [maskImages count];
    return [_userDeatilArray count]-1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.collectionView.frame.size;
}

-(ChangeMaskCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *const CellIdentifier = @"Cell";
    ChangeMaskCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.maskImage setImage:[UIImage imageNamed:[[_userDeatilArray objectAtIndex:indexPath.row +1] objectForKey:@"image"]]];
    getNo = (int)indexPath.row;
    __block UIActivityIndicatorView *activityIndicator;
    activityIndicator = (UIActivityIndicatorView *)[cell viewWithTag:901];
    activityIndicator.hidesWhenStopped = YES;
    
    [cell.maskImage sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[[_userDeatilArray objectAtIndex:indexPath.row +1 ] objectForKey:@"image"]] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger recievedSize, NSInteger expectedSize){
        
        if (!activityIndicator) {
            [activityIndicator startAnimating];
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        
        [activityIndicator removeFromSuperview];
        activityIndicator =nil;
    }];
    
    int pages = floor(_collectionView.contentSize.width / _collectionView.frame.size.width);
    [_pageControl setNumberOfPages:pages];
    
    unlock = [[_userDeatilArray objectAtIndex:indexPath.row + 1] objectForKey:@"unlock"];
    [cell.lockUnlockImage setImage:[UIImage imageNamed:@"lock.png"]];
    [cell.priceCoinsLbl setText:[NSString stringWithFormat:@"Price : %@ Coins",[[_userDeatilArray objectAtIndex:indexPath.row + 1] objectForKey:@"coins"]]];
    if ([unlock boolValue] == YES) {
        
        [cell.lockUnlockImage setImage:[UIImage imageNamed:@"unlocked.png"]];
    }
    
    return cell;
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    //  UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];
    // datasetCell.backgroundColor = [UIColor lightGrayColor];
    
    
    
#pragma on didSelect method check image is unlock or not if not than unlock and update plist to according image lock/unlock...
    
    if ([unlock boolValue] == YES) {
        
        [_deleget imageName:[NSString stringWithFormat:@"%@",[[_userDeatilArray objectAtIndex:indexPath.row + 1] objectForKey:@"image"]]];
        [DELEGATE setIsCancel:YES];
        [self dismissViewControllerAnimated:YES completion:^{
        
            [DELEGATE uploadPlistToServer];
        }];
        
        
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unlock First" message:@"Unlock now?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            
            if ([[[_userDeatilArray objectAtIndex:0] objectForKey:@"totalCoins"] integerValue] >= [[[_userDeatilArray objectAtIndex:indexPath.row + 1] objectForKey:@"coins"] integerValue]) {
                
                [DELEGATE decreaseCoins:[[[_userDeatilArray objectAtIndex:indexPath.row + 1] objectForKey:@"coins"] integerValue]];
                
                int remainingCoins = [[[_userDeatilArray objectAtIndex:0] objectForKey:@"totalCoins"] integerValue] -[[[_userDeatilArray objectAtIndex:indexPath.row + 1] objectForKey:@"coins"] integerValue];
                
                NSMutableDictionary *coins = [[NSMutableDictionary alloc]initWithDictionary:[_userDeatilArray objectAtIndex:0]];
                [coins setObject:[NSString stringWithFormat:@"%d",remainingCoins] forKey:@"totalCoins"];
                [_userDeatilArray replaceObjectAtIndex:0 withObject:coins];
                
                
                [_coinsLbl setText:[NSString stringWithFormat:@"Coins : %@",[[_userDeatilArray objectAtIndex:0] objectForKey:@"totalCoins"]]];
                
                [_cnlbl setText:[NSString stringWithFormat:@"Coins : %@",[[_userDeatilArray objectAtIndex:0] objectForKey:@"totalCoins"]]];
                
                // [self setRemainingHint:nil];
                
                NSMutableDictionary *innerDictToUpdate = [[NSMutableDictionary alloc]initWithDictionary:[_userDeatilArray objectAtIndex:indexPath.row + 1]];
                
                NSLog(@"inner Dict : %@ ", innerDictToUpdate);
                
                [innerDictToUpdate setObject:[NSNumber numberWithBool:YES] forKey:@"unlock"];
                NSLog(@"indexPath : %ld ",(long)indexPath.row);
                
                
                [_userDeatilArray replaceObjectAtIndex:indexPath.row + 1 withObject:innerDictToUpdate];
                
                NSLog(@"updated Array of User : %@ ",_userDeatilArray);
                
                NSMutableDictionary *gettingMainDict = [[NSMutableDictionary alloc]initWithDictionary:[DELEGATE getdata]];
                
                if ([gettingMainDict objectForKey:uniqueIdentifier]) {
                    
                    [gettingMainDict setObject:_userDeatilArray forKey:uniqueIdentifier];
                }
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                
                NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"ScaryCam.plist"];
                
                [gettingMainDict writeToFile:plistPath atomically:YES];
                
                [_deleget imageName:[NSString stringWithFormat:@"%@",[[_userDeatilArray objectAtIndex:indexPath.row + 1] objectForKey:@"image"]]];
                
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:getNo inSection:0];
                
                [self.collectionView reloadItemsAtIndexPaths:@[indexpath]];
                
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!!"
                                                                message:@"you don't have enough coins to unlock."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
            //            [DELEGATE setIsCancel:YES];
            //            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action1];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
    CGFloat pageWidth = _collectionView.frame.size.width;
    float currentPage = _collectionView.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f)) {
        _pageControl.currentPage = currentPage + 1;
    } else {
        _pageControl.currentPage = currentPage;
    }
}


-(void)buttonClick{
    
    [_pageControl setNumberOfPages:10];
    
    CGFloat pageWidth = _collectionView.frame.size.width;
    float currentPage = (_collectionView.contentOffset.x / pageWidth) +1;
    
    if (0.0f != fmodf(currentPage, 1.0f)) {
        _pageControl.currentPage = currentPage + 1;
    } else {
        _pageControl.currentPage = currentPage;
    }
    
}
-(void)PrevBtnClick{
    
    [_pageControl setNumberOfPages:10];
    
    CGFloat pageWidth = _collectionView.frame.size.width;
    float currentPage = (_collectionView.contentOffset.x / pageWidth) - 1;
    
    if (0.0f != fmodf(currentPage, 1.0f)) {
        _pageControl.currentPage = currentPage - 1;
    } else {
        _pageControl.currentPage = currentPage;
    }
    
}
-(UIImage*)getSavedImage:(NSString*)imageName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageName]];
    if ([mgr fileExistsAtPath: fullPath])
    {
        UIImage *originalImage = [UIImage imageWithContentsOfFile:fullPath];
        UIImage *imageToDisplay =[UIImage imageWithCGImage:[originalImage CGImage]scale:[originalImage scale]orientation: UIImageOrientationUp];
        return imageToDisplay;
    }
    return nil;
    
}


- (BOOL)uploadImage:(NSData *)imageData filename:(NSString *)filename{
    
    
    NSString *urlString = @" http://fluxtechsolutions.com/scarycam/";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",filename]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    return ([returnString isEqualToString:@"OK"]);
}




- (IBAction)reset:(id)sender {
    
    [self playSound:@"bloop" :@"wav"];
    
    NSLog(@"Index of array : %d ",getNo);
    [DELEGATE setIsCancel:YES];
    
    if ([unlock boolValue] == YES) {
        
        [_deleget imageName:[NSString stringWithFormat:@"%@",[[_userDeatilArray objectAtIndex:getNo + 1] objectForKey:@"image"]]];
        [DELEGATE setIsCancel:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            
            [DELEGATE uploadPlistToServer];
        }];
        
        
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unlock First" message:@"Unlock now?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            
            if ([[[_userDeatilArray objectAtIndex:0] objectForKey:@"totalCoins"] integerValue] >= [[[_userDeatilArray objectAtIndex:getNo + 1] objectForKey:@"coins"] integerValue]) {
                
                [DELEGATE decreaseCoins:[[[_userDeatilArray objectAtIndex:getNo + 1] objectForKey:@"coins"] integerValue]];
                
                int remainingCoins = (int)([[[_userDeatilArray objectAtIndex:0] objectForKey:@"totalCoins"] integerValue] -[[[_userDeatilArray objectAtIndex:getNo + 1] objectForKey:@"coins"] integerValue]);
                
                NSMutableDictionary *coins = [[NSMutableDictionary alloc]initWithDictionary:[_userDeatilArray objectAtIndex:0]];
                [coins setObject:[NSString stringWithFormat:@"%d",remainingCoins] forKey:@"totalCoins"];
                [_userDeatilArray replaceObjectAtIndex:0 withObject:coins];
                
                
                [_coinsLbl setText:[NSString stringWithFormat:@"Coins : %@",[[_userDeatilArray objectAtIndex:0] objectForKey:@"totalCoins"]]];
                
                [_cnlbl setText:[NSString stringWithFormat:@"Coins : %@",[[_userDeatilArray objectAtIndex:0] objectForKey:@"totalCoins"]]];
                
                NSMutableDictionary *innerDictToUpdate = [[NSMutableDictionary alloc]initWithDictionary:[_userDeatilArray objectAtIndex:getNo + 1]];
                
                NSLog(@"inner Dict : %@ ", innerDictToUpdate);
                
                [innerDictToUpdate setObject:[NSNumber numberWithBool:YES] forKey:@"unlock"];
                NSLog(@"indexPath : %ld ",(long)getNo + 1);
                
                
                [_userDeatilArray replaceObjectAtIndex:getNo + 1 withObject:innerDictToUpdate];
                
                NSLog(@"updated Array of User : %@ ",_userDeatilArray);
                
                NSMutableDictionary *gettingMainDict = [[NSMutableDictionary alloc]initWithDictionary:[DELEGATE getdata]];
                
                if ([gettingMainDict objectForKey:uniqueIdentifier]) {
                    
                    [gettingMainDict setObject:_userDeatilArray forKey:uniqueIdentifier];
                }
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                
                NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"ScaryCam.plist"];
                
                [gettingMainDict writeToFile:plistPath atomically:YES];
                
                [_deleget imageName:[NSString stringWithFormat:@"%@",[[_userDeatilArray objectAtIndex:getNo + 1] objectForKey:@"image"]]];
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:getNo inSection:0];
                
                [self.collectionView reloadItemsAtIndexPaths:@[indexpath]];
                
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!!"
                                                                message:@"you don't have enough coins to unlock."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
            [DELEGATE setIsCancel:YES];
            [self dismissViewControllerAnimated:YES completion:^{
                
                [DELEGATE uploadPlistToServer];
            }];
        }];
        [alert addAction:action1];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}





- (IBAction)cancel:(id)sender {
    
    
    
    [self playSound:@"bloop" :@"wav"];
    
    [DELEGATE setIsCancel:NO];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [DELEGATE uploadPlistToServer];
    }];
}

- (IBAction)previous:(id)sender {
    
    [self playSound:@"bloop" :@"wav"];
    
    
    if (DELEGATE.imageCount == 1) {
        
        //        [self.previosBtn setEnabled:NO];
        //        [self.nextBtn setEnabled:YES];
    }
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [self.player play];
    //    });
    
    [self performSelectorOnMainThread:@selector(previous) withObject:nil waitUntilDone:NO];
    
}

- (void)next {
    
    if (DELEGATE.imageCount < [_userDeatilArray count] - 2 ) {
        
        [self buttonClick];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:++DELEGATE.imageCount inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }else {
        //[DELEGATE setImageCount:0];
        // [[self navigationController] popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)next:(id)sender {
    
    [self playSound:@"bloop" :@"wav"];
    
    if (DELEGATE.imageCount == 8) {
        
        //        [self.nextBtn setEnabled:NO];
        //        [self.previosBtn setEnabled:YES];
    }
    
    [self performSelectorOnMainThread:@selector(next) withObject:nil waitUntilDone:NO];
    
}

- (void)previous {
    
    //    [self.previosBtn setEnabled:NO];
    
    if (DELEGATE.imageCount>0) {
        
        //  [self.previosBtn setEnabled:YES];
        
        [self PrevBtnClick];
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:--DELEGATE.imageCount inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}
- (IBAction)rateBtn:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://fluxtechsolutions.com"]];
}

@end
