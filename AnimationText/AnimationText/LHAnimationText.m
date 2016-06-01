//
//  LHAnimationText.m
//  AnimationText
//
//  Created by lh on 16/6/1.
//  Copyright © 2016年 Lh. All rights reserved.
//

#import "LHAnimationText.h"
#import <CoreFoundation/CoreFoundation.h>
#import <CoreText/CoreText.h>


@interface LHAnimationText()

@end

@implementation LHAnimationText

- (instancetype)initWithReferenceView:(UIView *)referenceView{
    if (self = [super init]) {
        self.referenceView = referenceView;
        [self defaultConfiguration];
       // [self setupPathLayerWithText:self.textToAnimate font:self.font fontSize:self.fontSize];
    }
    
    return self;
}


- (void)defaultConfiguration{
    self.animationLayer = [CALayer new];
    self.animationLayer.frame = self.referenceView.bounds;
    [self.referenceView.layer addSublayer:self.animationLayer];
    self.font = [UIFont fontWithName:@"Avenir" size:30];
    self.textColor = [UIColor redColor];
    
}

- (void)setupPathLayerWithText:(NSString *)text font:(UIFont *)font fontSize:(CGFloat)fontSize{
    CGMutablePathRef letters = CGPathCreateMutable();
    CTFontRef fontRef = CTFontCreateWithName( (__bridge CFStringRef)font.fontName, fontSize, nil);
    NSMutableAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:@{@"kCTFontAttributeName":font}];
    
    CTLineRef lineRef = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    CFArrayRef runArray = CTLineGetGlyphRuns(lineRef);
    
    for (int i = 0; i < CFArrayGetCount(runArray); i++) {
        CTRunRef run = CFArrayGetValueAtIndex(runArray, i);
        CFDictionaryRef dictRef = CTRunGetAttributes(run);
        NSDictionary *dict = (__bridge NSDictionary *)dictRef;
        CTFontRef fontName = (__bridge CTFontRef)dict[@"kCTFontAttributeName"];
        
        for (int runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++) {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint postion;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &postion);
            CGPathRef path = CTFontCreatePathForGlyph(fontName, glyph, nil);
            CGAffineTransform t = CGAffineTransformMakeTranslation(postion.x, postion.y);
            CGPathAddPath(letters, &t, path);
            
        }
    }
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.animationLayer.bounds;
    pathLayer.bounds = CGPathGetBoundingBox(path.CGPath);
    pathLayer.geometryFlipped = YES;
    pathLayer.path             = path.CGPath;
    pathLayer.strokeColor       = [UIColor blackColor].CGColor;
    pathLayer.fillColor         = self.textColor.CGColor;
    pathLayer.lineWidth         = 1.0;
    pathLayer.lineJoin          = kCALineJoinBevel;
    
    [self.animationLayer addSublayer:pathLayer];
    self.pathLayer = pathLayer;

}

- (void)startAnimation{
    NSTimeInterval duration = 4.0;
    
    [self setupPathLayerWithText:self.textToAnimate font:self.font fontSize:self.fontSize];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = duration;
    pathAnimation.fromValue = @(0.0);
    pathAnimation.toValue   = @(1.0);
    pathAnimation.delegate  = self;
    
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    
    NSTimeInterval coloringDuration = 4.0;
    CAKeyframeAnimation *colorFillAnimation = [CAKeyframeAnimation animationWithKeyPath:@"fillColor"];
    colorFillAnimation.duration = coloringDuration;
    colorFillAnimation.duration     = duration + coloringDuration;
    colorFillAnimation.values       = @[[UIColor clearColor], [UIColor clearColor], self.textColor];
    colorFillAnimation.keyTimes     = @[@0, @(duration/(duration + coloringDuration)), @1];
    
    [self.pathLayer addAnimation:colorFillAnimation forKey:@"fillColor"];
}

- (void)stopAnimation{
    [self.pathLayer removeAllAnimations];
}

@end
