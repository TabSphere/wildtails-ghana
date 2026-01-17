import 'package:flutter/material.dart';

class Chapter {
  final String id, title, description, icon;
  final int lessonCount;
  final bool isCompleted;

  const Chapter({
    required this.id, required this.title, required this.description,
    required this.icon, required this.lessonCount, this.isCompleted = false,
  });
}

final List<Chapter> chapters = [
  Chapter(id: '1', title: 'Introduction to Conservation', description: 'Learn the basics of wildlife conservation', icon: '🌍', lessonCount: 3),
  Chapter(id: '2', title: 'Ghana\'s Wildlife', description: 'Discover amazing animals of Ghana', icon: '🦁', lessonCount: 4),
  Chapter(id: '3', title: 'Protected Areas', description: 'Explore parks, reserves & sanctuaries', icon: '🏞️', lessonCount: 3),
  Chapter(id: '4', title: 'Threats to Wildlife', description: 'Understand the challenges', icon: '⚠️', lessonCount: 4),
  Chapter(id: '5', title: 'Taking Action', description: 'How you can help protect wildlife', icon: '💪', lessonCount: 3),
];

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Conservation'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Progress Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.secondary]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.school, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Your Learning Journey', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Become a Wildlife Guardian!', style: TextStyle(color: Colors.white.withOpacity(0.8))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ProgressStat(value: '0', label: 'Lessons'),
                    _ProgressStat(value: '0', label: 'Quizzes'),
                    _ProgressStat(value: '0', label: 'Points'),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: 0.0,
                  backgroundColor: Colors.white24,
                  color: const Color(0xFFFCD116),
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                Text('0% Complete', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text('Chapters', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          ...chapters.asMap().entries.map((entry) => _ChapterCard(
            chapter: entry.value,
            index: entry.key,
            onTap: () => _showChapterContent(context, entry.value),
          )),
        ],
      ),
    );
  }

  void _showChapterContent(BuildContext context, Chapter chapter) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 24),
              Center(child: Text(chapter.icon, style: const TextStyle(fontSize: 64))),
              const SizedBox(height: 16),
              Text(chapter.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(chapter.description, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Text('Lessons', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...List.generate(chapter.lessonCount, (i) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(child: Text('${i + 1}')),
                  title: Text('Lesson ${i + 1}'),
                  subtitle: const Text('Tap to start learning'),
                  trailing: const Icon(Icons.play_circle, color: Colors.green),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lesson content coming soon!')),
                    );
                  },
                ),
              )),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Quiz coming soon!')),
                  );
                },
                icon: const Icon(Icons.quiz),
                label: const Text('Take Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  final String value, label;
  const _ProgressStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
      ],
    );
  }
}

class _ChapterCard extends StatelessWidget {
  final Chapter chapter;
  final int index;
  final VoidCallback onTap;

  const _ChapterCard({required this.chapter, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLocked = index > 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isLocked ? Colors.grey[200] : theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text(chapter.icon, style: TextStyle(fontSize: 28, color: isLocked ? Colors.grey : null))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chapter.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(chapter.description, style: theme.textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.menu_book, size: 14, color: theme.colorScheme.primary),
                        const SizedBox(width: 4),
                        Text('${chapter.lessonCount} lessons', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                isLocked ? Icons.lock : Icons.chevron_right,
                color: isLocked ? Colors.grey : theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
