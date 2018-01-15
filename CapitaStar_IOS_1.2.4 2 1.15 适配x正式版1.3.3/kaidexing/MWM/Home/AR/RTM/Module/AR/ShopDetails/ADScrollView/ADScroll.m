//
//  ADScroll.m
//  ADScroll
//
//  Created by ZhaoChenHong on 15/8/27.
//  Copyright (c) 2015年 ZhaoChenHong. All rights reserved.
//

#import "ADScroll.h"
#import "iCarousel.h"

#define Width  self.frame.size.width
#define Height self.frame.size.height



@interface ADScroll ()<iCarouselDataSource,iCarouselDelegate>
{
    NSInteger _count;
}
@property (nonatomic, strong) NSTimer * scrollTimer;
@property (nonatomic, strong) iCarousel * scrollView;
@property (nonatomic, strong) UIPageControl * pageControl;
@end

@implementation ADScroll

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        _autoScroll = YES;
        _loop = YES;
        _showPageControl = YES;
        _scrollTimeInterval = 2;
        _count = 0;
    }
    return self;
}

-(void)reloadData
{
    self.backgroundColor = [UIColor clearColor];
    _autoScroll = YES;
    _loop = YES;
    _showPageControl = YES;
    _scrollTimeInterval = 5;
    
    [self.scrollView reloadData];
    
    if (_count > 0)
    {
        self.pageControl.numberOfPages = _count;
        [self startTimer];
    }
}
#pragma mark - Setter And Getter
-(void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    
    if (!_showPageControl)
    {
        if (_pageControl)
        {
            [_pageControl removeFromSuperview];
            _pageControl = nil;
        }
    }
}
-(UIPageControl *)pageControl
{
    if (_showPageControl && !_pageControl)
    {
        CGRect frame = self.bounds;
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.backgroundColor = [UIColor clearColor];
        [_pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        if (frame.size.height < 10)
        {
            _pageControl.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        }
        else
        {
            _pageControl.frame = CGRectMake(0, frame.size.height - 15, frame.size.width, 10);
        }
        
        [self addSubview:_pageControl];
        [self bringSubviewToFront:_pageControl];
    }
    return _pageControl;
}
-(void)setDateSource:(id<ADScrollDataSource>)dateSource
{
    _dateSource = dateSource;
    
    if (_dateSource)
    {
        [self reloadData];
    }
}
-(void)setScrollTimer:(NSTimer *)scrollTimer
{
    if (_scrollTimer)
    {
        [_scrollTimer invalidate];
        _scrollTimer = nil;
    }
    _scrollTimer = scrollTimer;
}
-(iCarousel *)scrollView
{
    if (!_scrollView)
    {
        CGRect frame = self.bounds;
        _scrollView = [[iCarousel alloc] initWithFrame:frame];
        _scrollView.clipsToBounds = YES;
        _scrollView.delegate = self;
        _scrollView.dataSource = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.stopAtItemBoundary = YES;
        _scrollView.type = iCarouselTypeLinear;
        [self addSubview:_scrollView];
        [self sendSubviewToBack:_scrollView];
    }
    return _scrollView;
}

#pragma mark - Pri Method
-(void)pageChange:(UIPageControl *) pageControl
{
    [_scrollView scrollToItemAtIndex:pageControl.currentPage animated:YES];
}
-(void)startTimer
{
    if (_autoScroll)
    {
        self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:_scrollTimeInterval target:self selector:@selector(scrollToNext) userInfo:nil repeats:YES];
    }
}
-(void)endTimer
{
    if (_scrollTimer)
    {
        [_scrollTimer invalidate];
        _scrollTimer = nil;
    }
}
-(void)setScrollTimeInterval:(CGFloat)scrollTimeInterval
{
    if (_scrollTimeInterval != scrollTimeInterval)
    {
        _scrollTimeInterval = scrollTimeInterval;

        if (_autoScroll)
        {
            [self startTimer];
        }
    }
}

-(void)setAutoScroll:(BOOL)autoScroll
{
    if (_autoScroll != autoScroll)
    {
        _autoScroll = autoScroll;
        
        if (autoScroll)
        {
            [self startTimer];
        }
        else
        {
            [self endTimer];
        }
    }
}

-(void)scrollToNext
{
    [_scrollView scrollToItemAtIndex:_scrollView.currentItemIndex + 1 animated:YES];
}
#pragma mark - iCarouselDataSource,iCarouselDelegate
- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
    [self endTimer];
}
- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}
- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return carousel.frame.size.width;
}

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    if (_dateSource && [_dateSource respondsToSelector:@selector(numberOfItemsInADScroll:)])
    {
        _count = [_dateSource numberOfItemsInADScroll:self];
    }
    return _count;
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    
    if (_dateSource && [_dateSource respondsToSelector:@selector(ADScroll:viewForItemAtIndex:reusingView:)])
    {
        return [_dateSource ADScroll:self viewForItemAtIndex:index reusingView:view];
    }
    return nil;
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return _loop;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value;
        }
        case iCarouselOptionFadeMax:
        {
            if (_scrollView.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if (_delegate && [_delegate respondsToSelector:@selector(adScroll:selectedIndex:)])
    {
        [_delegate adScroll:self selectedIndex:index];
    }
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    self.pageControl.currentPage = carousel.currentItemIndex;
    
    if (_delegate && [_delegate respondsToSelector:@selector(adScroll:changeTo:)])
    {
        if (carousel.currentItemIndex >= 0 && carousel.currentItemIndex < _count)
        {
            [_delegate adScroll:self changeTo:carousel.currentItemIndex];
        }
    }
}
@end
