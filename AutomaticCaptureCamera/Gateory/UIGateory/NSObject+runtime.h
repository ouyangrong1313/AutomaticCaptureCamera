//
//  NSObject+runtime.h
//  小蚁学堂
//
//  Created by 刘辉 on 2022/3/22.
//  Copyright © 2022 Liew. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (runtime)

/* 获取对象的所有属性 */
+(NSArray *)getAllProperties;

/* 获取对象的所有方法 */
+(NSArray *)getAllMethods;

/* 获取对象的所有属性和属性内容 */
+ (NSDictionary *)getAllPropertiesAndVaules:(NSObject *)obj;

@end

NS_ASSUME_NONNULL_END
