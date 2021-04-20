import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';


class FloatingSearchAppBarExample extends StatelessWidget with PreferredSizeWidget {
  const FloatingSearchAppBarExample({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingSearchAppBar(
      title: const Text('Concept map'),
      transitionDuration: const Duration(milliseconds: 800),
      color: Color(0xFF03A9F4),
      colorOnScroll: Color(0xFF29B6F6),
      body: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: 100,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item $index'),
          );
        },
      ),
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
