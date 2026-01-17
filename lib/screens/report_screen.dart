import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  String _reportType = 'Poaching';
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();
  bool _isAnonymous = false;
  bool _isUrgent = false;
  bool _isSubmitting = false;
  final List<XFile> _photos = [];
  final ImagePicker _picker = ImagePicker();

  final List<String> _reportTypes = [
    'Poaching',
    'Illegal Logging',
    'Encroachment',
    'Pollution',
    'Injured Animal',
    'Suspicious Activity',
    'Other',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_photos.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 5 photos allowed')),
      );
      return;
    }
    final XFile? image = await _picker.pickImage(source: source, maxWidth: 1200, imageQuality: 80);
    if (image != null) setState(() => _photos.add(image));
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isSubmitting = false);
      final reportId = 'WR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 64),
          title: const Text('Report Submitted'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Thank you for helping protect Ghana\'s wildlife!'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Report ID: '),
                    Text(reportId, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Wildlife Crime'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Warning Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Emergency?', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                        Text('If you witness an active crime, call 999 or Wildlife Division directly',
                          style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Report Type
            Text('Type of Incident', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _reportTypes.map((type) => ChoiceChip(
                label: Text(type),
                selected: _reportType == type,
                onSelected: (_) => setState(() => _reportType = type),
              )).toList(),
            ),

            const SizedBox(height: 24),

            // Description
            Text('Description', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Describe what you witnessed...',
              ),
              validator: (v) => (v?.isEmpty ?? true) ? 'Please provide a description' : null,
            ),

            const SizedBox(height: 24),

            // Location
            Text('Location', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                hintText: 'Park name, GPS coordinates, or landmarks',
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (v) => (v?.isEmpty ?? true) ? 'Please provide a location' : null,
            ),

            const SizedBox(height: 24),

            // Photo Upload
            Text('Photos (Optional)', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  if (_photos.isNotEmpty) ...[
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _photos.length,
                        itemBuilder: (context, index) => Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(File(_photos[index].path)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 12,
                              child: GestureDetector(
                                onTap: () => setState(() => _photos.removeAt(index)),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Camera'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Gallery'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Up to 5 photos • ${_photos.length}/5', style: theme.textTheme.bodySmall),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Options
            SwitchListTile(
              value: _isAnonymous,
              onChanged: (v) => setState(() => _isAnonymous = v),
              title: const Text('Submit Anonymously'),
              subtitle: const Text('Your contact info won\'t be shared'),
              secondary: const Icon(Icons.visibility_off),
            ),
            SwitchListTile(
              value: _isUrgent,
              onChanged: (v) => setState(() => _isUrgent = v),
              title: const Text('Mark as Urgent'),
              subtitle: const Text('For ongoing or time-sensitive incidents'),
              secondary: Icon(Icons.priority_high, color: _isUrgent ? Colors.red : null),
            ),

            // Contact (if not anonymous)
            if (!_isAnonymous) ...[
              const SizedBox(height: 16),
              Text('Contact Info', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  hintText: 'Phone or email (for follow-up)',
                  prefixIcon: Icon(Icons.contact_phone),
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Submit Button
            FilledButton(
              onPressed: _isSubmitting ? null : _submitReport,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red,
              ),
              child: _isSubmitting
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send),
                        SizedBox(width: 8),
                        Text('Submit Report'),
                      ],
                    ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
