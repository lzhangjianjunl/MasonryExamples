#1.通用知识

##1.1如果你想省略mas_前缀，那么在预编译文件中增加这段代码

```
    //define this constant if you want to use Masonry without the 'mas_' prefix
    #define MAS_SHORTHAND
```
##1.2简单设置top，bottom，left，right，width以及height的用法

```
    [greenView makeConstraints:^(MASConstraintMaker *make) {
                make.top.greaterThanOrEqualTo(superview.top).offset(padding);
        make.left.equalTo(superview.left).offset(padding);
        make.bottom.equalTo(blueView.top).offset(-padding);
        make.right.equalTo(redView.left).offset(-padding);
        make.width.equalTo(redView.width);
        make.height.equalTo(redView.height);
        make.height.equalTo(blueView.height);
    }];
```

##1.3直接使用常量的例子,例子中的位置参照物是父view
```
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
```

##1.4使用updateConstraints的例子，使用该方法，要确保前后约束都是一样的，只是约束的数值有变化,同时需要注意setNeedsUpdateConstraints，updateConstraintsIfNeeded，layoutIfNeeded这三个方法的含义和调用时机

```
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
```
##1.5使用remakeConstraints的例子，这会使用全新的约束，替代之前的约束
```
// this is Apple's recommended place for adding/updating constraints
- (void)updateConstraints {
    
    //约束的内容改变了，而不是约束的数值，看Update的例子
    [self.movingButton remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(100));
        make.height.equalTo(@(100));
        
        //左上角和右下角不断变化
        if (self.topLeft) {
            make.left.equalTo(self.left).with.offset(10);
            make.top.equalTo(self.top).with.offset(10);
        }
        else {
            make.bottom.equalTo(self.bottom).with.offset(-10);
            make.right.equalTo(self.right).with.offset(-10);
        }
    }];
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}
```