#import <Foundation/Foundation.h>
#import "FSVenue.h"

@interface FSConverter : NSObject
- (NSArray *)convertToObjects:(NSArray *)venues;
- (FSVenue *)convertToObject:(NSDictionary *)venue;
@end
