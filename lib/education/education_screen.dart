import 'package:flutter/material.dart';
import '../../../core/widgets/app_theme.dart';
import '../core/widgets/services/edukasi_service.dart';
import 'widgets/dynamic_condition_card.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  List<dynamic> _edukasiList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEdukasi();
  }

  Future<void> _loadEdukasi() async {
    setState(() => _isLoading = true);
    final data = await EdukasiService.getEdukasi(onlyPublished: true);
    setState(() {
      _edukasiList = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        final titleColor = isDark ? Colors.white : const Color(0xFF1A237E);
        final subtitleColor = isDark ? const Color(0xFF8B80C4) : const Color(0xFF718096);
        
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0F0D22) : Colors.white,
          body: RefreshIndicator(
            onRefresh: _loadEdukasi,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edukasi Gangguan Tidur',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Kenali kondisi tidurmu dan cara mengatasinya\nuntuk hidup yang lebih sehat dan berkualitas.',
                          style: TextStyle(
                            fontSize: 14,
                            color: subtitleColor,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                
                // Content
                if (_isLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_edukasiList.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 64, color: subtitleColor),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada edukasi',
                            style: TextStyle(color: subtitleColor),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return DynamicConditionCard(
                            edukasi: _edukasiList[index],
                          );
                        },
                        childCount: _edukasiList.length,
                      ),
                    ),
                  ),
                
                // Disclaimer
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1C1836) : const Color(0xFFF8FAFF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF3B82F6).withOpacity(0.25)
                              : const Color(0xFF1A237E).withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 16,
                            color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1A237E),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Informasi ini bersifat edukatif dan tidak menggantikan diagnosis medis. Konsultasikan ke dokter untuk penanganan lebih lanjut.',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF4A5568),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}