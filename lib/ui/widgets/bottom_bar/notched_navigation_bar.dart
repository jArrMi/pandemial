// import 'package:crownapp/model/notifier/navigation_model.dart'; // Not used if onTabSelected is implemented
// import 'package:flutter/cupertino.dart'; // Unnecessary import
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // Not used if onTabSelected is implemented

class NavigationItem {
  final IconData icon;
  final String label;

  NavigationItem({required this.icon, required this.label}); // Made parameters required
}

class NotchedNavigationBar extends StatelessWidget {
  NotchedNavigationBar({
    required this.selectedIndex,
    this.insertMiddleItem = false, // Default value
    required this.navigationItems,
    this.height = 60.0, // Default value
    this.iconSize = 24.0, // Default value
    required this.backgroundColor,
    required this.color,
    required this.selectedColor,
    this.notchedShape = const CircularNotchedRectangle(), // Default value
    required this.onTabSelected, // Added required callback
  });

  final bool insertMiddleItem;
  final double height;
  final double iconSize;
  final int selectedIndex;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape? notchedShape; // Made nullable
  final List<NavigationItem> navigationItems;
  final ValueChanged<int> onTabSelected; // Callback for tab selection

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(navigationItems.length, (int index) {
      return _buildTabItem(
        item: navigationItems[index],
        tabIndex: index,
        selectedIndex: selectedIndex, // Use the passed selectedIndex
        onPressed: onTabSelected, // Pass the callback
      );
    });
    if (insertMiddleItem) {
      items.insert(items.length >> 1, _buildMiddleTabItem());
    }

    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items,
      ),
      shape: notchedShape, // Use the passed notchedShape (can be null)
      color: backgroundColor,
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: iconSize),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required int tabIndex, // Made required
    required int selectedIndex, // Made required
    required NavigationItem item, // Made required
    required ValueChanged<int> onPressed, // Made required
  }) {
    Color itemColor = selectedIndex == tabIndex ? selectedColor : color;

    return Expanded(
      child: SizedBox(
        height: height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(tabIndex), // Use the passed callback
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.icon, color: itemColor, size: iconSize),
                Text(
                  item.label,
                  style: TextStyle(color: itemColor),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
