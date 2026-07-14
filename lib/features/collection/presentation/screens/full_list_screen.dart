import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/comic_collection_entry.dart';
import '../../domain/entities/ownership_status.dart';
import '../../domain/entities/reading_status.dart';
import '../providers/collection_providers.dart';
import '../widgets/section_filter_chips.dart';

class FullListScreen extends ConsumerStatefulWidget {
  final String type;
  const FullListScreen({super.key, required this.type});

  @override
  ConsumerState<FullListScreen> createState() => _FullListScreenState();
}

class _FullListScreenState extends ConsumerState<FullListScreen> {
  String _search = '';
  ReadingStatus? _readingFilter;
  OwnershipStatus? _ownerFilter;

  String get _title => switch (widget.type) {
    'wishlist' => 'WISHLIST',
    'online' => 'ONLINE',
    'physical' => 'FÍSICO',
    'favorites' => 'FAVORITOS',
    _ => '',
  };

  @override
  Widget build(BuildContext context) {
    final collectionAsync = ref.watch(userCollectionProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: Text(
          _title,
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
      body: Column(
        children: [
          // barra de pesquisa.
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _search = v.toLowerCase()),
              decoration: const InputDecoration(
                hintText: 'Pesquisar...',
                prefixIcon: Icon(Icons.search, color: Colors.white38),
              ),
            ),
          ),

          // filtros (conforme o tipo de lista).
          if (widget.type != 'wishlist')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: widget.type == 'favorites'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ownerFilterRow(),
                          const SizedBox(height: 8),
                          ReadingFilterChips(
                            selected: _readingFilter,
                            onChanged: (v) =>
                                setState(() => _readingFilter = v),
                            showWantToRead: false,
                          ),
                        ],
                      )
                    : ReadingFilterChips(
                        selected: _readingFilter,
                        onChanged: (v) => setState(() => _readingFilter = v),
                      ),
              ),
            ),

          const SizedBox(height: 8),

          // lista.
          Expanded(
            child: collectionAsync.when(
              data: (result) => result.fold(
                (_) => const Center(
                  child: Text(
                    'Erro ao carregar.',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
                (entries) => _buildList(_filterEntries(entries)),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Center(
                child: Text('Erro.', style: TextStyle(color: Colors.white54)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<ComicCollectionEntry> _filterEntries(List<ComicCollectionEntry> all) {
    return all.where((e) {
      // filtro por tipo de lista.
      switch (widget.type) {
        case 'wishlist':
          if (e.ownershipStatus != OwnershipStatus.wishlist) return false;
        case 'online':
          if (e.ownershipStatus != OwnershipStatus.online) return false;
        case 'physical':
          if (e.ownershipStatus != OwnershipStatus.physical) return false;
        case 'favorites':
          if (!e.isFavorite) return false;
      }
      // filtro de pesquisa pelo nome da série.
      if (_search.isNotEmpty && !e.seriesName.toLowerCase().contains(_search)) return false;
      // filtros de leitura e posse.
      if (_readingFilter != null && e.readingStatus != _readingFilter) return false;
      if (_ownerFilter != null && e.ownershipStatus != _ownerFilter) return false;
      return true;
    }).toList();
  }

  Widget _buildList(List<ComicCollectionEntry> entries) {
    if (entries.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma comic encontrada.',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.6,
      ),
      itemCount: entries.length,
      itemBuilder: (_, i) {
        final e = entries[i];
        final showOwnershipBadge =
            widget.type == 'favorites' &&
            e.ownershipStatus != OwnershipStatus.none;
        final showReadingBadge = e.readingStatus != null;
        final hasStatusBadges = showOwnershipBadge || showReadingBadge;
        return GestureDetector(
          onTap: () => context.push('/issue/${e.issueId}'),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF2E2E2E)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: e.coverUrl != null && e.coverUrl!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: e.coverUrl!,
                                fit: BoxFit.cover,
                                placeholder: (_, _) =>
                                    const _CoverPlaceholder(),
                                errorWidget: (_, _, _) =>
                                    const _CoverPlaceholder(),
                              )
                            : const _CoverPlaceholder(),
                      ),
                      if (e.isFavorite)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.85),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite,
                              color: Color(0xFFE53935),
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${e.seriesName} #${e.issueNumber}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      if (hasStatusBadges)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              if (showOwnershipBadge)
                                _ownershipBadge(
                                  _ownershipLabel(e.ownershipStatus),
                                ),
                              if (showReadingBadge)
                                _readingBadgeRed(
                                  _readingLabel(e.readingStatus!),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _ownershipBadge(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: const Color(0xFFE53935),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _readingBadgeRed(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: const Color(0xFFE53935),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _ownerFilterRow() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        _ownerChip(null, 'Todos'),
        const SizedBox(width: 8),
        _ownerChip(OwnershipStatus.online, 'Online'),
        const SizedBox(width: 8),
        _ownerChip(OwnershipStatus.physical, 'Físico'),
      ],
    ),
  );

  Widget _ownerChip(OwnershipStatus? value, String label) {
    final selected = _ownerFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _ownerFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE53935) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  String _ownershipLabel(OwnershipStatus s) => switch (s) {
    OwnershipStatus.online => 'Online',
    OwnershipStatus.physical => 'Físico',
    OwnershipStatus.wishlist => 'Wishlist',
    OwnershipStatus.none => '',
  };

  String _readingLabel(ReadingStatus s) => switch (s) {
    ReadingStatus.wantToRead => 'Quero ler',
    ReadingStatus.reading => 'A ler',
    ReadingStatus.read => 'Lido',
  };
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2A2A2A),
      alignment: Alignment.center,
      child: const Icon(Icons.menu_book, color: Colors.white24, size: 28),
    );
  }
}
