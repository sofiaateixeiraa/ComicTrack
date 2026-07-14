import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../collection/domain/entities/ownership_status.dart';
import '../../../collection/presentation/providers/collection_providers.dart';
import '../providers/auth_providers.dart';
import '../providers/user_profile_providers.dart';

const _red = Color(0xFFE53935);
const _card = Color(0xFF2A2A2A);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final entries = ref
        .watch(userCollectionProvider)
        .maybeWhen(
          data: (result) => result.fold((_) => const [], (entries) => entries),
          orElse: () => const [],
        );
    final profile = ref
        .watch(userProfileProvider)
        .maybeWhen(
          data: (result) => result.fold((_) => null, (p) => p),
          orElse: () => null,
        );

    final online = entries
        .where((e) => e.ownershipStatus == OwnershipStatus.online)
        .length;
    final physical = entries
        .where((e) => e.ownershipStatus == OwnershipStatus.physical)
        .length;
    final total = online + physical;
    final favorites = entries.where((e) => e.isFavorite).length;

    final displayName = profile?.name.isNotEmpty == true
        ? profile!.name
        : user?.displayName;
    final initial = displayName?.isNotEmpty == true
        ? displayName![0].toUpperCase()
        : user?.email.isNotEmpty == true
        ? user!.email[0].toUpperCase()
        : '?';

    Uint8List? photoBytes;
    final photoBase64 = profile?.photoBase64;
    if (photoBase64 != null) {
      try {
        photoBytes = base64Decode(photoBase64);
      } catch (_) {
        photoBytes = null;
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Perfil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: _red, width: 2),
                ),
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: _card,
                backgroundImage: photoBytes != null
                    ? MemoryImage(photoBytes)
                    : null,
                child: photoBytes == null
                    ? Text(
                        initial,
                        style: const TextStyle(
                          color: _red,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (displayName?.isNotEmpty == true)
            Center(
              child: Text(
                displayName!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              user?.email ?? '',
              style: const TextStyle(color: Colors.white54),
            ),
          ),
          const SizedBox(height: 24),

          // estatísticas da coleção.
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _StatTile(icon: Icons.menu_book, count: total, label: 'Total'),
                _StatTile(icon: Icons.wifi, count: online, label: 'Online'),
                _StatTile(
                  icon: Icons.inventory_2_outlined,
                  count: physical,
                  label: 'Físico',
                ),
                _StatTile(
                  icon: Icons.favorite,
                  count: favorites,
                  label: 'Favoritos',
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const _SectionLabel('CONTA'),
          const SizedBox(height: 8),
          _SettingsGroup(
            items: [
              _SettingsItem(
                'Editar perfil',
                onTap: () => context.push('/profile/edit'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const _SectionLabel('APP'),
          const SizedBox(height: 8),
          _SettingsGroup(
            items: [
              _SettingsItem(
                'Sobre a ComicTrack',
                onTap: () => _comingSoon(context),
              ),
            ],
          ),
          const SizedBox(height: 28),

          GestureDetector(
            onTap: () async {
              await ref.read(signOutProvider).call();
              // router redireciona automaticamente para /auth via authState.
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _red.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _red),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: _red, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Terminar sessão',
                    style: TextStyle(color: _red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Em breve.')));
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;

  const _StatTile({
    required this.icon,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: _red, size: 18),
          const SizedBox(height: 6),
          Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: Colors.white54,
      fontSize: 13,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.6,
    ),
  );
}

class _SettingsItem {
  final String label;
  final VoidCallback onTap;
  const _SettingsItem(this.label, {required this.onTap});
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItem> items;
  const _SettingsGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2E2E2E)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++)
            Container(
              decoration: BoxDecoration(
                border: i < items.length - 1
                    ? const Border(bottom: BorderSide(color: Color(0xFF2E2E2E)))
                    : null,
              ),
              child: ListTile(
                title: Text(
                  items[i].label,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.white24,
                ),
                onTap: items[i].onTap,
              ),
            ),
        ],
      ),
    );
  }
}
