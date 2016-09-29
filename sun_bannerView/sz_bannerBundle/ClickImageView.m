//
//  ClickImageView.m
//  jiShiJiaJiao-Teacher
//
//  Created by sundaoran on 14/10/24.
//  Copyright (c) 2014年 sundaoran. All rights reserved.
//

#import "ClickImageView.h"
#import <UIImageView+WebCache.h>

@implementation ClickImageView
{
    ImageViewTapGesture  _imageClick;
    successImage        _downSuccessImage;
}


-(void)getImageBlock:(successImage)blockImage
{
    _downSuccessImage=blockImage;
}

-(id)initWithImage:(NSString *)url andFrame:(CGRect)frame andplaceholderImage:(UIImage *)image andCkick:(ImageViewTapGesture)clickImageView
{
    self=[super initWithImage:image];
    if(self)
    {
        self.frame =frame;
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        
        _placeholderImage=image;
        [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:_placeholderImage options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
           if(error)
           {
               self.image=_placeholderImage;
               _downloadSuccess=NO;
           }
           else
           {
              _downloadSuccess=YES;
           }
            
            if(_downSuccessImage)
            {
                _downSuccessImage(image);
            }
        }];
        _imageClick=clickImageView;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        
        
    }
    return self;
}


-(void)setImageUrl:(NSString *)url andimageClick:(ImageViewTapGesture)clickImage
{
    _imageClick=clickImage;
    if(!([url isEqualToString:@"none"]||[url isEqualToString:@"null"]||[url isEqualToString:@""]|| [url hasPrefix:@"none"] || !url))
    {
        [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:_placeholderImage options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(!error)
            {
                self.image=image;
                _downloadSuccess=YES;
            }
            else
            {
                
                self.image=_placeholderImage;
                _downloadSuccess=NO;
            }
            if(_downSuccessImage)
            {
                _downSuccessImage(image);
            }
        }];
    }
    else
    {
        self.image=_placeholderImage;
        _imageClick=clickImage;
        _downloadSuccess=NO;
    }

}


//单击
-(void)handleSingleTap:(UITapGestureRecognizer *)tapGest
{
    NSLog(@"one");
    _imageClick((UIImageView *)[tapGest view]);
}


@end
