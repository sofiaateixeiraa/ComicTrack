import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/publisher.dart';
import '../providers/catalog_providers.dart';
import '../widgets/fast_scroll_index.dart';
import '../widgets/series_cover_placeholder.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _ctrl = TextEditingController();
  final _publisherScrollController = ScrollController();

  static const _publisherTileExtent = 56.0;
  static const _publisherHeaderExtent = 40.0;
  static const _publisherListTitleExtent = 56.0;
  static const _fastScrollLabels = [
    '#',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    _publisherScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final publishersAsync = ref.watch(publishersProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('PESQUISA GLOBAL'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _ctrl,
              onChanged: (v) =>
                  ref.read(searchQueryProvider.notifier).update(v),
              decoration: InputDecoration(
                hintText: 'Pesquisar em todas as editoras...',
                prefixIcon: const Icon(Icons.search, color: Colors.white38),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _ctrl.clear();
                          ref.read(searchQueryProvider.notifier).update('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: query.trim().isEmpty
                ? _buildPublisherList(publishersAsync)
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildPublisherList(AsyncValue<List<Publisher>> publishersAsync) {
    return publishersAsync.when(
      data: (publishers) {
        final entries = _buildPublisherEntries(publishers);
        final offsetByLabel = _buildPublisherOffsets(entries);
        return Stack(
          children: [
            ListView.builder(
              controller: _publisherScrollController,
              padding: const EdgeInsets.only(right: 32),
              itemCount: entries.length + 1,
              itemBuilder: (_, i) {
                if (i == 0) return const _PublisherListTitle();

                final entry = entries[i - 1];
                final publisher = entry.publisher;
                if (publisher == null) {
                  return _PublisherSectionHeader(label: entry.label);
                }

                return SizedBox(
                  height: _publisherTileExtent,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0x12FFFFFF)),
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        publisher.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.white24,
                      ),
                      onTap: () => context.push(
                        '/publisher/${publisher.id}?name=${Uri.encodeComponent(publisher.name)}',
                      ),
                    ),
                  ),
                );
              },
            ),
            if (offsetByLabel.length > 1)
              FastScrollIndex(
                labels: _fastScrollLabels,
                onSelect: (String label, {required bool animate}) =>
                    _scrollToPublisherLabel(
                      label,
                      offsetByLabel,
                      animate: animate,
                    ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const Center(
        child: Text(
          'Erro ao carregar editoras.',
          style: TextStyle(color: Colors.white54),
        ),
      ),
    );
  }

  List<_PublisherListEntry> _buildPublisherEntries(List<Publisher> publishers) {
    final entries = <_PublisherListEntry>[];
    String? currentLabel;
    for (final publisher in publishers) {
      final label = _publisherIndexLabel(publisher.name);
      if (label != currentLabel) {
        entries.add(_PublisherListEntry.header(label));
        currentLabel = label;
      }
      entries.add(_PublisherListEntry.publisher(label, publisher));
    }
    return entries;
  }

  Map<String, double> _buildPublisherOffsets(
    List<_PublisherListEntry> entries,
  ) {
    final offsetByLabel = <String, double>{};
    var offset = _publisherListTitleExtent;
    for (final entry in entries) {
      if (entry.publisher == null) {
        offsetByLabel.putIfAbsent(entry.label, () => offset);
        offset += _publisherHeaderExtent;
      } else {
        offset += _publisherTileExtent;
      }
    }
    return offsetByLabel;
  }

  String _publisherIndexLabel(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '#';

    final first = trimmed[0].toUpperCase();
    final codeUnit = first.codeUnitAt(0);
    if (codeUnit >= 65 && codeUnit <= 90) return first;
    return '#';
  }

  void _scrollToPublisherLabel(
    String label,
    Map<String, double> offsetByLabel, {
    required bool animate,
  }) {
    final offset = offsetByLabel[label];
    if (offset == null || !_publisherScrollController.hasClients) return;

    final maxScroll = _publisherScrollController.position.maxScrollExtent;
    final target = offset.clamp(0.0, maxScroll).toDouble();
    if (animate) {
      _publisherScrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
      return;
    }

    _publisherScrollController.jumpTo(target);
  }

  Widget _buildSearchResults() {
    final resultsAsync = ref.watch(searchResultsProvider);
    return resultsAsync.when(
      data: (result) {
        if (result.items.isEmpty) {
          return const Center(
            child: Text(
              'Sem resultados para esta pesquisa.',
              style: TextStyle(color: Colors.white54),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  subtitle: Text(
                    '${series.publisher}${series.yearBegan != null ? ' · ${series.yearBegan}' : ''}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
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
          'Erro na pesquisa.',
          style: TextStyle(color: Colors.white54),
        ),
      ),
    );
  }
}

class _PublisherListEntry {
  const _PublisherListEntry._({required this.label, this.publisher});

  factory _PublisherListEntry.header(String label) =>
      _PublisherListEntry._(label: label);

  factory _PublisherListEntry.publisher(String label, Publisher publisher) =>
      _PublisherListEntry._(label: label, publisher: publisher);

  final String label;
  final Publisher? publisher;
}

class _PublisherListTitle extends StatelessWidget {
  const _PublisherListTitle();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: _SearchScreenState._publisherListTitleExtent,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Text(
            'EDITORAS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ),
    );
  }
}

class _PublisherSectionHeader extends StatelessWidget {
  const _PublisherSectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _SearchScreenState._publisherHeaderExtent,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x12FFFFFF))),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFE53935),
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
