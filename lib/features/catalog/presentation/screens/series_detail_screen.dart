import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: seriesAsync.when(
          data: (series) => Text(series.title.toUpperCase()),
          loading: () => const Text(''),
          error: (_, __) => const Text(''),
        ),
      ),
      body: issuesAsync.when(
        data: (result) => ListView.builder(
          itemCount: result.items.length,
          itemBuilder: (_, i) {
            final issue = result.items[i];
            return ListTile(
              leading: Container(
                width: 40, height: 56,
                decoration: BoxDecoration(color: const Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(4)),
                child: const Icon(Icons.menu_book, color: Colors.white24, size: 18),
              ),
              title: Text('#${issue.number}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: issue.coverDate != null
                  ? Text(issue.coverDate!, style: const TextStyle(color: Colors.white54, fontSize: 12)) : null,
              onTap: () => context.push('/issue/${issue.id}'),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Erro ao carregar issues.', style: TextStyle(color: Colors.white54))),
      ),
    );
  }
}