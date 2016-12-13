//
//  KSDrawView.h
//  Quartz2D练习
//
//  Created by Yans on 2016/12/13.
//  Copyright © 2016年 Yans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSDrawView : UIView

/**画笔线宽*/
@property (nonatomic, assign) CGFloat lineWidth;
/**画笔颜色*/
@property (nonatomic, strong) UIColor *lineColor;
/**画笔颜色*/
@property (nonatomic, strong) UIImage *chooseImage;

/*清屏*/
- (void)clear;
/*撤销*/
- (void)undo;
/*橡皮*/
- (void)eraser;
/*选照片*/
- (void)choosePhoto;
/*存图片*/
- (void)saveDraw;


@end
