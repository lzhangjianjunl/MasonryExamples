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
##1.6快速设置内边距的办法,这样可以自动的适配高度和宽度
```
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            //快速设置内边距的办法
            make.edges.equalTo(lastView).insets(UIEdgeInsetsMake(5, 10, 15, 20));
        }];
```


#2约束比例
##2.1根据约束和比例优先级进行适配出合适的高度和宽度
```
        [self addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.top.equalTo(self);
        }];
        

        [self addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            //左右下都和父亲view贴着
            make.left.right.and.bottom.equalTo(self);
            //bottomView的顶部和topView的底部是仅仅贴着的
            make.top.equalTo(self.topView.mas_bottom);
            //他俩的高度是相等的
            make.height.equalTo(self.topView);
        }];
        
        // Inner views are configured for aspect fit with ratio of 3:1
        [self.topView addSubview:self.topInnerView];
        [self.topInnerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            // 其内部的view的width ＝ view.height * 3
            make.width.equalTo(self.topInnerView.mas_height).multipliedBy(3);
            
            //其的高度要小于等于起父亲view的高度,这个需要考虑到横屏的情况，是有意义的
            make.width.and.height.lessThanOrEqualTo(self.topView);
            
            //因为上面没有设置优先级，所以是必须实现的，如果下面的约束不设置优先级
            //那么当宽度和父亲宽度一样的时候，那么高度就会违反第二个约束，所以这里设置其优先级为低，如果满足可以，不满足也没事
            //所以横屏才是这个样子
            //宽度和高度等于起父亲view的高度和宽度
//            make.width.equalTo(self.topView.width);
//            make.width.equalTo(self.topView.width).with.priorityLow();
            make.width.and.height.equalTo(self.topView).with.priorityLow();
            
            make.center.equalTo(self.topView);
        }];
        
        [self.bottomView addSubview:self.bottomInnerView];
        [self.bottomInnerView mas_makeConstraints:^(MASConstraintMaker *make) {
            //高度等于长度乘以三
            make.height.equalTo(self.bottomInnerView.mas_width).multipliedBy(3);
            //高度和宽度比父亲view小，这是设置范围
            make.width.and.height.lessThanOrEqualTo(self.bottomView);
            //尽量满足，不能违反上面的约束
            make.width.and.height.equalTo(self.bottomView).with.priorityLow();
                        
            make.center.equalTo(self.bottomView);
        }];
```
#3动画
##3.1mas和动画的代码结合,通过更改padding值，来实现动画效果
```
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
    
    
```
#4调试
##4.1让约束关系也方便调试
```
    //OR you can attach keys automagically like so:
    // 如果不设置这些key，那么出现问题的时候，就只能看到uilabel之类的东东，很难调适
    MASAttachKeys(greenView, redView, blueView, superview);

    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        //you can also attach debug keys to constaints
        
        //给约束设置一个名称，让其出现问题的时候方便定位
        make.edges.equalTo(@1).key(@"ConflictingConstraint"); //composite constraint keys will be indexed
        make.height.greaterThanOrEqualTo(@5000).key(@"ConstantConstraint");

        make.top.equalTo(greenView.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.bottom.equalTo(superview.mas_bottom).offset(-padding).key(@"BottomConstraint");
        make.right.equalTo(superview.mas_right).offset(-padding);
        make.height.equalTo(greenView.mas_height);
        make.height.equalTo(redView.mas_height).key(@340954); //anything can be a key
    }];
```

#5多行label
##5.1多行label和autolayout的设置,设置后多行label后，要在layoutSubviews方法里面设置preferredMaxLayoutWidth属性
```
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
```
#6UIScrollView
##6.1让UIScrollView自动适配contentSize,注意这里自动计算了高度的contentSize，同时设置死了宽度
```
- (void)generateContent {
    UIView* contentView = UIView.new;
    [self.scrollView addSubview:contentView];
    
    //回到那个博文一样的问题了
    //1.为什么要添加一个contentView在scrollView上面
    //2.为什么设置了边距，还要再设置高度呢？      为了计算contentSize
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    UIView *lastView;
    CGFloat height = 25;
    
    for (int i = 0; i < 10; i++) {
        UIView *view = UIView.new;
        view.backgroundColor = [self randomColor];
        [contentView addSubview:view];
        
        //添加点击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [view addGestureRecognizer:singleTap];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            //顶在上一个view的底部
            //如果为nil，那么就是第一次，只要顶在最顶端就好，后面就是紧接着上一个view
            make.top.equalTo(lastView ? lastView.bottom : @0);
            make.left.equalTo(@0);
            make.width.equalTo(contentView.width);
            make.height.equalTo(@(height));
        }];
        
        height += 25;
        lastView = view;
    }
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.bottom);
    }];
    
    //这样就自动计算了contentSize
}
```
#7更新一组View的约束
##7.1更新一组view的约束
```
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
```

#8方便的办法
##8.1设置一个间距值，多次使用，部门方法可以传递数组进去，例如height
```
    //定一个间距的数据，后面可以被独立拿出来多次的使用
    UIEdgeInsets padding = UIEdgeInsetsMake(15, 10, 15, 10);


    [greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        // chain attributes
        // 一次设置多个间距
        make.top.and.left.equalTo(superview).insets(padding);

        // which is the equivalent of
//        make.top.greaterThanOrEqualTo(superview).insets(padding);
//        make.left.greaterThanOrEqualTo(superview).insets(padding);

        //设置位置
        make.bottom.equalTo(blueView.mas_top).insets(padding);
        make.right.equalTo(redView.mas_left).insets(padding);
        make.width.equalTo(redView.mas_width);

        //设置多个原素高度相等
        make.height.equalTo(@[redView, blueView]);
    }];

    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        // chain attributes
        make.top.and.right.equalTo(superview).insets(padding);

        make.left.equalTo(greenView.mas_right).insets(padding);
        make.bottom.equalTo(blueView.mas_top).insets(padding);
        make.width.equalTo(greenView.mas_width);

        make.height.equalTo(@[greenView, blueView]);
    }];

    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(greenView.mas_bottom).insets(padding);

        // chain attributes
        make.left.right.and.bottom.equalTo(superview).insets(padding);

        make.height.equalTo(@[greenView, redView]);
    }];
```
#9 layoutMargins
##9.1适配iOS8的新增属性layoutMargins
```

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    UIView *lastView = self;
    for (int i = 0; i < 10; i++) {
        UIView *view = UIView.new;
        view.backgroundColor = [self randomColor];
//        view.backgroundColor = [UIColor blackColor];
        view.layer.borderColor = UIColor.blackColor.CGColor;
        view.layer.borderWidth = 2;
        
        //iOS8新增的margin属性
        view.layoutMargins = UIEdgeInsetsMake(5, 10, 15, 20);
        [self addSubview:view];
     
        //感觉没啥鸟用
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.topMargin);
            make.bottom.equalTo(lastView.bottomMargin);
            make.left.equalTo(lastView.leftMargin);
            make.right.equalTo(lastView.rightMargin);
        }];
    
        lastView = view;
    }
    
    return self;
}
```

#10自适应
##10.1宽／高度自适应，间距自适应
```
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
```

#11topLayoutGuide和bottomLayoutGuide
##11.1适配iOS7种vc的新增的属性topLayoutGuide，bottomLayoutGuide,其代表的是除去状态栏等东西真正需要布局的内容,是除去状态栏，导航栏等元素遮盖的情况
```
    [topView makeConstraints:^(MASConstraintMaker *make) {
        //这里如果直接设置为0，可能会出现遮盖的状况,直接从状态栏开始布局了。。。
        make.top.equalTo(self.mas_topLayoutGuide);
//        make.top.equalTo(0);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@40);
    }];

    [topSubview makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.centerX.equalTo(@0);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(0);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@40);
    }];
```
