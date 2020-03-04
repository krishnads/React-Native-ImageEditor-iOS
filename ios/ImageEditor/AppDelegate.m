/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"
#import "React/RCTUIManager.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import "ImageEditor-Swift.h"


@interface AppDelegate () <PhotoEditorDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSFileManagerDelegate> {
  NSString *imagePath;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"ImageEditor"
                                            initialProperties:nil];

  options = launchOptions;
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}


- (void)startEditing:(NSArray *)data {
  NSLog(@"RN binding - Native View - ViewController - Load From Main storyboard");
  
  //If want to customise controls
  //==============================
/*
   UINavigationController *nav = (UINavigationController *) [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
   [nav setNavigationBarHidden:YES];
   MainViewController *vc = (MainViewController *)nav.viewControllers[0];
   vc.selectedData = data;
  [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
*/
  
  //ELSE
  //==============================

  int selectedOption = [data[0] intValue];
  UIImage *selectedImage =  [RCTConvert UIImage:data[1]];
  
  
  if (selectedOption == 1) {
    [self openCamera];
  } else if (selectedOption == 2) {
    [self openGallery];
  } else {
    [self openEditorWith:selectedImage];
  }
}

- (void)openCamera {

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.window.rootViewController presentViewController:picker animated:YES completion:NULL];
}

- (void)openGallery {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setAllowsEditing:YES];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.window.rootViewController presentViewController:picker animated:YES completion:nil];
}



- (void)openEditorWith:(UIImage *)image {
  PhotoEditorViewController * photoEditor = [[PhotoEditorViewController alloc] initWithNibName:@"PhotoEditorViewController" bundle:[NSBundle bundleForClass:[PhotoEditorViewController class]]];
  photoEditor.photoEditorDelegate = self;
  photoEditor.image = image; //[UIImage imageNamed:@"apple"];
  photoEditor.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  [self.window.rootViewController presentViewController:photoEditor animated:YES completion:nil];
}

- (void)canceledEditing {
  [self completedEditingWith:nil];
}

- (void)doneEditingWithImage:(UIImage * _Nonnull)image {
  [self completedEditingWith:image];
}

- (void) completedEditingWith:(UIImage *)image {
  if (image == nil) {
    self.callBack(@[@""]);
  } else {
    NSString *imagePath = [self saveImageToDirectory:image];
    self.callBack(@[imagePath]);
  }
}

- (NSString *)saveImageToDirectory:(UIImage *)image {
  
  NSData *pngData = UIImagePNGRepresentation(image);
  NSError *error;
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder

  NSString *pathImages = @"/VerisampleImages/Verisample/5e46a3c8e13d083b1f83ebdd/1582264567345777/ProjectNote/567dsff";

  NSArray *arrayImagePath = [pathImages componentsSeparatedByString:@"/"];
  NSMutableArray *arrayFolderPath = [arrayImagePath mutableCopy];
  [arrayFolderPath removeLastObject];
  NSString *folderpath = [arrayFolderPath componentsJoinedByString:@"/"];
  NSString *imagepath = [NSString stringWithFormat:@"%@.png", pathImages];

  NSLog(@"Folder path --->%@", folderpath);
  NSLog(@"Image path --->%@", imagepath);
  
  NSString *dataPathFolder = [documentsDirectory stringByAppendingPathComponent:folderpath];
  NSString *dataPathImage = [documentsDirectory stringByAppendingPathComponent:imagepath];

  
  if (![[NSFileManager defaultManager] fileExistsAtPath:dataPathFolder]) {
     BOOL isCreated = [[NSFileManager defaultManager] createDirectoryAtPath:dataPathFolder withIntermediateDirectories:YES attributes:nil error:&error];
    if (isCreated) {
      NSLog(@"created folder is --->%@", dataPathFolder);
    } else {
      NSLog(@"error is --->%@",error);
    }
  }

  [pngData writeToFile:dataPathImage atomically:YES];

  
  [[NSFileManager defaultManager] moveItemAtPath:dataPathImage toPath:documentsDirectory error:nil];
  
  

  return dataPathImage ;//[dataPath stringByAppendingPathComponent:@"edited_image.png"];
}



- (BOOL)fileManager:(NSFileManager *)fileManager shouldMoveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath {
    return true;
}


#pragma mark - Image Picker COntroller methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [picker dismissViewControllerAnimated:YES completion:nil];
  UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
  [self openEditorWith:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [picker dismissViewControllerAnimated:YES completion:NULL];
  [self completedEditingWith:nil];
}

@end
