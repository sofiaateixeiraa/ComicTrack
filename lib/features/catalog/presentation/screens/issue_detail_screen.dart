import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/issue.dart';
import '../providers/catalog_providers.dart';
import '../../../collection/domain/entities/ownership_status.dart';
import '../../../collection/domain/entities/reading_status.dart';
import '../../../collection/presentation/providers/collection_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
part 'issue_detail_screen.g.dart';

@riverpod
Future<Issue> issueDetail(Ref ref, String issueId) async {
  final result = await ref.read(getIssueDetailUseCaseProvider).call(issueId);
  return result.fold((f) => throw f, (i) => i);
}

class IssueDetailScreen extends ConsumerWidget {
  final String issueId;
  const IssueDetailScreen({super.key, required this.issueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final issueAsync = ref.watch(issueDetailProvider(issueId));
    final entryAsync = ref.watch(collectionEntryProvider(issueId));

    return Scaffold(
      body: issueAsync.when(
        data: (issue) => _buildBody(context, ref, issue, entryAsync),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(
          child: Text('Não foi possível carregar os dados deste issue.',
              style: TextStyle(color: Colors.white54)),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, Issue issue, AsyncValue entryAsync) {
    final entry = entryAsync.asData?.value;
    final ownership = entry?.ownershipStatus ?? OwnershipStatus.none;
    final reading = entry?.readingStatus;
    final isFav = entry?.isFavorite ?? false;
    final isInCollection = ownership != OwnershipStatus.none;
    final canHaveReading = ownership == OwnershipStatus.online || ownership == OwnershipStatus.physical;
    final canBeFavorite = reading == ReadingStatus.reading || reading == ReadingStatus.read;
    final title = '${issue.seriesName} #${issue.number}';

    return CustomScrollView(
      slivers: [
        // Capa grande no topo com botão back
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: issue.coverUrl != null
                ? Image.network(issue.coverUrl!, fit: BoxFit.cover)
                : Container(color: const Color(0xFF2A2A2A)),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título (série + número) e criadores
                Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                if (issue.creators.isNotEmpty || issue.coverDate != null)
                  Text(
                    [
                      if (issue.creators.isNotEmpty) issue.creators.join(', '),
                      if (issue.coverDate != null) issue.coverDate!,
                    ].join(' · '),
                    style: const TextStyle(color: Colors.white54, fontSize: 14),
                  ),

                // Sinopse
                if (issue.desc != null) ...[
                  const SizedBox(height: 16),
                  Text(issue.desc!, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)),
                ],

                const SizedBox(height: 24),

                // Dropdown Estado de Posse
                _SectionLabel('Estado de posse'),
                const SizedBox(height: 8),
                _OwnershipDropdown(
                  current: ownership,
                  isInCollection: isInCollection,
                  onChanged: (newStatus) => _updateOwnership(context, ref, newStatus, issue),
                ),

                // Dropdown Estado de Leitura (condicional: só se online/físico)
                if (canHaveReading) ...[
                  const SizedBox(height: 16),
                  _SectionLabel('Estado de leitura'),
                  const SizedBox(height: 8),
                  _ReadingDropdown(
                    current: reading ?? ReadingStatus.wantToRead,
                    onChanged: (newStatus) => _updateReading(context, ref, newStatus, issue),
                  ),
                ],

                // Favorito (condicional)
                if (canBeFavorite) ...[
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _toggleFavorite(context, ref, !isFav, issue),
                    child: Row(
                      children: [
                        Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? const Color(0xFFE53935) : Colors.white54,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isFav ? 'Nos favoritos' : 'Adicionar aos favoritos',
                          style: TextStyle(
                            color: isFav ? const Color(0xFFE53935) : Colors.white54,
                            fontWeight: isFav ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Botão Remover (condicional)
                if (isInCollection) ...[
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () => _confirmRemove(context, ref, title, issue),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE53935),
                      side: const BorderSide(color: Color(0xFFE53935)),
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Remover da coleção', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Handlers ---

  Future<void> _updateOwnership(BuildContext ctx, WidgetRef ref, OwnershipStatus status, Issue issue) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    await ref.read(updateOwnershipStatusProvider).call(
      userId: user.uid,
      issueId: issue.id,
      newStatus: status,
      seriesName: issue.seriesName,
      issueNumber: issue.number,
      coverUrl: issue.coverUrl,
    );
    ref.invalidate(collectionEntryProvider(issue.id));
  }

  Future<void> _updateReading(BuildContext ctx, WidgetRef ref, ReadingStatus status, Issue issue) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    await ref.read(updateReadingStatusProvider).call(
      userId: user.uid,
      issueId: issue.id,
      newStatus: status,
    );
    ref.invalidate(collectionEntryProvider(issue.id));
  }

  Future<void> _toggleFavorite(BuildContext ctx, WidgetRef ref, bool isFav, Issue issue) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    await ref.read(toggleFavoriteProvider).call(
      userId: user.uid,
      issueId: issue.id,
      isFavorite: isFav,
    );
    ref.invalidate(collectionEntryProvider(issue.id));
  }

  Future<void> _confirmRemove(BuildContext ctx, WidgetRef ref, String title, Issue issue) async {
    // Regra 7: confirmação explícita antes de executar a remoção
    final confirmed = await showModalBottomSheet<bool>(
      context: ctx,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _RemoveConfirmationModal(title: title),
    );
    if (confirmed == true) {
      final user = ref.read(currentUserProvider);
      if (user == null) return;
      await ref.read(removeFromCollectionProvider).call(
        userId: user.uid,
        issueId: issue.id,
      );
      ref.invalidate(collectionEntryProvider(issue.id));
    }
  }
}

// --- Sub-widgets ---

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) =>
      Text(text, style: const TextStyle(color: Colors.white54, fontSize: 13));
}

class _OwnershipDropdown extends StatelessWidget {
  final OwnershipStatus current;
  final bool isInCollection;
  final void Function(OwnershipStatus) onChanged;

  const _OwnershipDropdown({required this.current, required this.isInCollection, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    // Se não está na coleção: mostrar "Não está na coleção" + as 3 opções
    // Se já está: não mostrar "Não está na coleção" (apenas as 3)
    final items = <DropdownMenuItem<OwnershipStatus>>[
      if (!isInCollection)
        const DropdownMenuItem<OwnershipStatus>(
          value: OwnershipStatus.none,
          child: Text('Não está na coleção'),
        ),
      const DropdownMenuItem<OwnershipStatus>(
        value: OwnershipStatus.wishlist,
        child: Text('Wishlist'),
      ),
      const DropdownMenuItem<OwnershipStatus>(
        value: OwnershipStatus.online,
        child: Text('Online'),
      ),
      const DropdownMenuItem<OwnershipStatus>(
        value: OwnershipStatus.physical,
        child: Text('Físico'),
      ),
    ];

    return DropdownButtonFormField<OwnershipStatus>(
      initialValue: current,
      items: items,
      onChanged: (v) { if (v != null) onChanged(v); },
      dropdownColor: const Color(0xFF2A2A2A),
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(),
    );
  }
}

class _ReadingDropdown extends StatelessWidget {
  final ReadingStatus current;
  final void Function(ReadingStatus) onChanged;

  const _ReadingDropdown({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ReadingStatus>(
      initialValue: current,
      items: const [
        DropdownMenuItem<ReadingStatus>(
          value: ReadingStatus.wantToRead,
          child: Text('Quero ler'),
        ),
        DropdownMenuItem<ReadingStatus>(
          value: ReadingStatus.reading,
          child: Text('A ler'),
        ),
        DropdownMenuItem<ReadingStatus>(
          value: ReadingStatus.read,
          child: Text('Lido'),
        ),
      ],
      onChanged: (v) { if (v != null) onChanged(v); },
      dropdownColor: const Color(0xFF2A2A2A),
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(),
    );
  }
}

/// Modal de Confirmação de Remoção (Regra 7).
/// Frame separado no Figma — não é destino de navegação principal.
class _RemoveConfirmationModal extends StatelessWidget {
  final String title;
  const _RemoveConfirmationModal({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
          ),
          const SizedBox(height: 20),
          const Text('REMOVER DA COLEÇÃO',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              children: [
                const TextSpan(text: 'Tens a certeza que queres remover '),
                TextSpan(text: '"$title"', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                const TextSpan(text: ' da tua coleção?'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white54,
                    side: const BorderSide(color: Colors.white24),
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48)),
                  child: const Text('Remover'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}