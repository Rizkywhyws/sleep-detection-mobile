import 'package:flutter/material.dart';
import '../../../core/widgets/app_theme.dart';

class AssessmentTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextInputType type;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final String? helperText;

  const AssessmentTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.type,
    this.onSaved,
    this.onChanged,
    this.helperText,
  });

  @override
  State<AssessmentTextField> createState() => _AssessmentTextFieldState();
}

class _AssessmentTextFieldState extends State<AssessmentTextField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        // ── Token warna ──────────────────────────────────────────────────
        final labelColor   = isDark ? const Color(0xFF9B8FE8)  : const Color(0xFF9CA3AF);
        final inputText    = isDark ? const Color(0xFFF1F5F9)  : const Color(0xFF1A202C);
        final hintColor    = isDark ? const Color(0xFF4A4270)  : const Color(0xFFD1D5DB);
        final fillColor    = isDark ? const Color(0xFF1A1535)  : const Color(0xFFF9FAFB);
        final borderIdle   = isDark ? const Color(0xFF3B2A8A).withOpacity(0.60) : const Color(0xFFE5E7EB);
        final borderFocus  = isDark ? const Color(0xFF9B6FFF)  : const Color(0xFF4A90C7);
        final helperColor  = isDark ? const Color(0xFF9B6FFF)  : const Color(0xFF4A90C7);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _focused
                    ? (isDark ? const Color(0xFFBBA8F8) : const Color(0xFF4A90C7))
                    : labelColor,
                letterSpacing: 0.4,
              ),
              child: Text(widget.label),
            ),
            const SizedBox(height: 6),
            Focus(
              onFocusChange: (hasFocus) => setState(() => _focused = hasFocus),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _focused
                      ? [
                          BoxShadow(
                            color: (isDark ? const Color(0xFF9B6FFF) : const Color(0xFF4A90C7)).withOpacity(isDark ? 0.22 : 0.14),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : isDark
                          ? [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 4, offset: const Offset(0, 2))]
                          : null,
                ),
                child: TextFormField(
                  keyboardType: widget.type,
                  style: TextStyle(fontSize: 14, color: inputText),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: TextStyle(color: hintColor, fontSize: 14),
                    filled: true,
                    fillColor: fillColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderIdle, width: 0.8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderIdle, width: 0.8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderFocus, width: 1.5),
                    ),
                    helperText: widget.helperText,
                    helperStyle: TextStyle(fontSize: 10, color: helperColor),
                  ),
                  onSaved: widget.onSaved,
                  onChanged: widget.onChanged,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}