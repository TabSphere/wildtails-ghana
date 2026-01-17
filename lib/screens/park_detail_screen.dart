import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/parks_provider.dart';
import '../providers/user_provider.dart';
import '../config/app_router.dart';

class ParkDetailScreen extends StatelessWidget {
  final String parkId;
  const ParkDetailScreen({super.key, required this.parkId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final park = context.watch<ParksProvider>().getParkById(parkId);
    final userProvider = context.watch<UserProvider>();
    final isSaved = userProvider.isParkSaved(parkId);
    final isVisited = userProvider.user.visitedParkIds.contains(parkId);

    if (park == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Park not found')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                onPressed: () => userProvider.toggleSavedPark(parkId),
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [park.type.color, park.type.color.withOpacity(0.7)],
                  ),
                ),
                child: Stack(
                  children: [
                    Center(child: Text(park.emoji, style: const TextStyle(fontSize: 100))),
                    Positioned(
                      bottom: 60,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(park.type.icon, size: 16, color: Colors.white),
                                const SizedBox(width: 6),
                                Text(park.type.label, style: const TextStyle(color: Colors.white, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isVisited)
                      Positioned(
                        top: 100,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle, size: 16, color: Colors.white),
                              SizedBox(width: 4),
                              Text('Visited', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              title: Text(park.name),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location & Year
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 18, color: theme.colorScheme.primary),
                      const SizedBox(width: 6),
                      Text(park.region, style: theme.textTheme.bodyMedium),
                      const Spacer(),
                      Icon(Icons.calendar_today, size: 16, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Text('Est. ${park.yearEstablished}', style: theme.textTheme.bodySmall),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Quick Stats
                  Row(
                    children: [
                      _QuickStat(icon: Icons.straighten, value: '${park.areaSqKm.toInt()}', label: 'km²'),
                      const SizedBox(width: 16),
                      _QuickStat(icon: Icons.pets, value: '${park.wildlife.length}', label: 'Species'),
                      const SizedBox(width: 16),
                      _QuickStat(icon: Icons.hiking, value: '${park.activities.length}', label: 'Activities'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description
                  Text('About', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(park.description, style: theme.textTheme.bodyMedium),

                  const SizedBox(height: 24),

                  // Entry Fees
                  Text('Entry Fees', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _FeeRow(label: '🇬🇭 Ghanaian Adult', fee: 'GH₵ ${park.adultFeeGhanaian.toInt()}'),
                        const Divider(),
                        _FeeRow(label: '🌍 Foreign Adult', fee: 'GH₵ ${park.adultFeeForeigner.toInt()}'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Wildlife
                  Text('Wildlife', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: park.wildlife.map((w) => Chip(
                      avatar: const Icon(Icons.pets, size: 16),
                      label: Text(w),
                    )).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Activities
                  Text('Activities', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: park.activities.map((a) => Chip(
                      avatar: const Icon(Icons.hiking, size: 16),
                      label: Text(a),
                    )).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.push(AppRoutes.map),
                          icon: const Icon(Icons.map),
                          label: const Text('View on Map'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            final url = 'https://www.google.com/maps/search/?api=1&query=${park.latitude},${park.longitude}';
                            launchUrl(Uri.parse(url));
                          },
                          icon: const Icon(Icons.directions),
                          label: const Text('Get Directions'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Mark as Visited
                  if (!isVisited)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          userProvider.markParkVisited(parkId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('🎉 Park marked as visited! +50 points')),
                          );
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Mark as Visited (+50 pts)'),
                        style: FilledButton.styleFrom(backgroundColor: Colors.green),
                      ),
                    ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _QuickStat({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text(label, style: theme.textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeeRow extends StatelessWidget {
  final String label;
  final String fee;
  const _FeeRow({required this.label, required this.fee});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(fee, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
