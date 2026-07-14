import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/series.dart';
import '../../domain/entities/paginated_result.dart';
import '../providers/catalog_providers.dart';
import '../widgets/series_cover_placeholder.dart';
part 'publisher_series_screen.g.dart';

@riverpod
Future<PaginatedResult<Series>> publisherSeries(
  Ref ref, {
  required String publisherId,
  required String publisherName,
  String? nameFilter,
  String sort = 'name',
}) async {
  final result = await ref
      .watch(getSeriesByPublisherUseCaseProvider)
      .call(
        publisherId: publisherId,
        publisherName: publisherName,
        nameFilter: nameFilter,
        sort: sort,
      );
  return result.fold(
    (f) => throw f,
    (r) => PaginatedResult<Series>(
      items: _sortSeries(r.items, sort),
      total: r.total,
      nextUrl: r.nextUrl,
      previousUrl: r.previousUrl,
    ),
  );
}

List<Series> _sortSeries(List<Series> series, String sort) {
  final sorted = [...series];

  switch (sort) {
    case 'year_began':
      sorted.sort((a, b) {
        final yearCompare = _ascendingYear(a).compareTo(_ascendingYear(b));
        if (yearCompare != 0) return yearCompare;
        return _normalisedTitle(a.title).compareTo(_normalisedTitle(b.title));
      });
      break;
    case '-year_began':
      sorted.sort((a, b) {
        final yearCompare = _descendingYear(b).compareTo(_descendingYear(a));
        if (yearCompare != 0) return yearCompare;
        return _normalisedTitle(a.title).compareTo(_normalisedTitle(b.title));
      });
      break;
    case 'name':
    default:
      sorted.sort(
        (a, b) =>
            _normalisedTitle(a.title).compareTo(_normalisedTitle(b.title)),
      );
  }

  return sorted;
}

String _normalisedTitle(String title) => title.trim().toLowerCase();

int _ascendingYear(Series series) => series.yearBegan ?? 999999;

int _descendingYear(Series series) => series.yearBegan ?? -1;

class PublisherSeriesScreen extends ConsumerStatefulWidget {
  final String publisherId;
  final String publisherName;
  const PublisherSeriesScreen({
    super.key,
    required this.publisherId,
    required this.publisherName,
  });

  @override
  ConsumerState<PublisherSeriesScreen> createState() =>
      _PublisherSeriesScreenState();
}

class _PublisherSeriesScreenState extends ConsumerState<PublisherSeriesScreen> {
  final _ctrl = TextEditingController();
  final _listScrollController = ScrollController();
  String _filter = '';
  String _sort = 'name';

  @override
  void dispose() {
    _ctrl.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seriesAsync = ref.watch(
      publisherSeriesProvider(
        publisherId: widget.publisherId,
        publisherName: widget.publisherName,
        nameFilter: _filter.isEmpty ? null : _filter,
        sort: _sort,
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(widget.publisherName.toUpperCase())),
      body: Column(
        children: [
          // barra de pesquisa.
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
          // controlo de ordenação.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [_nameSortChip(), _sortChip('year_began', 'Data')],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // lista de series.
          Expanded(
            child: seriesAsync.when(
              data: (result) {
                return ListView.builder(
                  controller: _listScrollController,
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  itemCount: result.items.length,
                  itemBuilder: (_, i) {
                    final series = result.items[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF2E2E2E)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const SeriesCoverPlaceholder(),
                          title: Text(
                            series.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: series.yearBegan != null
                              ? Text(
                                  series.yearBegan.toString(),
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                )
                              : null,
                          onTap: () => context.push('/series/${series.id}'),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Center(
                child: Text(
                  'Erro ao carregar series.',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sortChip(String value, String label) {
    final selected = _sort == value || _sort == '-$value';
    final ascending = _sort == value;
    final icon = selected && !ascending
        ? Icons.arrow_downward
        : Icons.arrow_upward;
    return GestureDetector(
      onTap: () {
        setState(() {
          _sort = selected && ascending ? '-$value' : value;
        });
        _scrollListToTop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE53935) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
            const SizedBox(width: 6),
            Icon(icon, color: Colors.white, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _nameSortChip() {
    final selected = _sort == 'name';
    return GestureDetector(
      onTap: () {
        setState(() => _sort = 'name');
        _scrollListToTop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE53935) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'A-Z',
          style: TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }

  void _scrollListToTop() {
    if (_listScrollController.hasClients) {
      _listScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    }
  }
}
