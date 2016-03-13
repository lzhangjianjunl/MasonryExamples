//
//  MASExampleDistributeView.m
//  Masonry iOS Examples
//
//  Created by bibibi on 15/8/6.
//  Copyright (c) 2015年 Jonas Budelmann. All rights reserved.
//

#import "MASExampleDistributeView.h"

@implementation MASExampleDistributeView

- (id)init {
    self = [super init];
    if (!self) return nil;

    //随机生成了4个view
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0; i < 4; i++) {
        UIView *view = UIView.new;
        view.backgroundColor = [self randomColor];
        view.layer.borderColor = UIColor.blackColor.CGColor;
        view.layer.borderWidth = 2;
        [self addSubview:view];
        [arr addObject:view];
    }
    
    //随机生成这四个数
    unsigned int type  = arc4random()%4;
//    type = 1;
    switch (type) {
        case 0:
            //数组中的元素水平/垂直分布，平均分布的间距，第一个间距，最后一个元素的间距
            //宽度自适应
            [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:5 tailSpacing:5];

            //数组中每一个元素的约束
            [arr makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@60);          //top
                make.height.equalTo(@60);       //宽度
            }];
            break;
        case 1:
            //垂直分布
            //固定了间距为20，第一个元素的top是5，最后一个元素的bottom是5，高度自适应
            [arr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:20 leadSpacing:5 tailSpacing:5];
            [arr makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@0);
                make.width.equalTo(@60);
            }];
            break;
        case 2:
            //间距平均分布
            //水平分布，第一个元素left是200，最后一个元素的right是30，每个元素的宽度是30，
            [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:30 leadSpacing:200 tailSpacing:30];
            [arr makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@60);
                make.height.equalTo(@60);
            }];
            break;
        case 3:
            //间距平均分布
            //垂直分布，第一个元素的top是30，最后一个元素的bottom是200，每个元素的高度是30
            [arr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:30 leadSpacing:30 tailSpacing:200];
            [arr makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@0);
                make.width.equalTo(@60);
            }];
            break;
            
        default:
            break;
    }
    
    [self showPlaceHolderWithAllSubviews];
    
    return self;
}

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
