//
//  XHPanGestureRecognizer.m
//  Pods-XHBrowseView_Example
//
//  Created by 郑信鸿 on 2019/1/8.
//

#import "XHPanGestureRecognizer.h"

@interface XHPanGestureRecognizer ()

@property (nonatomic, assign)BOOL drag;/**<#注释#>**/

@property (nonatomic, assign)int moveX;/**<#注释#>**/

@property (nonatomic, assign)int moveY;/**<#注释#>**/

@end

@implementation XHPanGestureRecognizer

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    _moveX += prevPoint.x - nowPoint.x;
    _moveY += prevPoint.y - nowPoint.y;
    if (!_drag) {
        if (abs(_moveX) == 0 && abs(_moveY) == 0) {
            self.drag = NO;
        }else{
            if (abs(_moveX) / abs(_moveY) > 0.5 || abs(_moveY) == 0) {
                self.state = UIGestureRecognizerStateFailed;
            }else{
                self.drag = YES;
            }
        }
    }

}

- (void)reset {
    [super reset];
    _drag = NO;
    _moveX = 0;
    _moveY = 0;
}

@end
