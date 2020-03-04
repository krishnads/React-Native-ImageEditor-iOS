//
//  ChangeViewBridge.m
//  ImageEditor
//
//  Created by Apple on 05/02/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "ChangeViewBridge.h"
#import "AppDelegate.h"
#import "ImageEditor-Swift.h"
#import <UIKit/UIKit.h>

@implementation ChangeViewBridge

// reference "ChangeViewBridge" module in index.ios.js
RCT_EXPORT_MODULE(ChangeViewBridge);

RCT_EXPORT_METHOD(startEditingImage:(NSArray *)data callback:(RCTResponseSenderBlock)callback)
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // Call long-running code on background thread
    
    dispatch_async(dispatch_get_main_queue(), ^{
      AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
      appDelegate.callBack = callback;
      [appDelegate startEditing:data];
    });
  });
}


@end
