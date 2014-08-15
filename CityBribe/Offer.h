//
//  Offer.h
//  CityBribe
//
//  Created by Anthony Amoyal on 8/9/14.
//  Copyright (c) 2014 BattleHack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Offer : NSObject

@property (nonatomic, copy) NSString *offerId;
@property (nonatomic, copy) NSString *merchantId;
@property (nonatomic, copy) NSString *fundingIncrement;
@property (nonatomic, copy) NSString *fundingTarget;
@property (nonatomic, copy) NSString *dealCta;
@property (nonatomic, copy) NSString *dealEmoji;
@property (nonatomic, copy) NSString *dealName;
@property (nonatomic, copy) NSString *perkCta;
@property (nonatomic, copy) NSString *perkEmoji;
@property (nonatomic, copy) NSString *perkName;
@property (nonatomic, assign) BOOL *userFunded;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
