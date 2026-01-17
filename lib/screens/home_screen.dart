import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/app_router.dart';
import '../providers/user_provider.dart';
import '../providers/parks_provider.dart';
import '../models/park_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<UserProvider>().user;
    final parks = context.watch<ParksProvider>().parks;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [theme.colorScheme.primary, theme.colorScheme.primary.withOpacity(0.8)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.white24,
                              child: Text(user.level.icon, style: const TextStyle(fontSize: 26)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Hello, ${user.displayName}!',
                                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                  Text('${user.level.title} • ${user.points} pts',
                                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => context.push(AppRoutes.settings),
                              icon: const Icon(Icons.settings, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Quick Actions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quick Actions', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _QuickAction(icon: Icons.map, label: 'Map', color: Colors.blue, onTap: () => context.push(AppRoutes.map)),
                      const SizedBox(width: 10),
                      _QuickAction(icon: Icons.report, label: 'Report', color: Colors.red, onTap: () => context.push(AppRoutes.report)),
                      const SizedBox(width: 10),
                      _QuickAction(icon: Icons.school, label: 'Learn', color: Colors.purple, onTap: () => context.push(AppRoutes.education)),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms),
          ),

          // Featured Parks Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Featured Parks', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () => context.go(AppRoutes.explore), child: const Text('See All')),
                ],
              ),
            ),
          ),

          // Featured Parks List
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: parks.take(5).length,
                itemBuilder: (context, index) {
                  final park = parks[index];
                  return _ParkCard(park: park).animate().fadeIn(delay: (100 * index).ms);
                },
              ),
            ),
          ),

          // Stats
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text('Your Journey', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _Stat(icon: Icons.park, value: '${user.visitedParkIds.length}', label: 'Visited'),
                        _Stat(icon: Icons.bookmark, value: '${user.savedParkIds.length}', label: 'Saved'),
                        _Stat(icon: Icons.emoji_events, value: '${user.earnedBadgeIds.length}', label: 'Badges'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: user.levelProgress,
                      backgroundColor: Colors.white38,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 8),
                    Text('${(user.levelProgress * 100).toInt()}% to ${user.level == UserLevel.champion ? "Max Level" : UserLevel.values[user.level.index + 1].title}',
                      style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 300.ms),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 8),
                Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ParkCard extends StatelessWidget {
  final Park park;
  const _ParkCard({required this.park});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push('/park/${park.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [park.type.color, park.type.color.withOpacity(0.7)]),
                ),
                child: Stack(
                  children: [
                    Center(child: Text(park.emoji, style: const TextStyle(fontSize: 40))),
                    Positioned(
                      top: 8, right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12)),
                        child: Text(park.type.label, style: const TextStyle(color: Colors.white, fontSize: 9)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(park.name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: theme.colorScheme.primary),
                        const SizedBox(width: 4),
                        Expanded(child: Text(park.region, style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _Stat({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
