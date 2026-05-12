// lib/features/history/widgets/history_bottom_sheet.dart

import 'package:flutter/material.dart';
import '../../../core/model/prediction_history_result.dart';
import '../core/widgets/services/prediction_history_services.dart';

// ── Entry point ───────────────────────────────────────────────────────────────
void showHistorySheet(BuildContext context, {bool isDarkMode = false}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.50),
    builder: (_) => _HistoryBottomSheet(isDarkMode: isDarkMode),
  );
}

// ── Sheet ─────────────────────────────────────────────────────────────────────
class _HistoryBottomSheet extends StatefulWidget {
  final bool isDarkMode;
  const _HistoryBottomSheet({required this.isDarkMode});

  @override
  State<_HistoryBottomSheet> createState() => _HistoryBottomSheetState();
}

class _HistoryBottomSheetState extends State<_HistoryBottomSheet> {
  static const _filters = ['all', 'healthy', 'insomnia', 'sleep_apnea'];
  static const _filterLabels = {
    'all':        'Semua',
    'healthy':    'Sehat',
    'insomnia':   'Insomnia',
    'sleep_apnea':'Sleep Apnea',
  };

  final _service    = PredictionHistoryService.instance;
  final _scrollCtrl = ScrollController();

  List<PredictionHistoryItem> _items     = [];
  PredictionHistoryPagination? _pagination;
  bool   _loading   = false;
  bool   _loadingMore = false;
  String _error     = '';
  String _filter    = 'all';
  int    _page      = 1;

  @override
  void initState() {
    super.initState();
    _loadPage(reset: true);
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 150 &&
        !_loadingMore &&
        (_pagination?.hasNext ?? false)) {
      _loadPage();
    }
  }

  Future<void> _loadPage({bool reset = false}) async {
    if (reset) {
      _page = 1;
      setState(() { _loading = true; _error = ''; _items = []; });
    } else {
      if (_loadingMore) return;
      setState(() => _loadingMore = true);
    }

    try {
      final result = await _service.fetchHistory(
        page:    _page,
        perPage: 10,
        filter:  _filter,
      );

      setState(() {
        _items.addAll(result.items);
        _pagination = result.pagination;
        _page++;
      });
    } catch (e) {
      if (reset) setState(() => _error = e.toString());
    } finally {
      setState(() { _loading = false; _loadingMore = false; });
    }
  }

  Future<void> _confirmDelete(PredictionHistoryItem item) async {
    final isDark = widget.isDarkMode;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1A35) : Colors.white,
        title: Text(
          'Hapus Riwayat',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Hapus prediksi "${item.label}" ini?',
          style: TextStyle(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
            fontSize: 13.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Color(0xFFEF5350))),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    try {
      await _service.deleteHistory(item.id);
      setState(() => _items.removeWhere((e) => e.id == item.id));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus riwayat')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark   = widget.isDarkMode;
    final sheetBg  = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final headerBg = isDark ? const Color(0xFF1E1A35) : Colors.white;

    return DraggableScrollableSheet(
      initialChildSize: 0.90,
      minChildSize:     0.50,
      maxChildSize:     0.95,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 4),
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF4F46E5).withOpacity(0.40) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
              decoration: BoxDecoration(
                color: headerBg,
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? const Color(0xFF4F46E5).withOpacity(0.15)
                        : const Color(0xFFE2E8F0),
                    width: 0.6,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Riwayat Prediksi',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const Spacer(),
                      if (_pagination != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F46E5).withOpacity(isDark ? 0.20 : 0.10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_pagination!.total}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4F46E5),
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: isDark ? const Color(0xFF9B8FE8) : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Filter chips
                  SizedBox(
                    height: 32,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final f       = _filters[i];
                        final active  = f == _filter;
                        return GestureDetector(
                          onTap: () {
                            if (_filter == f) return;
                            setState(() => _filter = f);
                            _loadPage(reset: true);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: active
                                  ? const Color(0xFF4F46E5)
                                  : isDark
                                      ? const Color(0xFF1E1A35)
                                      : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: active
                                    ? const Color(0xFF4F46E5)
                                    : isDark
                                        ? const Color(0xFF6D5FD8).withOpacity(0.30)
                                        : const Color(0xFFE2E8F0),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _filterLabels[f]!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: active
                                    ? Colors.white
                                    : isDark
                                        ? const Color(0xFF9B8FE8)
                                        : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(child: _buildContent(scrollController)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ScrollController scrollController) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF4F46E5)));
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 42, color: Color(0xFF94A3B8)),
            const SizedBox(height: 12),
            Text('Gagal memuat data', style: TextStyle(
              color: widget.isDarkMode ? const Color(0xFF9B8FE8) : const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            )),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => _loadPage(reset: true),
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      );
    }

    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_rounded, size: 52,
                color: widget.isDarkMode ? const Color(0xFF4F46E5).withOpacity(0.40) : const Color(0xFFCBD5E1)),
            const SizedBox(height: 12),
            Text(
              'Belum ada riwayat prediksi',
              style: TextStyle(
                color: widget.isDarkMode ? const Color(0xFF9B8FE8) : const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: _items.length + (_loadingMore ? 1 : 0),
      itemBuilder: (_, i) {
        if (i == _items.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF4F46E5),
            )),
          );
        }
        return _HistoryCard(
          item:        _items[i],
          isDarkMode:  widget.isDarkMode,
          onDelete:    () => _confirmDelete(_items[i]),
        );
      },
    );
  }
}

// ── History Card ──────────────────────────────────────────────────────────────
class _HistoryCard extends StatelessWidget {
  final PredictionHistoryItem item;
  final bool                  isDarkMode;
  final VoidCallback          onDelete;

  const _HistoryCard({
    required this.item,
    required this.isDarkMode,
    required this.onDelete,
  });

  Color _hexColor(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  IconData _iconFor(String prediction) {
    final p = prediction.toLowerCase();
    if (p.contains('insomnia'))  return Icons.visibility_off_outlined;
    if (p.contains('apnea'))     return Icons.air_outlined;
    return Icons.bedtime_outlined;
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    final local = dt.toLocal();
    final months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
    return '${local.day} ${months[local.month - 1]} ${local.year}, ${local.hour.toString().padLeft(2,'0')}.${local.minute.toString().padLeft(2,'0')}';
  }

  @override
  Widget build(BuildContext context) {
    final mainColor = _hexColor(item.color);
    final bgColor   = _hexColor(item.bgColor);
    final cardBg    = isDarkMode ? const Color(0xFF1E1A35) : Colors.white;
    final cardBorder= isDarkMode
        ? const Color(0xFF4F46E5).withOpacity(0.18)
        : const Color(0xFFE2E8F0);
    final dateColor = isDarkMode ? const Color(0xFF9B8FE8) : const Color(0xFF94A3B8);
    final pct       = (item.highestConfidence * 100).toStringAsFixed(1);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardBorder, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? const Color(0xFF4F46E5).withOpacity(0.06)
                : const Color(0xFF0F172A).withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(_iconFor(item.prediction), color: mainColor, size: 22),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: mainColor.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Keyakinan $pct%',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: mainColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(item.predictedAt),
                  style: TextStyle(fontSize: 11, color: dateColor),
                ),
              ],
            ),
          ),
          // Delete button
          GestureDetector(
            onTap: onDelete,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.delete_outline_rounded,
                size: 18,
                color: isDarkMode
                    ? const Color(0xFF9B8FE8).withOpacity(0.60)
                    : const Color(0xFFCBD5E1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}