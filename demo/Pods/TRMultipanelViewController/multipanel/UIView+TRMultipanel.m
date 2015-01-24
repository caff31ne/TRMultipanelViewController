//
//  UIView+TRMultipanel.m
//  Pods
//
//  Created by Vitaly on 1/24/15.
//
//

#import "UIView+TRMultipanel.h"

@implementation UIView (TRMultipanel)

- (void)tieToSuperview {
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:self.superview
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1
                                                                      constant:0];
    NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:self.superview
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:0];
    
    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:self.superview
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1
                                                                       constant:0];
    
    NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:self.superview
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1
                                                                        constant:0];
    
    [self.superview addConstraints:@[topConstraint, bottomConstraint, leftConstraint, rightConstraint]];
}


@end
