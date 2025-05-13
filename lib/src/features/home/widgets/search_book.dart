import 'package:flutter/material.dart';

class SearchBook extends StatelessWidget {
  final void Function(String)? onChanged;
  const SearchBook({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
            onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Search your book',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
