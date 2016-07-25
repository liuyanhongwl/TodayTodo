//
//  TodayTodoKit.h
//  TodayTodoKit
//
//  Created by Hong on 16/7/21.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for TodayTodoKit.
FOUNDATION_EXPORT double TodayTodoKitVersionNumber;

//! Project version string for TodayTodoKit.
FOUNDATION_EXPORT const unsigned char TodayTodoKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <TodayTodoKit/PublicHeader.h>

//#ifndef _TODAYTODOKIT_
//    #define _TODAYTODOKIT_
//
//    #import "Post.h"
//    #import "APIClient.h"
//
//#endif


#if __has_include(<TodayTodoKit/TodayTodoKit.h>)
    FOUNDATION_EXPORT double TodayTodoKitVersionNumber;
    FOUNDATION_EXPORT const unsigned char TodayTodoKitVersionString[];
    #import <TodayTodoKit/Post.h>
    #import <TodayTodoKit/APIClient.h>
#else
    #import "Post.h"
    #import "APIClient.h"
#endif