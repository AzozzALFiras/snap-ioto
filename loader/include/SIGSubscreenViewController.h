//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Sep 17 2017 16:24:48).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2015 by Steve Nygard.
//

#import <UIKit/UIViewController.h>

#import "SIGCardTransitionDelegate-Protocol.h"
#import "SIGHeaderAssociateBackgroundDelegate-Protocol.h"
#import "SIGHeaderItemDelegate-Protocol.h"

@class NSObject, NSString, SIGHeader, SIGSubscreenView, UIScrollView, UIView;
@protocol SIGCardTransition, SIGHeaderItem;

@interface SIGSubscreenViewController : UIViewController <SIGHeaderAssociateBackgroundDelegate, SIGHeaderItemDelegate, SIGCardTransitionDelegate>
{
    unsigned long long _currentPresentationMode;
    _Bool _userCanPullToDismiss;
    unsigned long long _style;
    unsigned long long _presentationMode;
    id <SIGCardTransition> _cardTransition;
    NSObject<SIGHeaderItem> *_headerItem;
    SIGSubscreenView *_subscreenView;
}

- (void).cxx_destruct;	// IMP=0x0000000106fdb704
@property(readonly, nonatomic) SIGSubscreenView *subscreenView; // @synthesize subscreenView=_subscreenView;
@property(readonly, nonatomic) NSObject<SIGHeaderItem> *headerItem; // @synthesize headerItem=_headerItem;
@property(readonly, nonatomic) id <SIGCardTransition> cardTransition; // @synthesize cardTransition=_cardTransition;
@property(nonatomic, getter=isPullToDismissEnabled) _Bool userCanPullToDismiss; // @synthesize userCanPullToDismiss=_userCanPullToDismiss;
@property(nonatomic) unsigned long long presentationMode; // @synthesize presentationMode=_presentationMode;
@property(nonatomic) unsigned long long style; // @synthesize style=_style;
- (void)observeValueForKeyPath:(id)arg1 ofObject:(id)arg2 change:(id)arg3 context:(void *)arg4;	// IMP=0x0000000106fdb560
- (void)didSelectDismissalActionWithHeaderItem:(id)arg1;	// IMP=0x0000000106fdb518
- (void)cardTransitionEndedWithView:(id)arg1 transitionType:(unsigned long long)arg2;	// IMP=0x0000000106fdb484
- (void)cardTransitionDidUpdateProgress:(double)arg1;	// IMP=0x0000000106fdb3d0
- (void)cardTransitionWillBeginWithView:(id)arg1;	// IMP=0x0000000106fdb3bc
- (id)cardToExpandTransition;	// IMP=0x0000000106fdb3b8
- (_Bool)cardTransitionShouldBeginWithView:(id)arg1 touchLocation:(struct CGPoint)arg2;	// IMP=0x0000000106fdb260
- (void)headerAssociatedBackground:(id)arg1;	// IMP=0x0000000106fdb248
- (void)viewWillAppear:(_Bool)arg1;	// IMP=0x0000000106fdb138
- (void)loadView;	// IMP=0x0000000106fdad2c
@property(readonly, nonatomic) UIScrollView *scrollView;
@property(readonly, nonatomic) SIGHeader *header;
@property(readonly, nonatomic) UIView *contentView;
@property(readonly, nonatomic) UIView *backgroundView;
- (id)loadScrollView;	// IMP=0x0000000106fdab0c
- (void)dealloc;	// IMP=0x0000000106fdaa84
- (id)initWithNibName:(id)arg1 bundle:(id)arg2;	// IMP=0x0000000106fda8f8

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end

