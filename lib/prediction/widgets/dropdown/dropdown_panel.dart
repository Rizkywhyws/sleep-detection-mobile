import 'package:flutter/material.dart';
import 'dropdown_model.dart';
import 'dropdown_item_title.dart';

class DropdownPanel extends StatefulWidget {
  final List<DropdownItem> items;
  final String? selectedValue;
  final bool searchable;
  final bool showAbove;
  final bool isDark;
  final void Function(String) onSelect;

  const DropdownPanel({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.searchable,
    required this.showAbove,
    required this.isDark,
    required this.onSelect,
  });

  @override
  State<DropdownPanel> createState() => _DropdownPanelState();
}

class _DropdownPanelState extends State<DropdownPanel> {
  String _query = '';

  List<DropdownItem> get _filtered => _query.isEmpty
      ? widget.items
      : widget.items
          .where((i) =>
              i.label.toLowerCase().contains(_query.toLowerCase()) ||
              (i.subtitle?.toLowerCase().contains(_query.toLowerCase()) ?? false))
          .toList();

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(14));

    final panelBg     = widget.isDark ? const Color(0xFF1A1635) : Colors.white;
    final borderColor = widget.isDark ? const Color(0xFF2D2650)  : const Color(0xFFE5E7EB);
    final divColor    = widget.isDark ? const Color(0xFF2D2650)  : const Color(0xFFE5E7EB);
    final hintColor   = widget.isDark ? const Color(0xFF4A4270)  : const Color(0xFFD1D5DB);
    final inputColor  = widget.isDark ? const Color(0xFFF1F5F9)  : const Color(0xFF0F172A);

    return Container(
      decoration: BoxDecoration(
        color: panelBg,
        borderRadius: radius,
        border: Border.all(color: borderColor, width: widget.isDark ? 0.9 : 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(widget.isDark ? 0.40 : 0.10),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          if (widget.isDark)
            BoxShadow(
              color: const Color(0xFF4F46E5).withOpacity(0.10),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.searchable) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: TextField(
                  autofocus: false,
                  onChanged: (v) => setState(() => _query = v),
                  style: TextStyle(fontSize: 14, color: inputColor),
                  decoration: InputDecoration(
                    hintText: 'Cari...',
                    hintStyle: TextStyle(color: hintColor),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Divider(height: 1, color: divColor),
            ],
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final item = _filtered[i];
                  return DropdownItemTile(
                    item: item,
                    isSelected: item.value == widget.selectedValue,
                    isDark: widget.isDark,
                    onTap: () => widget.onSelect(item.value),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}