//
//  ClassActions.m
//  私塾家
//
//  Created by liew on 2018/2/9.
//  Copyright © 2018年 Liew. All rights reserved.


/*
编码值      |  含意
----------- | -------------
c          |  代表char类型
i          |  代表int类型
s          |  代表short类型
l          |  代表long类型，在64位处理器上也是按照32位处理
q          |  代表long long类型
C          |  代表unsigned char类型
I          |  代表unsigned int类型
S          |  代表unsigned short类型
L          |  代表unsigned long类型
Q          |  代表unsigned long long类型
f          |  代表float类型
d          |  代表double类型
B          |  代表C++中的bool或者C99中的_Bool
v          |  代表void类型
*          |  代表char *类型
@          |  代表对象类型
\#          |  代表类对象 (Class)
:          |  代表方法selector (SEL)
[arraytype]|  代表array
{name=type...}| 代表结构体
    (name=type...)| 代表union
    bnum          | A bitfieldofnumbits
    ^type        | A pointertotype
    ?            | An unknowntype (amongotherthings, thiscodeisusedforfunctionpointers)
*/
#import "ClassActions.h"
#import <objc/runtime.h>
@implementation ClassActions
/**
 * 判断 该类中有没存在该类方法 classInit 类名称对应的class selector 调用的类方法
 */
BOOL isExistClassMethodInClass(Class classInit,SEL selector){
    BOOL exist = NO;
    if (classInit) {
        Method method = class_getClassMethod(classInit, selector);
        NSString *methodName = NSStringFromSelector(method_getName(method));
        NSString *selectorName = NSStringFromSelector(selector);
        
        if (methodName && selectorName && [methodName isEqualToString:selectorName]) {
            exist = YES;
        }
    }
    return exist;
}
/**
 * 获取类方法的返回值
 */
NSString * classMethodToReturnType(Class classInit,SEL selector){
    char returnType[512] = {};
    Method method = class_getClassMethod(classInit, selector);
    method_getReturnType(method, returnType, 512);
    
    return [NSString stringWithFormat:@"%s",returnType];
}

/**
 * 判断 该类中有没存在该方法  classInit 类名称对应的class selector 调用方法
 */
BOOL isExistMethodInClass(Class classInit,SEL selector){
    BOOL exist = NO;
    if (classInit) {
        exist = class_respondsToSelector(classInit, selector);
    }
    return exist;
}
/**
 *调用类方法  classInit 类名称对应的class selector 调用的类方法 object 参数
 */
id classMethodPerformInClss(Class classInit,SEL selector,id object){
    if (isExistClassMethodInClass(classInit, selector)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        @try {
            NSString *returnType = classMethodToReturnType(classInit, selector);
            if ([returnType isEqualToString:@"@"]) {
                return  [classInit performSelector:selector withObject:object];
            }else{
                return nil;
            }
        } @catch (NSException *exception) {
            return nil;
        } @finally {
       
        }
#pragma clang diagnostic pop
    }else{
        return nil;
    }
}
/**
  *  调用类方法  classInit 类名称对应的class selector 调用的类方法 object 参数  调用的方法返回值是void
  */
void classMethodPerformReturnVoidInClss(Class classInit,SEL selector,id object){
    if (isExistClassMethodInClass(classInit, selector)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        @try {
            [classInit performSelector:selector withObject:object];
        } @catch (NSException *exception) {
           
        } @finally {
            
        }
#pragma clang diagnostic pop
    }
}
@end
