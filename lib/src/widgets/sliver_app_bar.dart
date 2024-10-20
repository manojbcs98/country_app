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
            right: 22,
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
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sort Options',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Sort: A-Z',style: TextStyle( fontSize: 18,fontWeight: FontWeight.w500)),
              onTap: () {
                onSortSelected(SortOrder.aToZ);
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              title: const Text('Sort: Z-A',style: TextStyle( fontSize: 18,fontWeight: FontWeight.w500)),
              onTap: () {
                onSortSelected(SortOrder.zToA);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Sort: Region',style: TextStyle( fontSize: 18,fontWeight: FontWeight.w500)),
              onTap: () {
                onSortSelected(SortOrder.region);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Cancel',style: TextStyle( fontSize: 20,fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );
    },
  );
}
