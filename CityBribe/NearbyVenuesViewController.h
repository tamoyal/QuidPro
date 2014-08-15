//
//  NearbyVenuesViewController.h
//  CityBribe
//
//  Created by Anthony Amoyal on 8/9/14.
//  Copyright (c) 2014 BattleHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSVenue;

@protocol FoursquareVenuesDelegate <NSObject>
- (void) venueChosen:(FSVenue *)venue;
@end

@interface NearbyVenuesViewController : UITableViewController

@property (nonatomic, assign) id<FoursquareVenuesDelegate> foursquareVenueDelegate;

@end
