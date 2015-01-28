//
//  TRMultipanelViewControllerSide.h
//  Created by Vitali Bondur on 1/17/15.
//

#import <Foundation/Foundation.h>

@class TRMultipanelViewController;
@class TRMultipanelViewControllerSide;

@protocol TRMultipanelViewControllerSideDelegate <NSObject>

- (void)multipanelSideDidPanOutside:(TRMultipanelViewControllerSide*)side;
- (BOOL)multipanelSide:(TRMultipanelViewControllerSide*)side shouldReceiveTouch:(UITouch *)touch;

@end

@interface TRMultipanelViewControllerSide : NSObject

@property (weak, nonatomic) id<TRMultipanelViewControllerSideDelegate> delegate;
@property (strong, nonatomic) UIViewController* contentController;
@property (assign, nonatomic) BOOL visible;
@property (assign, nonatomic) CGFloat width;
@property (strong, nonatomic) UIView* view;
@property (weak, nonatomic) NSLayoutConstraint* centerEdgeConstraint;

- (instancetype)initWithContainer:(TRMultipanelViewController*)container
      boundaryConnectionAttribute:(NSLayoutAttribute)boundaryConnectionAttribute
                            width:(CGFloat)width;

@end
