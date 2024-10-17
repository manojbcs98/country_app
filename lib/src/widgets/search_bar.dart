import 'package:country_app/src/utilities/sort_order.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final SortOrder selectedSortOrder;
  final Function(SortOrder) onSortSelected;

  const SearchBar({
    Key? key,
    required this.controller,
    required this.selectedSortOrder,
    required this.onSortSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFFACCCC);
    const grey = Color(0xFFF2F2F7);

    return SizedBox(
      width: MediaQuery.of(context).size.width - 32,
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          focusedBorder: _border(pink),
          border: _border(grey),
          enabledBorder: _border(grey),
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.black),
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortOptions(context),
          ),
        ),
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
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
            ],
          ),
        );
      },
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderSide: BorderSide(width: 0.5, color: color),
        borderRadius: BorderRadius.circular(12),
      );
}
