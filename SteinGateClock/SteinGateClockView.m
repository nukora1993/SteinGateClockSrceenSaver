//
//  SteinGateClockView.m
//  SteinGateClock
//
//  Created by nuko on 2020/10/28.
//  Copyright © 2020 nuko. All rights reserved.
//

#import "SteinGateClockView.h"
#import <Masonry/Masonry.h>

static const NSString *debugTag = @"SteinGateClock";

@interface SteinGateClockView ()
// 存储数字图片
@property (nonatomic) NSMutableDictionary *digitImageDict;
// 容器view
@property (nonatomic) NSView *clockView;
// 存储数字图片对应的image view
@property (nonatomic) NSMutableDictionary *digitImageViewDict;

@end

@implementation SteinGateClockView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    NSLog(@"%@ %@", debugTag, NSStringFromSelector(_cmd));
    NSLog(@"%@ %@ thread is:%@", debugTag, NSStringFromSelector(_cmd),NSThread.currentThread);
    self = [super initWithFrame:frame isPreview:isPreview];
    
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
        // 初始化dict
        self.digitImageDict = NSMutableDictionary.dictionary;
        self.digitImageViewDict = NSMutableDictionary.dictionary;
        // 初始化clock view
        self.clockView = [NSView new];
        // 读取读片，存储到字典，注意由于screen saver是作为插件运行的，所以不能使用main bundle
//        NSBundle *bundle = NSBundle.mainBundle;
        NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.nuko.SteinGateClock"];
        NSLog(@"%@ bundle.bundlePath: %@",debugTag, bundle.bundlePath);
        // 0到9是正常数字，10是全暗，11是右点，12是左点
        for (int i = 0; i <=12; i++) {
            NSString *imagePath = [bundle pathForResource:[NSString stringWithFormat:@"%d", i] ofType:@"png"];
//            NSLog(@"%@ imagePath:%@", debugTag, imagePath);
            NSImage *digitImage = [[NSImage alloc] initWithContentsOfFile:imagePath];
            
            [self.digitImageDict setObject:digitImage forKey:@(i)];
            
            
        }
        
        [self setupClockView];
        [self updateClockView];
        
    }
    
    return self;
}


// 初始化clock view
- (void)setupClockView{
    // 24小时制，创建8个image view
    for (int i = 0; i < 8; i++) {
        NSImageView *imageView = [NSImageView new];
        [self.digitImageViewDict setObject:imageView forKey:@(i)];
    }
    
    // 添加到container view
    // 注意添加masonry约束之前，必须将相对约束的对象添加到父view
    [self addSubview:self.clockView];
    
    // 设置container view
    // 不能使用约束，否则刚开始读取到的是宽高是0
//    [self.clockView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self);
//        make.width.mas_equalTo(@(1080));
//        make.height.mas_equalTo(@(720));
//    }];
    self.clockView.frame = self.bounds;
    
    
    

    
    // 设置每一个image view的约束
    for (int i = 0; i < 8; i++) {
        NSImageView *imageView = self.digitImageViewDict[@(i)];
        [self.clockView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.clockView.bounds.size.width / 8);
            make.height.mas_equalTo(self.clockView.bounds.size.height);
            make.left.mas_equalTo(self.clockView.bounds.size.width / 8 * i);
            make.top.mas_equalTo(self.clockView.mas_top);
        }];
    }
    
   

}

// 根据当前时间更新clock view
- (void)updateClockView{
    NSLog(@"%@ clock view: %@", debugTag, self.clockView);
    // 获取当前时间的各个数字
    // 当前时间
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要获取的信息
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int year = dateComponent.year;
    int month = dateComponent.month;
    int day = dateComponent.day;
    int hour = dateComponent.hour;
    int minute = dateComponent.minute;
    int second = dateComponent.second;
    
    int hour1 = hour / 10;
    int hour2 = hour % 10;
    
    int minute1 = minute / 10;
    int minute2 = minute % 10;
    
    int second1 = second / 10;
    int second2 = second % 10;
    
    for (int i = 0; i < 8; i++) {
        NSImageView *imageView = self.digitImageViewDict[@(i)];
        NSLog(@"%@ image view: %@", debugTag, imageView);
        if (i == 0) {
            imageView.image = self.digitImageDict[@(hour1)];
        }else if (i == 1){
            imageView.image = self.digitImageDict[@(hour2)];
        }else if (i == 2){
            imageView.image = self.digitImageDict[@(12)];
        }else if (i == 3){
            imageView.image = self.digitImageDict[@(minute1)];
        }else if (i == 4){
            imageView.image = self.digitImageDict[@(minute2)];
        }else if (i == 5){
            imageView.image = self.digitImageDict[@(12)];
        }else if (i == 6){
            imageView.image = self.digitImageDict[@(second1)];
        }else if (i == 7){
            imageView.image = self.digitImageDict[@(second2)];
        }else{
            NSLog(@"impossible");
        }
    }
    
    
    
}

- (void)startAnimation
{
    NSLog(@"%@ %@ thread is:%@", debugTag, NSStringFromSelector(_cmd),NSThread.currentThread);
    NSLog(@"%@ %@", debugTag, NSStringFromSelector(_cmd));
    [super startAnimation];
    
        
}

- (void)stopAnimation
{
    NSLog(@"%@ %@ thread is:%@", debugTag, NSStringFromSelector(_cmd),NSThread.currentThread);
    NSLog(@"%@ %@", debugTag, NSStringFromSelector(_cmd));
    [super stopAnimation];
    
}

- (void)drawRect:(NSRect)rect
{
    NSLog(@"%@ %@ thread is:%@", debugTag, NSStringFromSelector(_cmd),NSThread.currentThread);
    NSLog(@"%@ %@", debugTag, NSStringFromSelector(_cmd));
//    NSLog(@"%@ subviews:%@", debugTag, self.subviews);
    NSLog(@"%@ window:%@", debugTag, self.window);
    [super drawRect:rect];
    
}

// 按道理绘制每一帧的动作应该都是在这里，但是不知道为啥获取不到context
// 可以在这里调用setNeedsDisplay,让系统调用drawRect
- (void)animateOneFrame
{
    NSLog(@"%@ %@ thread is:%@", debugTag, NSStringFromSelector(_cmd),NSThread.currentThread);
    NSLog(@"%@ %@", debugTag, NSStringFromSelector(_cmd));
    [self updateClockView];
    
    return;
}

- (BOOL)hasConfigureSheet
{
    NSLog(@"%@ %@ thread is:%@", debugTag, NSStringFromSelector(_cmd),NSThread.currentThread);
    NSLog(@"%@ %@", debugTag, NSStringFromSelector(_cmd));
    return NO;
}

- (NSWindow*)configureSheet
{
    NSLog(@"%@ %@ thread is:%@", debugTag, NSStringFromSelector(_cmd),NSThread.currentThread);
    NSLog(@"%@ %@", debugTag, NSStringFromSelector(_cmd));
    return nil;
}

@end
