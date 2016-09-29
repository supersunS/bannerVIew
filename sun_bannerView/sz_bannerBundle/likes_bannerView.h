//
//  likes_bannerView.h
//  Likes
//
//  Created by sundaoran on 15/6/25.
//  Copyright (c) 2015年 zzz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectPageImage)(id selectObject) ;

@interface likes_bannerView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@property(nonatomic,strong)NSMutableArray *imageArray;

@property(nonatomic,strong)NSTimer *tempTimer;

@property(nonatomic)BOOL pageControllHidden;

@property(nonatomic)BOOL scrollEnabled;

-(id)initWithFrame:(CGRect)frame;


-(void)changeSelectImage:(selectPageImage)selectBlock;

//暂停滚动
-(void)timerPasue;

//重新开始滚动
-(void)timerRestart;

//停止滚动
-(void)timerStop;


-(void)reloadBannerView;
@end
