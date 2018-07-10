//
//  LocalDataManager.m
//  BlackboardRecord
//
//  Created by lyons on 2018/7/6.
//  Copyright © 2018年 lyons. All rights reserved.
//

#import "LocalDataManager.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
@interface LocalDataManager ()

@end

@implementation LocalDataManager
+(instancetype)shareLocalReceiptSingleton
{
    static LocalDataManager *userInfo=nil;;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo=[[self class] getReceiptFromLocal];
        if(userInfo==nil)
        {
            userInfo = [[[self class] alloc] init];
        }
    });
    return userInfo;
}

+(LocalDataManager *)getReceiptFromLocal
{
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"videoList.sqlite"];
    
    //2.获得数据库
    LocalDataManager *db = [LocalDataManager databaseWithPath:fileName];
    
    //3.使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。
    if ([db open])
    {
        //4.创表
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_videoList (id integer PRIMARY KEY AUTOINCREMENT, url text NOT NULL, name text NOT NULL, cover text NOT NULL);"];
        if (result)
        {
            NSLog(@"创建表成功");
        }
    }
    return db;
}

-(BOOL)addReceiptToLocal:(VideoModel *)video
{
    //1.executeUpdate:不确定的参数用？来占位（后面参数必须是oc对象，；代表语句结束）
    BOOL hasReceipt = [self executeUpdate:@"INSERT INTO t_videoList (url, name ,cover) VALUES (?,?,?);",video.url,video.name,video.cover];
    return hasReceipt;
}

-(BOOL)removeReceipt:(NSInteger)idNum
{
    //1.不确定的参数用？来占位 （后面参数必须是oc对象,需要将int包装成OC对象）
    BOOL hasRemove = [self executeUpdate:@"delete from t_videoList where id = ?;",@(idNum)];
    return hasRemove;
}

-(BOOL)updateReceipt:(NSInteger)idNum
{
    //修改标志位
    BOOL hasUpdate = [self executeUpdate:@"update t_videoList set isValidate=? where id=?",@(1),@(idNum)];
    return hasUpdate;
}

-(void)executeAllReceipt{
        //查询整个表
        FMResultSet *resultSet = [self executeQuery:@"select * from t_receipt where isValidate=0;"];
        //遍历结果集合
        while ([resultSet next])
        {
//            int idNum = [resultSet intForColumn:@"id"];
//            NSString *receipt = [resultSet objectForColumn:@"receipt"];
//            int productId = [resultSet intForColumn:@"productId"];
            //重新验证本地订单信息
//            WS(wself)
//            [NPRequestPayment requestApplePayValidateWithParams:@{@"productId":@(productId),@"receipt":receipt} AndResultBlock:^(NSString *myBalance) {
//                //TODO:更新该条数据isValidate为1，表示已经验证成功
//                //[wself removeReceipt:idNum];
//                [wself updateReceipt:idNum];
//            } AndErrorBlock:^(NPRequestError *error) {
//                DLog(@"");
//            }];
        }
}

- (NSArray *)getVideoList{
    FMResultSet *set = [self executeQuery:@"SELECT * FROM t_videoList"];
    NSMutableArray *array = [NSMutableArray new];
    while ([set next]) {
        VideoModel *video = [VideoModel new];
        video.url = [set stringForColumn:@"url"];
        video.name = [set stringForColumn:@"name"];
        video.cover = [set stringForColumn:@"cover"];
        [array addObject:video];
    }
    return array;
}
@end
