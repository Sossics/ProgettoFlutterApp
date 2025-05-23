import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const SideBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      groupAlignment:
          -0.8,
      leading: const Padding(
        padding: EdgeInsets.only(top: 24),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Color.fromARGB(173, 148, 9, 212),
          child: Icon(Icons.person, color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.note),
          label: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text("Notes"),
          ),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.dashboard),
          label: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text("Notepads"),
          ),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.share),
          label: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text("Sharing"),
          ),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person),
          label: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text("Account"),
          ),
        ),
      ],
    );
  }
}
