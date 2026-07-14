import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../providers/user_profile_providers.dart';

const _red = Color(0xFFE53935);
const _card = Color(0xFF2A2A2A);

class ProfileAvatarPicker extends ConsumerStatefulWidget {
  final String? uid;
  final Uint8List? photoBytes;
  final String initial;
  final double radius;
  final bool showLabel;

  const ProfileAvatarPicker({
    super.key,
    required this.uid,
    required this.photoBytes,
    required this.initial,
    this.radius = 40,
    this.showLabel = true,
  });

  @override
  ConsumerState<ProfileAvatarPicker> createState() =>
      _ProfileAvatarPickerState();
}

class _ProfileAvatarPickerState extends ConsumerState<ProfileAvatarPicker> {
  bool _uploading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _uploading ? null : _changePhoto,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                    BorderSide(color: _red, width: 2),
                  ),
                ),
                child: CircleAvatar(
                  radius: widget.radius,
                  backgroundColor: _card,
                  backgroundImage: widget.photoBytes != null
                      ? MemoryImage(widget.photoBytes!)
                      : null,
                  child: widget.photoBytes == null
                      ? Text(
                          widget.initial,
                          style: TextStyle(
                            color: _red,
                            fontSize: widget.radius * 0.8,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
              if (_uploading)
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black45,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _red,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF121212),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.showLabel) ...[
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _uploading ? null : _changePhoto,
            child: const Text(
              'Alterar foto',
              style: TextStyle(
                color: _red,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _changePhoto() async {
    final uid = widget.uid;
    if (uid == null) return;

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.photo_camera, color: Colors.white),
              title: const Text(
                'Tirar foto',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text(
                'Escolher da galeria',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    if (source == ImageSource.camera) {
      final granted = await _ensureCameraPermission();
      if (!granted) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permissão da câmara necessária para tirar fotos.'),
          ),
        );
        return;
      }
    }

    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    setState(() => _uploading = true);
    final bytes = await picked.readAsBytes();
    final result = await ref
        .read(updateProfilePhotoProvider)
        .call(uid: uid, imageBytes: bytes);
    if (!mounted) return;
    setState(() => _uploading = false);
    result.fold(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível atualizar a foto.')),
      ),
      (_) {},
    );
  }

  Future<bool> _ensureCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }
    return status.isGranted || status.isLimited;
  }
}
