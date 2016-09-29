//
//  likes_bannerCollectionViewCell.m
//  Likes
//
//  Created by sundaoran on 15/6/25.
//  Copyright (c) 2015年 zzz. All rights reserved.
//

#import "likes_bannerCollectionViewCell.h"
#import "ClickImageView.h"

@implementation likes_bannerCollectionViewCell
{
    ClickImageView *_bannerImage;
}

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        UIImage *placeImage=[UIImage imageNamed:@"default"];
        _bannerImage=[[ClickImageView alloc]initWithImage:nil andFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) andplaceholderImage:placeImage andCkick:^(UIImageView *imageView) {
            
        }];
        _bannerImage.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _bannerImage.userInteractionEnabled=NO;
        [self.contentView addSubview:_bannerImage];
    }
    return self;
}

-(void)setImageUrl:(NSString *)imageUrl
{
    [_bannerImage setImageUrl:imageUrl andimageClick:^(UIImageView *imageView) {
        
    }];
}

- (void)awakeFromNib {
    // Initialization code
}

@end
