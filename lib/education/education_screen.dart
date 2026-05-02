import 'package:flutter/material.dart';
import 'widgets/condition_card.dart';
import 'sleep_condition.dart';
class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Edukasi Gangguan Tidur',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Kenali kondisi tidurmu dan cara mengatasinya\nuntuk hidup yang lebih sehat dan berkualitas.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF718096),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          ...sleepConditions.map(
            (condition) => ConditionCard(condition: condition),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF1A237E).withOpacity(0.15),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.info_outline, size: 16, color: Color(0xFF1A237E)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Informasi ini bersifat edukatif dan tidak menggantikan diagnosis medis. Konsultasikan ke dokter untuk penanganan lebih lanjut.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF1A237E),
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
