import 'package:flutter/material.dart';

import '../../core/responsive.dart';
import '../dashboard/pattern_dashboard_screen.dart';
import '../home/home_screen.dart';
import '../journal/journal_entry_screen.dart';
import '../query/query_screen.dart';
import '../reflection/weekly_reflection_screen.dart';

/// Adaptive navigation shell.
///
/// • Compact (phones): bottom [NavigationBar] + a "New entry" FAB.
/// • Medium / expanded (tablets, desktop): side [NavigationRail] with an
///   extended new-entry button.
///
/// This is the heart of the "works at all sizes" requirement.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _destinations = [
    _Dest('Today', Icons.wb_sunny_outlined, Icons.wb_sunny),
    _Dest('Reflect', Icons.auto_awesome_outlined, Icons.auto_awesome),
    _Dest('Patterns', Icons.insights_outlined, Icons.insights),
    _Dest('Ask', Icons.forum_outlined, Icons.forum),
  ];

  final _pages = const [
    HomeScreen(),
    WeeklyReflectionScreen(),
    PatternDashboardScreen(),
    QueryScreen(),
  ];

  void _newEntry() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const JournalEntryScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final useRail = !context.isCompact;
    final body = IndexedStack(index: _index, children: _pages);

    if (useRail) {
      return Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              NavigationRail(
                selectedIndex: _index,
                onDestinationSelected: (i) => setState(() => _index = i),
                extended: context.isExpanded,
                minWidth: 72,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      FloatingActionButton(
                        heroTag: 'fab-rail',
                        onPressed: _newEntry,
                        elevation: 0,
                        child: const Icon(Icons.edit_outlined),
                      ),
                      const SizedBox(height: 8),
                      if (context.isExpanded)
                        const Text('New entry',
                            style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                destinations: [
                  for (final d in _destinations)
                    NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.activeIcon),
                      label: Text(d.label),
                    ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: body),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: body,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab-bottom',
        onPressed: _newEntry,
        icon: const Icon(Icons.edit_outlined),
        label: const Text('New entry'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          for (final d in _destinations)
            NavigationDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.activeIcon),
              label: d.label,
            ),
        ],
      ),
    );
  }
}

class _Dest {
  const _Dest(this.label, this.icon, this.activeIcon);
  final String label;
  final IconData icon;
  final IconData activeIcon;
}
