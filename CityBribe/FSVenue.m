#import "FSVenue.h"
#import "FSPhoto.h"

@implementation FSLocation

@end

@implementation FSVenue
- (id)init {
    self = [super init];
    if (self) {
        self.location = [[FSLocation alloc]init];
        self.photos = [[NSMutableArray alloc] init];
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    return self.location.coordinate;
}

- (NSString *)title {
    return self.name;
}

- (FSPhoto *)profilePhoto
{
    return [self.photos objectAtIndex:0];
}

- (NSURL *)profilePhotoUrl
{
    return [self profilePhoto].url;
}

@end
