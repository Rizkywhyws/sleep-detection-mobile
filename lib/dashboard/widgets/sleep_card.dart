import 'package:flutter/material.dart';

class SleepCard extends StatelessWidget {
  const SleepCard({super.key});

  static const Color _primaryText = Color(0xFF0F172A);
  static const Color _secondaryText = Color(0xFF64748B);
  static const Color _mutedText = Color(0xFF94A3B8);

  static const Color _violet = Color(0xFF7C3AED);
  static const Color _indigo = Color(0xFF4F46E5);
  static const Color _blue = Color(0xFF4D7AD4);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.92),
            const Color(0xFFF7F8FF),
            const Color(0xFFF4F0FF),
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _violet.withOpacity(0.14),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF312E81).withOpacity(0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.6),
            blurRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Icon(
                      Icons.dark_mode_rounded,
                      size: 13,
                      color: _violet,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'TIDUR SEMALAM',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: _secondaryText,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _violet.withOpacity(0.12),
                      _blue.withOpacity(0.10),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _violet.withOpacity(0.18),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [_violet, _blue],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _violet.withOpacity(0.28),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Excellent',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5B21B6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Time Display
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: const [
              Text(
                '8',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: _primaryText,
                  height: 1,
                  letterSpacing: -1.2,
                ),
              ),
              Text(
                'j ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _secondaryText,
                ),
              ),
              Text(
                '20',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: _primaryText,
                  height: 1,
                  letterSpacing: -1.2,
                ),
              ),
              Text(
                'm',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          const Text(
            '22:10 - 06:30',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: _mutedText,
            ),
          ),

          const SizedBox(height: 12),

          // Sleep Stages Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildStage(_violet.withOpacity(0.34)),
                ),
                const SizedBox(width: 3),
                Expanded(
                  flex: 2,
                  child: _buildStage(_indigo.withOpacity(0.46)),
                ),
                const SizedBox(width: 3),
                Expanded(
                  flex: 2,
                  child: _buildStage(const Color(0xFF6366F1).withOpacity(0.30)),
                ),
                const SizedBox(width: 3),
                Expanded(
                  flex: 3,
                  child: _buildStage(_blue.withOpacity(0.56)),
                ),
                const SizedBox(width: 3),
                Expanded(
                  flex: 1,
                  child: _buildStage(_violet.withOpacity(0.28)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Stage Legend
          Row(
            children: [
              _buildLegend(_violet.withOpacity(0.68), 'Ringan'),
              const SizedBox(width: 14),
              _buildLegend(_indigo.withOpacity(0.74), 'Dalam'),
              const SizedBox(width: 14),
              _buildLegend(_blue.withOpacity(0.74), 'REM'),
            ],
          ),

          const SizedBox(height: 12),

          // Divider
          Divider(
            color: _violet.withOpacity(0.10),
            thickness: 0.7,
            height: 0,
          ),

          const SizedBox(height: 12),

          // Score Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kualitas Skor',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF475569),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [_blue, _violet],
                    ).createShader(bounds),
                    child: const Text(
                      '92%',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.1,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildBar(0.4, false),
                  const SizedBox(width: 4),
                  _buildBar(0.6, false),
                  const SizedBox(width: 4),
                  _buildBar(0.5, false),
                  const SizedBox(width: 4),
                  _buildBar(0.8, false),
                  const SizedBox(width: 4),
                  _buildBar(1.0, true),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStage(Color color) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.22),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBar(double heightFactor, bool isActive) {
    return Container(
      width: 8,
      height: 32.0 * heightFactor,
      decoration: BoxDecoration(
        gradient: isActive
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_violet, _blue],
              )
            : LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFE2E8F0),
                  const Color(0xFFCBD5E1).withOpacity(0.85),
                ],
              ),
        borderRadius: BorderRadius.circular(4),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: _violet.withOpacity(0.22),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
    );
  }
}
