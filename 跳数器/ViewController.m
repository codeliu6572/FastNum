//
//  ViewController.m
//  跳数器
//
//  Created by 刘浩浩 on 2016/12/26.
//  Copyright © 2016年 CodingFire. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *countJump;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    _countJump = [[UILabel alloc]initWithFrame:self.view.bounds];
    _countJump.backgroundColor = [UIColor orangeColor];
    _countJump.text = @"00000";
    _countJump.textAlignment = NSTextAlignmentCenter;
    _countJump.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:_countJump];
    
    [self countJumpAction];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self countJumpAction];
}
- (void)countJumpAction
{

    
    
    __block int _numText = 0;
    //全局队列    默认优先级
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时器模式  事件源
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    //NSEC_PER_SEC是秒，＊1是每秒
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 0.00003, 0);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(timer, ^{
        //回调主线程，在主线程中操作UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_numText <= 9999) {
                _countJump.text = [NSString stringWithFormat:@"%.5d",_numText];
                _numText++;

            }
            else
            {
                //这句话必须写否则会出问题
                dispatch_source_cancel(timer);
                _countJump.text = @"98461";
            }
        });
    });
    //启动源
    dispatch_resume(timer);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
