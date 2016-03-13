//
//  MASExampleArrayView.m
//  Masonry iOS Examples
//
//  Created by Daniel Hammond on 11/26/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "MASExampleArrayView.h"

static CGFloat const kArrayExampleIncrement = 10.0;

@interface MASExampleArrayView ()

@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, strong) NSArray *buttonViews;

@end

@implementation MASExampleArrayView

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    UIButton *raiseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [raiseButton setTitle:@"Raise" forState:UIControlStateNormal];
    [raiseButton addTarget:self action:@selector(raiseAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:raiseButton];
    
    UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [centerButton setTitle:@"Center" forState:UIControlStateNormal];
    [centerButton addTarget:self action:@selector(centerAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:centerButton];

    UIButton *lowerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [lowerButton setTitle:@"Lower" forState:UIControlStateNormal];
    [lowerButton addTarget:self action:@selector(lowerAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lowerButton];
    
    [lowerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10.0);
    }];

    [centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
    }];

    [raiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-10);
    }];
    
    //把所有的view添加到数组中
    self.buttonViews = @[ raiseButton, lowerButton, centerButton ];
    
    return self;
}

- (void)centerAction {
    self.offset = 0.0;
}

- (void)raiseAction {
    self.offset -= kArrayExampleIncrement;
}

- (void)lowerAction {
    self.offset += kArrayExampleIncrement;
}

- (void)setOffset:(CGFloat)offset {
    _offset = offset;
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    
    //更新一组view的约束
    [self.buttonViews updateConstraints:^(MASConstraintMaker *make) {
        //baseline的用法，在y的中心点偏移一定的数值
        make.baseline.equalTo(self.mas_centerY).with.offset(self.offset);
        //用下面的就会崩溃，说是之前没有定义，因为这里是更新操作
//        make.bottom.equalTo(self.mas_centerY).width.offset(self.offset);
    }];
    
    //according to apple super should be called at end of method
    //注意这里最后要调用super
    [super updateConstraints];
}

@end
