//
//  MASExampleOneViewController.m
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "MASExampleViewController.h"
#import "MASExampleBasicView.h"

@interface MASExampleViewController ()

@property (nonatomic, strong) Class viewClass;

@end

@implementation MASExampleViewController

- (id)initWithTitle:(NSString *)title viewClass:(Class)viewClass {
    self = [super init];
    if (!self) return nil;
    
    self.title = title;
    self.viewClass = viewClass;
    
    return self;
}

- (void)loadView {
    //使用给予的view设置self.view
    self.view = self.viewClass.new;
    self.view.backgroundColor = [UIColor whiteColor];
}

//用于直接在导航栏下面开始计算布局，而不是从状态栏顶端开始
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

@end
