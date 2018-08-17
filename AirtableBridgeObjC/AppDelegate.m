//
//  AppDelegate.m
//  AirtableBridgeObjC
//
//  Created by Danilo Campos on 8/16/18.
//  Copyright © 2018 Danilo Campos. All rights reserved.
//

#import "AppDelegate.h"
#import "AirtableBridge.h"
#import "APIKey.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    AirtableBridge *bridge = [AirtableBridge bridgeWithBaseId:@"appoAITxTMYXNz4Pw" apiKey:AIRTABLE_API_KEY];
    
    [bridge loadTable:@"AI in Science Fiction" atOffset:nil maxRecords:100 viewName:nil completionHandler:^(NSDictionary *results, NSString *offset, NSError *error) {
        //NSLog(@"Results: %@", results);
    }];
    
    [bridge loadRecordWithID:@"recF40hqsTKzqkRbm" tableName:@"AI in Science Fiction" completionHandler:^(NSDictionary *results, NSError *error) {
        //NSLog(@"Results: %@", results);
    }];
    
    [bridge loadRecordIDs:@[@"reccXuyAu1AHjUXf3", @"recRG9adqAEEFM5gc"] atOffset:nil tableName:@"Science Fiction Properties" viewName:nil completionHandler:^(NSDictionary *results, NSString *offset, NSError *error) {
        
        if (error) NSLog(@"Error: %@", error);
        
        NSLog(@"Results: %@", results);
    }];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
