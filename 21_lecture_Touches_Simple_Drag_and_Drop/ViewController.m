//
//  ViewController.m
//  21_lecture_Touches_Simple_Drag_and_Drop
//
//  Created by Slava on 13.04.17.
//  Copyright © 2017 Slava. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
//@property (weak, nonatomic) UIView *testView; // 26 строка
@property (weak, nonatomic) UIView *draggingView;
@property (assign, nonatomic) CGPoint  touchOffset;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i = 0; i < 8; i++) {
        UIView *rectView = [[UIView alloc] initWithFrame:CGRectMake(10 + 110 * i, 100, 100, 100)];
        [self.view addSubview:rectView];
        rectView.backgroundColor = [self randomColor];
    }
    
    
    // активируем мультитач
//    self.view.multipleTouchEnabled = YES;
    
//    self.testView = rectView; // 50 строка
}

- (UIColor *) randomColor {
    CGFloat r = (float)(arc4random() % 256) / 255;
    CGFloat g = (float)(arc4random() % 256) / 255;
    CGFloat b = (float)(arc4random() % 256) / 255;
    UIColor *randColor = [UIColor colorWithRed:r
                                         green:g
                                          blue:b
                                         alpha:1];
    return randColor;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) logTouches:(NSSet *)touches withMethod:(NSString *)methodName {
    NSMutableString *mutableString = [NSMutableString stringWithString:methodName]; // изменяемая строка в которую передается имя метода
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self.view];   // находим точки с помошью locationInView
        [mutableString appendFormat:@" %@", NSStringFromCGPoint(point)];    // добовляем строки
    }
    NSLog(@"%@", mutableString);
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
//    NSLog(@"touchesBegan");
    [self logTouches:touches withMethod:@"touchesBegan"];
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self.testView];
//    NSLog(@"inside =  %d", [self.testView pointInside:point withEvent:event]);
    
    UITouch *touch = [touches anyObject];
    CGPoint pointOnMainView = [touch locationInView:self.view];
    UIView *view = [self.view hitTest:pointOnMainView withEvent:event];
    if (![view isEqual:self.view]) { // низя сравнивать объекты (== таким образом сравниваются примитивы)
        self.draggingView = view;
        [self.view bringSubviewToFront:self.draggingView];
        CGPoint touchPoint = [touch locationInView:self.draggingView];
        self.touchOffset = CGPointMake(CGRectGetMidX(self.draggingView.bounds) - touchPoint.x,
                                       CGRectGetMidY(self.draggingView.bounds) - touchPoint.y);
        
//        [self.draggingView.layer removeAllAnimations]; // отменяем анимацию
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.draggingView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                             self.draggingView.alpha = 0.3;
                         } completion:^(BOOL finished) {
                             //
                         }];
    } else {
        self.draggingView = nil;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *) event {
//    NSLog(@"touchesMoved");
    [self logTouches:touches withMethod:@"touchesMoved"];
    if (self.draggingView) {
        UITouch *touch = [touches anyObject];
        CGPoint pointOnMainView = [touch locationInView:self.view];
        CGPoint correction = CGPointMake(pointOnMainView.x + self.touchOffset.x,
                                         pointOnMainView.y + self.touchOffset.y);
        self.draggingView.center = correction;
    }
}

- (void) onTouchIsEnded {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.draggingView.transform = CGAffineTransformIdentity;
                         self.draggingView.alpha = 1;
                     } completion:^(BOOL finished) {
                         //
                     }];
    self.draggingView = nil;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
//    NSLog(@"touchesEnded");
    [self logTouches:touches withMethod:@"touchesEnded"];
    [self onTouchIsEnded];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
//    NSLog(@"touchetouchesCancelledsBegan");
    [self logTouches:touches withMethod:@"touchesCancelled"];
    [self onTouchIsEnded];
}



@end
