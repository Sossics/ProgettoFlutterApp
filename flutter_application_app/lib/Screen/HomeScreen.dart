import 'package:flutter/material.dart';
import 'package:flutter_application_app/Services/TokenStorageService.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_application_app/Widgets/NotesPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TokenStorageService _tokenStorageService = TokenStorageService();
  // ignore: unused_field
  String? _token;
  String _username = "Utente";
  int _selectedIndex = 0;

  final List<String> _pageTitles = [
    "Notes",
    "Noteblocks",
    "Sharing",
    "Account",
  ];

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    String? token = await _tokenStorageService.getToken();
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

  Widget _buildPageContent(bool isWide) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 800),
            child: Text(
              "Welcome to your Home,",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: Colors.grey.shade800),
            ),
          ),
          const SizedBox(height: 6),
          FadeInDown(
            duration: const Duration(milliseconds: 1000),
            from: 30,
            child: Text(
              _username,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: isWide ? 2 : 1,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: isWide ? 1.6 : 1.2,
              children: [
                _buildHomeCard("Notes", Icons.note_alt_outlined, Colors.indigo, () {}),
                _buildHomeCard("Noteblocks", Icons.dashboard_customize_outlined, Colors.deepOrange, () {}),
                _buildHomeCard("Sharing", Icons.share_outlined, Colors.teal, () {}),
                _buildHomeCard("Account", Icons.person_outline, Colors.purple, () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileContent() {
    final List<Widget> _mobilePages = [
      const NotesPage(),
      Center(child: Text("Noteblocks Page")),
      Center(child: Text("Sharing Page")),
      Center(child: Text("Account Page")),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green.withOpacity(0.1),
              foregroundColor: Colors.green,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text("Add Note"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(child: Text(_username, style: const TextStyle(fontWeight: FontWeight.w500))),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: _mobilePages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.note), label: "Notes"),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Noteblocks"),
          BottomNavigationBarItem(icon: Icon(Icons.share), label: "Sharing"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
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
                appBar: AppBar(
                  title: const Text("Home"),
                  actions: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green.withOpacity(0.1),
                        foregroundColor: Colors.green,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text("Add Note"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Center(child: Text(_username, style: const TextStyle(fontWeight: FontWeight.w500))),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                body: _buildPageContent(isWide),
              )
            : _buildMobileContent();
      },
    );
  }
}
