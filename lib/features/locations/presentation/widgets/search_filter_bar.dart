import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/location_providers.dart';
import '../providers/search_filter_provider.dart';

/// A search bar with a debounced text field and a type filter dropdown.
///
/// Both filters work together — changing either triggers a combined
/// re-fetch via [SearchFilterNotifier].
class SearchFilterBar extends ConsumerStatefulWidget {
  const SearchFilterBar({super.key});

  @override
  ConsumerState<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends ConsumerState<SearchFilterBar> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.text = ref.read(searchFilterNotifierProvider).name;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(searchFilterNotifierProvider.notifier).setName(value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(searchFilterNotifierProvider);
    final typesAsync = ref.watch(locationTypesProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        children: [
          // ── Search field ───────────────────────────────────────────
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Search locations...',
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.textMuted,
              ),
              suffixIcon: filters.name.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear_rounded,
                        color: AppColors.textMuted,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        ref
                            .read(searchFilterNotifierProvider.notifier)
                            .setName('');
                      },
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 8),

          // ── Type filter dropdown ───────────────────────────────────
          typesAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (types) {
              if (types.isEmpty) return const SizedBox.shrink();

              return SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _TypeChip(
                      label: 'All',
                      isSelected: filters.type.isEmpty,
                      onTap: () => ref
                          .read(searchFilterNotifierProvider.notifier)
                          .setType(''),
                    ),
                    ...types.map(
                      (type) => _TypeChip(
                        label: type,
                        isSelected: filters.type == type,
                        onTap: () => ref
                            .read(searchFilterNotifierProvider.notifier)
                            .setType(type),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// A selectable chip used in the horizontal type filter list.
class _TypeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.portalGreen.withValues(alpha: 0.25),
        checkmarkColor: AppColors.portalGreen,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.portalGreen : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          fontSize: 13,
        ),
        side: BorderSide(
          color: isSelected
              ? AppColors.portalGreen.withValues(alpha: 0.5)
              : AppColors.divider,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
