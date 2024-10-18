import 'package:country_app/src/utilities/sort_order.dart';
import 'package:country_app/src/widgets/search_bar.dart';
import 'package:flutter/material.dart';
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
          right: 60,
          child: SearchBar(
            controller: searchController,
          ),
        ),
        Positioned(
            top: topPadding + offset + 10,
            right: 16,
            child: InkWell(
                onTap: () {
                    _showSortOptions(context, onSortSelected);

                },
                child: const Icon(
                  Icons.sort,
                  color: Colors.blue,
                )))
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

void _showSortOptions(
    BuildContext context, Function(SortOrder) onSortSelected) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Sort A-Z'),
              onTap: () {
                onSortSelected(SortOrder.aToZ);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sort Z-A'),
              onTap: () {
                onSortSelected(SortOrder.zToA);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sort By Region'),
              onTap: () {
                onSortSelected(SortOrder.region);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
