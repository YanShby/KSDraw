//
//  KSDrawViewController.m
//  Quartz2D练习
//
//  Created by Yans on 2016/12/13.
//  Copyright © 2016年 Yans. All rights reserved.
//

#import "KSDrawViewController.h"
#import "KSDrawView.h"

@interface KSDrawViewController ()

/*画板*/
@property (weak, nonatomic) IBOutlet KSDrawView *drawView;

@end

@implementation KSDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 动作函数
- (IBAction)clear:(id)sender {
    
    [_drawView clear];
}

- (IBAction)undo:(id)sender {
    
    [_drawView undo];
}

- (IBAction)eraser:(id)sender {
    
    [_drawView eraser];
}

- (IBAction)openPhoto:(id)sender {
    
    [_drawView choosePhoto];

}

- (IBAction)saveDraw:(id)sender {
    
    [_drawView saveDraw];
}

- (IBAction)lineWidth:(UISlider *)sender {
    
    _drawView.lineWidth = sender.value;
}

- (IBAction)lineColor:(UIButton *)sender {
    
    _drawView.lineColor = sender.backgroundColor;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
