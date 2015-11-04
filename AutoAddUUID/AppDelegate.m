//
//  AppDelegate.m
//  AutoAddUUID
//
//  Created by lixy on 15/10/26.
//  Copyright © 2015年 lixy. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    if (flag) {
        return NO;
    } else {
        [[NSApplication sharedApplication].windows.firstObject makeKeyAndOrderFront:self];
        return YES;
    }
}

@end
