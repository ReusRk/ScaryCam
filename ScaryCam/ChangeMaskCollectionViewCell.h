//
//  ChangeMaskCollectionViewCell.h
//  ChangeMask
//
//  Created by Fluxtech_MacMini1 on 6/7/16.
//  Copyright © 2016 Fluxtech_MacMini1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeMaskCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *maskImage;
@property (weak, nonatomic) IBOutlet UIImageView *lockUnlockImage;
@property (weak, nonatomic) IBOutlet UILabel *priceCoinsLbl;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
