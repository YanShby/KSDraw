//
//  KSBezierPath.h
//  Quartz2D练习
//
//  Created by Yans on 2016/12/13.
//  Copyright © 2016年 Yans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSBezierPath : UIBezierPath

/*新增颜色*/
@property (nonatomic, strong) UIColor *lineColor;

+ (KSBezierPath *)ksBezierPath;

@end
