//
//  OfferView.m
//  CityBribe
//
//  Created by Anthony Amoyal on 8/9/14.
//  Copyright (c) 2014 BattleHack. All rights reserved.
//

#import "OfferView.h"

@implementation OfferView

@synthesize dealCta;
@synthesize dealEmoji;
@synthesize dealName;
@synthesize perkCta;
@synthesize perkEmoji;
@synthesize perkName;
@synthesize letsDoIt;
@synthesize offer;
@synthesize backgroundPhoto;

- (id)initWithFrame:(CGRect)frame andOffer:(PFObject *)o andbackgroundPhoto:(FSPhoto *)bp
{
    self = [super initWithFrame:frame];
    if (self) {
        offer = o;
        self.backgroundPhoto = bp;
        [self setUpSubViews];
    }
    return self;
}

- (void) setUpSubViews
{
    float leftPad = 22;
    float yOffset = 20.0f;

    [self.backgroundPhoto download];
    [self.backgroundPhoto blur];
    [self.backgroundPhoto resize:CGSizeMake(320, 163)];
    
    //[backgroundPhoto downloadAndResize:CGSizeMake(320, 163)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.backgroundPhoto.image];
    [self addSubview:imageView];
    [self sendSubviewToBack:imageView];
    UIView *blackView = [[UIView alloc] initWithFrame:imageView.frame];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.3f;
    [imageView addSubview:blackView];
    
    dealCta = [[UILabel alloc] initWithFrame:CGRectMake(leftPad, yOffset, 320, 23.0f)];
    dealCta.backgroundColor = [UIColor clearColor];
    dealCta.textColor = [UIColor whiteColor];
    dealCta.text = self.offer[@"deal_cta"];
    dealCta.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
    
    yOffset += 25.0f;
    
    dealEmoji = [[UILabel alloc] initWithFrame:CGRectMake(leftPad, yOffset, 100, 28.0f)];
    dealEmoji.text = self.offer[@"deal_emoji"];
    
    dealName = [[UILabel alloc] initWithFrame:CGRectMake(dealEmoji.frame.origin.x + 30, yOffset, 240, 28.0f)];
    dealName.text = self.offer[@"deal_name"];
    dealName.font = [UIFont fontWithName:@"AvenirNext-Medium" size:24];
    dealName.textColor = [UIColor whiteColor];
    
    yOffset += 40.0f;
    
    perkCta = [[UILabel alloc] initWithFrame:CGRectMake(leftPad, yOffset, 320, 28.0f)];
    perkCta.backgroundColor = [UIColor clearColor];
    perkCta.textColor = [UIColor whiteColor];
    perkCta.text = self.offer[@"perk_cta"];
    perkCta.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
    
    yOffset += 25.0f;
    
    perkName = [[UILabel alloc] initWithFrame:CGRectMake(leftPad, yOffset, 240, 28.0f)];
    perkName.text = self.offer[@"perk_name"];
    perkName.font = [UIFont fontWithName:@"AvenirNext-Medium" size:24];
    perkName.textColor = [UIColor whiteColor];
    
    perkEmoji = [[UILabel alloc] initWithFrame:CGRectMake(leftPad + 180 + 40, yOffset, 100, 28.0f)];
    perkEmoji.text = self.offer[@"perk_emoji"];

    
    float ratio = [offer[@"current_funding"] floatValue] / [offer[@"funding_target"] floatValue];
    float flatColorWidth = 320 * (1-ratio);
    
    int percentFunded = ratio * 100;
    UILabel *percentFundedLabel = [[UILabel alloc] initWithFrame:CGRectMake(320-flatColorWidth, 150, 50.0f, 20.0f)];
    percentFundedLabel.text = [NSString stringWithFormat:@"%d%% funded", percentFunded];
    percentFundedLabel.textColor = [UIColor colorWithRed:0.45f green:0.80f blue:0.65f alpha:1];
    percentFundedLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:9];
    
    UIImage *triangleImage = [UIImage imageNamed:@"Green Arrow-01.png"];
    UIImageView *triangle = [[UIImageView alloc] initWithImage:triangleImage];
    
    int triangleXPos = 320-flatColorWidth+1;
    triangleXPos -= triangleImage.size.width/2;
    triangle.frame = CGRectMake(triangleXPos, 155, triangleImage.size.width, triangleImage.size.height);
    
    int percentFundedLabelXPos = triangleXPos;
    
    if (percentFundedLabelXPos < 28) {
        percentFundedLabelXPos = 28;
    }else if(percentFundedLabelXPos > 292){
        percentFundedLabelXPos = 292;
    }
    
    percentFundedLabel.center = CGPointMake(percentFundedLabelXPos, 150);
    
    UIView *flatView = [[UIView alloc] initWithFrame:CGRectMake(320-flatColorWidth, 163, flatColorWidth, 3)];
    flatView.backgroundColor = [UIColor colorWithRed:0.45f green:0.80f blue:0.65f alpha:1];
    
    UIImage *patternImage = [UIImage imageNamed:@"Tiled Green Pinstripe-01.png"];
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 163, 320, 3)];
    progressView.backgroundColor = [UIColor colorWithPatternImage:patternImage];

    letsDoIt = [[UIButton alloc] initWithFrame:CGRectMake(0, 166, 320, 60)];
    letsDoIt.userInteractionEnabled = YES;
    [letsDoIt addTarget:self action:@selector(moVenmo) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *letsDoItAmount = [NSString stringWithFormat:@"$%@", offer[@"funding_increment"]];
    
    [letsDoIt setBackgroundImage:[UIImage imageNamed:@"Let's Do It-01.png"] forState:UIControlStateNormal];
    letsDoIt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [letsDoIt setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [letsDoIt setTitle:letsDoItAmount forState:UIControlStateNormal];
    letsDoIt.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:28];
    
    [self addSubview:dealCta];
    [self addSubview:dealEmoji];
    [self addSubview:dealName];
    [self addSubview:perkCta];
    [self addSubview:perkName];
    [self addSubview:perkEmoji];
    [self addSubview:progressView];
    [self addSubview:flatView];
    [self addSubview:letsDoIt];
    [self addSubview:percentFundedLabel];
    [self addSubview:triangle];
    [self bringSubviewToFront:flatView];
}

- (void)moVenmo
{
    NSLog(@"moVenmo");
   [self.paydayDelegate offerBought:self.offer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
