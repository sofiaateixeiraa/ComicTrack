import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_providers.dart';
import '../providers/user_profile_providers.dart';
import '../widgets/profile_avatar_picker.dart';

const _surface = Color(0xFF1E1E1E);
const _red = Color(0xFFE53935);

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameCtrl = TextEditingController();
  bool _initialized = false;
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final profile = ref
        .watch(userProfileProvider)
        .maybeWhen(
          data: (result) => result.fold((_) => null, (p) => p),
          orElse: () => null,
        );

    if (!_initialized) {
      if (profile != null && profile.name.isNotEmpty) {
        _nameCtrl.text = profile.name;
        _initialized = true;
      } else if (user?.displayName?.isNotEmpty == true) {
        _nameCtrl.text = user!.displayName!;
        _initialized = true;
      }
    }

    Uint8List? photoBytes;
    final photoBase64 = profile?.photoBase64;
    if (photoBase64 != null) {
      try {
        photoBytes = base64Decode(photoBase64);
      } catch (_) {
        photoBytes = null;
      }
    }
    final initial = _nameCtrl.text.isNotEmpty
        ? _nameCtrl.text[0].toUpperCase()
        : user?.email.isNotEmpty == true
        ? user!.email[0].toUpperCase()
        : '?';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Editar perfil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: ProfileAvatarPicker(
              uid: user?.uid,
              photoBytes: photoBytes,
              initial: initial,
            ),
          ),
          const SizedBox(height: 32),

          const Text(
            'Nome Completo',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameCtrl,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(hintText: 'O teu nome'),
          ),
          const SizedBox(height: 20),

          const Text(
            'Email',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              user?.email ?? '',
              style: const TextStyle(color: Colors.white54),
            ),
          ),
          const SizedBox(height: 20),
          if (user?.hasPasswordProvider == true) ...[
            GestureDetector(
              onTap: () => context.push('/profile/change-email'),
              child: const Text(
                'Alterar email',
                style: TextStyle(
                  color: _red,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => context.push('/profile/change-password'),
              child: const Text(
                'Alterar palavra-passe',
                style: TextStyle(
                  color: _red,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ] else
            const Text(
              'Sessão iniciada com Google. O email e a palavra-passe são geridos na tua conta Google.',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          const SizedBox(height: 32),

          ElevatedButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Guardar Alterações'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O nome não pode estar vazio.')),
      );
      return;
    }

    setState(() => _saving = true);
    final result = await ref
        .read(updateProfileNameProvider)
        .call(uid: user.uid, name: name);
    if (!mounted) return;
    setState(() => _saving = false);

    result.fold(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível guardar as alterações.'),
        ),
      ),
      (_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Perfil atualizado.')));
        context.pop();
      },
    );
  }
}
