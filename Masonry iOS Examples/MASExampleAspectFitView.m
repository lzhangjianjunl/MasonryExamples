//
//  MASExampleAspectFitView.m
//  Masonry iOS Examples
//
//  Created by Michael Koukoullis on 19/01/2015.
//  Copyright (c) 2015 Jonas Budelmann. All rights reserved.
//

#import "MASExampleAspectFitView.h"

@interface MASExampleAspectFitView ()
@property UIView *topView;
@property UIView *topInnerView;
@property UIView *bottomView;
@property UIView *bottomInnerView;
@end

@implementation MASExampleAspectFitView

// Designated initializer
- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        
        // Create views
        self.topView = [[UIView alloc] initWithFrame:CGRectZero];
        self.topInnerView = [[UIView alloc] initWithFrame:CGRectZero];
        self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        self.bottomInnerView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // Set background colors
        UIColor *blueColor = [UIColor colorWithRed:0.663 green:0.796 blue:0.996 alpha:1];
        [self.topView setBackgroundColor:blueColor];

        UIColor *lightGreenColor = [UIColor colorWithRed:0.784 green:0.992 blue:0.851 alpha:1];
        [self.topInnerView setBackgroundColor:lightGreenColor];

        UIColor *pinkColor = [UIColor colorWithRed:0.992 green:0.804 blue:0.941 alpha:1];
        [self.bottomView setBackgroundColor:pinkColor];
        
        UIColor *darkGreenColor = [UIColor colorWithRed:0.443 green:0.780 blue:0.337 alpha:1];
        [self.bottomInnerView setBackgroundColor:darkGreenColor];
        
        
        
        // Layout top and bottom views to each take up half of the window
        //左右上都和父亲view仅仅贴着
        [self addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.top.equalTo(self);
        }];
        

        [self addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            //左右下都和父亲view贴着
            make.left.right.and.bottom.equalTo(self);
            //bottomView的顶部和topView的底部是仅仅贴着的
            make.top.equalTo(self.topView.mas_bottom);
            //他俩的高度是相等的
            make.height.equalTo(self.topView);
        }];
        
        // Inner views are configured for aspect fit with ratio of 3:1
        [self.topView addSubview:self.topInnerView];
        [self.topInnerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            // 其内部的view的width ＝ view.height * 3
            make.width.equalTo(self.topInnerView.mas_height).multipliedBy(3);
            
            //其的高度要小于等于起父亲view的高度,这个需要考虑到横屏的情况，是有意义的
            make.width.and.height.lessThanOrEqualTo(self.topView);
            
            //因为上面没有设置优先级，所以是必须实现的，如果下面的约束不设置优先级
            //那么当宽度和父亲宽度一样的时候，那么高度就会违反第二个约束，所以这里设置其优先级为低，如果满足可以，不满足也没事
            //所以横屏才是这个样子
            //宽度和高度等于起父亲view的高度和宽度
//            make.width.equalTo(self.topView.width);
//            make.width.equalTo(self.topView.width).with.priorityLow();
            make.width.and.height.equalTo(self.topView).with.priorityLow();
            
            make.center.equalTo(self.topView);
        }];
        
        [self.bottomView addSubview:self.bottomInnerView];
        [self.bottomInnerView mas_makeConstraints:^(MASConstraintMaker *make) {
            //高度等于长度乘以三
            make.height.equalTo(self.bottomInnerView.mas_width).multipliedBy(3);
            //高度和宽度比父亲view小，这是设置范围
            make.width.and.height.lessThanOrEqualTo(self.bottomView);
            //尽量满足，不能违反上面的约束
            make.width.and.height.equalTo(self.bottomView).with.priorityLow();
                        
            make.center.equalTo(self.bottomView);
        }];
    }
    
    return self;
}

// Override previous designated initializer
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self init];
}

@end
