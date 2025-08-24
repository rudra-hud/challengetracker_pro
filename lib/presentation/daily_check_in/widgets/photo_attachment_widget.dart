import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhotoAttachmentWidget extends StatefulWidget {
  final List<XFile> attachedPhotos;
  final Function(List<XFile>) onPhotosChanged;

  const PhotoAttachmentWidget({
    super.key,
    required this.attachedPhotos,
    required this.onPhotosChanged,
  });

  @override
  State<PhotoAttachmentWidget> createState() => _PhotoAttachmentWidgetState();
}

class _PhotoAttachmentWidgetState extends State<PhotoAttachmentWidget> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _showCamera = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) return;

      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {
      debugPrint('Focus mode error: $e');
    }

    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {
        debugPrint('Flash mode error: $e');
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      final updatedPhotos = List<XFile>.from(widget.attachedPhotos)..add(photo);
      widget.onPhotosChanged(updatedPhotos);

      setState(() {
        _showCamera = false;
      });
    } catch (e) {
      debugPrint('Photo capture error: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final updatedPhotos = List<XFile>.from(widget.attachedPhotos)
          ..add(image);
        widget.onPhotosChanged(updatedPhotos);
      }
    } catch (e) {
      debugPrint('Gallery pick error: $e');
    }
  }

  void _removePhoto(int index) {
    final updatedPhotos = List<XFile>.from(widget.attachedPhotos)
      ..removeAt(index);
    widget.onPhotosChanged(updatedPhotos);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'photo_camera',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Add Photos',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '${widget.attachedPhotos.length}/5',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Camera Preview
          if (_showCamera && _isCameraInitialized && _cameraController != null)
            Container(
              height: 30.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    CameraPreview(_cameraController!),
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _showCamera = false),
                            child: Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'close',
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _capturePhoto,
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'camera_alt',
                                color: Colors.black,
                                size: 28,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _pickFromGallery,
                            child: Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'photo_library',
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Photo Thumbnails
          if (widget.attachedPhotos.isNotEmpty)
            Container(
              height: 12.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.attachedPhotos.length,
                separatorBuilder: (context, index) => SizedBox(width: 2.w),
                itemBuilder: (context, index) {
                  final photo = widget.attachedPhotos[index];
                  return Stack(
                    children: [
                      Container(
                        width: 20.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: kIsWeb
                              ? Image.network(
                                  photo.path,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: CustomIconWidget(
                                        iconName: 'image',
                                        color: Colors.grey[600]!,
                                        size: 24,
                                      ),
                                    );
                                  },
                                )
                              : Image.file(
                                  File(photo.path),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: CustomIconWidget(
                                        iconName: 'image',
                                        color: Colors.grey[600]!,
                                        size: 24,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removePhoto(index),
                          child: Container(
                            padding: EdgeInsets.all(1.w),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.8),
                              shape: BoxShape.circle,
                            ),
                            child: CustomIconWidget(
                              iconName: 'close',
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

          // Action Buttons
          if (!_showCamera)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: widget.attachedPhotos.length < 5
                        ? () => setState(() => _showCamera = true)
                        : null,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      decoration: BoxDecoration(
                        color: widget.attachedPhotos.length < 5
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: widget.attachedPhotos.length < 5
                              ? AppTheme.lightTheme.colorScheme.primary
                              : Colors.grey[400]!,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'camera_alt',
                            color: widget.attachedPhotos.length < 5
                                ? AppTheme.lightTheme.colorScheme.primary
                                : Colors.grey[600]!,
                            size: 18,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Camera',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: widget.attachedPhotos.length < 5
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: GestureDetector(
                    onTap: widget.attachedPhotos.length < 5
                        ? _pickFromGallery
                        : null,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      decoration: BoxDecoration(
                        color: widget.attachedPhotos.length < 5
                            ? AppTheme.lightTheme.colorScheme.secondary
                                .withValues(alpha: 0.1)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: widget.attachedPhotos.length < 5
                              ? AppTheme.lightTheme.colorScheme.secondary
                              : Colors.grey[400]!,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'photo_library',
                            color: widget.attachedPhotos.length < 5
                                ? AppTheme.lightTheme.colorScheme.secondary
                                : Colors.grey[600]!,
                            size: 18,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Gallery',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: widget.attachedPhotos.length < 5
                                  ? AppTheme.lightTheme.colorScheme.secondary
                                  : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
