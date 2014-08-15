//
//  OfferView.h
//  CityBribe
//
//  Created by Anthony Amoyal on 8/9/14.
//  Copyright (c) 2014 BattleHack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Offer.h"
#import <Parse/Parse.h>
#import "FSPhoto.h"

@protocol PaydayDelegate <NSObject>
- (void) offerBought:(PFObject *)offer;
@end

@interface OfferView : UIView

@property (nonatomic, retain) UILabel *dealCta;
@property (nonatomic, retain) UILabel *dealEmoji;
@property (nonatomic, retain) UILabel *dealName;

@property (nonatomic, retain) UILabel *perkCta;
@property (nonatomic, retain) UILabel *perkEmoji;
@property (nonatomic, retain) UILabel *perkName;

@property (nonatomic, retain) UIButton *letsDoIt;

@property (nonatomic, copy) NSString *fundingIncrement;
@property (nonatomic, copy) NSString *fundingTarget;

@property (nonatomic, retain) PFObject *offer;
@property (nonatomic, retain) FSPhoto *backgroundPhoto;

@property (nonatomic, assign) id<PaydayDelegate> paydayDelegate;

- (id)initWithFrame:(CGRect)frame andOffer:(PFObject *)o andbackgroundPhoto:(FSPhoto *)bp;

@end