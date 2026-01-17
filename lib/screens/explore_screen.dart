import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/parks_provider.dart';
import '../models/park_model.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _searchQuery = '';
  ParkType? _selectedType;
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allParks = context.watch<ParksProvider>().parks;
    
    var parks = allParks.where((p) {
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.region.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType = _selectedType == null || p.type == _selectedType;
      return matchesSearch && matchesType;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Parks'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search parks...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _searchQuery = ''))
                    : null,
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),

          // Type Filter Chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _selectedType == null,
                  onSelected: (_) => setState(() => _selectedType = null),
                ),
                const SizedBox(width: 8),
                ...ParkType.values.map((type) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    avatar: Icon(type.icon, size: 18, color: _selectedType == type ? Colors.white : type.color),
                    label: Text(type.label),
                    selected: _selectedType == type,
                    onSelected: (_) => setState(() => _selectedType = _selectedType == type ? null : type),
                  ),
                )),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('${parks.length} parks found', style: theme.textTheme.bodySmall),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Parks Grid/List
          Expanded(
            child: _isGridView
                ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: parks.length,
                    itemBuilder: (context, index) => _ParkGridCard(park: parks[index]),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: parks.length,
                    itemBuilder: (context, index) => _ParkListCard(park: parks[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ParkGridCard extends StatelessWidget {
  final Park park;
  const _ParkGridCard({required this.park});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/park/${park.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [park.type.color, park.type.color.withOpacity(0.7)]),
                ),
                child: Stack(
                  children: [
                    Center(child: Text(park.emoji, style: const TextStyle(fontSize: 48))),
                    Positioned(
                      top: 8, left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(park.type.icon, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(park.type.label, style: const TextStyle(color: Colors.white, fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(park.name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                    const Spacer(),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _ParkListCard extends StatelessWidget {
  final Park park;
  const _ParkListCard({required this.park});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/park/${park.id}'),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [park.type.color, park.type.color.withOpacity(0.7)]),
              ),
              child: Center(child: Text(park.emoji, style: const TextStyle(fontSize: 40))),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(park.name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(park.type.icon, size: 14, color: park.type.color),
                        const SizedBox(width: 4),
                        Text(park.type.label, style: theme.textTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: theme.colorScheme.primary),
                        const SizedBox(width: 4),
                        Text(park.region, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Icon(Icons.chevron_right),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
