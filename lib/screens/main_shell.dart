import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import 'home_screen.dart';
import 'leaderboard_screen.dart';
import 'profile_screen.dart';
import 'stats_screen.dart';

class _TabItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  const _TabItem(this.label, this.icon, this.selectedIcon);
}

/// Kerangka utama setelah login: 4 tab dengan navigasi adaptif.
/// Layar sempit memakai NavigationBar (bawah), layar lebar memakai NavigationRail (kiri).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  /// HP landscape lebarnya >= 600 tetapi tingginya pendek, jadi tetap pakai bar bawah.
  static const double _railMinHeight = 480;

  static const List<_TabItem> _tabs = [
    _TabItem('Beranda', Icons.home_outlined, Icons.home),
    _TabItem('Peringkat', Icons.leaderboard_outlined, Icons.leaderboard),
    _TabItem('Statistik', Icons.bar_chart_outlined, Icons.bar_chart),
    _TabItem('Profil', Icons.person_outline, Icons.person),
  ];

  static const List<Widget> _pages = [
    HomeScreen(),
    LeaderboardScreen(),
    StatsScreen(),
    ProfileScreen(),
  ];

  int _index = 0;

  void _select(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final useRail = r.isTablet && r.screenHeight >= _railMinHeight;

    // IndexedStack menjaga state tiap tab (scroll, filter) saat berpindah tab.
    final body = IndexedStack(index: _index, children: _pages);

    return PopScope(
      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _index = 0); // Back: kembali ke Beranda dulu
      },
      child: Scaffold(
        body: useRail
            ? Row(
          children: [
            SafeArea(
              child: NavigationRail(
                selectedIndex: _index,
                onDestinationSelected: _select,
                labelType: NavigationRailLabelType.all,
                destinations: [
                  for (final t in _tabs)
                    NavigationRailDestination(
                      icon: Icon(t.icon),
                      selectedIcon: Icon(t.selectedIcon),
                      label: Text(t.label),
                    ),
                ],
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: body),
          ],
        )
            : body,
        bottomNavigationBar: useRail
            ? null
            : NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: _select,
          destinations: [
            for (final t in _tabs)
              NavigationDestination(
                icon: Icon(t.icon),
                selectedIcon: Icon(t.selectedIcon),
                label: t.label,
              ),
          ],
        ),
      ),
    );
  }
}