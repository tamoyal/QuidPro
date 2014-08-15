//
//  FSPhoto.m
//  CityBribe
//
//  Created by Anthony Amoyal on 8/10/14.
//  Copyright (c) 2014 BattleHack. All rights reserved.
//

#import "FSPhoto.h"
#import "UIImage+Resize.h"
#import "UIImage+StackBlur.h"

@implementation FSPhoto

@synthesize suffix;
@synthesize prefix;
@synthesize image;

#pragma mark -
#pragma mark Init

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
	if (self) {
        self.suffix    = [dictionary objectForKey:@"suffix"];
        self.prefix = [dictionary objectForKey:@"prefix"];
    }
    return self;
}

- (NSURL *)url
{
    return [NSURL URLWithString: [NSString stringWithFormat:@"%@original%@", self.prefix, self.suffix]];
}

- (void)download{
    NSData * imageData = [NSData dataWithContentsOfURL:[self url]];
    self.image = [UIImage imageWithData:imageData];
}

- (void)resize:(CGSize)size{
    UIImage *resizedImage = [self.image resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                             bounds:size
                                               interpolationQuality:kCGInterpolationHigh];
    
    // Crop out any part of the image that's larger than the thumbnail size
    // The cropped rect must be centered on the resized image
    // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
    CGRect cropRect = CGRectMake(round((resizedImage.size.width - size.width) / 2),
                                 round((resizedImage.size.height - size.height) / 2),
                                 size.width,
                                 size.height);
    self.image = [resizedImage croppedImage:cropRect];
}

- (void)blur
{
    self.image = [self.image stackBlur:20];
}

- (void)downloadAndResize:(CGSize)size
{
    [self download];
    [self resize:size];
}

@end
