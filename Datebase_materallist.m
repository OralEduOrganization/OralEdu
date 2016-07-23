//
//  Datebase_materallist.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/29.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "Datebase_materallist.h"
#import "FMDatabase.h"
@implementation Datebase_materallist

//创建数据库

+(FMDatabase*)getDatebase
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSLog(@"docDir = %@",docDir);
    
    NSString *dateBasePath = [docDir stringByAppendingPathComponent:@"Datebase_materal.db"];
    //操作本地文件
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if (![filemanager fileExistsAtPath:dateBasePath])
    {
        //创建数据库
        FMDatabase *db = [[FMDatabase alloc] initWithPath:dateBasePath];
        if (db ==nil) {
            NSLog(@"createDate error! %@",[db lastErrorMessage]);
        }
        if([db open])
        {
            //创建数据表
            NSString *sql = @"create table if not exists Datebase_materallist_info(materallist_id varchar , materallist_name varchar primary key)";
            NSString *sql2 = @"create table if not exists Datebase_details_info(materal_id varchar , materal_name varchar ,materal_imagepath varchar primary key,materal_time varchar)";
            
            if (![db executeUpdate:sql]) {
                NSLog(@"create table error :%@",[db lastErrorMessage]);
            }
            if (![db executeUpdate:sql2]) {
                NSLog(@"create table error :%@",[db lastErrorMessage]);
            }

            [db close];
        }
        else
        {
            NSLog(@"openDate error! %@",[db lastErrorMessage]);
            
        }
    }
    FMDatabase *db = [[FMDatabase alloc] initWithPath:dateBasePath];
    return db;
    
    
}

+(void)savematerallist:(materal_finder *)materallist
{
    FMDatabase *db = [self getDatebase];
    [db open];
    NSString *sql = @"insert into Datebase_materallist_info(materallist_id,materallist_name)values(?,?)";
    
    if(![db executeUpdate:sql withArgumentsInArray:@[materallist.materal_finder_id,materallist.materal_finder_name]])
    {
        NSLog(@"saveDate error :%@",[db lastErrorMessage]);
    }
    [db close];
}
//更新数据
+(void)updatematerallist:(materal_finder *)materallist
{
    FMDatabase *db = [self getDatebase];
    [db open];
    NSString *sql = @"update Datebase_materallist_info set materallist_id = ?,materallist_name = ?  where materallist_id = ?";
    
    if(![db executeUpdate:sql withArgumentsInArray:@[materallist.materal_finder_id,materallist.materal_finder_name]])
    {
        NSLog(@"update Date error :%@",[db lastErrorMessage]);
    }
    [db close];
}
//读取数据
+(NSMutableArray*)readmaderallist
{
    
    FMDatabase *db = [self getDatebase];
    [db open];
    FMResultSet *set = [db executeQuery:@"select materallist_name from Datebase_materallist_info"];
    NSMutableArray *listArr = [NSMutableArray array];
    while ([set next]) {
        materal_finder *list = [[materal_finder alloc] init];
        //list.materal_finder_id= [set stringForColumn:@"materallist_id"];
        list.materal_finder_name = [set stringForColumn:@"materallist_name"];
        [listArr addObject:list];
    }
    [db close];
    NSLog(@"stu = %@",listArr);
    return listArr;
}

//删除数据

+(void)deletematerallist:(NSString*)name
{
    FMDatabase *db = [self getDatebase];
    [db open];
    NSString *sql = @"delete from Datebase_materallist_info where materallist_name = ?";
    
    if(![db executeUpdate:sql withArgumentsInArray:@[name]])
    {
        NSLog(@"delete Date error :%@",[db lastErrorMessage]);
    }
    [db close];
}




+(void)savemateraldetails:(materal_model *)details
{
    FMDatabase *db = [self getDatebase];
    [db open];
    NSString *sql = @"insert into Datebase_details_info(materal_id,materal_name,materal_imagepath,materal_time)values(?,?,?,?)";
    
    if(![db executeUpdate:sql withArgumentsInArray:@[details.materal_id,details.materal_name,details.materal_imagepath,details.materal_time]])
    {
        NSLog(@"saveDate error :%@",[db lastErrorMessage]);
    }
    [db close];
}

//更新数据

+(void)updatemateraldetails:(materal_model *)details
{
    FMDatabase *db = [self getDatebase];
    [db open];
    NSString *sql2 = @"update Datebase_details_info set materal_id = ?,materal_name = ?,materal_imagepath = ?, materal_time = ? where user_id = ?";
    
    if(![db executeUpdate:sql2 withArgumentsInArray:@[details.materal_id,details.materal_name,details.materal_imagepath,details.materal_imagepath,details.materal_id]])
    {
        NSLog(@"update Date error :%@",[db lastErrorMessage]);
    }
    [db close];
}



//读取数据
+(NSMutableArray*)readmateraldetailsWithuser_id:(NSString *)user_id Name:(NSString *)path_name
{
    
    FMDatabase *db = [self getDatebase];
    [db open];
    
    NSString *sql=[NSString stringWithFormat:@"select * from Datebase_details_info where materal_id = '%@' and materal_name = '%@'",user_id,path_name];
    
    FMResultSet *set = [db executeQuery:sql];
    NSMutableArray *detailsArr = [NSMutableArray array];
    while ([set next]) {
        materal_model *detail = [[materal_model alloc] init];
        detail.materal_id = [set stringForColumn:@"materal_id"];
        detail.materal_name = [set stringForColumn:@"materal_name"];
        detail.materal_imagepath = [set stringForColumn:@"materal_imagepath"];
        detail.materal_time = [set stringForColumn:@"materal_time"];
        [detailsArr addObject:detail];
    }
    [db close];
    NSLog(@"stu = %@",detailsArr);
    return detailsArr;
    
}

//删除数据

+(void)deletemateraldetails:(NSString*)materal_imagepath
{
    FMDatabase *db = [self getDatebase];
    [db open];
    NSString *sql = @"delete from Datebase_details_info where materal_imagepath = ?";
    
    if(![db executeUpdate:sql withArgumentsInArray:@[materal_imagepath]])
    {
        NSLog(@"delete Date error :%@",[db lastErrorMessage]);
    }
    [db close];
}


@end
