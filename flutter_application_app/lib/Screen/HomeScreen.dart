import 'package:flutter/material.dart';
import 'package:flutter_application_app/Services/StorageService.dart';
import 'package:flutter_application_app/Widgets/SharingPage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_application_app/Widgets/NotesPage.dart';
import 'package:flutter_application_app/Widgets/CustomSideBar.dart';
import 'package:flutter_application_app/Widgets/HeaderBar.dart';
import 'package:flutter_application_app/Widgets/AccountPage.dart';
import 'package:flutter_application_app/Widgets/NoteblockPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _StorageService = StorageService();
  // ignore: unused_field
  String? _token;
  String _username = "Utente";
  int _selectedIndex = 0;

  final List<String> _pageTitles = [
    "Notes",
    "Notepads",
    "Sharing",
    "Account",
  ];

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    String? token = await _StorageService.getToken();
    print("\n\n\n\-------------------"+token.toString()+"-------------------\n\n\n\n");
    // _tokenStorageService.deleteToken();
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      setState(() {
        _token = token;
        _username = decodedToken['username'] ?? "Utente";
      });
    }
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHomeCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 16),
            Text(title, style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

Widget _buildWideLayout() {
  final List<Widget> _desktopPages = [
    const NotesPage(),
    const NoteblockPage(),
      const SharingPage(),
    AccountPage(),
  ];

  return Row(
    children: [
      SideBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onBottomNavTapped,
      ),
      const VerticalDivider(thickness: 1, width: 1),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderBar(
              pageTitle: _pageTitles[_selectedIndex],
              username: _username,
              onBack: null, // o () => Navigator.pop(context) se serve
            ),
            Expanded(
              child: _desktopPages[_selectedIndex],
            ),
          ],
        ),
      ),
    ],
  );
}

  Widget _buildMobileContent() {
    final List<Widget> mobilePages = [
      const NotesPage(),
      const NoteblockPage(),
      const SharingPage(),
      AccountPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        //inserisci un padding on top
        toolbarHeight: 80,
        //rendila scollabile
        toolbarOpacity: 0.9,
        backgroundColor: const Color.fromARGB(0, 252, 221, 255),
        title: HeaderBar(
          pageTitle: _pageTitles[_selectedIndex],
          username: _username,
          onBack: null, // o () => Navigator.pop(context) se serve
        ),
      ),
      body: mobilePages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        indicatorColor: const Color.fromARGB(38, 84, 2, 161),
        onDestinationSelected: _onBottomNavTapped,
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.note),
            icon: Icon(Icons.note),
            label: 'Notes',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.dashboard),
            icon: Icon(Icons.dashboard),
            label: 'Notepads',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.share),
            icon: Icon(Icons.share),
            label: 'Sharing',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return isWide
            ? Scaffold(
                body: _buildWideLayout(),
              )
            : _buildMobileContent();
      },
    );
  }
}
