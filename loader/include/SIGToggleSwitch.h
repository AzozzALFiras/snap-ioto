//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Sep 17 2017 16:24:48).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2015 by Steve Nygard.
//

#import <UIKit/UIControl.h>

@class CALayer, CAShapeLayer, SIGToggleColorModel, UIColor, UIImpactFeedbackGenerator;

@interface SIGToggleSwitch : UIControl
{
    _Bool _on;
    CDUnknownBlockType _tapAction;
    CAShapeLayer *_switchBackgroundLayer;
    CAShapeLayer *_switchHandleLayer;
    CALayer *_handleShadowLayer;
    SIGToggleColorModel *_colors;
    UIImpactFeedbackGenerator *_generator;
    UIColor *_handleColor;
    double _handleRadius;
}

+ (id)switchWithAccessibilityLabel:(id)arg1 andAccessibilityHint:(id)arg2;	// IMP=0x0000000106feadc4
- (void).cxx_destruct;	// IMP=0x0000000106fecacc
@property(nonatomic) double handleRadius; // @synthesize handleRadius=_handleRadius;
@property(retain, nonatomic) UIColor *handleColor; // @synthesize handleColor=_handleColor;
@property(retain, nonatomic) UIImpactFeedbackGenerator *generator; // @synthesize generator=_generator;
@property(retain, nonatomic) SIGToggleColorModel *colors; // @synthesize colors=_colors;
@property(retain, nonatomic) CALayer *handleShadowLayer; // @synthesize handleShadowLayer=_handleShadowLayer;
@property(retain, nonatomic) CAShapeLayer *switchHandleLayer; // @synthesize switchHandleLayer=_switchHandleLayer;
@property(retain, nonatomic) CAShapeLayer *switchBackgroundLayer; // @synthesize switchBackgroundLayer=_switchBackgroundLayer;
@property(copy, nonatomic) CDUnknownBlockType tapAction; // @synthesize tapAction=_tapAction;
@property(nonatomic, getter=isOn) _Bool on; // @synthesize on=_on;
- (unsigned long long)accessibilityTraits;	// IMP=0x0000000106fec9bc
- (id)accessibilityHint;	// IMP=0x0000000106fec938
- (id)accessibilityLabel;	// IMP=0x0000000106fec8b4
- (id)accessibilityValue;	// IMP=0x0000000106fec818
- (_Bool)isAccessibilityElement;	// IMP=0x0000000106fec810
- (struct CGRect)accessibilityFrame;	// IMP=0x0000000106fec7d8
- (struct CGRect)alignmentRectForFrame:(struct CGRect)arg1;	// IMP=0x0000000106fec7cc
- (struct CGSize)intrinsicContentSize;	// IMP=0x0000000106fec778
- (void)touchesEnded:(id)arg1 withEvent:(id)arg2;	// IMP=0x0000000106fec600
- (void)toggleAnimationForLayer:(id)arg1;	// IMP=0x0000000106fec1a8
- (void)setIsOn:(_Bool)arg1 animated:(_Bool)arg2;	// IMP=0x0000000106febf44
- (void)layoutSwitch;	// IMP=0x0000000106feb9e8
- (void)refreshColors;	// IMP=0x0000000106feb898
- (void)layoutSubviews;	// IMP=0x0000000106feb838
@property(readonly, nonatomic) double handleTravel;
@property(retain, nonatomic) UIColor *offColor;
@property(retain, nonatomic) UIColor *onColor;
@property(readonly, nonatomic) struct CGRect switchFrame;
- (void)setHighlighted:(_Bool)arg1;	// IMP=0x0000000106feb4b8
- (id)initWithFrame:(struct CGRect)arg1;	// IMP=0x0000000106feaee0
- (id)initWithAccessibilityLabel:(id)arg1 andAccessibilityHint:(id)arg2;	// IMP=0x0000000106feae3c

@end

