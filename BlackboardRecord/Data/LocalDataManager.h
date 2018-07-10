//
//  LocalDataManager.h
//  BlackboardRecord
//
//  Created by lyons on 2018/7/6.
//  Copyright © 2018年 lyons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoModel.h"
#import "FMDatabase.h"

@interface LocalDataManager : FMDatabase

+(instancetype)shareLocalReceiptSingleton;

-(BOOL)addReceiptToLocal:(VideoModel *)video;

-(BOOL)removeReceipt:(NSInteger)idNum;

-(void)executeAllReceipt;

-(NSArray *)getVideoList;

@end
