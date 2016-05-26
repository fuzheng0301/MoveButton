//
//  PTSingletonManager.m
//  iPos
//
//  Created by fuzheng on 16-5-26.
//  Copyright © 2016年 付正. All rights reserved.
//

#import "PTSingletonManager.h"

@implementation PTSingletonManager

+(PTSingletonManager *)shareInstance
{
    static PTSingletonManager * singletonManager = nil;
    @synchronized(self){
        if (!singletonManager) {
            singletonManager = [[PTSingletonManager alloc]init];
        }
    }
    return singletonManager;
}

@end
