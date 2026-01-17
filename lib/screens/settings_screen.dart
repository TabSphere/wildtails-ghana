import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // App Section
          _SectionHeader(title: 'App'),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            subtitle: Text(settings.themeMode == ThemeMode.dark ? 'On' : settings.themeMode == ThemeMode.light ? 'Off' : 'System'),
            trailing: Switch(
              value: settings.themeMode == ThemeMode.dark,
              onChanged: (_) => settings.toggleDarkMode(),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            subtitle: Text(settings.notificationsEnabled ? 'Enabled' : 'Disabled'),
            trailing: Switch(
              value: settings.notificationsEnabled,
              onChanged: settings.setNotificationsEnabled,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: const Text('English'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context),
          ),

          const Divider(),

          // About Section
          _SectionHeader(title: 'About'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About WildTails Ghana'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAboutDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showTermsDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPrivacyDialog(context),
          ),

          const Divider(),

          // Support Section
          _SectionHeader(title: 'Support'),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & FAQ'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Contact Us'),
            subtitle: const Text('support@wildtailsghana.com'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => launchUrl(Uri.parse('mailto:support@wildtailsghana.com')),
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Rate the App'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          const Divider(),

          // Social Section
          _SectionHeader(title: 'Follow Us'),
          ListTile(
            leading: const Icon(Icons.play_circle, color: Colors.red),
            title: const Text('YouTube'),
            subtitle: const Text('@wildtails24'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => launchUrl(Uri.parse('https://youtube.com/@wildtails24')),
          ),

          const SizedBox(height: 24),

          // Version
          Center(
            child: Column(
              children: [
                Text('WildTails Ghana', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Version 1.0.0', style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                Text('Made with ❤️ for Ghana\'s Wildlife', style: theme.textTheme.bodySmall),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              leading: const Text('🇬🇧'),
              trailing: const Icon(Icons.check, color: Colors.green),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('French'),
              leading: const Text('🇫🇷'),
              subtitle: const Text('Coming soon'),
              enabled: false,
            ),
            ListTile(
              title: const Text('Twi'),
              leading: const Text('🇬🇭'),
              subtitle: const Text('Coming soon'),
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Text('🦁', style: TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            const Text('WildTails Ghana'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('WildTails Ghana is your gateway to exploring and protecting Ghana\'s incredible wildlife.'),
            SizedBox(height: 16),
            Text('Our mission is to connect people with nature, educate about conservation, and help combat wildlife crime.'),
            SizedBox(height: 16),
            Text('🌿 23 Protected Areas\n🐘 Wildlife Information\n🗺️ Interactive Maps\n📚 Conservation Education\n🚨 Crime Reporting'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'By using WildTails Ghana, you agree to:\n\n'
            '1. Use the app responsibly and ethically\n'
            '2. Report wildlife crimes truthfully\n'
            '3. Respect wildlife and protected areas\n'
            '4. Not share false information\n'
            '5. Follow all applicable laws\n\n'
            'We reserve the right to suspend accounts that violate these terms.',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'WildTails Ghana respects your privacy.\n\n'
            'Data We Collect:\n'
            '• Account information\n'
            '• App usage statistics\n'
            '• Wildlife reports (optional location)\n\n'
            'How We Use Data:\n'
            '• Improve app experience\n'
            '• Process wildlife reports\n'
            '• Track conservation progress\n\n'
            'Your data is never sold to third parties.\n\n'
            'Contact: privacy@wildtailsghana.com',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
