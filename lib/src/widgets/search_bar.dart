import 'package:country_app/src/utilities/sort_order.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController controller;

  const SearchBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.controller.selection = TextSelection.collapsed(offset: 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFFACCCC);
    const grey = Color(0xFFF2F2F7);

    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusedBorder: _border(pink),
        border: _border(grey),
        enabledBorder: _border(grey),
        hintText: 'Search',
        hintStyle: const TextStyle(color: Colors.black),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.black,
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: widget.controller.text.isNotEmpty,
              child: IconButton(
                icon: const Icon(Icons.clear, color: Colors.black87),
                onPressed: () {
                  widget.controller.clear(); // Clear the text field
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderSide: BorderSide(width: 0.5, color: color),
    borderRadius: BorderRadius.circular(12),
  );

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
