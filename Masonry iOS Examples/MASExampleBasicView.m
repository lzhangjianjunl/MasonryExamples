//
//  MASExampleBasicView.m
//  Masonry
//
//  Created by Jonas Budelmann on 21/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "MASExampleBasicView.h"

@implementation MASExampleBasicView

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    //设置颜色和边框宽度
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
    int padding = 10;

    //如果你想要省略mas_前缀，那么在宏定义里面定义即可
    //if you want to use Masonry without the mas_ prefix
    //define MAS_SHORTHAND before importing Masonry.h see Masonry iOS Examples-Prefix.pch
    [greenView makeConstraints:^(MASConstraintMaker *make) {
        
        //greenview.top = 0 ＋10
        make.top.greaterThanOrEqualTo(superview.top).offset(padding);
        //greenview.top = 0 +10
        make.left.equalTo(superview.left).offset(padding);
        //greenview.bottom = blueView.top - 10
        make.bottom.equalTo(blueView.top).offset(-padding);
        //greenview.right = redvIEW.left - 10
        make.right.equalTo(redView.left).offset(-padding);
        //greenView.width = redView.width
        make.width.equalTo(redView.width);

        //三个view高度相等
        make.height.equalTo(redView.height);
        make.height.equalTo(blueView.height);
    }];

    //with is semantic and option
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        //with只是用来说明语义的完整性的，有没有都可以
        make.top.equalTo(superview.mas_top).with.offset(padding); //with with
        //前面写过了，不写这句可以么？结果是可以的，因为这条和前面完全是重复哦
//        make.left.equalTo(greenView.mas_right).offset(padding); //without with
        //redView.bottom = blueView.top - 10
        make.bottom.equalTo(blueView.mas_top).offset(-padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        make.width.equalTo(greenView.mas_width);
        
        //三个view高度相等，还可以传入数组
        make.height.equalTo(@[greenView, blueView]); //can pass array of views
    }];
    
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        //这句前面也是重复的，还是写上吧
        //这里也可以用redView.bottom代替，但是有可能和别的categroy冲突，还是带上mas为妙
//        make.top.equalTo(redView.bottom).offset(padding);
        make.top.equalTo(greenView.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.bottom.equalTo(superview.mas_bottom).offset(-padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        make.height.equalTo(@[greenView.mas_height, redView.mas_height]); //can pass array of attributes
    }];

    return self;
}

@end
