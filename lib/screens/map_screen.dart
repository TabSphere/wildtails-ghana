import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../providers/parks_provider.dart';
import '../models/park_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  Park? _selectedPark;
  final Set<ParkType> _activeFilters = ParkType.values.toSet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parks = context.watch<ParksProvider>().parks;
    final filteredParks = parks.where((p) => _activeFilters.contains(p.type)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wildlife Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () => _mapController.move(const LatLng(7.9465, -1.0232), 6.5),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(7.9465, -1.0232), // Ghana center
              initialZoom: 6.5,
              onTap: (_, __) => setState(() => _selectedPark = null),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.wildtails.ghana',
              ),
              MarkerLayer(
                markers: filteredParks.map((park) => Marker(
                  point: LatLng(park.latitude, park.longitude),
                  width: 50,
                  height: 50,
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedPark = park),
                    child: Container(
                      decoration: BoxDecoration(
                        color: park.type.color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                      ),
                      child: Center(child: Text(park.emoji, style: const TextStyle(fontSize: 20))),
                    ),
                  ),
                )).toList(),
              ),
            ],
          ),

          // Legend
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${filteredParks.length} Parks', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...ParkType.values.where((t) => _activeFilters.contains(t)).map((type) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 12, height: 12, decoration: BoxDecoration(color: type.color, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text(type.label, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),

          // Selected Park Card
          if (_selectedPark != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _selectedPark!.type.color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(child: Text(_selectedPark!.emoji, style: const TextStyle(fontSize: 32))),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_selectedPark!.name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(_selectedPark!.type.icon, size: 14, color: _selectedPark!.type.color),
                                const SizedBox(width: 4),
                                Text(_selectedPark!.type.label, style: theme.textTheme.bodySmall),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 14, color: theme.colorScheme.primary),
                                const SizedBox(width: 4),
                                Text(_selectedPark!.region, style: theme.textTheme.bodySmall),
                              ],
                            ),
                          ],
                        ),
                      ),
                      FilledButton(
                        onPressed: () => context.push('/park/${_selectedPark!.id}'),
                        child: const Text('View'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filter by Type', style: Theme.of(context).textTheme.titleLarge),
                  TextButton(
                    onPressed: () {
                      setSheetState(() {
                        if (_activeFilters.length == ParkType.values.length) {
                          _activeFilters.clear();
                        } else {
                          _activeFilters.addAll(ParkType.values);
                        }
                      });
                      setState(() {});
                    },
                    child: Text(_activeFilters.length == ParkType.values.length ? 'None' : 'All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...ParkType.values.map((type) => CheckboxListTile(
                value: _activeFilters.contains(type),
                onChanged: (v) {
                  setSheetState(() {
                    if (v == true) {
                      _activeFilters.add(type);
                    } else {
                      _activeFilters.remove(type);
                    }
                  });
                  setState(() {});
                },
                title: Row(
                  children: [
                    Container(width: 16, height: 16, decoration: BoxDecoration(color: type.color, shape: BoxShape.circle)),
                    const SizedBox(width: 12),
                    Text(type.label),
                  ],
                ),
                secondary: Icon(type.icon, color: type.color),
              )),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
