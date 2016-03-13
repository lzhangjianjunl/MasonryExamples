//
//  MASExampleAnimatedView.m
//  Masonry iOS Examples
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "MASExampleAnimatedView.h"

@interface MASExampleAnimatedView ()

@property (nonatomic, strong) NSMutableArray *animatableConstraints;        //定义的会参与动画的约束
@property (nonatomic, assign) int padding;
@property (nonatomic, assign) BOOL animating;

@end

@implementation MASExampleAnimatedView

- (id)init {
    self = [super init];
    if (!self) return nil;

    UIView *greenView = UIView.new;
    greenView.backgroundColor = UIColor.greenColor;
    greenView.layer.borderColor = UIColor.blackColor.CGColor;
    greenView.layer.borderWidth = 2;
    [self addSubview:greenView];

    UIView *redView = UIView.new;
    redView.backgroundColor = UIColor.redColor;
    redView.layer.borderColor = UIColor.blackColor.CGColor;
    redView.layer.borderWidth = 2;
    [self addSubview:redView];

    UIView *blueView = UIView.new;
    blueView.backgroundColor = UIColor.blueColor;
    blueView.layer.borderColor = UIColor.blackColor.CGColor;
    blueView.layer.borderWidth = 2;
    [self addSubview:blueView];

    UIView *superview = self;
    int padding = self.padding = 10;
    //设置内间距
    UIEdgeInsets paddingInsets = UIEdgeInsetsMake(self.padding, self.padding, self.padding, self.padding);
    //初始化会动画的约束数组
    self.animatableConstraints = NSMutableArray.new;

    [greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        [self.animatableConstraints addObjectsFromArray:@[
            make.edges.equalTo(superview).insets(paddingInsets).priorityLow(),      //设置和父亲view的内间距
            make.bottom.equalTo(blueView.mas_top).offset(-padding),                 //greedView.bottom = blueView.top - padding
        ]];

        make.size.equalTo(redView);                                                 //greenView.height,width = redView.height,width
        make.height.equalTo(blueView.mas_height);                                   //greenView.height = blueView.height
    }];

    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        [self.animatableConstraints addObjectsFromArray:@[
            make.edges.equalTo(superview).insets(paddingInsets).priorityLow(),      //间距
            make.left.equalTo(greenView.mas_right).offset(padding),                 //redView.left = greenView.right + padding
            make.bottom.equalTo(blueView.mas_top).offset(-padding),                 //redView.bottom = blueView.top - padding
        ]];

        make.size.equalTo(greenView);
        make.height.equalTo(blueView.mas_height);                                   //类似greenView
    }];

    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        [self.animatableConstraints addObjectsFromArray:@[
            make.edges.equalTo(superview).insets(paddingInsets).priorityLow(),
        ]];

        make.height.equalTo(greenView.mas_height);                                  //blueView.height = greenView.height = redView.height
        make.height.equalTo(redView.mas_height);
    }];

    return self;
}

/**
 *  然后调用此方法，然后不断进行动画
 */
- (void)didMoveToWindow {
    [self layoutIfNeeded];

    if (self.window) {
        self.animating = YES;
        [self animateWithInvertedInsets:NO];
    }
}

/**
 *  优先调用该方法
 *
 *  @param newWindow <#newWindow description#>
 */
- (void)willMoveToWindow:(UIWindow *)newWindow {
    self.animating = newWindow != nil;
}


/**
 *  根据设置不同的padding值，更改持有的MASConstraint变量，然后触发重绘
 *
 *  @param invertedInsets
 */
- (void)animateWithInvertedInsets:(BOOL)invertedInsets {
    if (!self.animating) return;

    int padding = invertedInsets ? 100 : self.padding;
    UIEdgeInsets paddingInsets = UIEdgeInsetsMake(padding, padding, padding, padding);
    for (MASConstraint *constraint in self.animatableConstraints) {
        constraint.insets = paddingInsets;
    }

    [UIView animateWithDuration:1 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        //repeat!
        [self animateWithInvertedInsets:!invertedInsets];
    }];
}


@end

