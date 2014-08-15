//
//  Offer.m
//  CityBribe
//
//  Created by Anthony Amoyal on 8/9/14.
//  Copyright (c) 2014 BattleHack. All rights reserved.
//

#import "Offer.h"

@implementation Offer

@synthesize offerId;
@synthesize merchantId;
@synthesize fundingIncrement;
@synthesize fundingTarget;
@synthesize dealCta;
@synthesize dealEmoji;
@synthesize dealName;
@synthesize perkCta;
@synthesize perkEmoji;
@synthesize perkName;
@synthesize userFunded;

#pragma mark -
#pragma mark Init

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
	if (self) {
        //self.offerId    = [dictionary objectForKey:@"offer_id"];
        self.merchantId = [dictionary objectForKey:@"foursquaere_id"];
        self.fundingIncrement       = [dictionary objectForKey:@"funding_increment"];
        self.fundingTarget       = [dictionary objectForKey:@"funding_target"];
        self.dealCta   = [dictionary objectForKey:@"deal_cta"];
        self.dealEmoji  = [dictionary objectForKey:@"deal_emoji"];
        self.dealName   = [dictionary objectForKey:@"deal_name"];
        self.perkCta = [dictionary objectForKey:@"perk_cta"];
        self.perkEmoji = [dictionary objectForKey:@"perk_emoji"];
        self.perkName = [dictionary objectForKey:@"perk_name"];
        self.userFunded = NO;
    }
    return self;
}

@end
