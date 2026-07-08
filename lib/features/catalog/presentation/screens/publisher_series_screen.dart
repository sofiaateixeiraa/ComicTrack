import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/series.dart';
import '../../domain/entities/paginated_result.dart';
import '../providers/catalog_providers.dart';
part 'publisher_series_screen.g.dart';

@riverpod
Future<PaginatedResult<Series>> publisherSeries(
  Ref ref, {
  required String publisherId,
  required String publisherName,   // a API não devolve isto na listagem — ver B.2
  String? nameFilter,
  String sort = 'name',
}) async {
  final result = await ref.watch(getSeriesByPublisherUseCaseProvider).call(
    publisherId: publisherId,
    publisherName: publisherName,
    nameFilter: nameFilter,
    sort: sort,
  );
  return result.fold((f) => throw f, (r) => r);
}

class PublisherSeriesScreen extends ConsumerStatefulWidget {
  final String publisherId;
  final String publisherName;
  const PublisherSeriesScreen({super.key, required this.publisherId, required this.publisherName});

  @override
  ConsumerState<PublisherSeriesScreen> createState() => _PublisherSeriesScreenState();
}

class _PublisherSeriesScreenState extends ConsumerState<PublisherSeriesScreen> {
  final _ctrl = TextEditingController();
  String _filter = '';
  String _sort = 'name'; // 'name' = A-Z | '-year_began' = Data

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final seriesAsync = ref.watch(publisherSeriesProvider(
      publisherId: widget.publisherId,
      publisherName: widget.publisherName,
      nameFilter: _filter.isEmpty ? null : _filter,
      sort: _sort,
    ));

    return Scaffold(
      appBar: AppBar(title: Text(widget.publisherName.toUpperCase())),
      body: Column(
        children: [
          // Barra de pesquisa
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _ctrl,
              onChanged: (v) => setState(() => _filter = v),
              decoration: const InputDecoration(
                hintText: 'Pesquisar...',
                prefixIcon: Icon(Icons.search, color: Colors.white38),
              ),
            ),
          ),
          // Controlo de ordenação
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _sortChip('name', 'A–Z'),
                const SizedBox(width: 10),
                _sortChip('-year_began', 'Data de lançamento'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Lista de séries
          Expanded(
            child: seriesAsync.when(
              data: (result) => ListView.builder(
                itemCount: result.items.length,
                itemBuilder: (_, i) {
                  final series = result.items[i];
                  return ListTile(
                    leading: Container(
                      width: 40, height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.menu_book, color: Colors.white24, size: 18),
                    ),
                    title: Text(series.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: series.yearBegan != null
                        ? Text(series.yearBegan.toString(), style: const TextStyle(color: Colors.white54, fontSize: 12))
                        : null,
                    onTap: () => context.push('/series/${series.id}'),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text('Erro ao carregar séries.', style: TextStyle(color: Colors.white54))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sortChip(String value, String label) {
    final selected = _sort == value;
    return GestureDetector(
      onTap: () => setState(() => _sort = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE53935) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
      ),
    );
  }
}