import 'package:country_app/src/utilities/sort_order.dart';
import 'package:country_app/src/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';

import 'bg_wave_ui.dart';

class SliverSearchAppBar extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;
  final Function(SortOrder) onSortSelected;
  final SortOrder selectedSortOrder;

  const SliverSearchAppBar({
    required this.searchController,
    required this.onSortSelected,
    required this.selectedSortOrder,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var adjustedShrinkOffset =
    shrinkOffset > minExtent ? minExtent : shrinkOffset;
    double offset = (minExtent - adjustedShrinkOffset) * 0.5;
    double topPadding = MediaQuery.of(context).padding.top + 16;

    return Stack(
      children: [
        const BackgroundWave(height: 280),
        Positioned(
          top: topPadding + offset,
          left: 16,
          right: 16,
          child: SearchBar(
            controller: searchController,
            selectedSortOrder: selectedSortOrder,
            onSortSelected: onSortSelected,
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => 280;

  @override
  double get minExtent => 140;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      oldDelegate.maxExtent != maxExtent || oldDelegate.minExtent != minExtent;
}