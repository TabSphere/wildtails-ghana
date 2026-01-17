import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../config/app_router.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.secondary]),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white24,
                  child: Text(user.level.icon, style: const TextStyle(fontSize: 48)),
                ),
                const SizedBox(height: 16),
                Text(user.displayName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                  child: Text('${user.level.title} • ${user.points} pts', style: const TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 16),
                // Level Progress
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Level Progress', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                        Text('${(user.levelProgress * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: user.levelProgress,
                      backgroundColor: Colors.white24,
                      color: const Color(0xFFFCD116),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Stats Grid
          Row(
            children: [
              _StatCard(icon: Icons.park, value: '${user.visitedParkIds.length}', label: 'Parks\nVisited', color: Colors.green),
              const SizedBox(width: 12),
              _StatCard(icon: Icons.bookmark, value: '${user.savedParkIds.length}', label: 'Parks\nSaved', color: Colors.blue),
              const SizedBox(width: 12),
              _StatCard(icon: Icons.emoji_events, value: '${user.earnedBadgeIds.length}', label: 'Badges\nEarned', color: Colors.orange),
            ],
          ),

          const SizedBox(height: 24),

          // Menu Items
          _MenuItem(
            icon: Icons.history,
            title: 'Visit History',
            subtitle: 'Parks you\'ve explored',
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.bookmark_border,
            title: 'Saved Parks',
            subtitle: 'Your bookmarked parks',
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.emoji_events_outlined,
            title: 'Badges & Achievements',
            subtitle: 'View your earned badges',
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.report_outlined,
            title: 'My Reports',
            subtitle: 'Wildlife crime reports',
            onTap: () => context.push(AppRoutes.report),
          ),
          _MenuItem(
            icon: Icons.school_outlined,
            title: 'Learning Progress',
            subtitle: 'Conservation education',
            onTap: () => context.push(AppRoutes.education),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 12),
              Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(label, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuItem({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        title: Text(title),
        subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
