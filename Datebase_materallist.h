//
//  Datebase_materallist.h
//  OralEdu
//
//  Created by 王俊钢 on 16/6/29.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "materal_finder.h"
#import "materal_model.h"
@interface Datebase_materallist : NSObject
+(void)savematerallist:(materal_finder *)materallist;
+(void)updatematerallist:(materal_finder *)materallist;
+(NSMutableArray*)readmaderallist;
+(void)deletematerallist:(NSString*)Id;



@end
