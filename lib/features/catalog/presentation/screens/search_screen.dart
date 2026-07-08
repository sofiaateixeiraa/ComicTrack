import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/catalog_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final publishersAsync = ref.watch(publishersProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          onChanged: (v) => ref.read(searchQueryProvider.notifier).update(v),
          decoration: const InputDecoration(
            hintText: 'Pesquisar séries...',
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _ctrl.clear();
                ref.read(searchQueryProvider.notifier).update('');
              },
            ),
        ],
      ),
      body: query.trim().isEmpty
          ? _buildPublisherList(publishersAsync)
          : _buildSearchResults(),
    );
  }

  Widget _buildPublisherList(AsyncValue publishersAsync) {
    return publishersAsync.when(
      data: (publishers) => ListView.builder(
        itemCount: publishers.length,
        itemBuilder: (_, i) {
          final p = publishers[i];
          return ListTile(
            title: Text(p.name, style: const TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: Colors.white38),
            onTap: () => context.push('/publisher/${p.id}?name=${Uri.encodeComponent(p.name)}'),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Erro ao carregar editoras.', style: TextStyle(color: Colors.white54))),
    );
  }

  Widget _buildSearchResults() {
    final resultsAsync = ref.watch(searchResultsProvider);
    return resultsAsync.when(
      data: (result) {
        if (result.items.isEmpty) {
          return const Center(
            child: Text('Sem resultados para esta pesquisa.', style: TextStyle(color: Colors.white54)),
          );
        }
        return ListView.builder(
          itemCount: result.items.length,
          itemBuilder: (_, i) {
            final series = result.items[i];
            return ListTile(
              leading: Container(
                width: 40,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.menu_book, color: Colors.white24, size: 20),
              ),
              title: Text(series.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text('${series.publisher}${series.yearBegan != null ? ' · ${series.yearBegan}' : ''}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12)),
              onTap: () => context.push('/series/${series.id}'),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Erro na pesquisa.', style: TextStyle(color: Colors.white54))),
    );
  }
}