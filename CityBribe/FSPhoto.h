//
//  FSPhoto.h
//  CityBribe
//
//  Created by Anthony Amoyal on 8/10/14.
//  Copyright (c) 2014 BattleHack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSPhoto : NSObject

@property (nonatomic,strong)NSString *suffix;
@property (nonatomic,strong)NSString *prefix;
@property (nonatomic,strong)UIImage *image;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSURL *)url;
- (void)downloadAndResize:(CGSize)size;
- (void)resize:(CGSize)size;
- (void)download;
- (void)blur;
@end