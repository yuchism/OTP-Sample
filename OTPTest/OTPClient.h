//
//  OTPClient.h
//  OTPTest
//
//  Created by John Y on 7/09/2015.
//  Copyright (c) 2015 Yuch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTPClient : NSObject



+ (instancetype) sharedInstance;
- (NSString *)generate;
- (NSTimeInterval)remainTime;


@property(nonatomic,strong,readonly) NSString *secret;
@property(nonatomic,copy) void(^didGenerated)(NSString *pwd,NSTimeInterval remainSec);
@end
