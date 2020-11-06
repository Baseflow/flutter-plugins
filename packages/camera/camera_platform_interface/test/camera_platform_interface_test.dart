// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:camera_platform_interface/src/method_channel/method_channel_camera.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$CameraPlatform', () {
    test('$MethodChannelCamera is the default instance', () {
      expect(CameraPlatform.instance, isA<MethodChannelCamera>());
    });

    test('Cannot be implemented with `implements`', () {
      expect(() {
        CameraPlatform.instance = ImplementsCameraPlatform();
      }, throwsNoSuchMethodError);
    });

    test('Can be extended', () {
      CameraPlatform.instance = ExtendsCameraPlatform();
    });

    test('Can be mocked with `implements`', () {
      final mock = MockCameraPlatform();
      CameraPlatform.instance = mock;
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Default implementation of availableCameras() should throw unimplemented error',
        () {
      // Arrange
      final cameraPlatform = ExtendsCameraPlatform();

      // Act & Assert
      expect(
        () => cameraPlatform.availableCameras(),
        throwsUnimplementedError,
      );
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Default implementation of cameraEventsFor() should throw unimplemented error',
        () {
      // Arrange
      final cameraPlatform = ExtendsCameraPlatform();

      // Act & Assert
      expect(
        () => cameraPlatform.cameraEventsFor(1),
        throwsUnimplementedError,
      );
    });

    test('Default implementation of dispose() should throw unimplemented error',
        () {
      // Arrange
      final cameraPlatform = ExtendsCameraPlatform();

      // Act & Assert
      expect(
        () => cameraPlatform.dispose(1),
        throwsUnimplementedError,
      );
    });

    test(
        'Default implementation of initialize() should throw unimplemented error',
        () {
      // Arrange
      final cameraPlatform = ExtendsCameraPlatform();

      // Act & Assert
      expect(
        () => cameraPlatform.initializeCamera(null),
        throwsUnimplementedError,
      );
    });

    test(
        'Default implementation of pauseVideoRecording() should throw unimplemented error',
        () {
      // Arrange
      final cameraPlatform = ExtendsCameraPlatform();

      // Act & Assert
      expect(
        () => cameraPlatform.pauseVideoRecording(1),
        throwsUnimplementedError,
      );
    });

    test(
        'Default implementation of prepareForVideoRecording() should throw unimplemented error',
        () {
      // Arrange
      final cameraPlatform = ExtendsCameraPlatform();

      // Act & Assert
      expect(
        () => cameraPlatform.prepareForVideoRecording(),
        throwsUnimplementedError,
      );
    });

    test(
        'Default implementation of resumeVideoRecording() should throw unimplemented error',
        () {
      // Arrange
      final cameraPlatform = ExtendsCameraPlatform();

      // Act & Assert
      expect(
        () => cameraPlatform.resumeVideoRecording(1),
        throwsUnimplementedError,
      );
    });

    test(
        'Default implementation of startImageStream() should throw unimplemented error',
        () {
      // Arrange
      final cameraPlatform = ExtendsCameraPlatform();

      // Act & Assert
      expect(
        () => cameraPlatform.startImageStream(null),
        throwsUnimplementedError,
      );
    });

    test(
        'Default implementation of startVideoRecording() should throw unimplemented error',
        () {
      // Arrange
      final cameraPlatform = ExtendsCameraPlatform();

      // Act & Assert
      expect(
        () => cameraPlatform.startVideoRecording(1, null),
        throwsUnimplementedError,
      );
    });

    test(
        'Default implementation of stopImageStream() should throw unimplemented error',
        () {
      // Arrange
      final cameraPlatform = ExtendsCameraPlatform();

      // Act & Assert
      expect(
        () => cameraPlatform.stopImageStream(),
        throwsUnimplementedError,
      );
    });

    test(
        'Default implementation of stopVideoRecording() should throw unimplemented error',
        () {
      // Arrange
      final cameraPlatform = ExtendsCameraPlatform();

      // Act & Assert
      expect(
        () => cameraPlatform.stopVideoRecording(1),
        throwsUnimplementedError,
      );
    });

    test(
        'Default implementation of takePicture() should throw unimplemented error',
        () {
      // Arrange
      final cameraPlatform = ExtendsCameraPlatform();

      // Act & Assert
      expect(
        () => cameraPlatform.takePicture(1, null),
        throwsUnimplementedError,
      );
    });
  });
}

class ImplementsCameraPlatform implements CameraPlatform {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockCameraPlatform extends Mock
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements
        CameraPlatform {}

class ExtendsCameraPlatform extends CameraPlatform {}