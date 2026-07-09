import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/comic_collection_entry.dart';
import '../../domain/entities/ownership_status.dart';
import '../../domain/entities/reading_status.dart';
import '../providers/collection_providers.dart';
import '../widgets/section_filter_chips.dart';

class FullListScreen extends ConsumerStatefulWidget {
  final String type; // 'wishlist' | 'online' | 'physical' | 'favorites'
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
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/home')),
        title: Text(_title, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
      ),
      body: Column(
        children: [
          // Barra de pesquisa
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

          // Filtros (conforme o tipo de lista)
          if (widget.type != 'wishlist')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: widget.type == 'favorites'
                  ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      ReadingFilterChips(
                        selected: _readingFilter,
                        onChanged: (v) => setState(() => _readingFilter = v),
                      ),
                      const SizedBox(height: 8),
                      _ownerFilterRow(),
                    ])
                  : ReadingFilterChips(
                      selected: _readingFilter,
                      onChanged: (v) => setState(() => _readingFilter = v),
                    ),
            ),

          const SizedBox(height: 8),

          // Lista
          Expanded(
            child: collectionAsync.when(
              data: (result) => result.fold(
                (_) => const Center(child: Text('Erro ao carregar.', style: TextStyle(color: Colors.white54))),
                (entries) => _buildList(_filterEntries(entries)),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Center(child: Text('Erro.', style: TextStyle(color: Colors.white54))),
            ),
          ),
        ],
      ),
    );
  }

  List<ComicCollectionEntry> _filterEntries(List<ComicCollectionEntry> all) {
    return all.where((e) {
      // Filtro por tipo de lista
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
      // Filtro de pesquisa pelo nome da série (denormalizado)
      if (_search.isNotEmpty && !e.seriesName.toLowerCase().contains(_search)) return false;
      // Filtros de leitura e posse
      if (_readingFilter != null && e.readingStatus != _readingFilter) return false;
      if (_ownerFilter != null && e.ownershipStatus != _ownerFilter) return false;
      return true;
    }).toList();
  }

  Widget _buildList(List<ComicCollectionEntry> entries) {
    if (entries.isEmpty) {
      return const Center(child: Text('Nenhum issue encontrado.', style: TextStyle(color: Colors.white54)));
    }
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (_, i) {
        final e = entries[i];
        return ListTile(
          leading: Container(
            width: 44, height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.menu_book, color: Colors.white24, size: 20),
          ),
          title: Text('${e.seriesName} #${e.issueNumber}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Row(children: [
            if (e.ownershipStatus != OwnershipStatus.wishlist) ...[
              _statusBadge(_ownershipLabel(e.ownershipStatus)),
              const SizedBox(width: 6),
              if (e.readingStatus != null) _statusBadge(_readingLabel(e.readingStatus!)),
            ],
          ]),
          trailing: e.isFavorite ? const Icon(Icons.favorite, color: Color(0xFFE53935), size: 18) : null,
          onTap: () => context.push('/issue/${e.issueId}'),
        );
      },
    );
  }

  Widget _statusBadge(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
      );

  Widget _ownerFilterRow() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          _ownerChip(null, 'Todos'),
          const SizedBox(width: 8),
          _ownerChip(OwnershipStatus.online, 'Online'),
          const SizedBox(width: 8),
          _ownerChip(OwnershipStatus.physical, 'Físico'),
        ]),
      );

  Widget _ownerChip(OwnershipStatus? value, String label) {
    final selected = _ownerFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _ownerFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE53935) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
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