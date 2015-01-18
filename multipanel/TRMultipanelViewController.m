//
//  TrMultipanelViewController.m
//  tvoirecepty
//
//  Created by Vitaly on 3/23/14.
//  Copyright (c) 2014 tvoirecepty. All rights reserved.
//

#import "TRMultipanelViewController.h"

#import "TRMultipanelViewControllerSide.h"

NSString* const TRMultipanelDidShowSideNotification = @"TRMultipanelDidShowSideNotification";
NSString* const TRMultipanelDidHideSideNotification = @"TRMultipanelDidHideSideNotification";
NSString* const TRMultipanelDidToggleSideNotification = @"TRMultipanelDidToggleSideNotification";

static const CGFloat TRMultipanelToggleAnimationDuration = 0.2;
static const CGFloat TRMultipanelDefaultSideWith = 320.0;

@interface TRMultipanelViewController () <TRMultipanelViewControllerSideDelegate>

@property (strong, nonatomic) NSDictionary* sides;

@end

@implementation TRMultipanelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -- Public 

- (UIViewController*)contentControllerForSide:(TRMultipanelSideType)sideType {
    TRMultipanelViewControllerSide* side = [self sideWithType:sideType];
    return side.contentController;
}

- (void)setContentController:(UIViewController*)controller
                     forSide:(TRMultipanelSideType)sideType {
    TRMultipanelViewControllerSide* side = [self sideWithType:sideType];
    side.contentController = controller;
}

- (BOOL)isVisibleSide:(TRMultipanelSideType)sideType {
    TRMultipanelViewControllerSide* side = [self sideWithType:sideType];
    return side.visible;
}

- (CGFloat)widthForSide:(TRMultipanelSideType)sideType {
    TRMultipanelViewControllerSide* side = [self sideWithType:sideType];
    return side.width;
}

- (void)setWidth:(CGFloat)width
         forSide:(TRMultipanelSideType)sideType {
    TRMultipanelViewControllerSide* side = [self sideWithType:sideType];
    side.width = width;
}

#pragma mark -- Private 

- (UIView*)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
        _centerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view insertSubview:_centerView atIndex:0];
        [self addCenterConstraints];
        [_centerView setNeedsLayout];
        [_centerView layoutIfNeeded];
    }
    return _centerView;
}

- (NSDictionary*)sides {
    if (!_sides) {
        
        TRMultipanelViewControllerSide* leftSide =
            [[TRMultipanelViewControllerSide alloc] initWithContainer:self
                                          boundaryConnectionAttribute:NSLayoutAttributeLeading
                                                                width:TRMultipanelDefaultSideWith];
        leftSide.delegate = self;
        TRMultipanelViewControllerSide* rightSide =
            [[TRMultipanelViewControllerSide alloc] initWithContainer:self
                                          boundaryConnectionAttribute:NSLayoutAttributeTrailing
                                                                width:TRMultipanelDefaultSideWith];
        rightSide.delegate = self;
        
        _sides = @{
            @(TRMultipanelSideTypeLeft): leftSide,
            @(TRMultipanelSideTypeRight): rightSide
        };
    }
    return _sides;
}

- (TRMultipanelViewControllerSide*)sideWithType:(TRMultipanelSideType)type {
    return self.sides[@(type)];
}

- (TRMultipanelSideType)typeOfSide:(TRMultipanelViewControllerSide*)side {
    for (NSNumber* key in self.sides) {
        if ([self.sides[key] isEqual:side]) {
            return [key integerValue];
        }
    }
    return TRMultipanelSideTypeUnknown;
}

- (void)addCenterConstraints {
    NSLayoutConstraint* topCenterConstraint = [NSLayoutConstraint constraintWithItem:self.centerView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:0];
    NSLayoutConstraint* bottomCenterConstraint = [NSLayoutConstraint constraintWithItem:self.centerView
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1
                                                                constant:0];
    
    TRMultipanelViewControllerSide* leftSide = [self sideWithType:TRMultipanelSideTypeLeft];
    
    NSLayoutConstraint* leftCenterConstraint = [NSLayoutConstraint constraintWithItem:self.centerView
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:leftSide.view
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1
                                                              constant:0];
    
    TRMultipanelViewControllerSide* rightSide = [self sideWithType:TRMultipanelSideTypeRight];
    
    NSLayoutConstraint* rightCenterConstraint = [NSLayoutConstraint constraintWithItem:rightSide.view
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.centerView
                                                              attribute:NSLayoutAttributeTrailing
                                                             multiplier:1
                                                               constant:0];
    
    [self.view addConstraints:@[topCenterConstraint, bottomCenterConstraint, leftCenterConstraint,rightCenterConstraint]];
}


#pragma mark -- Actions

- (void)showSide:(TRMultipanelSideType)sideType
        animated:(BOOL)animated
{
    [self showSide:sideType
          animated:animated
        completion:nil];
}

- (void)hideSide:(TRMultipanelSideType)sideType
        animated:(BOOL)animated
{
    [self hideSide:sideType
          animated:animated
        completion:nil];
}

- (void)toggleSide:(TRMultipanelSideType)sideType
          animated:(BOOL)animated
{
    [self toggleSide:sideType
            animated:animated
          completion:nil];
}

- (void)showSide:(TRMultipanelSideType)sideType
        animated:(BOOL)animated
      completion:(void (^)(TRMultipanelSideType sideType, BOOL finished))completion
{
    __weak typeof(self) weakSelf = self;
    [self moveSide:sideType
          animated:animated
         operation:
     ^(TRMultipanelViewControllerSide* side) {
         side.visible = YES;
     }
        completion:
     ^(TRMultipanelSideType sideType, BOOL finished) {
         if (completion)
             completion(sideType, finished);
         typeof(self) strongSelf = weakSelf;
         [[NSNotificationCenter defaultCenter] postNotificationName:TRMultipanelDidShowSideNotification
                                                             object:strongSelf
                                                           userInfo:@{@"side":@(sideType)}];
     }];
}



- (void)hideSide:(TRMultipanelSideType)sideType
        animated:(BOOL)animated
      completion:(void (^)(TRMultipanelSideType sideType, BOOL finished))completion
{
    __weak typeof(self) weakSelf = self;
    [self moveSide:sideType
          animated:animated
         operation:
     ^(TRMultipanelViewControllerSide* side) {
         side.visible = NO;
     }
        completion:
     ^(TRMultipanelSideType sideType, BOOL finished) {
         if (completion)
             completion(sideType, finished);
         typeof(self) strongSelf = weakSelf;
         [[NSNotificationCenter defaultCenter] postNotificationName:TRMultipanelDidHideSideNotification
                                                             object:strongSelf
                                                           userInfo:@{@"side":@(sideType)}];
     }];
}

- (void)toggleSide:(TRMultipanelSideType)sideType
          animated:(BOOL)animated
        completion:(void (^)(TRMultipanelSideType sideType, BOOL finished))completion
{
    __weak typeof(self) weakSelf = self;
    [self moveSide:sideType
          animated:animated
         operation:
     ^(TRMultipanelViewControllerSide* side) {
         side.visible = !side.visible;
     }
        completion:
     ^(TRMultipanelSideType sideType, BOOL finished) {
         if (completion)
             completion(sideType, finished);
         typeof(self) strongSelf = weakSelf;
         [[NSNotificationCenter defaultCenter] postNotificationName:TRMultipanelDidToggleSideNotification
                                                             object:strongSelf
                                                           userInfo:@{@"side":@(sideType)}];
     }];
}

- (void)moveSide:(TRMultipanelSideType)sideType
        animated:(BOOL)animated
       operation:(void (^)(TRMultipanelViewControllerSide* side))operation
      completion:(void (^)(TRMultipanelSideType sideType, BOOL finished))completion
{
    __weak TRMultipanelViewControllerSide* side = [self sideWithType:sideType];
    if (animated) {
        [UIView animateWithDuration:TRMultipanelToggleAnimationDuration
                         animations:
         ^{
             operation(side);
         } completion:^(BOOL finished) {
             if (completion)
                 completion(sideType, finished);
         }];
    } else {
        operation(side);
        if (completion)
            completion(sideType, YES);
    }
}

#pragma mark -- TRMultipanelViewControllerSideDelegate

- (void)multipanelSideDidPanOutside:(TRMultipanelViewControllerSide*)side {
    TRMultipanelSideType sideType = [self typeOfSide:side];
    [self hideSide:sideType animated:YES];
}

- (BOOL)multipanelSide:(TRMultipanelViewControllerSide*)side shouldReceiveTouch:(UITouch *)touch {
    if ([self.delegate respondsToSelector:@selector(multipanel:side:shouldReceiveTouch:)])
        return [self.delegate multipanel:self side:[self typeOfSide:side] shouldReceiveTouch:touch];
    else
        return YES;
}

@end
