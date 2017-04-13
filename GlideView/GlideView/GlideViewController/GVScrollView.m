//
//  GVScrollView.m
//  GlideView
//
//  Created by GuillermoD on 8/3/16.
//  Copyright © 2017. All rights reserved.
//

#import "GVScrollView.h"

@interface GVScrollView() <UIScrollViewDelegate>

@property (nonatomic) NSUInteger offsetIndex;
@property (nonatomic) BOOL isOpen;
@property (nonatomic) UIView *container;

@end

#define kDefaultMargin 20

#define kAniDuration 0.3
#define kAniDelay 0.0
#define kAniDamping 0.7
#define kAniVelocity 0.6

@implementation GVScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeByDefault];
    }
    
    return self;
}

- (void)initializeByDefault {
    
    self.margin = kDefaultMargin;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;

    [self setBounces:NO];
    [self setDirectionalLockEnabled:YES];
    [self setScrollsToTop:NO];
    [self setPagingEnabled:NO];
    [self setContentInset:UIEdgeInsetsZero];
    [self setDecelerationRate:UIScrollViewDecelerationRateFast];
    
    [self setOrientationType:GVScrollViewOrientationRightToLeft];
}

#pragma mark - Public Methods

- (void)setContent:(UIView *)content {
    _content = content;

    if (!content && CGRectIsNull(content.frame)) {
        return;
    }
    
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.container = [UIView new];

    [self.container addSubview:_content];
    [self addSubview:self.container];

    self.container.translatesAutoresizingMaskIntoConstraints = NO;
    _content.translatesAutoresizingMaskIntoConstraints = NO;

    if (self.orientationType == GVScrollViewOrientationRightToLeft) {
                
        [self.container addConstraints:@[[NSLayoutConstraint constraintWithItem:_content  attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.container attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0],
                                    [NSLayoutConstraint constraintWithItem:_content  attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.container   attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0],
                                    [NSLayoutConstraint constraintWithItem:_content  attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.container   attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0],
                                    
                                    [NSLayoutConstraint constraintWithItem:_content  attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil      attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:CGRectGetWidth(_content.frame)]]];
        
        [self addConstraints:@[[NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
                                                               toItem:self      attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0],
                               [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                                                               toItem:self      attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0],
                               [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                               toItem:self      attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0],
                               [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                                                               toItem:self      attribute:NSLayoutAttributeWidth multiplier:1.0 constant:CGRectGetWidth(_content.frame)]]];
    }
    else if (self.orientationType == GVScrollViewOrientationBottomToTop) {
        
        [self.container addConstraints:@[[NSLayoutConstraint constraintWithItem:_content  attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.container attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0],
                                    [NSLayoutConstraint constraintWithItem:_content  attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.container attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0],
                                    [NSLayoutConstraint constraintWithItem:_content  attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.container attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]]];

        [self addConstraints:@[[NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
                                                               toItem:self      attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0],
                               [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                                                               toItem:self      attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0],
                               [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                                                               toItem:self      attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]]];
        
        if (CGRectIsEmpty(_content.frame)) {
            [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_content attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                                   toItem:self     attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0],
                                   [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                                   toItem:self      attribute:NSLayoutAttributeHeight multiplier:2.0 constant:0.0]]];
        } else {
            [self.container addConstraint:[NSLayoutConstraint constraintWithItem:_content attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil      attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:CGRectGetHeight(_content.frame)]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                                toItem:self      attribute:NSLayoutAttributeHeight multiplier:1.0 constant:CGRectGetHeight(_content.frame)]];
        }
    }
    else if (self.orientationType == GVScrollViewOrientationTopToBottom) {
        
        [self.container addConstraints:@[[NSLayoutConstraint constraintWithItem:_content  attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.container attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0],
                                    [NSLayoutConstraint constraintWithItem:_content  attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.container attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0],
                                    [NSLayoutConstraint constraintWithItem:_content  attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.container attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]]];
        
        [self addConstraints:@[[NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
                                                               toItem:self      attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0],
                               [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                                                               toItem:self      attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0],
                               [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                                                               toItem:self      attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]]];
        
        if (CGRectIsEmpty(_content.frame)) {
            [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_content attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                                   toItem:self     attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0],
                                   [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                                   toItem:self      attribute:NSLayoutAttributeHeight multiplier:2.0 constant:0.0]]];
        } else {
            [self.container addConstraint:[NSLayoutConstraint constraintWithItem:_content attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil      attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:CGRectGetHeight(_content.frame)]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                                toItem:self      attribute:NSLayoutAttributeHeight multiplier:1.0 constant:CGRectGetHeight(_content.frame)]];
        }
    }
    else if (self.orientationType == GVScrollViewOrientationLeftToRight) {
        
    }
    
    [self layoutIfNeeded];
    [self recalculateContentSize];
}

- (void)setOffsets:(NSArray<NSNumber *> *)offsets {
    NSMutableArray *reversedOffsets = [NSMutableArray new];
    for (NSNumber *number in offsets) {
        if ([number floatValue] > 1.0) {
            [NSException raise:@"Invalid offset value" format:@"offset represents a %% of contentView to be shown i.e. 0.5 of a contentView of 100px will show 50px"];
        }
        else if (self.orientationType == GVScrollViewOrientationTopToBottom ||
                 self.orientationType == GVScrollViewOrientationLeftToRight) {
            [reversedOffsets addObject:@(1 - number.floatValue)];
        }
    }
    
    NSArray *newOffsets = [offsets sortedArrayUsingSelector: @selector(compare:)];
    
    if (reversedOffsets.count > 0) {
        newOffsets = [reversedOffsets sortedArrayUsingSelector: @selector(compare:)];
        newOffsets = [[newOffsets reverseObjectEnumerator] allObjects];
    }
    
    if (newOffsets && ![_offsets isEqualToArray:newOffsets]) {
        [self recalculateContentSize];
    }
    _offsets = newOffsets;

}

- (void)expandWithCompletion:(void (^)(BOOL finished))completion {
    NSUInteger nextIndex = (self.offsetIndex + 1 < [[self offsets] count]) ? self.offsetIndex + 1 : self.offsetIndex;
    [self changeOffsetTo:nextIndex animated:NO completion:completion];
}

- (void)collapseWithCompletion:(void (^)(BOOL finished))completion {

    NSUInteger nextIndex = self.offsetIndex - 1;
    [self changeOffsetTo:nextIndex animated:NO completion:completion];
}

- (void)closeWithCompletion:(void (^)(BOOL finished))completion {
    [self changeOffsetTo:0 animated:NO completion:completion];
}

- (void)changeOffsetTo:(NSUInteger)offsetIndex animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    self.panGestureRecognizer.enabled = NO;
    [UIView animateWithDuration:kAniDuration delay:kAniDelay usingSpringWithDamping:kAniDamping
          initialSpringVelocity:kAniVelocity options:UIViewAnimationOptionCurveEaseOut animations:^{
              
              if (self.orientationType == GVScrollViewOrientationLeftToRight ||
                  self.orientationType == GVScrollViewOrientationRightToLeft) {
                  
                  [self setContentOffset:CGPointMake([[self offsets] objectAtIndex:offsetIndex].floatValue * CGRectGetWidth(self.content.frame), self.contentOffset.y) animated:animated];
              }
              else if (self.orientationType == GVScrollViewOrientationBottomToTop ||
                       self.orientationType == GVScrollViewOrientationTopToBottom) {
                  
                  [self setContentOffset:CGPointMake(self.contentOffset.x, [[self offsets] objectAtIndex:offsetIndex].floatValue * CGRectGetHeight(self.content.frame)) animated:animated];
              }
          } completion:^(BOOL finished) {
              self.offsetIndex = offsetIndex;
              self.isOpen = (self.offsetIndex == 0) ? NO : YES;
              
              self.panGestureRecognizer.enabled = YES;
              
              if (completion) {
                  completion(finished);
              }
          }];
}

#pragma mark - Private methods

- (void)recalculateContentSize {
    CGSize size = self.container.frame.size;
    if (self.orientationType == GVScrollViewOrientationBottomToTop) {
        size.height += self.margin;
    }
    else if (self.orientationType == GVScrollViewOrientationRightToLeft) {
        size.width += self.margin;
    }

    [self setContentSize:size];
    [self layoutIfNeeded];
}

#pragma mark - touch handler

- (BOOL)viewContainsPoint:(CGPoint)point inView:(UIView *)content {
    if (CGRectContainsPoint(_content.frame, point)) {
        return YES;
    }

    if (self.selectContentSubViews) {
        for (UIView *subView in content.subviews) {
            if (CGRectContainsPoint(subView.frame, point)) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    
    if (_content && [self viewContainsPoint:point inView:_content]) {
        
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            
            CGPoint pt = CGPointMake(fabs(point.x), fabs(point.y));

            CGPoint convertedPoint = [subview convertPoint:pt fromView:self];
            UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
            
            if (hitTestView) {
                return hitTestView;
            }
        }
    }
    
    return nil;
}

@end
