import 'package:flutter/material.dart';

class DetailEdukasiScreen extends StatelessWidget {
  final Map<String, dynamic> edukasi;
  
  const DetailEdukasiScreen({super.key, required this.edukasi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          edukasi['title'] ?? 'Detail Edukasi',
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image jika ada
            if (edukasi['image_url'] != null && edukasi['image_url'].toString().isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  edukasi['image_url'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.broken_image, size: 48)),
                  ),
                ),
              ),
            
            const SizedBox(height: 20),
            
            // Category Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getAccentColor().withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                edukasi['category'] ?? 'Umum',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getAccentColor(),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Title
            Text(
              edukasi['title'] ?? 'No Title',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Author & Read Time
            Row(
              children: [
                Icon(Icons.person_outline, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  edukasi['author'] ?? 'Admin',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  edukasi['read_time'] ?? '5 menit',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Tags
            if (edukasi['tags'] != null && edukasi['tags'] is List && (edukasi['tags'] as List).isNotEmpty) ...[
              const Text(
                'Tags',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (edukasi['tags'] as List).map((tag) {
                  return Chip(
                    label: Text(tag.toString()),
                    backgroundColor: _getAccentColor().withOpacity(0.1),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
            
            // Content
            const Text(
              'Materi Edukasi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              edukasi['content'] ?? 'Konten tidak tersedia',
              style: const TextStyle(height: 1.7),
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Color _getAccentColor() {
    switch (edukasi['category']) {
      case 'Insomnia':
        return const Color(0xFFEF5350);
      case 'Sleep Apnea':
        return const Color(0xFF3B82F6);
      case 'Healthy':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF8B5CF6);
    }
  }
}