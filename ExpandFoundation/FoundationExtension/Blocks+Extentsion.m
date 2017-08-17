/*
 *  ExpandFoundation
 *  Blocks+Extentsion.m
 *
 *  Created by apple on 2017/8/17
 *  Copyright © 2017年 zoufuqiang. All rights reserved.
 *
 *  描述: <描述>
 *
 */

#import "Blocks+Extentsion.h"

@implementation BlockStatus

@end


BlockStatus* dispatch_async_with_status(dispatch_queue_t queue, BlockStatus_t block) {
    BlockStatus *status = [[BlockStatus alloc] init];
    dispatch_sync(queue, ^{
        if (block == nil) {
            return;
        }
        
        block(status);
    });
    return status;
}
