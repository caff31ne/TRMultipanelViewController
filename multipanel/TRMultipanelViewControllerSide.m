//
//  TRMultipanelViewControllerSide.m
//  tvoirecepty
//
//  Created by Vitaly on 1/17/15.
//  Copyright (c) 2015 tvoirecepty. All rights reserved.
//

#import "TRMultipanelViewControllerSide.h"
#import "TRMultipanelViewController.h"

#import "UIView+TRMultipanel.h"

static const int TRPanActionThreshold = 100;

@interface TRMultipanelViewControllerSide () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) UIViewController* container;
@property (assign, nonatomic) NSLayoutAttribute boundaryConnectionAttribute;

@property (nonatomic, strong) NSLayoutConstraint* positionConstraint;
@property (nonatomic, strong) NSLayoutConstraint* widthConstraint;

@end

@implementation TRMultipanelViewControllerSide

- (instancetype)initWithContainer:(TRMultipanelViewController*)container
      boundaryConnectionAttribute:(NSLayoutAttribute)boundaryConnectionAttribute
                            width:(CGFloat)width
{
    self = [super init];
    if (self) {
        self.container = container;
        self.boundaryConnectionAttribute = boundaryConnectionAttribute;
        self.width = width;
        self.view = [[UIView alloc] init];
    }
    return self;
}

- (void)setView:(UIView*)view {
    if (_view != view) {
        if (_view)
            [_view removeFromSuperview];
        _view = view;
        
        if (_view)
            [self addViewToContainer];
    }
}

- (void)setWidth:(CGFloat)width {
    if (_width != width) {
        _width = width;
        
        if (self.widthConstraint) {
            self.widthConstraint.constant = width;
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        }
    }
}

- (void)setContentController:(UIViewController *)contentController {
    if (_contentController != contentController) {
        if (_contentController) {
            [_contentController.view removeFromSuperview];
            [_contentController removeFromParentViewController];
        }
        
        _contentController = contentController;
        
        if (_contentController) {
            _contentController.view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.container addChildViewController:_contentController];
            [self.view addSubview:_contentController.view];
            [_contentController.view tieToSuperview];
            [_contentController.view setNeedsLayout];
            [_contentController.view layoutIfNeeded];
        }
    }
}

- (NSArray*)viewSequenceWithView:(UIView*)view
              forLayoutAttribute:(NSLayoutAttribute)attribute
{
    if (attribute == NSLayoutAttributeTrailing) {
        return @[view.superview, view];
    } else {
        return @[view, view.superview];
    }
}

- (void)addViewToContainer {
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.container.view addSubview:self.view];
    
    self.widthConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:self.width];
    
    NSArray* views = [self viewSequenceWithView:self.view
                             forLayoutAttribute:self.boundaryConnectionAttribute];
    
    self.positionConstraint = [NSLayoutConstraint constraintWithItem:[views objectAtIndex:0]
                                                           attribute:self.boundaryConnectionAttribute
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:[views objectAtIndex:1]
                                                           attribute:self.boundaryConnectionAttribute
                                                          multiplier:1
                                                            constant:0];
    
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.container.view
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:0];
    
    NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.container.view
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:0];
    
    [self.view addConstraint:self.widthConstraint];
    [self.container.view addConstraints:@[topConstraint, bottomConstraint, self.positionConstraint]];
    
    [self addGestureRecognizer];
}

- (void)addGestureRecognizer {
    UIPanGestureRecognizer* gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    gestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (CGFloat)applyTranslation:(UIPanGestureRecognizer*)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:self.container.view];
    
    switch (self.boundaryConnectionAttribute) {
        case NSLayoutAttributeLeading:
            if (translation.x < 0) {
                self.positionConstraint.constant = translation.x;
            }
            break;
        case NSLayoutAttributeTrailing:
            if (translation.x > 0) {
                self.positionConstraint.constant = -translation.x;
            }
            break;
        default:
            break;
    }
    return self.positionConstraint.constant;
}

- (void)onPan:(UIPanGestureRecognizer*)gestureRecognizer {
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            [self applyTranslation:gestureRecognizer];
            break;
        case UIGestureRecognizerStateEnded:
            if (self.width - [self applyTranslation:gestureRecognizer] > TRPanActionThreshold) {
                [self.delegate multipanelSideDidPanOutside:self];
            } else {
                self.positionConstraint.constant = 0;
            }
            break;
        default:
            break;
    }
}

- (BOOL)visible {
    return self.positionConstraint.constant != -self.width;
}

- (void)setVisible:(BOOL)visible {
    if (visible) {
        self.positionConstraint.constant = 0;
    } else {
        self.positionConstraint.constant = -self.width;
    }
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return [self.delegate multipanelSide:self shouldReceiveTouch:touch];
}

@end
