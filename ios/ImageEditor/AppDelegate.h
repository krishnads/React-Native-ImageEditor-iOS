/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <React/RCTBridgeDelegate.h>
#import <UIKit/UIKit.h>
#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, RCTBridgeDelegate> {
  NSDictionary *options;
  UIViewController *viewController;
}

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) RCTResponseSenderBlock callBack;

- (void)startEditing:(NSArray *)data; // called from the RCTBridge modul

- (void) completedEditingWith:(UIImage *)image; // called from the RCTBridge modul


@end
