//
//  likes_bannerView.m
//  Likes
//
//  Created by sundaoran on 15/6/25.
//  Copyright (c) 2015年 zzz. All rights reserved.
//

#import "likes_bannerView.h"
#import "likes_bannerCollectionViewCell.h"
#import "likes_bannerObject.h"

@implementation likes_bannerView
{
    UICollectionView    *_collectionView;
    int                 _currentPage;
    int                 _lastPage;
    UIPageControl      *_pageController;
    selectPageImage     _selectBlock;
    NSMutableArray      *_dataArray;
}


-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing=0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滑动方向
        
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:flowLayout];
        _collectionView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.backgroundColor=[UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator=NO;
        _collectionView.pagingEnabled=YES;
        [_collectionView registerClass:[likes_bannerCollectionViewCell class] forCellWithReuseIdentifier:@"bannerCell"];
        [self addSubview:_collectionView];

        _pageController=[[UIPageControl alloc]initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 20)];
        _pageController.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _pageController.currentPageIndicatorTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"banner_select"]];
        _pageController.pageIndicatorTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"banner_nomal"]];

        [self addSubview:_pageController];
      
    }
    return self;
}


-(void)setPageControllHidden:(BOOL)pageControllHidden
{
    _pageController.hidden=pageControllHidden;
}

-(void)setScrollEnabled:(BOOL)scrollEnabled
{
    _collectionView.scrollEnabled=scrollEnabled;
}

-(void)drawRect:(CGRect)rect
{
    [_collectionView reloadData];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

-(void)pageChange:(UIPageControl *)pageController
{
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:pageController.currentPage+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

-(void)setImageArray:(NSMutableArray *)imageArray
{
    _dataArray=[[NSMutableArray alloc]init];
    for (NSDictionary *dict in imageArray)
    {
        likes_bannerObject *banner=[[likes_bannerObject alloc]initWithDict:dict];
        [_dataArray addObject:banner];
    }
    imageArray=[[NSMutableArray alloc]initWithArray:_dataArray];
    _pageController.numberOfPages=[imageArray count];
    _pageController.currentPage=0;
    
//    banner 靠右
//    CGSize pointSize = [_pageController sizeForNumberOfPages:[imageArray count]];
//    CGFloat page_x = -(_pageController.bounds.size.width - pointSize.width) / 2 ;
//    [_pageController setBounds:CGRectMake(page_x+20, _pageController.bounds.origin.y, _pageController.bounds.size.width, _pageController.bounds.size.height)];
    
    
    if([imageArray count]>=2)
    {
        [_dataArray insertObject:[imageArray lastObject] atIndex:0];
        [_dataArray addObject:[imageArray firstObject]];
        if(_tempTimer)
        {
            [_tempTimer invalidate];
            _tempTimer=nil;
        }
        _tempTimer= [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(collectionScroll) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_tempTimer forMode:NSDefaultRunLoopMode];
        [_tempTimer fire];
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        [_pageController addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
    }
    
}

-(void)reloadBannerView
{
    if(_collectionView && [_dataArray count])
    {
        [_collectionView reloadData];
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"bannerCell";
    likes_bannerCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    [cell setImageUrl:((likes_bannerObject*)[_dataArray objectAtIndex:indexPath.row]).bannerPicture];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectBlock([_dataArray objectAtIndex:indexPath.row]);
    
    /*
    likes_bannerObject *banner=[_dataArray objectAtIndex:indexPath.row];
    NSLog(@"%@+++++%ld",banner.bannerType,indexPath.row)    ;
    if([banner.bannerType isEqualToString:@"5"])//为链接
    {
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误" message:@"未找到该内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
     */
}


-(void)collectionScroll
{
    _currentPage++;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    if(_currentPage==[_dataArray count]-1)
    {
        _currentPage=0;
        [_collectionView setContentOffset:CGPointMake(_currentPage*self.frame.size.width, 0)];
        _currentPage=1;
    }
    _pageController.currentPage=_currentPage-1;
}


-(void)currentPageChange
{
    if([_dataArray count]>1)
    {
        if(_currentPage==0)
        {
            _currentPage=(int)[_dataArray count]-1;
             [_collectionView setContentOffset:CGPointMake((_currentPage-1)*self.frame.size.width, 0)];
        }
        else if (_currentPage == [_dataArray count]-1)
        {
            _currentPage=1;
            [_collectionView setContentOffset:CGPointMake(_currentPage*self.frame.size.width, 0)];
        }
        _pageController.currentPage=_currentPage-=1;
    }
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView==_collectionView)
    {
//        _collectionView.userInteractionEnabled=NO;
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView==_collectionView)
    {
        //        _collectionView.userInteractionEnabled=YES;
        CGFloat offect=_collectionView.contentOffset.x;
        _currentPage=offect/self.frame.size.width;
        _lastPage=_currentPage;
        [self currentPageChange];
    }
}


-(void)changeSelectImage:(selectPageImage)selectBlock
{
    _selectBlock=selectBlock;
}

-(void)timerStart
{
    _tempTimer= [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(collectionScroll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_tempTimer forMode:NSDefaultRunLoopMode];
    [_tempTimer fire];
}

//是指图片会重新开启定时器，此时需要重新关闭一次
-(void)timerStop
{
    [_tempTimer invalidate];
    _tempTimer=nil;
}

-(void)timerPasue
{
    if(_tempTimer)
    {
        [_tempTimer setFireDate:[NSDate distantFuture]];
    }
}

-(void)timerRestart
{
    if(_tempTimer)
    {
        [_tempTimer setFireDate:[NSDate date]];

    }
}

@end
