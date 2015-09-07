//
//  ViewController.m
//  OTPTest
//
//  Created by John Y on 7/09/2015.
//  Copyright (c) 2015 Yuch. All rights reserved.
//

#import "ViewController.h"
#import "OTPClient.h"
@interface ViewController ()
{
    OTPClient *_otpClient;

}


@property (weak, nonatomic) IBOutlet UIProgressView *remainView;
@property (weak, nonatomic) IBOutlet UILabel *lblPwd;
@property (weak, nonatomic) IBOutlet UILabel *lblRemainTime;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _otpClient = [OTPClient sharedInstance];
    self.remainView.tintColor = [UIColor redColor];
    
    __weak typeof(self) weakSelf = self;

    self.lblPwd.text = [_otpClient generate];
    CGFloat progress = ([_otpClient remainTime] * 1.0)/30.0;
    
    self.remainView.progress = progress;
    
    _otpClient.didGenerated = ^(NSString *pwd,NSTimeInterval remainSec)
    {
        
        weakSelf.lblRemainTime.text = [NSString stringWithFormat:@"%.2f",remainSec];
        weakSelf.lblPwd.text = pwd;
        CGFloat progress = (remainSec * 1.0)/30.0;
        [weakSelf.remainView setProgress:progress animated:NO];
    };
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    

}

@end
