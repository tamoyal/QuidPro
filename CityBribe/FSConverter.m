#import "FSConverter.h"
#import "FSVenue.h"
#import "FSPhoto.h"

@implementation FSConverter

- (NSArray *)convertToObjects:(NSArray *)venues {
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:venues.count];
    for (NSDictionary *v  in venues) {
        FSVenue *ann = [self convertToObject:v];
        [objects addObject:ann];
    }
    return objects;
}

- (FSVenue *)convertToObject:(NSDictionary *)v {
    FSVenue *ann = [[FSVenue alloc]init];
    
    ann.name = v[@"name"];
    ann.venueId = v[@"id"];

    ann.location.address = v[@"location"][@"address"];
    ann.location.distance = v[@"location"][@"distance"];
    
    ann.vanityAddress = [NSString stringWithFormat:@"%@, %@, %@", v[@"location"][@"address"], v[@"location"][@"city"], v[@"location"][@"state"]];
    
    [ann.location setCoordinate:CLLocationCoordinate2DMake([v[@"location"][@"lat"] doubleValue],
                                                           [v[@"location"][@"lng"] doubleValue])];
    
    if (v[@"photos"] && ((NSArray *)v[@"photos"]).count) {
        NSArray *groups = v[@"photos"][@"groups"];
        if (groups && groups.count) {
            NSDictionary *firstGroup = [groups objectAtIndex:0];
            if (firstGroup) {
                NSArray *items = firstGroup[@"items"];
                if(items && items.count){
                    for (NSDictionary *item in items) {
                        [ann.photos addObject:[[FSPhoto alloc] initWithDictionary:item]];
                    }
                }
            }
        }
    }

    return ann;
}

@end
