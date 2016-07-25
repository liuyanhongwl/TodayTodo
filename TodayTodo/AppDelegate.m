//
//  AppDelegate.m
//  Today Todo
//
//  Created by Hong on 16/7/20.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    NSString *action = url.relativeString;
    if ([action hasPrefix:@"todaytodo://new_item"]) {
        UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
        [tab setSelectedIndex:0];
        UINavigationController *firstNavi = [tab viewControllers].firstObject;
        UIViewController *first = [firstNavi viewControllers].firstObject;
        if ([first isKindOfClass:[FirstViewController class]]) {
            [(FirstViewController *)first showAddAlert];
        }
    }else if ([action hasPrefix:@"todaytodo://select_item"]) {
        UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
        [tab setSelectedIndex:0];
        UINavigationController *firstNavi = [tab viewControllers].firstObject;
        UIViewController *first = [firstNavi viewControllers].firstObject;
        if ([first isKindOfClass:[FirstViewController class]]) {
            NSString *item = [[self paramsFormUrl:url] objectForKey:@"item"];
            [(FirstViewController *)first editRowWithItem:item];
        }
    }
    return YES;
}

- (NSDictionary *)paramsFormUrl:(NSURL *)url
{
    NSString *query = url.query;
    NSArray *params = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSString *p in params) {
        NSArray *keyValue = [p componentsSeparatedByString:@"="];
        NSString *key = keyValue.firstObject;
        NSString *value = keyValue.lastObject;
        if (key && value) {
            [result setObject:value forKey:key];
        }
    }
    return result;
}

@end
