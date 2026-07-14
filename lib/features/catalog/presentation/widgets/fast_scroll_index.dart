import 'package:flutter/material.dart';

typedef FastScrollSelect = void Function(String label, {required bool animate});

/// fast scroll index para saltar rapidamente numa lista longa.
class FastScrollIndex extends StatefulWidget {
  const FastScrollIndex({
    super.key,
    required this.labels,
    required this.onSelect,
  });

  final List<String> labels;
  final FastScrollSelect onSelect;

  @override
  State<FastScrollIndex> createState() => _FastScrollIndexState();
}

class _FastScrollIndexState extends State<FastScrollIndex> {
  String? _activeLabel;

  static const _minSlotHeight = 16.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      right: 4,
      bottom: 8,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final visibleLabels = _thinLabels(
            widget.labels,
            constraints.maxHeight,
          );

          void selectFromOffset(Offset localPosition, {required bool animate}) {
            final height = constraints.maxHeight;
            if (height <= 0 || visibleLabels.isEmpty) return;

            final rawIndex = localPosition.dy / height * visibleLabels.length;
            final index = rawIndex
                .floor()
                .clamp(0, visibleLabels.length - 1)
                .toInt();
            final label = visibleLabels[index];
            setState(() => _activeLabel = label);
            widget.onSelect(label, animate: animate);
          }

          void clearActive() => setState(() => _activeLabel = null);

          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapDown: (details) {
              selectFromOffset(details.localPosition, animate: true);
            },
            onTapUp: (_) => clearActive(),
            onVerticalDragDown: (details) {
              selectFromOffset(details.localPosition, animate: false);
            },
            onVerticalDragUpdate: (details) {
              selectFromOffset(details.localPosition, animate: false);
            },
            onVerticalDragEnd: (_) => clearActive(),
            child: Container(
              width: 28,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final label in visibleLabels)
                    Expanded(
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 3,
                            vertical: 1,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: label == _activeLabel
                                ? const Color(0xFFE53935)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              label,
                              maxLines: 1,
                              style: TextStyle(
                                color: label == _activeLabel
                                    ? Colors.white
                                    : const Color(0xFFE53935),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<String> _thinLabels(List<String> labels, double availableHeight) {
    if (labels.isEmpty || availableHeight <= 0) return labels;

    final maxVisible = (availableHeight / _minSlotHeight).floor().clamp(
      1,
      labels.length,
    );
    if (labels.length <= maxVisible) return labels;

    final thinned = <String>[];
    for (var i = 0; i < maxVisible; i++) {
      final index = maxVisible == 1
          ? 0
          : (i * (labels.length - 1) / (maxVisible - 1)).round();
      thinned.add(labels[index]);
    }
    return [
      for (var i = 0; i < thinned.length; i++)
        if (i == 0 || thinned[i] != thinned[i - 1]) thinned[i],
    ];
  }
}
