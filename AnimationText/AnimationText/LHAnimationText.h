//
//  LHAnimationText.h
//  AnimationText
//
//  Created by lh on 16/6/1.
//  Copyright © 2016年 Lh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LHAnimationText;
@protocol LHAnimationTextDelegate <NSObject>
- (void)animationText:(LHAnimationText *)animationText animationDidStartAnimation:(CAAnimation *) animation;
- (void)animationText:(LHAnimationText *)animationText animationDidStopAnimation:(CAAnimation *)animation;
@end


@interface LHAnimationText : NSObject
@property (nonatomic, strong)UIFont *font;
@property (nonatomic, assign)CGFloat fontSize;
@property (nonatomic, copy)NSString *textToAnimate;
@property (nonatomic, strong)UIColor *textColor;
@property (nonatomic, weak)id <LHAnimationTextDelegate>delegate;
@property (nonatomic, strong)CALayer *animationLayer;
@property (nonatomic, strong)CAShapeLayer *pathLayer;
@property (nonatomic, strong)UIView *referenceView;


- (instancetype)initWithReferenceView:(UIView *)referenceView;
- (void)startAnimation;
@end
