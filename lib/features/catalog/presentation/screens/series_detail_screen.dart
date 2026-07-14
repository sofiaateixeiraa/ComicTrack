import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../collection/domain/entities/comic_collection_entry.dart';
import '../../../collection/domain/entities/ownership_status.dart';
import '../../../collection/domain/entities/reading_status.dart';
import '../../../collection/presentation/providers/collection_providers.dart';
import '../../domain/entities/series.dart';
import '../providers/catalog_providers.dart';
part 'series_detail_screen.g.dart';

@riverpod
Future<Series> seriesDetail(Ref ref, String seriesId) async {
  final result = await ref.watch(getSeriesDetailUseCaseProvider).call(seriesId);
  return result.fold((f) => throw f, (s) => s);
}

class SeriesDetailScreen extends ConsumerWidget {
  final String seriesId;
  const SeriesDetailScreen({super.key, required this.seriesId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(seriesDetailProvider(seriesId));
    final issuesAsync = ref.watch(seriesIssuesProvider(seriesId));
    final collectionAsync = ref.watch(userCollectionProvider);
    final collectionEntries = collectionAsync.maybeWhen(
      data: (result) => result.fold(
        (_) => const <ComicCollectionEntry>[],
        (entries) => entries,
      ),
      orElse: () => const <ComicCollectionEntry>[],
    );
    final collectionByIssueId = {
      for (final entry in collectionEntries) entry.issueId: entry,
    };

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: seriesAsync.when(
          data: (series) => Text(series.title.toUpperCase()),
          loading: () => const Text(''),
          error: (_, _) => const Text(''),
        ),
      ),
      body: issuesAsync.when(
        data: (result) => GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.56,
          ),
          itemCount: result.items.length,
          itemBuilder: (_, i) {
            final issue = result.items[i];
            final entry = collectionByIssueId[issue.id];
            final coverUrl = issue.coverUrl ?? entry?.coverUrl;
            return GestureDetector(
              onTap: () => context.push('/issue/${issue.id}'),
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
                          _IssueCover(url: coverUrl),
                          if (entry != null)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFFE53935),
                                  size: 18,
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
                            '#${issue.number}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          if (issue.coverDate != null || entry != null)
                            _IssueSubtitle(issue.coverDate, entry: entry),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(
          child: Text(
            'Erro ao carregar issues.',
            style: TextStyle(color: Colors.white54),
          ),
        ),
      ),
    );
  }
}

class _IssueCover extends StatelessWidget {
  final String? url;

  const _IssueCover({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: url != null && url!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: url!,
              fit: BoxFit.cover,
              placeholder: (_, _) => const _CoverPlaceholder(),
              errorWidget: (_, _, _) => const _CoverPlaceholder(),
            )
          : const _CoverPlaceholder(),
    );
  }
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

class _IssueSubtitle extends StatelessWidget {
  final String? coverDate;
  final ComicCollectionEntry? entry;

  const _IssueSubtitle(this.coverDate, {required this.entry});

  @override
  Widget build(BuildContext context) {
    final collectionEntry = entry;
    if (coverDate == null && collectionEntry == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (coverDate != null)
            Text(
              coverDate!,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          if (collectionEntry != null)
            _CollectionBadge(
              label: _ownershipLabel(collectionEntry.ownershipStatus),
            ),
          if (collectionEntry?.readingStatus != null)
            _StatusBadge(label: _readingLabel(collectionEntry!.readingStatus!)),
          if (collectionEntry?.isFavorite == true)
            const Icon(Icons.favorite, color: Color(0xFFE53935), size: 16),
        ],
      ),
    );
  }

  String _ownershipLabel(OwnershipStatus status) => switch (status) {
    OwnershipStatus.wishlist => 'Wishlist',
    OwnershipStatus.online => 'Online',
    OwnershipStatus.physical => 'Físico',
    OwnershipStatus.none => 'Na coleção',
  };

  String _readingLabel(ReadingStatus status) => switch (status) {
    ReadingStatus.wantToRead => 'Quero ler',
    ReadingStatus.reading => 'A ler',
    ReadingStatus.read => 'Lido',
  };
}

class _CollectionBadge extends StatelessWidget {
  final String label;

  const _CollectionBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
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
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;

  const _StatusBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white54, fontSize: 11),
      ),
    );
  }
}
