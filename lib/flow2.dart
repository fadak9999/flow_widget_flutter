import 'package:flutter/material.dart';

class FlowExample2 extends StatefulWidget {
  const FlowExample2({super.key});

  @override
  State<FlowExample2> createState() => _FlowExample2State();
}

class _FlowExample2State extends State<FlowExample2>
    with SingleTickerProviderStateMixin {
  late AnimationController menuAnimation;
  IconData lastIconClicked = Icons.notifications;
  final List<IconData> menuItems = <IconData>[
    Icons.home,
    Icons.new_releases,
    Icons.pets,
    Icons.settings,
    Icons.menu,
  ];

  @override
  void initState() {
    super.initState();
    menuAnimation = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  @override
  void dispose() {
    menuAnimation.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      if (menuAnimation.isDismissed) {
        menuAnimation.forward();
      } else {
        menuAnimation.reverse();
      }
    });
  }

  void _handleIconPress(IconData icon) {
    setState(() {
      lastIconClicked = icon;
      if (icon != Icons.menu) {
        print("مرحبا");
      } else {
        _toggleMenu();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flow Example'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Center(
            child: Flow(
              delegate: FlowMenuDelegate(menuAnimation: menuAnimation),
              children: menuItems.map((IconData icon) {
                return FloatingActionButton(
                  onPressed: () => _handleIconPress(icon),
                  child: Icon(icon),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

//_______________
class FlowMenuDelegate extends FlowDelegate {
  final Animation<double> menuAnimation;

  FlowMenuDelegate({required this.menuAnimation})
      : super(repaint: menuAnimation);

  @override
  void paintChildren(FlowPaintingContext context) {
    for (int i = 0; i < context.childCount; i++) {
      final double dx =
          (context.getChildSize(i)?.width ?? 0) * i * menuAnimation.value;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(dx, 0, 0),
      );
    }
  }

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }
}
