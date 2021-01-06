//
//  AppDelegate.m
//  BMLongPressDragCellCollectionViewDemo
//
//  Created by __liangdahong on 2017/7/17.
//  Copyright © 2017年 https://liangdahong.com All rights reserved.
//

#import "AppDelegate.h"
#import "AMHomeVC.h"
#import "BMNavigationController.h"
#import "AMTabBarController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UINavigationController *nav = [[BMNavigationController alloc] initWithRootViewController:[AMHomeVC new]];
    nav.navigationBar.translucent = NO;
    nav.navigationBar.hidden = NO;
    
    AMTabBarController *tabVC = [[AMTabBarController alloc] init];
    tabVC.viewControllers = @[nav];
    self.window.rootViewController = tabVC;
    
    return YES;
}

@end
