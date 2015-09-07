//
//  OTPClient.m
//  OTPTest
//
//  Created by John Y on 7/09/2015.
//  Copyright (c) 2015 Yuch. All rights reserved.
//

#import "OTPClient.h"
#import "AGTotp.h"
#import "AGBase32.h"


NSInteger const refreshtime = 30;

#define kDefaultSecret @"MZygpewJsCpRrfOr"

@interface OTPClient()
{
    NSTimer *_timer;
    AGTotp *_totp;
    NSString *_secret;
}
@property(nonatomic,strong,readwrite) NSString *secret;
@end


@implementation OTPClient

+ (instancetype)sharedInstance
{
    static OTPClient *g_OTPClientSharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_OTPClientSharedInstance = [[OTPClient alloc] init];
    });
    
    return g_OTPClientSharedInstance;
}

- (instancetype)initWithSecret:(NSString *)secret
{
    self = [super init];
    if(self)
    {
        self.secret = secret;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithSecret:kDefaultSecret];
}

- (NSString *)generate
{
    NSString *otp = [_totp generateOTP];
    return otp;
}

- (void)setSecret:(NSString *)secret
{
    _secret = secret;
    _totp = [[AGTotp alloc] initWithSecret:[AGBase32 base32Decode:_secret]];
    [self _startTimer];
}

- (void)_startTimer
{
    [self _stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    
}

- (void)_stopTimer
{
    if(_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)tick:(NSTimer *)timer
{
    NSString *otp = [self generate];
    NSTimeInterval remainTime = [self remainTime];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(weakSelf.didGenerated)
        {
            
            weakSelf.didGenerated(otp,remainTime);
        }
    });
}

- (NSTimeInterval)remainTime
{
    
    NSDate *now = [NSDate date];
    
    double sec = fmod([now timeIntervalSince1970], 60.0);
    double remainTime = refreshtime - (fmod(sec, refreshtime * 1.0));
    
    return remainTime;
}

@end

