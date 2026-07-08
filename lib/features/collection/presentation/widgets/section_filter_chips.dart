
import 'package:flutter/material.dart';
import '../../domain/entities/reading_status.dart';
import '../../domain/entities/ownership_status.dart';

class ReadingFilterChips extends StatelessWidget {
  final ReadingStatus? selected; // null = "Todos"
  final void Function(ReadingStatus?) onChanged;

  const ReadingFilterChips({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _chip(context, null, 'Todos'),
          const SizedBox(width: 8),
          _chip(context, ReadingStatus.wantToRead, 'Quero ler'),
          const SizedBox(width: 8),
          _chip(context, ReadingStatus.reading, 'A ler'),
          const SizedBox(width: 8),
          _chip(context, ReadingStatus.read, 'Lido'),
        ],
      ),
    );
  }

  Widget _chip(BuildContext ctx, ReadingStatus? value, String label) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(ctx).colorScheme.primary : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}