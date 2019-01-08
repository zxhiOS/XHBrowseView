//
//  XHPanGestureRecognizer.m
//  Pods-XHBrowseView_Example
//
//  Created by 郑信鸿 on 2019/1/8.
//

#import "XHPanGestureRecognizer.h"

CGFloat const gestureMinimumTranslation = 20.0;

typedef enum :NSInteger {
    kCameraMoveDirectionNone,
    kCameraMoveDirectionUp,
    kCameraMoveDirectionDown,
    kCameraMoveDirectionRight,
    kCameraMoveDirectionLeft
    
} CameraMoveDirection;

@interface XHPanGestureRecognizer ()

//@property (nonatomic, assign) DirectionPangestureRecognizerDirection direction;

@property (nonatomic, assign)BOOL drag;/**<#注释#>**/

@property (nonatomic, assign)int moveX;/**<#注释#>**/

@property (nonatomic, assign)int moveY;/**<#注释#>**/

@property (nonatomic, assign)BOOL startMove;/**<#注释#>**/

@end

@implementation XHPanGestureRecognizer



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    _moveX += prevPoint.x - nowPoint.x;
    _moveY += prevPoint.y - nowPoint.y;
    NSLog(@"%d ---- %d",_moveX,_moveY);
    if (!_drag) {
        if (abs(_moveX) == 0 && abs(_moveY) == 0) {
            self.drag = NO;
        }else{
            if (abs(_moveX) / abs(_moveY) > 0.5 || abs(_moveY) == 0) {
                self.state = UIGestureRecognizerStateFailed;
                NSLog(@"手势失败");
            }else{
                NSLog(@"手势成功");
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
