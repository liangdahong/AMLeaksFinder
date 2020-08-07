////
////  UIViewController+BMMemoryLeak.m
////  BMMoonStore
////
////  Created by liangdahong on 2020/4/6.
////  Copyright © 2020 liangdahong. All rights reserved.
////  此文件是为了把公司的网络日志进一步格式化的处理
////  此文件是为了把公司的网络日志进一步格式化的处理
////  此文件是为了把公司的网络日志进一步格式化的处理
////  此文件是为了把公司的网络日志进一步格式化的处理
////  此文件是为了把公司的网络日志进一步格式化的处理
////  此文件是为了把公司的网络日志进一步格式化的处理
////  此文件是为了把公司的网络日志进一步格式化的处理
////  此文件是为了把公司的网络日志进一步格式化的处理
////  此文件是为了把公司的网络日志进一步格式化的处理
////  此文件是为了把公司的网络日志进一步格式化的处理
////  此文件是为了把公司的网络日志进一步格式化的处理

//#ifdef DEBUG
//
//#import <BMNetworkAPIManager/BMBaseAPIManager.h>
//#import <BMNetworkAPIManager/BMAPICalledProxy.h>
//
//@interface BMAPICalledProxy ()
//
//- (void)callAPIFailure:(NSURLSessionTask *)task error:(NSError *)error requestId:(NSNumber *)requestId failureCallback:(id)failureCallback;
//- (void)callAPISuccess:(NSURLSessionTask *)task responseObject:(id)responseObject requestId:(NSNumber *)requestId successCallback:(id)successCallback;
//
//@end
//
//@implementation BMAPICalledProxy (TestLog)
//+ (void)load {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if ([[UIDevice currentDevice].name hasPrefix:@"bmtestldh"]) {
//
//            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"我是测试模块【上线请删除哦】" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//            [alertVC addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            }]];
//            [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
//
//            static dispatch_once_t onceToken;
//            dispatch_once(&onceToken, ^{
//                {
//                    Method originalMethod = class_getInstanceMethod(BMAPICalledProxy.class, @selector(callAPIFailure:error:requestId:failureCallback:));
//                    Method swizzledMethod = class_getInstanceMethod(BMAPICalledProxy.class, @selector(bm_test_callAPIFailure:error:requestId:failureCallback:));
//                    method_exchangeImplementations(originalMethod, swizzledMethod);
//                }
//                {
//                    Method originalMethod = class_getInstanceMethod(BMAPICalledProxy.class, @selector(callAPISuccess:responseObject:requestId:successCallback:));
//                    Method swizzledMethod = class_getInstanceMethod(BMAPICalledProxy.class, @selector(bm_test_callAPISuccess:responseObject:requestId:successCallback:));
//                    method_exchangeImplementations(originalMethod, swizzledMethod);
//                }
//            });
//        }
//    });
//}
//
//- (void)bm_test_callAPIFailure:(NSURLSessionTask *)task error:(NSError *)error requestId:(NSNumber *)requestId failureCallback:(id)failureCallback
//{
//    NSURLRequest *request = task.originalRequest;
//    NSMutableString *str = @"".mutableCopy;
//    [str appendFormat:@"\n\n❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌\n%@\n%@\n%@\n\n",
//    request.URL.absoluteString,
//    request.allHTTPHeaderFields,
//     request.HTTPBody ? [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:kNilOptions error:NULL] : @""];
//
//    NSMutableString *str1 = @"".mutableCopy;
//    [str1 appendFormat:@"domain: %@\n", error.domain];
//    [str1 appendFormat:@"code: %@\n", @(error.code).description];
//    if (error.localizedDescription) {
//        [str1 appendFormat:@"%@\n", error.localizedDescription];
//    }
//
//    if (error.localizedFailureReason) {
//        [str1 appendFormat:@"%@\n", error.localizedFailureReason];
//    }
//    if (error.localizedRecoverySuggestion) {
//        [str1 appendFormat:@"%@\n", error.localizedRecoverySuggestion];
//    }
//    [str appendString:str1];
//    [str appendString:@"\n❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌\n\n"];
//    printf("%s", str.UTF8String);
//    [self bm_test_callAPIFailure:task error:error requestId:requestId failureCallback:failureCallback];
//}
//
//- (void)bm_test_callAPISuccess:(NSURLSessionTask *)task responseObject:(id)responseObject requestId:(NSNumber *)requestId successCallback:(id)successCallback
//{
//    NSURLRequest *request = task.originalRequest;
//    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:NULL];
//    NSString *jsonStr = @"";
//    NSString *temp = @"";
//    if (json) {
//        jsonStr = json.description;
//        if ([json[@"responseCode"] integerValue] != 200 || [json[@"isSuccess"] boolValue] != 1) {
//            temp =  @"❌❌❌❌❌❌❌❌❌❌❌❌❌";
//        } else {
//            temp = @"✅✅✅✅✅✅✅✅✅✅✅✅✅✅";
//        }
//    } else {
//        jsonStr = @"\n{ 不是 json }\n";
//        temp =  @"❌❌❌❌❌❌❌❌❌❌❌❌❌";
//    }
//    NSMutableString *str = @"".mutableCopy;
//    [str appendFormat:@"\n\n\n%@\n%@\n\n%@\n\n%@\n\n",
//     temp,
//    request.URL.absoluteString,
//    request.allHTTPHeaderFields,
//    request.HTTPBody ? [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:kNilOptions error:NULL] : @""];
//    [str appendString:json.description];
//    [str appendFormat:@"\n%@\n\n\n", temp];
//    printf("%s", str.UTF8String);
//    [self bm_test_callAPISuccess:task responseObject:responseObject requestId:requestId successCallback:successCallback];
//}
//
//@end
//
//#endif
//
//#ifdef DEBUG
//
//#import <Foundation/Foundation.h>
//
//@implementation NSDictionary (jlExtension)
//
//- (NSString *)description {
//    return [self jl_descriptionWithLevel:1];
//}
//
//- (NSString *)descriptionWithLocale:(nullable id)locale {
//    return [self jl_descriptionWithLevel:1];
//}
//- (NSString *)descriptionWithLocale:(nullable id)locale indent:(NSUInteger)level {
//    return [self jl_descriptionWithLevel:(int)level];
//}
//
///**
// * 非字典时，会引发崩溃
// */
//- (NSString *)jl_getUTF8String {
//    if ([self isKindOfClass:[NSDictionary class]] == NO) {
//        return @"";
//    }
//    NSError *error = nil;
//    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
//    if (error) {
//        return @"";
//    }
//    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    return str;
//}
//
///**
// 将字典转化成字符串，文字格式UTF8,并且格式化
//
// @param level 当前字典的层级，最少为 1，代表最外层字典
// @return 格式化的字符串
// */
//- (NSString *)jl_descriptionWithLevel:(int)level {
//    NSString *subSpace = [self jl_getSpaceWithLevel:level];
//    NSString *space = [self jl_getSpaceWithLevel:level - 1];
//    NSMutableString *retString = [[NSMutableString alloc] init];
//    // 1、添加 {
//    [retString appendString:[NSString stringWithFormat:@"{"]];
//    // 2、添加 key : value;
//    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        if ([obj isKindOfClass:[NSString class]]) {
//            NSString *value = (NSString *)obj;
////            value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            value = [value stringByReplacingOccurrencesOfString:@"\0" withString:@"\\0"];
//
//            NSString *subString = [NSString stringWithFormat:@"\n%@\"%@\" : \"%@\",", subSpace, key, value];
//            [retString appendString:subString];
//        } else if ([obj isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *dic = (NSDictionary *)obj;
//            NSString *str = [dic jl_descriptionWithLevel:level + 1];
//            str = [NSString stringWithFormat:@"\n%@\"%@\" : %@,", subSpace, key, str];
//            [retString appendString:str];
//        } else if ([obj isKindOfClass:[NSArray class]]) {
//            NSArray *arr = (NSArray *)obj;
//            NSString *str = [arr descriptionWithLocale:nil indent:level + 1];
//            str = [NSString stringWithFormat:@"\n%@\"%@\" : %@,", subSpace, key, str];
//            [retString appendString:str];
//        } else {
//            NSString *subString = [NSString stringWithFormat:@"\n%@\"%@\" : %@,", subSpace, key, obj];
//            [retString appendString:subString];
//        }
//    }];
//    if ([retString hasSuffix:@","]) {
//        [retString deleteCharactersInRange:NSMakeRange(retString.length-1, 1)];
//    }
//    // 3、添加 }
//    [retString appendString:[NSString stringWithFormat:@"\n%@}", space]];
//    return retString;
//}
//
///**
// 根据层级，返回前面的空格占位符
//
// @param level 字典的层级
// @return 占位空格
// */
//- (NSString *)jl_getSpaceWithLevel:(int)level {
//    NSMutableString *mustr = [[NSMutableString alloc] init];
//    for (int i=0; i<level; i++) {
//        [mustr appendString:@"\t"];
//    }
//    return mustr;
//}
//
//@end
//
//#endif
//
//#import <Foundation/Foundation.h>
//
//#ifdef DEBUG
//
//@implementation NSArray (jlExtension)
//
//- (NSString *)description {
//    return [self jl_descriptionWithLevel:1];
//}
//
//-(NSString *)descriptionWithLocale:(id)locale
//{
//    return [self jl_descriptionWithLevel:1];
//}
//
//- (NSString *)descriptionWithLocale:(nullable id)locale indent:(NSUInteger)level {
//    return [self jl_descriptionWithLevel:(int)level];
//}
//
//- (NSString *)jl_descriptionWithLevel:(int)level {
//    NSString *subSpace = [self jl_getSpaceWithLevel:level];
//    NSString *space = [self jl_getSpaceWithLevel:level - 1];
//    NSMutableString *retString = [[NSMutableString alloc] init];
//    // 1、添加 [
//    [retString appendString:[NSString stringWithFormat:@"["]];
//    // 2、添加 value
//    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj isKindOfClass:[NSString class]]) {
//            NSString *value = (NSString *)obj;
//            NSString *subString = [NSString stringWithFormat:@"\n%@\"%@\",", subSpace, value];
//            [retString appendString:subString];
//        } else if ([obj isKindOfClass:[NSArray class]]) {
//            NSArray *arr = (NSArray *)obj;
//            NSString *str = [arr jl_descriptionWithLevel:level + 1];
//            str = [NSString stringWithFormat:@"\n%@%@,", subSpace, str];
//            [retString appendString:str];
//        } else if ([obj isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *dic = (NSDictionary *)obj;
//            NSString *str = [dic descriptionWithLocale:nil indent:level + 1];
//            str = [NSString stringWithFormat:@"\n%@%@,", subSpace, str];
//            [retString appendString:str];
//        } else {
//            NSString *subString = [NSString stringWithFormat:@"\n%@%@,", subSpace, obj];
//            [retString appendString:subString];
//        }
//    }];
//    if ([retString hasSuffix:@","]) {
//        [retString deleteCharactersInRange:NSMakeRange(retString.length-1, 1)];
//    }
//    // 3、添加 ]
//    [retString appendString:[NSString stringWithFormat:@"\n%@]", space]];
//    return retString;
//}
//
//- (NSString *)jl_getSpaceWithLevel:(int)level {
//    NSMutableString *mustr = [[NSMutableString alloc] init];
//    for (int i=0; i<level; i++) {
//        [mustr appendString:@"\t"];
//    }
//    return mustr;
//}
//
//@end
//
//#endif
