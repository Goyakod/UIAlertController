//
//  ViewController.m
//  ScanBar
//
//  Created by pro on 16/1/20.
//  Copyright © 2016年 vickyTest. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake((self.view.frame.size.width-200)/2, (self.view.frame.size.height-100)/2, 200, 100)];
    [button setTitle:@"我是按钮" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:115.0 / 255.0 green:198.0 / 255.0 blue:190.0 / 255.0 alpha:1.0]];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 10;
    [self.view addSubview:button];

    
    
}

- (IBAction)buttonPress:(UIButton *)sender {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示:" message:@"I am message..." preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"default0" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"action 0 selected");
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"default1" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"action 1 selected");
    }];
    
    //UIAlertController弹出框默认取消了Cancel样式的Action，因为用户通过点击弹出框外围区域即可取消弹出框，所以不再需要了。
    //由于上面的原因，action2虽然添加了，但是并不显示。
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"action Cancel selected");
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Destructive" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"action Destructive selected");
    }];
    
    [alertVC addAction:action0];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [alertVC addAction:action3];
    
     
    //在iphone上或者其他紧缩宽度的设备上，UIAlertControllerStyleActionSheet样式可以正常显示，但是如果是在iPad上或者常规宽度的设备上，不添加UIPopoverPresentationController，就会报如下一个错误：
    /*
     Your application has presented a UIAlertController (<UIAlertController: 0x16e2dc70>) of style UIAlertControllerStyleActionSheet. The modalPresentationStyle of a UIAlertController with this style is UIModalPresentationPopover. You must provide location information for this popover through the alert controller's popoverPresentationController. You must provide either a sourceView and sourceRect or a barButtonItem.  If this information is not known when you present the alert controller, you may provide it in the UIPopoverPresentationControllerDelegate method -prepareForPopoverPresentation.
     */
    //因为弹出框必须要有一个能够作为源视图或者栏按钮项目的描点(anchor point)。
    //由于在本例中我们是使用了常规的UIButton来触发上拉菜单的，因此我们就将其作为描点。
    
    
    UIPopoverPresentationController *popover = alertVC.popoverPresentationController;
    if (popover) {
        popover.sourceView = sender;
        popover.sourceRect = sender.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

//    ScanBarCodeViewController *scanBarCodeVC = [[ScanBarCodeViewController alloc] init];
//    scanBarCodeVC.delegate = self;
//    [self presentViewController:scanBarCodeVC animated:YES completion:nil];

//#pragma mark scanBar Delegate 
//- (void)scanCallback:(NSString *)dimensionCode
//{
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示:" message:dimensionCode preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"action Destructive selected");
//    }];
//    
//    [alertVC addAction:action];
//    
//    [self presentViewController:alertVC animated:YES completion:nil];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
