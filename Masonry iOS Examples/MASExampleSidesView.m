//
//  MASExampleSidesView.m
//  Masonry
//
//  Created by Jonas Budelmann on 21/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "MASExampleSidesView.h"

@implementation MASExampleSidesView

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    UIView *lastView = self;
    for (int i = 0; i < 10; i++) {
        UIView *view = UIView.new;
        view.backgroundColor = [self randomColor];
        view.layer.borderColor = UIColor.blackColor.CGColor;
        view.layer.borderWidth = 2;
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            //快速设置内边距的办法
            make.edges.equalTo(lastView).insets(UIEdgeInsetsMake(5, 10, 15, 20));
        }];
        
        lastView = view;
    }
    
    return self;
}

/**
 *  生成一个随机的颜色
 *
 *  @return 
 */
- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
