//
//  ClassActions.h
//  私塾家
//
//  Created by liew on 2018/2/9.
//  Copyright © 2018年 Liew. All rights reserved.

#import <Foundation/Foundation.h>

@interface ClassActions : NSObject

/**
 * 判断 该类中有没存在该类方法 classInit 类名称对应的class selector 调用的类方法
 */
BOOL isExistClassMethodInClass(Class classInit,SEL selector);
/**
 * 判断 该类中有没存在该方法 classInit 类名称对应的class selector 调用方法
 */
BOOL isExistMethodInClass(Class classInit,SEL selector);
/**
 *  调用类方法  classInit 类名称对应的class selector 调用的类方法 object 参数  调用的方法返回值是id类型的  否则会崩
 */
id classMethodPerformInClss(Class classInit,SEL selector,id object);
/**
 *  调用类方法  classInit 类名称对应的class selector 调用的类方法 object 参数  调用的方法返回值是void
 */
void classMethodPerformReturnVoidInClss(Class classInit,SEL selector,id object);

@end
