//
//  KSDrawView.m
//  Quartz2D练习
//
//  Created by Yans on 2016/12/13.
//  Copyright © 2016年 Yans. All rights reserved.
//

#import "KSDrawView.h"
#import "KSBezierPath.h"

@interface KSDrawView () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/**存放手绘路径*/
@property (nonatomic, strong) NSMutableArray *paths;
/**单个路径*/
@property (nonatomic, strong) KSBezierPath *path;

@end


@implementation KSDrawView

#pragma mark - 初始化
- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self setUp];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        [self setUp];
    }
    
    return self;
}

- (void)setUp {
    
    self.backgroundColor = [UIColor whiteColor];
    
    _lineColor = [UIColor blackColor];
    _lineWidth = 2;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:pan];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)paths {
    
    if (_paths == nil) {
        
        _paths = [NSMutableArray array];
    }
    return _paths;
}

#pragma mark - set方法
- (void)setChooseImage:(UIImage *)chooseImage {
    
    _chooseImage = chooseImage;
    
    [self.paths addObject:_chooseImage];
    
    [self setNeedsDisplay];
}

#pragma mark - 以下是动作函数
#pragma mark 滑动手势
- (void)panAction:(UIPanGestureRecognizer *)pan {
    
    CGPoint curPoint = [pan locationInView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        _path = [KSBezierPath ksBezierPath];
        _path.lineWidth = _lineWidth;
        _path.lineColor = _lineColor;
        [_path moveToPoint:curPoint];
        
        [self.paths addObject:_path];

    } else if (pan.state == UIGestureRecognizerStateChanged) {
        
        [_path addLineToPoint:curPoint];
        [self setNeedsDisplay];
        
    }
}

#pragma mark 清屏
- (void)clear {
    
    [self.paths removeAllObjects];
    
    [self setNeedsDisplay];
}

#pragma mark 撤销
- (void)undo {
    
    if (self.paths != nil) {
        
        [self.paths removeLastObject];
        
        [self setNeedsDisplay];
    }
}

#pragma mark 橡皮
- (void)eraser {
    
    if (_paths == nil) {
        return;
    }
    
    _lineColor = self.backgroundColor;
}

#pragma mark 选照片
- (void)choosePhoto {
    
    if (_paths != nil) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"现在画板上有数据,请问是否要删除" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

            [self clear];
            [self openPhotoLibrary];
        }];

        [alertVC addAction:cancel];
        [alertVC addAction:delete];

        [[self viewController] presentViewController:alertVC animated:YES completion:nil];

    } else {
        
        [self openPhotoLibrary];
    }
}

#pragma mark 存图片
- (void)saveDraw {
    
    if (_paths != nil) {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.layer renderInContext:context];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // 保存画板的内容放入相册
        // image:写入的图片
        // completionTarget图片保存监听者
        // 注意：以后写入相册方法中，想要监听图片有没有保存完成，保存完成的方法不能随意乱写
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"保存图片成功");
}


#pragma mark - 打开相册
- (void)openPhotoLibrary {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [[self viewController] presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
    
    self.chooseImage = pickImage;
    
    [[self viewController] dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 绘图
- (void)drawRect:(CGRect)rect {
    
    for (KSBezierPath *path in _paths) {
        
        if ([path isKindOfClass:[UIImage class]]) {
            
            UIImage *image = (UIImage *)path;
            [image drawInRect:rect];
            
        } else {
            
            [path.lineColor set];
            [path stroke];
        }
        
    }
}

#pragma mark - 找到该控件所在的控制器
/*找到该控件所在的控制器*/
- (UIViewController *)viewController {
    
    for (UIView *next = [self superview]; next; next = next.superview) {
        
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
