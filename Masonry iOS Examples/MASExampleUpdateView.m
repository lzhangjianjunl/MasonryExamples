//
//  MASExampleUpdateView.m
//  Masonry iOS Examples
//
//  Created by Jonas Budelmann on 3/11/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "MASExampleUpdateView.h"

@interface MASExampleUpdateView ()

@property (nonatomic, strong) UIButton *growingButton;
@property (nonatomic, assign) CGSize buttonSize;

@end

@implementation MASExampleUpdateView

- (id)init {
    self = [super init];
    if (!self) return nil;

    self.growingButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.growingButton setTitle:@"Grow Me!" forState:UIControlStateNormal];
    self.growingButton.layer.borderColor = UIColor.greenColor.CGColor;
    self.growingButton.layer.borderWidth = 3;

    [self.growingButton addTarget:self action:@selector(didTapGrowButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.growingButton];

    self.buttonSize = CGSizeMake(100, 100);

    return self;
}

/**
 *  调用这里保证系统会调用updateConstraints方法
 *
 *  @return
 */
+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

// this is Apple's recommended place for adding/updating constraints

/**
 *  这个方法是由系统调用，寻找你的约束的方法
 */
- (void)updateConstraints {

    [self.growingButton updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        
        //如果不写优先级，说明约束是必须满足的
//        make.width.equalTo(@(self.buttonSize.width));
//        make.height.equalTo(@(self.buttonSize.height));

        //说明这个约束是低优先级的，如果有冲突的话，这个约束不会被优先满足
        make.width.equalTo(@(self.buttonSize.width)).priorityLow();
        make.height.equalTo(@(self.buttonSize.height)).priorityLow();
        
        //高度和宽度，永远都比父亲view小,这个东西原来是设置范围的
        make.width.lessThanOrEqualTo(self);
        make.height.lessThanOrEqualTo(self);
    }];
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}


/**
 *  按钮的点击事件
 *
 *  @param button
 */
- (void)didTapGrowButton:(UIButton *)button {
    
    //因为没有更改约束内容，只是改变约束数值，所以可以这样使用
    self.buttonSize = CGSizeMake(self.buttonSize.width * 1.3, self.buttonSize.height * 1.3);

    // tell constraints they need updating
    //告诉系统需要更新约束了，我已经为更新布局准备好了信息，我将要调用updateConstraintsIfNeeded了
    [self setNeedsUpdateConstraints];

    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];

    [UIView animateWithDuration:0.4 animations:^{
        //我要重新布局子view了
        [self layoutIfNeeded];
    }];
}

@end
//