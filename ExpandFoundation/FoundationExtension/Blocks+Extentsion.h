/*
 *  ExpandFoundation
 *  Blocks+Extentsion.h
 *
 *  Created by apple on 2017/8/17
 *  Copyright © 2017年 zoufuqiang. All rights reserved.
 *
 *  描述: <描述>
 *
 */

#ifndef ExpandFoundation_Blocks_Extentsion_h_
#define ExpandFoundation_Blocks_Extentsion_h_

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

typedef void(^CommonVoidBlock)(void);
typedef void(^CommonObjectBlock)(id obj);
typedef void(^CommonErrorBlock)(NSError *error);

@interface BlockStatus : NSObject

@property (assign, getter = isCancelled) BOOL cancel;

@end

typedef void(^BlockStatus_t)(BlockStatus *blockStatus);
BlockStatus* dispatch_async_with_status(dispatch_queue_t queue, BlockStatus_t block);

#endif
