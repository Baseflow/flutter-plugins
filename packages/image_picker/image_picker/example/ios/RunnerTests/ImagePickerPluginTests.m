// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ImagePickerTestImages.h"

@import image_picker;
@import XCTest;

@interface MockViewController : UIViewController
@property(nonatomic, retain) UIViewController *mockPresented;
@end

@implementation MockViewController
@synthesize mockPresented;

- (UIViewController *)presentedViewController {
  return mockPresented;
}

@end

@interface FLTImagePickerPlugin (Test)
@property(copy, nonatomic) FlutterResult result;
- (void)handleMultiSavedPaths:(NSMutableArray *)pathList;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
@end

@interface ImagePickerPluginTests : XCTestCase
@end

@implementation ImagePickerPluginTests

#pragma mark - Test camera devices, no op on simulators
- (void)testPluginPickImageDeviceBack {
  if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    return;
  }
  FLTImagePickerPlugin *plugin = [FLTImagePickerPlugin new];
  FlutterMethodCall *call =
      [FlutterMethodCall methodCallWithMethodName:@"pickImage"
                                        arguments:@{@"source" : @(0), @"cameraDevice" : @(0)}];
  [plugin handleMethodCall:call
                    result:^(id _Nullable r){
                    }];
  XCTAssertEqual([plugin getImagePickerController].cameraDevice,
                 UIImagePickerControllerCameraDeviceRear);
}

- (void)testPluginPickImageDeviceFront {
  if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    return;
  }
  FLTImagePickerPlugin *plugin = [FLTImagePickerPlugin new];
  FlutterMethodCall *call =
      [FlutterMethodCall methodCallWithMethodName:@"pickImage"
                                        arguments:@{@"source" : @(0), @"cameraDevice" : @(1)}];
  [plugin handleMethodCall:call
                    result:^(id _Nullable r){
                    }];
  XCTAssertEqual([plugin getImagePickerController].cameraDevice,
                 UIImagePickerControllerCameraDeviceFront);
}

- (void)testPluginPickVideoDeviceBack {
  if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    return;
  }
  FLTImagePickerPlugin *plugin = [FLTImagePickerPlugin new];
  FlutterMethodCall *call =
      [FlutterMethodCall methodCallWithMethodName:@"pickVideo"
                                        arguments:@{@"source" : @(0), @"cameraDevice" : @(0)}];
  [plugin handleMethodCall:call
                    result:^(id _Nullable r){
                    }];
  XCTAssertEqual([plugin getImagePickerController].cameraDevice,
                 UIImagePickerControllerCameraDeviceRear);
}

- (void)testPluginPickImageDeviceCancelClickMultipleTimes {
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    return;
  }
  FLTImagePickerPlugin *plugin = [FLTImagePickerPlugin new];
  FlutterMethodCall *call =
      [FlutterMethodCall methodCallWithMethodName:@"pickImage"
                                        arguments:@{@"source" : @(0), @"cameraDevice" : @(1)}];
  [plugin handleMethodCall:call
                    result:^(id _Nullable r){
                    }];
  plugin.result = ^(id result) {

  };
  [plugin imagePickerControllerDidCancel:[plugin getImagePickerController]];
  [plugin imagePickerControllerDidCancel:[plugin getImagePickerController]];
}

- (void)testPluginPickVideoDeviceFront {
  if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    return;
  }
  FLTImagePickerPlugin *plugin = [FLTImagePickerPlugin new];
  FlutterMethodCall *call =
      [FlutterMethodCall methodCallWithMethodName:@"pickVideo"
                                        arguments:@{@"source" : @(0), @"cameraDevice" : @(1)}];
  [plugin handleMethodCall:call
                    result:^(id _Nullable r){
                    }];
  XCTAssertEqual([plugin getImagePickerController].cameraDevice,
                 UIImagePickerControllerCameraDeviceFront);
}

#pragma mark - Test video duration
- (void)testPickingVideoWithDuration {
  FLTImagePickerPlugin *plugin = [FLTImagePickerPlugin new];
  FlutterMethodCall *call = [FlutterMethodCall
      methodCallWithMethodName:@"pickVideo"
                     arguments:@{@"source" : @(0), @"cameraDevice" : @(0), @"maxDuration" : @95}];
  [plugin handleMethodCall:call
                    result:^(id _Nullable r){
                    }];
  XCTAssertEqual([plugin getImagePickerController].videoMaximumDuration, 95);
}

- (void)testViewController {
  UIWindow *window = [UIWindow new];
  MockViewController *vc1 = [MockViewController new];
  window.rootViewController = vc1;

  UIViewController *vc2 = [UIViewController new];
  vc1.mockPresented = vc2;

  FLTImagePickerPlugin *plugin = [FLTImagePickerPlugin new];
  XCTAssertEqual([plugin viewControllerWithWindow:window], vc2);
}

- (void)testPluginMultiImagePathIsNil {
  FLTImagePickerPlugin *plugin = [FLTImagePickerPlugin new];

  dispatch_semaphore_t resultSemaphore = dispatch_semaphore_create(0);
  __block FlutterError *pickImageResult = nil;

  plugin.result = ^(id _Nullable r) {
    pickImageResult = r;
    dispatch_semaphore_signal(resultSemaphore);
  };
  [plugin handleMultiSavedPaths:nil];

  dispatch_semaphore_wait(resultSemaphore, DISPATCH_TIME_FOREVER);

  XCTAssertEqualObjects(pickImageResult.code, @"create_error");
}

- (void)testPluginMultiImagePathHasZeroItem {
  FLTImagePickerPlugin *plugin = [FLTImagePickerPlugin new];
  NSMutableArray *pathList = [NSMutableArray new];

  dispatch_semaphore_t resultSemaphore = dispatch_semaphore_create(0);
  __block FlutterError *pickImageResult = nil;

  plugin.result = ^(id _Nullable r) {
    pickImageResult = r;
    dispatch_semaphore_signal(resultSemaphore);
  };
  [plugin handleMultiSavedPaths:pathList];

  dispatch_semaphore_wait(resultSemaphore, DISPATCH_TIME_FOREVER);

  XCTAssertEqualObjects(pickImageResult.code, @"create_error");
}

- (void)testPluginMultiImagePathHasItem {
  FLTImagePickerPlugin *plugin = [FLTImagePickerPlugin new];
  NSString *savedPath = @"test";
  NSMutableArray *pathList = [NSMutableArray new];

  [pathList addObject:savedPath];

  dispatch_semaphore_t resultSemaphore = dispatch_semaphore_create(0);
  __block id pickImageResult = nil;

  plugin.result = ^(id _Nullable r) {
    pickImageResult = r;
    dispatch_semaphore_signal(resultSemaphore);
  };
  [plugin handleMultiSavedPaths:pathList];

  dispatch_semaphore_wait(resultSemaphore, DISPATCH_TIME_FOREVER);

  XCTAssertEqual(pickImageResult, pathList);
}

@end
