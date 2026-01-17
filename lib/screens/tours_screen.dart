import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TourOperator {
  final String id, name, description, phone, email;
  final double rating;
  final int reviewCount;
  final List<String> specialties;
  final String priceRange;

  const TourOperator({
    required this.id, required this.name, required this.description,
    required this.phone, required this.email, required this.rating,
    required this.reviewCount, required this.specialties, required this.priceRange,
  });
}

final List<TourOperator> tourOperators = [
  TourOperator(
    id: 'safari-ghana', name: 'Safari Ghana Tours',
    description: 'Expert guides with 15+ years experience. Specializing in wildlife photography and walking safaris.',
    rating: 4.8, reviewCount: 124, specialties: ['Safari', 'Photography', 'Walking Tours'],
    priceRange: 'Moderate', phone: '+233241234567', email: 'info@safarighana.com',
  ),
  TourOperator(
    id: 'eco-wild', name: 'EcoWild Adventures',
    description: 'Sustainable tourism focused on conservation. Expert in bird watching and eco-friendly travel.',
    rating: 4.6, reviewCount: 89, specialties: ['Eco-Tourism', 'Bird Watching', 'Community Tours'],
    priceRange: 'Budget', phone: '+233202345678', email: 'hello@ecowild.gh',
  ),
  TourOperator(
    id: 'mole-safaris', name: 'Mole Safari Specialists',
    description: 'Based at Mole National Park with deep local knowledge. Best for elephant encounters.',
    rating: 4.9, reviewCount: 203, specialties: ['Mole Park', 'Elephants', 'Savannah Tours'],
    priceRange: 'Moderate', phone: '+233245678901', email: 'info@molesafaris.com',
  ),
  TourOperator(
    id: 'nature-bound', name: 'Nature Bound Ghana',
    description: 'Family-friendly tours with educational focus. Great for school groups.',
    rating: 4.5, reviewCount: 67, specialties: ['Family', 'Educational', 'School Groups'],
    priceRange: 'Budget', phone: '+233274567890', email: 'tours@naturebound.gh',
  ),
];

class ToursScreen extends StatelessWidget {
  const ToursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Tour Operators')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.secondary]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🎯 Find Your Perfect Tour', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Connect with verified operators for unforgettable wildlife experiences',
                  style: TextStyle(color: Colors.white.withOpacity(0.9))),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _StatChip(icon: Icons.verified, label: '${tourOperators.length} Verified'),
                    const SizedBox(width: 12),
                    _StatChip(icon: Icons.star, label: '4.7 Avg Rating'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text('All Operators', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          ...tourOperators.map((op) => _OperatorCard(operator: op)),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}

class _OperatorCard extends StatelessWidget {
  final TourOperator operator;
  const _OperatorCard({required this.operator});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(operator.name[0], style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(operator.name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text('${operator.rating} (${operator.reviewCount})', style: theme.textTheme.bodySmall),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: operator.priceRange == 'Budget' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(operator.priceRange, style: TextStyle(
                              fontSize: 10,
                              color: operator.priceRange == 'Budget' ? Colors.green : Colors.orange,
                            )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(operator.description, style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: operator.specialties.map((s) => Chip(
                label: Text(s, style: const TextStyle(fontSize: 11)),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              )).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => launchUrl(Uri.parse('tel:${operator.phone}')),
                    icon: const Icon(Icons.phone, size: 18),
                    label: const Text('Call'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => launchUrl(Uri.parse('mailto:${operator.email}')),
                    icon: const Icon(Icons.email, size: 18),
                    label: const Text('Email'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
