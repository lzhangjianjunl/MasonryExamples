//
//  MASExampleLabelView.m
//  Masonry iOS Examples
//
//  Created by Jonas Budelmann on 24/10/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "MASExampleLabelView.h"

static UIEdgeInsets const kPadding = {10, 10, 10, 10};

@interface MASExampleLabelView ()

@property (nonatomic, strong) UILabel *shortLabel;
@property (nonatomic, strong) UILabel *longLabel;

@end

@implementation MASExampleLabelView

- (id)init {
    self = [super init];
    if (!self) return nil;

    // text courtesy of http://baconipsum.com/

    self.shortLabel = UILabel.new;
    self.shortLabel.numberOfLines = 1;
    self.shortLabel.textColor = [UIColor purpleColor];
    self.shortLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.shortLabel.text = @"Bacon";
    self.shortLabel.layer.borderColor = [UIColor grayColor].CGColor;
    self.shortLabel.layer.borderWidth = 1;
    [self addSubview:self.shortLabel];

    self.longLabel = UILabel.new;
    self.longLabel.numberOfLines = 8;
    self.longLabel.textColor = [UIColor darkGrayColor];
    self.longLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.longLabel.text = @"Bacon ipsum dolor sit amet spare ribs fatback kielbasa salami, tri-tip jowl pastrami flank short loin rump sirloin. Tenderloin frankfurter chicken biltong rump chuck filet mignon pork t-bone flank ham hock.";
    self.longLabel.layer.borderColor = [UIColor grayColor].CGColor;
    self.longLabel.layer.borderWidth = 1;
    [self addSubview:self.longLabel];

    
//    直接设置在这里是不奏效的
//    CGFloat width = CGRectGetMinX(self.shortLabel.frame) - kPadding.left;
//    width -= CGRectGetMinX(self.longLabel.frame);
//    self.longLabel.preferredMaxLayoutWidth = width;

    
    //仅仅适配左边距和上边距
    [self.longLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).insets(kPadding);
        make.top.equalTo(self.top).insets(kPadding);
    }];

    //仅仅适配右边距和y中心点
    [self.shortLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.longLabel.centerY);
        make.right.equalTo(self.right).insets(kPadding);
    }];

    //MARK:多行label并没有正常显示
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // for multiline UILabel's you need set the preferredMaxLayoutWidth
    //多行文本要设置preferredMaxLayoutWidth属性
    
    // you need to do this after [super layoutSubviews] as the frames will have a value from Auto Layout at this point
    // 需要在super layoutSubviews方法执行以后，这时候才会得到具体的frames，然后再设置这个值才会生效

    // stay tuned for new easier way todo this coming soon to Masonry

    //longLabel适合的长度是  = shortLabel.left - padding.left - longLabel.left
    
    
    CGFloat width = CGRectGetMinX(self.shortLabel.frame) - kPadding.left;
    width -= CGRectGetMinX(self.longLabel.frame);
    self.longLabel.preferredMaxLayoutWidth = width;

    // need to layoutSubviews again as frames need to recalculated with preferredLayoutWidth
    [super layoutSubviews];
}

@end
