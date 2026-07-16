import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../auth/presentation/providers/user_profile_providers.dart';
import '../../domain/entities/comic_collection_entry.dart';
import '../../domain/entities/ownership_status.dart';
import '../../domain/entities/reading_status.dart';
import '../providers/collection_providers.dart';
import '../widgets/section_filter_chips.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  // filtros por secção.
  ReadingStatus? _onlineFilter;
  ReadingStatus? _physicalFilter;
  ReadingStatus? _favReadingFilter;
  OwnershipStatus? _favOwnerFilter;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final collectionAsync = ref.watch(userCollectionProvider);
    final profile = ref
        .watch(userProfileProvider)
        .maybeWhen(
          data: (result) => result.fold((_) => null, (p) => p),
          orElse: () => null,
        );
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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // app bar com logo e ícone perfil.
            SliverToBoxAdapter(child: _buildHeader(context, photoBytes)),
            // barra de pesquisa fixa.
            SliverToBoxAdapter(child: _buildSearchBar()),
            // secções.
            SliverToBoxAdapter(
              child: collectionAsync.when(
                data: (result) => result.fold(
                  (failure) => const _ErrorWidget(),
                  (entries) => _buildSections(entries),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => const _ErrorWidget(),
              ),
            ),
          ],
        ),
      ),
      // botão para ir à pesquisa.
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/search'),
        backgroundColor: const Color(0xFFE53935),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Uint8List? photoBytes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'COMIC',
                  style: GoogleFonts.bangers(fontSize: 28, color: Colors.white),
                ),
                TextSpan(
                  text: 'TRACK',
                  style: GoogleFonts.bangers(
                    fontSize: 28,
                    color: const Color(0xFFE53935),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/profile'),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF2A2A2A),
              backgroundImage: photoBytes != null
                  ? MemoryImage(photoBytes)
                  : null,
              child: photoBytes == null
                  ? const Icon(
                      Icons.person_outline,
                      size: 20,
                      color: Colors.white70,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
        decoration: const InputDecoration(
          hintText: 'Pesquisar na coleção...',
          prefixIcon: Icon(Icons.search, color: Colors.white38),
        ),
      ),
    );
  }

  Widget _buildSections(List<ComicCollectionEntry> entries) {
    return Column(
      children: [
        _buildSection(
          title: 'WISHLIST',
          icon: '📋',
          entries: _filterAndSearch(entries, OwnershipStatus.wishlist, null),
          showViewAll: true,
          listType: 'wishlist',
        ),
        _buildOnlineSection(entries),
        _buildPhysicalSection(entries),
        _buildFavoritesSection(entries),
        const SizedBox(height: 100),
      ],
    );
  }

  List<ComicCollectionEntry> _filterAndSearch(
    List<ComicCollectionEntry> all,
    OwnershipStatus ownership,
    ReadingStatus? readingFilter,
  ) {
    return all.where((e) {
      if (e.ownershipStatus != ownership) return false;
      if (readingFilter != null && e.readingStatus != readingFilter) {
        return false;
      }
      // pesquisa pelo nome da série.
      if (_searchQuery.isNotEmpty &&
          !e.seriesName.toLowerCase().contains(_searchQuery)) {
        return false;
      }
      return true;
    }).toList();
  }

  Widget _buildOnlineSection(List<ComicCollectionEntry> entries) {
    final filtered = entries.where((e) {
      if (e.ownershipStatus != OwnershipStatus.online) return false;
      if (_onlineFilter != null && e.readingStatus != _onlineFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty &&
          !e.seriesName.toLowerCase().contains(_searchQuery)) {
        return false;
      }
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('ONLINE', 'online'),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: ReadingFilterChips(
            selected: _onlineFilter,
            onChanged: (v) => setState(() => _onlineFilter = v),
          ),
        ),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              _emptyMessage('online'),
              style: const TextStyle(color: Colors.white38, fontSize: 14),
            ),
          )
        else
          _buildCarousel(filtered, 'online'),
      ],
    );
  }

  Widget _buildPhysicalSection(List<ComicCollectionEntry> entries) {
    final filtered = entries.where((e) {
      if (e.ownershipStatus != OwnershipStatus.physical) return false;
      if (_physicalFilter != null && e.readingStatus != _physicalFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty &&
          !e.seriesName.toLowerCase().contains(_searchQuery)) {
        return false;
      }
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('FÍSICO', 'physical'),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: ReadingFilterChips(
            selected: _physicalFilter,
            onChanged: (v) => setState(() => _physicalFilter = v),
          ),
        ),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              _emptyMessage('physical'),
              style: const TextStyle(color: Colors.white38, fontSize: 14),
            ),
          )
        else
          _buildCarousel(filtered, 'physical'),
      ],
    );
  }

  Widget _buildFavoritesSection(List<ComicCollectionEntry> entries) {
    final filtered = entries.where((e) {
      if (!e.isFavorite) return false;
      if (_favReadingFilter != null && e.readingStatus != _favReadingFilter) {
        return false;
      }
      if (_favOwnerFilter != null && e.ownershipStatus != _favOwnerFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty &&
          !e.seriesName.toLowerCase().contains(_searchQuery)) {
        return false;
      }
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('FAVORITOS', 'favorites'),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _favOwnerChip(null, 'Todos'),
                      const SizedBox(width: 6),
                      _favOwnerChip(OwnershipStatus.online, 'Online'),
                      const SizedBox(width: 6),
                      _favOwnerChip(OwnershipStatus.physical, 'Físico'),
                      const SizedBox(width: 12),
                      _favChip(null, 'Todos', true),
                      const SizedBox(width: 6),
                      _favChip(ReadingStatus.reading, 'A ler', true),
                      const SizedBox(width: 6),
                      _favChip(ReadingStatus.read, 'Lido', true),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              _emptyMessage('favorites'),
              style: const TextStyle(color: Colors.white38, fontSize: 14),
            ),
          )
        else
          _buildCarousel(filtered, 'favorites'),
      ],
    );
  }

  Widget _favChip(ReadingStatus? value, String label, bool isReading) {
    final isSelected = _favReadingFilter == value;
    return _filterChip(
      label,
      isSelected,
      () => setState(() => _favReadingFilter = value),
    );
  }

  Widget _favOwnerChip(OwnershipStatus? value, String label) {
    final isSelected = _favOwnerFilter == value;
    return _filterChip(
      label,
      isSelected,
      () => setState(() => _favOwnerFilter = value),
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE53935) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String icon,
    required List<ComicCollectionEntry> entries,
    required bool showViewAll,
    required String listType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(title, listType),
        if (entries.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              _emptyMessage(listType),
              style: const TextStyle(color: Colors.white38, fontSize: 14),
            ),
          )
        else
          _buildCarousel(entries, listType),
      ],
    );
  }

  Widget _sectionHeader(String title, String listType) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.bangers(
              fontSize: 22,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/list/$listType'),
            child: const Icon(Icons.chevron_right, color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel(List<ComicCollectionEntry> entries, String listType) {
    if (entries.isEmpty) return const SizedBox.shrink();

    final show = entries.take(5).toList();
    final hasMore = entries.length > 5;

    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: show.length + (hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          if (hasMore && i == show.length) {
            return GestureDetector(
              onTap: () => context.push('/list/$listType'),
              child: Container(
                width: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.chevron_right,
                  color: Colors.white38,
                  size: 32,
                ),
              ),
            );
          }
          final entry = show[i];
          return GestureDetector(
            onTap: () => context.push('/issue/${entry.issueId}'),
            child: SizedBox(
              width: 110,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: entry.coverUrl != null
                        ? CachedNetworkImage(
                            imageUrl: entry.coverUrl!,
                            width: 110,
                            height: 160,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 110,
                            height: 160,
                            color: const Color(0xFF2A2A2A),
                            child: const Icon(
                              Icons.menu_book,
                              color: Colors.white24,
                            ),
                          ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${entry.seriesName} #${entry.issueNumber}',
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _emptyMessage(String type) => switch (type) {
    'wishlist' => 'A tua wishlist está vazia.',
    'online' => 'Nenhuma comic online.',
    'physical' => 'Nenhuma comic física.',
    'favorites' => 'Ainda não tens favoritos.',
    _ => 'Sem resultados.',
  };
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget();
  @override
  Widget build(BuildContext context) => const Center(
    child: Text(
      'Erro ao carregar a coleção.',
      style: TextStyle(color: Colors.white54),
    ),
  );
}
