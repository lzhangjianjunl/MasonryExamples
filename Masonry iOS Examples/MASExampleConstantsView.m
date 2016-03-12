//
//  MASExampleConstantsView.m
//  Masonry
//
//  Created by Jonas Budelmann on 21/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "MASExampleConstantsView.h"

@implementation MASExampleConstantsView

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    UIView *purpleView = UIView.new;
    purpleView.backgroundColor = UIColor.purpleColor;
    purpleView.layer.borderColor = UIColor.blackColor.CGColor;
    purpleView.layer.borderWidth = 2;
    [self addSubview:purpleView];
    
    UIView *orangeView = UIView.new;
    orangeView.backgroundColor = UIColor.orangeColor;
    orangeView.layer.borderColor = UIColor.blackColor.CGColor;
    orangeView.layer.borderWidth = 2;
    [self addSubview:orangeView];
    
    //example of using constants
    //使用一个常量，所有的间距都是20
    [purpleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@20);
        make.bottom.equalTo(@-20);
        make.right.equalTo(@-20);
        
        //下面这样是不对的哈
//        make.top.left.bottom.and.right.equalTo(@20);
        
        //这样是可以的哈
//        make.edges.equalTo(self).insets(UIEdgeInsetsMake(20, 20, 20, 20));
        
    }];
    
    // auto-boxing macros allow you to simply use scalars and structs, they will be wrapped automatically
    // 自动装箱容许你使用直接传入结构体
    [orangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //这里为啥？？？这里貌似是以父的中心点做参照的点？
        //center属性的意思就是说，这个view在父亲view的中心，你设置的x，y都是在这个点的偏移
//        make.centerX.mas_equalTo(@0);
//        make.centerY.mas_equalTo(@0);
        make.center.mas_equalTo(CGPointMake(0, 50));
//        make.center.equalTo(CGPointMake(0, 50));
        //设置固定大小的办法
        make.size.equalTo(CGSizeMake(200, 100));
    }];
    
    return self;
}

@end
