//
//  ViewController.m
//  assiDemo
//
//  Created by Fluxtech_MacMini1 on 6/23/16.
//  Copyright © 2016 Fluxtech_MacMini1. All rights reserved.
//

#import "ViewController.h"
#import "EditScreenViewController.h"
//#import "FMDatabase.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
@interface ViewController ()<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    
    NSMutableDictionary *dict ;
    NSString *vendorId;
    NSNumber* unlock;
    NSMutableArray *innerUserArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"Vendor Id : %@",uniqueIdentifier);
    
    vendorId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    if (!dict) {
        
        dict = [[NSMutableDictionary alloc]initWithDictionary:[DELEGATE getdata]];
        
    }
    NSMutableArray *newObject = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"1234"]];
    NSLog(@"Dictionary of plist : %@ ",dict);
    
    if ([dict objectForKey:vendorId]) {
        
        NSLog(@"User Dict : %@ ",[dict objectForKey:vendorId]);
        
    }else{
        
        [dict setObject:newObject forKey:vendorId];
        
    }
    
    NSLog(@"Updated dictionary : %@ ",dict);
    [self replaceImagesWithNew];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)viewWillAppear:(BOOL)animated{
    
    
    
    
}

-(void)replaceImagesWithNew{
    
    
    NSMutableArray *seprateImages = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"SeprateImages"]];
    
    innerUserArray = [[NSMutableArray alloc]initWithArray:[dict objectForKey:vendorId]];
    
    
    for (int i = 1; i < [seprateImages count]; i++) {
        
        if (i < [innerUserArray count]) {
            
            unlock = [[innerUserArray objectAtIndex:i] objectForKey:@"unlock"];
            
            if ([unlock boolValue] == YES) {
                [[[dict objectForKey:@"SeprateImages"] objectAtIndex:i] setObject:[NSNumber numberWithBool:YES] forKey:@"unlock"];
            }else{
                
                [[[dict objectForKey:@"SeprateImages"] objectAtIndex:i] setObject:[NSNumber numberWithBool:NO] forKey:@"unlock"];
            }
            //  [contentArray addObject:[[[dataFromPlist objectAtIndex:0] objectForKey:@"seprateImage"] objectAtIndex:i]];
            NSLog(@"Inner Array : %@ ",innerUserArray);
            NSLog(@"Dict : %@ ",[seprateImages objectAtIndex:i]);
            [innerUserArray replaceObjectAtIndex:i withObject:[seprateImages objectAtIndex:i]];
            
            
        }else{
            
            for (int k = (int)[innerUserArray count]; k < [seprateImages count]; k++) {
                
                //  isUpdate = YES;
                [innerUserArray addObject:[seprateImages objectAtIndex:k]];
//                [[[dict objectForKey:@"seprateImage"] objectAtIndex:k] setObject:[NSNumber numberWithBool:NO] forKey:@"unlock"];
            }
        }
    }
    
    [self updatePlist];
    
}

-(void)updatePlist{
    
    [dict setObject:innerUserArray forKey:vendorId];
    
    NSLog(@"Getting Updated D Dict : %@", dict);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"ScaryCam.plist"];
    
    [dict writeToFile:plistPath atomically:YES];
    
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


- (IBAction)takePic:(id)sender {
    
    //    [self oggSetup];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [self.player play];
    //    });
    [self playSound:@"bloop" :@"wav"];
    
    UIImagePickerController *picker;
    if (!picker) {
        picker = [[UIImagePickerController alloc] init];
    }
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    [self presentViewController:picker animated:YES completion:nil];
    
    
}

- (IBAction)chooseImage:(id)sender {
    
    
    [self playSound:@"bloop" :@"wav"];
    
    
    UIImagePickerController *picker;
    if (!picker) {
        picker = [[UIImagePickerController alloc] init];
    }
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"editScreen" sender:chosenImage];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"editScreen"]) {
        
        EditScreenViewController *edv = [segue destinationViewController];
        [edv setUserDetailArray:[[NSMutableArray alloc] initWithArray:[dict objectForKey:vendorId]]];
        [edv setSelectImage:sender];
    }
    
}

@end
