//
//  ViewController.m
//  AutoAddUUID
//
//  Created by lixy on 15/10/26.
//  Copyright © 2015年 lixy. All rights reserved.
//

#import "ViewController.h"

#define DefaultPathPrefix @"/Applications/Xcode.app/"
#define PathSuffix @"Contents/Info.plist"

#define PlugPath1 @"/Library/Application Support/Developer/Shared/Xcode/Plug-ins"
#define PlugPath2 @"/Library/Developer/Xcode/Plug-ins"

@interface ViewController ()<NSTextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pathTextField.delegate = self;
    NSClickGestureRecognizer *click = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(gesClick)];
    [self.pathTextField addGestureRecognizer:click];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)gesClick
{
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.allowsMultipleSelection = NO;
    panel.canChooseFiles = YES;
    panel.allowedFileTypes = @[@"app"];
    panel.directoryURL = [NSURL URLWithString:[NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSSystemDomainMask, NO) firstObject]];
    
    if ([panel runModal] == NSModalResponseOK) {
        NSString *path = [panel.URLs.firstObject path];
        self.pathTextField.stringValue = path;
    }
  
}

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
{
    return NO;
}

- (IBAction)doneClick:(NSButton*)sender
{
    NSDictionary *infoDic = nil;
    
    if (self.pathTextField.stringValue.length==0) {
        infoDic = [NSDictionary dictionaryWithContentsOfFile:[DefaultPathPrefix stringByAppendingPathComponent:PathSuffix]];
    } else {
        infoDic = [NSDictionary dictionaryWithContentsOfFile:[self.pathTextField.stringValue stringByAppendingPathComponent:PathSuffix]];
    }
    
    if (!infoDic) {
        
        return;
    }
    
    NSString *xcodeUUID = infoDic[@"DVTPlugInCompatibilityUUID"];
    if (!xcodeUUID) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"Error";
        alert.informativeText = @"Please choose your Xcode!";
        [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse returnCode) {
            
        }];
        
        return;
    }
    
    NSString *homeDir = NSHomeDirectory();
    NSString *path = [homeDir stringByAppendingPathComponent:PlugPath1];

    NSArray *plugIns = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    for (NSString *name in plugIns) {
        if ([name hasSuffix:@"xcplugin"]) {
            NSString *plugInPath = [[path stringByAppendingPathComponent:name] stringByAppendingPathComponent:PathSuffix];
            
            NSDictionary *plugInInfo = [NSDictionary dictionaryWithContentsOfFile:plugInPath];
            
            NSMutableDictionary *tempPlugInInfo = [NSMutableDictionary dictionaryWithDictionary:plugInInfo];
            
            NSMutableArray *UUIDs = [NSMutableArray arrayWithArray: tempPlugInInfo[@"DVTPlugInCompatibilityUUIDs"]];
            
            if (![UUIDs containsObject:xcodeUUID]) {
                [UUIDs addObject:xcodeUUID];
                [tempPlugInInfo setObject:UUIDs forKey:@"DVTPlugInCompatibilityUUIDs"];
                [tempPlugInInfo writeToFile:plugInPath atomically:NO];
            }
            
        }
    }
    
    path = [homeDir stringByAppendingPathComponent:PlugPath2];
    plugIns = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    for (NSString *name in plugIns) {
        if ([name hasSuffix:@"ideplugin"]) {
            NSString *plugInPath = [[path stringByAppendingPathComponent:name] stringByAppendingPathComponent:PathSuffix];
            
            NSDictionary *plugInInfo = [NSDictionary dictionaryWithContentsOfFile:plugInPath];
            
            NSMutableDictionary *tempPlugInInfo = [NSMutableDictionary dictionaryWithDictionary:plugInInfo];
            
            NSMutableArray *UUIDs = [NSMutableArray arrayWithArray: tempPlugInInfo[@"DVTPlugInCompatibilityUUIDs"]];
            
            if (![UUIDs containsObject:xcodeUUID]) {
                [UUIDs addObject:xcodeUUID];
                [tempPlugInInfo setObject:UUIDs forKey:@"DVTPlugInCompatibilityUUIDs"];
                [tempPlugInInfo writeToFile:plugInPath atomically:NO];
            }
            
        }
    }
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"Cheers! Please restart your Xcode!";
    [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse returnCode) {
        
    }];
    
}

@end
