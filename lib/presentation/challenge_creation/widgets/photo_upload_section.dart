import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PhotoUploadSection extends StatefulWidget {
  final XFile? selectedImage;
  final Function(XFile?) onImageSelected;

  const PhotoUploadSection({
    super.key,
    required this.selectedImage,
    required this.onImageSelected,
  });

  @override
  State<PhotoUploadSection> createState() => _PhotoUploadSectionState();
}

class _PhotoUploadSectionState extends State<PhotoUploadSection> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<bool> _requestPermission() async {
    if (kIsWeb) return true;

    final status = await Permission.photos.request();
    return status.isGranted;
  }

  Future<void> _pickImageFromGallery() async {
    try {
      setState(() => _isLoading = true);

      if (!await _requestPermission()) {
        _showPermissionDialog();
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        widget.onImageSelected(image);
      }
    } catch (e) {
      _showErrorDialog('Failed to select image. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      setState(() => _isLoading = true);

      if (!kIsWeb) {
        final cameraStatus = await Permission.camera.request();
        if (!cameraStatus.isGranted) {
          _showPermissionDialog();
          return;
        }
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        widget.onImageSelected(image);
      }
    } catch (e) {
      _showErrorDialog('Failed to capture image. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showImageSourceDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Select Image Source',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'photo_library',
                  size: 24,
                  color: colorScheme.primary,
                ),
                title: const Text('Gallery'),
                subtitle: const Text('Choose from your photos'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'camera_alt',
                  size: 24,
                  color: colorScheme.primary,
                ),
                title: const Text('Camera'),
                subtitle: const Text('Take a new photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              if (widget.selectedImage != null)
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'delete',
                    size: 24,
                    color: Colors.red,
                  ),
                  title: const Text('Remove Image'),
                  subtitle: const Text('Remove current image'),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onImageSelected(null);
                  },
                ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showPermissionDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
            'Please grant permission to access photos and camera to upload challenge images.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Challenge Image (Optional)',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),

        Text(
          'Add a custom image to personalize your challenge',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: 2.h),

        // Image Upload Area
        GestureDetector(
          onTap: _isLoading ? null : _showImageSourceDialog,
          child: Container(
            width: double.infinity,
            height: widget.selectedImage != null ? 25.h : 15.h,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: colorScheme.primary,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Processing image...',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : widget.selectedImage != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: kIsWeb
                                ? Image.network(
                                    widget.selectedImage!.path,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildPlaceholder();
                                    },
                                  )
                                : Image.file(
                                    File(widget.selectedImage!.path),
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildPlaceholder();
                                    },
                                  ),
                          ),
                          Positioned(
                            top: 2.w,
                            right: 2.w,
                            child: GestureDetector(
                              onTap: () => widget.onImageSelected(null),
                              child: Container(
                                padding: EdgeInsets.all(1.w),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: CustomIconWidget(
                                  iconName: 'close',
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : _buildPlaceholder(),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomIconWidget(
          iconName: 'add_photo_alternate',
          size: 48,
          color: colorScheme.primary.withValues(alpha: 0.6),
        ),
        SizedBox(height: 2.h),
        Text(
          'Tap to add image',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Gallery or Camera',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
