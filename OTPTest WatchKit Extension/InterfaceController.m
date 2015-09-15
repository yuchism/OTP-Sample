//
//  InterfaceController.m
//  OTPTest WatchKit Extension
//
//  Created by John Y on 10/09/2015.
//  Copyright (c) 2015 Yuch. All rights reserved.
//

#import "InterfaceController.h"
#import "OTPClient.h"
#import "AGTotp.h"
#import "AGBase32.h"

@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *lblRemain;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *lblPassword;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    AGTotp *client = [[AGTotp alloc] initWithSecret:[AGBase32 base32Decode:@"MZygpewJsCpRrfOr"]];

    [self.lblPassword setText:[client generateOTP]];

    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(_tick:) userInfo:nil repeats:YES];

    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void) _tick:(NSTimer *)timer
{
    AGTotp *client = [[AGTotp alloc] initWithSecret:[AGBase32 base32Decode:@"MZygpewJsCpRrfOr"]];
    [self.lblPassword setText:[client generateOTP]];

    NSString *str = [NSString stringWithFormat:@"%.2f Sec.",[self remainTime]];
    [self.lblRemain setText:str];

}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


- (NSTimeInterval)remainTime
{
    
    NSDate *now = [NSDate date];
    double refreshtime = 30.0;
    
    double sec = fmod([now timeIntervalSince1970], 60.0);
    double remainTime = refreshtime - (fmod(sec, refreshtime * 1.0));
    
    return remainTime;
}

@end



