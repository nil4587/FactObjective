//
//  AppConstant.h
//  FactObjective
//
//  Created by Nilesh Prajapati on 21/11/17.
//  Copyright © 2017 Nilesh Prajapati. All rights reserved.
//

#ifndef AppConstant_h
#define AppConstant_h

#pragma mark - ========================================================
#pragma mark Log printing statements used within the application
#pragma mark ========================================================

#ifdef DEBUG
#   define DLog(FORMAT, ...) printf("%s\n",[[NSString stringWithFormat:(@"%s [Line %d] " FORMAT), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__] UTF8String])
#else
#   define DLog(...)
#endif

#define ALog(FORMAT, ...) printf("%s\n",[[NSString stringWithFormat:(@"%s [Line %d] " FORMAT), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__] UTF8String])

#ifdef DEBUG
#   define ULog(FORMAT, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:(@"" FORMAT), ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

#pragma mark - ========================================================
#pragma mark iOS system versions comparision
#pragma mark ========================================================

//-- iOS system versions comparision
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#pragma mark - ========================================================
#pragma mark Application Domain & web-service urls
#pragma mark ========================================================

#define JSON_FILE_URL @"https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
#define appDelegate   ((AppDelegate *)[[UIApplication sharedApplication]delegate])

#endif /* AppConstant_h */
