import 'package:flutter/material.dart';
import 'dropdown_model.dart';
import 'dropdown_panel.dart';

class AssessmentDropdown extends StatefulWidget {
  final String label;
  final String? value;
  final List<DropdownItem> items;
  final bool isDark;
  final void Function(String?) onChanged;

  const AssessmentDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.isDark,
    required this.onChanged,
  });

  @override
  State<AssessmentDropdown> createState() => _AssessmentDropdownState();
}

class _AssessmentDropdownState extends State<AssessmentDropdown>
    with WidgetsBindingObserver {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _close();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (_isOpen) _overlayEntry?.markNeedsBuild();
  }

  void _toggle() => _isOpen ? _close() : _open();

  void _open() {
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _close() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isOpen = false);
  }

  OverlayEntry _buildOverlay() {
    final box      = context.findRenderObject() as RenderBox;
    final size     = box.size;
    final position = box.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (overlayContext) {
        final mediaQuery     = MediaQuery.of(overlayContext);
        final screenHeight   = mediaQuery.size.height;
        final keyboardHeight = mediaQuery.viewInsets.bottom;
        final available      = screenHeight - keyboardHeight;

        final spaceAbove = position.dy - 8;
        final spaceBelow = available - (position.dy + size.height) - 8;
        final showAbove  = spaceBelow < 180 || spaceAbove > spaceBelow;

        const double preferred = 240.0;
        final double maxHeight;
        final double top;

        if (showAbove) {
          maxHeight = spaceAbove.clamp(120.0, preferred);
          top       = position.dy - maxHeight - 6;
        } else {
          maxHeight = spaceBelow.clamp(120.0, preferred);
          top       = position.dy + size.height + 6;
        }

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _close,
                behavior: HitTestBehavior.translucent,
              ),
            ),
            Positioned(
              left:  position.dx,
              top:   top,
              width: size.width,
              child: Material(
                color: Colors.transparent,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 0, maxHeight: maxHeight),
                  child: DropdownPanel(
                    items:         widget.items,
                    selectedValue: widget.value,
                    searchable:    true,
                    showAbove:     showAbove,
                    isDark:        widget.isDark,
                    onSelect: (val) {
                      widget.onChanged(val);
                      _close();
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  DropdownItem? get _selected =>
      widget.items.where((e) => e.value == widget.value).firstOrNull;

  @override
  Widget build(BuildContext context) {
    final hasValue = _selected != null;

    // ── Warna adaptif dark/light ──────────────────────────────────────────
    final labelColor  = widget.isDark ? const Color(0xFF7C6FBE)  : const Color(0xFF9CA3AF);
    final fillColor   = widget.isDark
        ? (hasValue ? const Color(0xFF1E1A35) : const Color(0xFF151225))
        : (hasValue ? Colors.white            : const Color(0xFFF9FAFB));
    final borderColor = widget.isDark
        ? (_isOpen
            ? const Color(0xFF4F46E5)
            : hasValue
                ? const Color(0xFF4F46E5).withOpacity(0.45)
                : const Color(0xFF2D2650))
        : (_isOpen
            ? const Color(0xFF2563EB)
            : Colors.grey.shade300);
    final valueColor  = widget.isDark ? const Color(0xFFF1F5F9)  : const Color(0xFF1A202C);
    final hintColor   = widget.isDark ? const Color(0xFF4A4270)  : const Color(0xFFD1D5DB);
    final chevronColor = widget.isDark
        ? (_isOpen ? const Color(0xFF9B8FFF) : const Color(0xFF6D5FD8))
        : (_isOpen ? const Color(0xFF2563EB) : Colors.grey.shade500);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 6),
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              constraints: const BoxConstraints(minHeight: 48),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: fillColor,
                border: Border.all(
                  color: borderColor,
                  width: (_isOpen || hasValue) ? 1.5 : 1.0,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: _isOpen && widget.isDark
                    ? [BoxShadow(
                        color: const Color(0xFF4F46E5).withOpacity(0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      )]
                    : null,
              ),
              child: Row(
                children: [
                  if (hasValue) ...[
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: widget.isDark
                            ? (_selected!.iconColor ?? const Color(0xFF6D5FD8)).withOpacity(0.18)
                            : _selected!.iconBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(_selected!.icon, size: 13, color: _selected!.iconColor),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      _selected?.label ?? 'Pilih...',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                        color: hasValue ? valueColor : hintColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isOpen ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.arrow_drop_down, color: chevronColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}