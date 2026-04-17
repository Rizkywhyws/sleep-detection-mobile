import 'package:flutter/material.dart';

class SleepCard extends StatelessWidget {
  const SleepCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4D7AD4).withOpacity(0.22),
            const Color(0xFF6B46C1).withOpacity(0.18),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF6B46C1).withOpacity(0.25),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Row ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('🌙', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  const Text(
                    'TIDUR SEMALAM',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withOpacity(0.3),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF8B5CF6),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Excellent',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B46C1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Time Display ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: const [
              Text(
                '8',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                  height: 1,
                ),
              ),
              Text(
                'j ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                '20',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                  height: 1,
                ),
              ),
              Text(
                'm',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          const Text(
            '22:10 – 06:30',
            style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
          ),

          const SizedBox(height: 12),

          // ── Sleep Stages Bar ──
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Row(
              children: [
                Expanded(flex: 1, child: _buildStage(const Color(0xFF8B5CF6).withOpacity(0.35))),
                const SizedBox(width: 3),
                Expanded(flex: 2, child: _buildStage(const Color(0xFF4F46E5).withOpacity(0.45))),
                const SizedBox(width: 3),
                Expanded(flex: 2, child: _buildStage(const Color(0xFF6366F1).withOpacity(0.30))),
                const SizedBox(width: 3),
                Expanded(flex: 3, child: _buildStage(const Color(0xFF4D7AD4).withOpacity(0.55))),
                const SizedBox(width: 3),
                Expanded(flex: 1, child: _buildStage(const Color(0xFF8B5CF6).withOpacity(0.30))),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ── Stage Legend ──
          Row(
            children: [
              _buildLegend(const Color(0xFF8B5CF6).withOpacity(0.6), 'Ringan'),
              const SizedBox(width: 14),
              _buildLegend(const Color(0xFF4F46E5).withOpacity(0.7), 'Dalam'),
              const SizedBox(width: 14),
              _buildLegend(const Color(0xFF4D7AD4).withOpacity(0.7), 'REM'),
            ],
          ),

          const SizedBox(height: 12),

          // ── Divider ──
          Divider(
            color: const Color(0xFF6B46C1).withOpacity(0.15),
            thickness: 0.5,
            height: 0,
          ),

          const SizedBox(height: 12),

          // ── Score Row ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kualitas Skor',
                    style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF4D7AD4), Color(0xFF7C3AED)],
                    ).createShader(bounds),
                    child: const Text(
                      '92%',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.1,
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
    return Container(height: 6, color: color);
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
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
                colors: [Color(0xFF7C3AED), Color(0xFF4D7AD4)],
              )
            : null,
        color: isActive ? null : const Color(0xFFCBD5E1).withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}