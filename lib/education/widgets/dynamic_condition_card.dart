import 'package:flutter/material.dart';
import '../../../core/widgets/app_theme.dart';

class DynamicConditionCard extends StatelessWidget {
  final Map<String, dynamic> edukasi;
  const DynamicConditionCard({super.key, required this.edukasi});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        if (isDark) {
          return _buildDarkCard(context);
        }
        return _buildLightCard(context);
      },
    );
  }

  Widget _buildLightCard(BuildContext context) {
    final accent = _getAccentColor();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showDetailDialog(context),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge + Icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_getEmoji(), style: const TextStyle(fontSize: 12)),
                          const SizedBox(width: 4),
                          Text(
                            edukasi['category'] ?? 'Umum',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: accent,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.chevron_right, size: 20, color: accent),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Title
                Text(
                  edukasi['title'] ?? 'No Title',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A237E),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Description
                Text(
                  _getSummary(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4A5568),
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                
                // Author & Read Time
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      edukasi['author'] ?? 'Admin',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      edukasi['read_time'] ?? '5 menit',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDarkCard(BuildContext context) {
    final accent = _getAccentColor();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withOpacity(0.16),
            const Color(0xFF0F0D22),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.30), width: 1.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showDetailDialog(context),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: accent.withOpacity(0.45), width: 1.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_getEmoji(), style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        edukasi['category'] ?? 'Umum',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                
                // Title
                Text(
                  edukasi['title'] ?? 'No Title',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Description
                Text(
                  _getSummary(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFCBD5E1),
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                
                // Author & Read Time
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 12, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      edukasi['author'] ?? 'Admin',
                      style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 12, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      edukasi['read_time'] ?? '5 menit',
                      style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxHeight: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getAccentColor().withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      edukasi['category'] ?? 'Umum',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getAccentColor(),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Title
              Text(
                edukasi['title'] ?? 'No Title',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // Author & Time
              Row(
                children: [
                  Icon(Icons.person_outline, size: 12, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    edukasi['author'] ?? 'Admin',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    edukasi['read_time'] ?? '5 menit',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Content (scrollable)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (edukasi['summary'] != null && edukasi['summary'].toString().isNotEmpty) ...[
                        Text(
                          'Ringkasan',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _getAccentColor(),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          edukasi['summary'],
                          style: const TextStyle(fontSize: 13, height: 1.5),
                        ),
                        const SizedBox(height: 12),
                      ],
                      
                      Text(
                        'Materi Lengkap',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _getAccentColor(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        edukasi['content'] ?? 'Konten tidak tersedia',
                        style: const TextStyle(fontSize: 13, height: 1.6),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSummary() {
    if (edukasi['summary'] != null && edukasi['summary'].toString().isNotEmpty) {
      return edukasi['summary'];
    }
    String content = edukasi['content'] ?? '';
    if (content.length > 100) {
      return content.substring(0, 100) + '...';
    }
    return content;
  }

  String _getEmoji() {
    switch (edukasi['category']) {
      case 'Insomnia':
        return '😵';
      case 'Sleep Apnea':
        return '😮';
      case 'Healthy':
        return '✨';
      default:
        return '📚';
    }
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