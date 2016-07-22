//
//  EditScreenViewController.m
//  ChangeMask
//
//  Created by Fluxtech_MacMini1 on 6/6/16.
//  Copyright © 2016 Fluxtech_MacMini1. All rights reserved.
//

#import "EditScreenViewController.h"
#import "SPUserResizableView.h"
#import "ChangeMaskViewController.h"
#import "SettingViewController.h"
#import "UIImageView+WebCache.h"
#import <AudioToolbox/AudioToolbox.h>
@interface EditScreenViewController ()<UIGestureRecognizerDelegate,SPUserResizableViewDelegate,imageName,GADBannerViewDelegate>
{

    SPUserResizableView *currentlyEditingView;
    SPUserResizableView *lastEditedView;
    SPUserResizableView *userResizableView;
    UIImage *shareImg;
    NSString *getImageName;
}
@end

@implementation EditScreenViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _selectedImage.image = _selectImage;
    [_maskImage setImage:[UIImage imageNamed:@"set.png"]];
    [_maskImage setUserInteractionEnabled:YES];
    UIPinchGestureRecognizer *pgr = [[UIPinchGestureRecognizer alloc]
                                     initWithTarget:self action:@selector(handlePinch:)];
    pgr.delegate = self;
    [_maskImage addGestureRecognizer:pgr];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    [panGestureRecognizer setDelegate:self];
    [_maskImage addGestureRecognizer:panGestureRecognizer];

    
    CGRect gripFrame = CGRectMake(_maskImage.frame.origin.x , _maskImage.frame.origin.y, 200, 150);
   userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
    userResizableView.contentView = _maskImage;
    userResizableView.delegate = self;
    [userResizableView showEditingHandles];
    currentlyEditingView = userResizableView;
    lastEditedView = userResizableView;
    [self.screenShotView addSubview:userResizableView];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideEditingHandles)];
    [gestureRecognizer setDelegate:self];
    [self.screenShotView addGestureRecognizer:gestureRecognizer];
    


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


- (void)userResizableViewDidBeginEditing:(SPUserResizableView *)userResizableView1 {
    [currentlyEditingView hideEditingHandles];
    currentlyEditingView = userResizableView1;
}

- (void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView1 {
    lastEditedView = userResizableView1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([currentlyEditingView hitTest:[touch locationInView:currentlyEditingView] withEvent:nil]) {
        return NO;
    }
    return YES;
}

- (void)hideEditingHandles {
    // We only want the gesture recognizer to end the editing session on the last
    // edited view. We wouldn't want to dismiss an editing session in progress.
    [lastEditedView hideEditingHandles];
   // [_maskImage setImage:[UIImage imageNamed:@"mask1.png"]];
}



- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    if (pinchGestureRecognizer.scale >1.0f && pinchGestureRecognizer.scale < 2.5f) {
        CGAffineTransform transform = CGAffineTransformMakeScale(pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        _maskImage.transform = transform;
    }
}

- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        [recognizer.view setTransform:CGAffineTransformTranslate(recognizer.view.transform, translation.x, translation.y)];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
    }
}

#pragma Custom Delegate Protocol Method..

-(void) imageName:(NSString *)imgName{

    getImageName = imgName;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
//    _maskImage.backgroundColor = [UIColor clearColor];
//    _maskImage.opaque = NO;

    
    //[DELEGATE removeAds];
    
    if ([DELEGATE isAdsRemove]) {
        
        [_bannerView removeFromSuperview];
        [_removeAdsView setHidden:NO];
        [_bottomView setHidden:YES];
    }else{
    
        [_removeAdsView setHidden:YES];
        [_bottomView setHidden:NO];
        [self createAndLoadBannerAds];

    }
   // [lastEditedView hideEditingHandles];
    if ([DELEGATE isCancel]) {
        
        [lastEditedView hideEditingHandles];
        
       // [_maskImage setImage:[UIImage imageNamed:getImageName]];
        
        
        __block UIActivityIndicatorView *activityIndicator;
        activityIndicator = (UIActivityIndicatorView *)[self.view viewWithTag:901];
        activityIndicator.hidesWhenStopped = YES;
        
        [self.maskImage sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:getImageName]  placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger recievedSize, NSInteger expectedSize){
            
            if (!activityIndicator) {
                [activityIndicator startAnimating];
            }
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
            
            [activityIndicator removeFromSuperview];
            activityIndicator =nil;
        }];
        
        
        [DELEGATE setIsCancel:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeMask:(id)sender {
    
  
    [self playSound:@"bloop" :@"wav"];
    
   // [_maskImage setImage:[UIImage imageNamed:@""]];

    [self performSegueWithIdentifier:@"ChangeMask" sender:self];
}

- (IBAction)reset:(id)sender {
    

    [self playSound:@"bloop" :@"wav"];

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveImage:(id)sender {
    
    [self playSound:@"bloop" :@"wav"];

    
    UIImageWriteToSavedPhotosAlbum([self screenshot], nil, nil, nil);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                    message:@"Photo save to gallery!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
//    [self.topView setHidden:YES];
//    [self.bottomView setHidden:YES];
    //[self.screenShotView addSubview:userResizableView];
}

- (UIImage *)screenshot{
    
    UIGraphicsBeginImageContext(self.screenShotView.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    self.screenShotView.backgroundColor = [UIColor whiteColor];
    [self.screenShotView.layer renderInContext:context];
    shareImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return shareImg;
   //    [self.topView setHidden:NO];
//    [self.bottomView setHidden:NO];

    // [UIImagePNGRepresentation(capturedImage) writeToFile:imagePath atomically:YES];
}
- (IBAction)share:(id)sender {
    

    [self playSound:@"bloop" :@"wav"];
    
   // [self screenshot];
    NSString *strshare =[[NSString alloc] initWithFormat:@"Hey! Check out this cool app!"] ;
    
    NSString *urlString = [NSString stringWithFormat:@"http://fluxtechsolutions.com"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSArray *activityItems = @[strshare,url,[self screenshot]];
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc]
     initWithActivityItems:activityItems applicationActivities:nil];
    if (IS_IPHONE) {
    [self presentViewController:activityController
                           animated:YES completion:nil];
    }else{
        
        if ( [activityController respondsToSelector:@selector(popoverPresentationController)] ) {
            
            UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityController];
            [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2 - 80, self.view.frame.size.height - 200, 300, 250) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
         /*   [DELEGATE increaseCoins:1];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"coinsAdded" object:nil];*/


     }
   }
    
 
    [activityController setCompletionHandler:^(NSString *act, BOOL done)
    {
        
        NSLog(@"act type %@",act);
        NSString *ServiceMsg = nil;
        if ( [act isEqualToString:UIActivityTypeMail] )
            ServiceMsg = @"Mail sent";
        
        if ( [act isEqualToString:UIActivityTypePostToTwitter] )
            ServiceMsg = @"Post on twitter!";
        
        if ( [act isEqualToString:UIActivityTypePostToFacebook] )
            ServiceMsg = @"Post on facebook!";
        
        if ( done )
        {
            UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:ServiceMsg message:@"Success" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [Alert show];
            [DELEGATE increaseCoins:1];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"coinsAdded" object:nil];
        }
        else
        {
            UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Cancel" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [Alert show];        }
    }];
}

- (IBAction)setting:(id)sender {
    

    [self playSound:@"bloop" :@"wav"];
    
    [self performSegueWithIdentifier:@"Setting" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"ChangeMask"]) {
        
        ChangeMaskViewController *chng = [segue destinationViewController];
        [chng setDeleget:self];
        [chng setUserDeatilArray:[[NSMutableArray alloc] initWithArray:_userDetailArray]];
    }else if ([segue.identifier isEqualToString:@"Setting"]){
    
        SettingViewController *setting = [segue destinationViewController];
        NSLog(@"%@",setting);
        
    }

}

- (IBAction)sliderValueChange:(UISlider *)sender {
    
    NSLog(@"slider value = %f", sender.value);
    [_maskImage setAlpha:sender.value];
}

- (IBAction)done:(id)sender {
    

    [self playSound:@"bloop" :@"wav"];

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert!!" message:@"save image to gallery" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"exit" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
    
        [self dismissViewControllerAnimated:YES completion:nil];

    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"stay here" style:UIAlertActionStyleDefault handler:nil];

    UIAlertAction *action = [UIAlertAction actionWithTitle:@"save & exit" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        
        UIImageWriteToSavedPhotosAlbum([self screenshot], nil, nil, nil);
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
//                                                        message:@"Photo save to gallery!"
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];

    }];
    [alert addAction:action1];
    [alert addAction:action];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

@end
