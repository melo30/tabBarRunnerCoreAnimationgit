//
//  ButtonMenu.m
//  底部旋转菜单 - CoreAnimation
//
//  Created by 陈诚 on 15/12/11.
//  Copyright © 2015年 陈诚. All rights reserved.
//

#import "ButtonMenu.h"

#define AnimationDuration 5
#define delta 80 //按钮间的间距
@interface ButtonMenu()
/**
 *  items存放三个隐藏的按钮
 */
@property (nonatomic, strong)NSMutableArray *items;
@property (weak, nonatomic) IBOutlet UIButton *mainBtn;

@end
@implementation ButtonMenu
- (IBAction)mainBtnClicked:(id)sender {
    //1.先实现主按钮的动画效果
    [UIView animateWithDuration:AnimationDuration animations:^{
        if (CGAffineTransformIsIdentity(self.mainBtn.transform)) {//代表transform未被改变时
            self.mainBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
        }else
        {//恢复
            self.mainBtn.transform = CGAffineTransformIdentity;
        }
    }];
    [self showItems:CGAffineTransformIsIdentity(self.mainBtn.transform)];
}
- (void)showItems:(BOOL)show
{
        //实现items的显示位置
    for (UIButton *btn in self.items) {
#warning 一个按钮对应一个组动画
        //2.实现items的动画效果
        //2.1创建组动画
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.duration = AnimationDuration;
        //2.2 添加平移动画
        CAKeyframeAnimation *positionAni = [CAKeyframeAnimation animation];
        positionAni.keyPath = @"position";
        //2.3添加旋转动画
        CAKeyframeAnimation *rotationAni = [CAKeyframeAnimation animation];
        rotationAni.keyPath = @"transform.rotation";

        CGFloat btnCenterX = self.mainBtn.center.x + (btn.tag + 1) * delta;
        CGFloat btnCenterY = self.mainBtn.center.y;
        CGPoint showPosition = CGPointMake(btnCenterX, btnCenterY);
        //重新计算每个按钮的x值
        if (!CGAffineTransformIsIdentity(self.mainBtn.transform)) {//显示
            //设置平移动画的路径
            NSValue *value1 = [NSValue valueWithCGPoint:self.mainBtn.center];
            NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(btnCenterX * 0.5, btnCenterY)];
            NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(btnCenterX * 1.1, btnCenterY)];
            NSValue *value4 = [NSValue valueWithCGPoint:showPosition];

            positionAni.values = @[value1,value2,value3,value4];
            //设置旋转的路径
            rotationAni.values = @[@0,@(M_PI * 2),@(M_PI * 4),@(M_PI * 2)];
            btn.center = showPosition;
        }else{//隐藏
            //设置平移动画的路径
            NSValue *value1 = [NSValue valueWithCGPoint:btn.center];
            NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(btnCenterX * 1.1, btnCenterY)];
            NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(btnCenterX * 0.5, btnCenterY)];
            NSValue *value4 = [NSValue valueWithCGPoint:self.mainBtn.center];
            positionAni.values = @[value1,value2,value3,value4];
            //设置旋转的路径
            rotationAni.values = @[@0,@(M_PI * 2),@0,@(-M_PI *2)];
            btn.center = self.mainBtn.center;
        }
        
        //添加组动画
        group.animations = @[positionAni,rotationAni];
        //执行组动画
        [btn.layer addAnimation:group forKey:nil];
    }
    
}
- (NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;

}
+ (instancetype)buttonMenu
{
    return [[[NSBundle mainBundle]loadNibNamed:@"ButtonMenu" owner:nil options:nil]lastObject];
}
/**
 *  用xib加载的时候调用
 *
 */
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initItems];
    }
    return self;
}

/**
 *  初始化三个隐藏的按钮
 */
- (void)initItems
{
    [self addBtnWithBgImage:@"menu_btn_call" tag:0];
    [self addBtnWithBgImage:@"menu_btn_cheyou" tag:1];
    [self addBtnWithBgImage:@"menu_btn_tixing" tag:2];
}
/**
 *  通过一张图片来添加按钮
 *
 */
- (void)addBtnWithBgImage:(NSString *)bgImage tag:(NSInteger)tag
{
    //添加一个按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:bgImage] forState:UIControlStateNormal];
    btn.tag = tag;
    [self.items addObject:btn];
    [self addSubview:btn];
}
/**
 *  3个隐藏按钮的尺寸和位置(自动调用)
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect btnBounds = CGRectMake(0, 0, 43, 43);
    //遍历三个隐藏按钮
    for (UIButton *btn in self.items) {
        btn.bounds = btnBounds;
        btn.center = self.mainBtn.center;
    }
    //把红色的按钮置顶
    [self bringSubviewToFront:self.mainBtn];
}
@end
