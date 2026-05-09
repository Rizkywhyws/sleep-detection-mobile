import 'package:flutter/material.dart';
import '../../../core/widgets/app_theme.dart';
import '../../data/form_data.dart';
import '../../widgets/prediction_textfield.dart';
import '../../widgets/custom_slider.dart';
import '../../widgets/gender_card.dart';
import '../../widgets/dropdown/dropdown_field.dart';
import '../../widgets/dropdown/dropdown_model.dart';
import 'section_card.dart';

class Step1Profile extends StatelessWidget {
  final UserFormData formData;
  final void Function(VoidCallback) onUpdate;

  const Step1Profile({
    super.key,
    required this.formData,
    required this.onUpdate,
  });

  static const String _otherJobValue = 'Lainnya';

  static final List<DropdownItem> _jobItems = [
    const DropdownItem(value: 'Dokter',               label: 'Dokter',               subtitle: 'Tenaga kesehatan',       icon: Icons.medical_services_outlined,  iconBg: Color(0xFFFCEBEB), iconColor: Color(0xFFA32D2D)),
    const DropdownItem(value: 'Guru',                 label: 'Guru',                 subtitle: 'Pendidikan',             icon: Icons.menu_book_outlined,         iconBg: Color(0xFFFAEEDA), iconColor: Color(0xFF854F0B)),
    const DropdownItem(value: 'Software Engineer',    label: 'Software Engineer',    subtitle: 'Teknologi',              icon: Icons.code_rounded,               iconBg: Color(0xFFEEEDFE), iconColor: Color(0xFF534AB7)),
    const DropdownItem(value: 'Pengacara',            label: 'Pengacara',            subtitle: 'Hukum',                  icon: Icons.balance_outlined,           iconBg: Color(0xFFE1F5EE), iconColor: Color(0xFF0F6E56)),
    const DropdownItem(value: 'Insinyur',             label: 'Insinyur',             subtitle: 'Teknik',                 icon: Icons.engineering_outlined,       iconBg: Color(0xFFE6F1FB), iconColor: Color(0xFF185FA5)),
    const DropdownItem(value: 'Akuntan',              label: 'Akuntan',              subtitle: 'Keuangan',               icon: Icons.bar_chart_rounded,          iconBg: Color(0xFFEAF3DE), iconColor: Color(0xFF3B6D11)),
    const DropdownItem(value: 'Perawat',              label: 'Perawat',              subtitle: 'Tenaga kesehatan',       icon: Icons.health_and_safety_outlined, iconBg: Color(0xFFFCEBEB), iconColor: Color(0xFFA32D2D)),
    const DropdownItem(value: 'Ilmuwan',              label: 'Ilmuwan',              subtitle: 'Penelitian & Sains',     icon: Icons.science_outlined,           iconBg: Color(0xFFE8F4FD), iconColor: Color(0xFF1565C0)),
    const DropdownItem(value: 'Sales',                label: 'Sales',                subtitle: 'Penjualan',              icon: Icons.storefront_outlined,        iconBg: Color(0xFFFFF3E0), iconColor: Color(0xFFE65100)),
    const DropdownItem(value: 'Sales Representative', label: 'Sales Representative', subtitle: 'Penjualan & Pemasaran',  icon: Icons.handshake_outlined,         iconBg: Color(0xFFF3E5F5), iconColor: Color(0xFF6A1B9A)),
    const DropdownItem(value: _otherJobValue,         label: 'Lainnya',              subtitle: 'Isi pekerjaan lain',     icon: Icons.edit_note_rounded,          iconBg: Color(0xFFF1F5F9), iconColor: Color(0xFF475569)),
  ];

  bool get _isOtherJob => formData.job == _otherJobValue;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        return SingleChildScrollView(
          key: const ValueKey(1),
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              SectionCard(
                title: 'Data Pribadi',
                icon: Icons.person_outline_rounded,
                accentColor: const Color(0xFF2563EB),
                isDark: isDark,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GenderCard(
                            label: 'Laki-laki',
                            icon: Icons.male_rounded,
                            selected: formData.gender == 0,
                            isDark: isDark,
                            onTap: () => onUpdate(() => formData.gender = 0),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GenderCard(
                            label: 'Perempuan',
                            icon: Icons.female_rounded,
                            selected: formData.gender == 1,
                            isDark: isDark,
                            onTap: () => onUpdate(() => formData.gender = 1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 70,
                            child: AssessmentTextField(
                              label: 'Usia',
                              hint: '25',
                              type: TextInputType.number,
                              onChanged: (v) => onUpdate(() => formData.age = int.tryParse(v) ?? 0),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 70,
                            child: AssessmentDropdown(
                              label: 'Pekerjaan',
                              value: formData.job.isEmpty ? null : formData.job,
                              items: _jobItems,
                              isDark: isDark,
                              onChanged: (v) => onUpdate(() {
                                formData.job = v ?? '';
                                if (formData.job != _otherJobValue) formData.customJob = '';
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOutCubic,
                      child: _isOtherJob
                          ? Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: _OtherJobField(
                                isDark: isDark,
                                onChanged: (v) => onUpdate(() => formData.customJob = v ?? ''),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              SectionCard(
                title: 'Durasi Tidur',
                icon: Icons.bedtime_outlined,
                accentColor: const Color(0xFF7C3AED),
                isDark: isDark,
                child: StatefulBuilder(
                  builder: (_, s) => CustomSlider(
                    value: formData.sleepDuration,
                    min: 0,
                    max: 12,
                    divisions: 24,
                    unit: 'jam',
                    onChanged: (v) => s(() => formData.sleepDuration = v),
                    activeColor: isDark ? const Color(0xFF9B6FFF) : const Color(0xFF7C3AED),
                    showLabelsUnderAxis: true,
                    labels: const ['0j', '3j', '6j', '9j', '12j'],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OtherJobField extends StatelessWidget {
  final bool isDark;
  final void Function(String?) onChanged;

  const _OtherJobField({required this.isDark, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1E1A35), const Color(0xFF1A1535)]
              : [const Color(0xFFF5F8FF), const Color(0xFFEEF4FF)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF6D5FD8).withOpacity(0.35) : const Color(0xFFBDD0FF),
          width: 1,
        ),
        boxShadow: isDark
            ? [BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.10), blurRadius: 8, offset: const Offset(0, 2))]
            : null,
      ),
      child: AssessmentTextField(
        label: 'Pekerjaan Lainnya',
        hint: 'Contoh: Arsitek, Desainer, Wirausaha',
        type: TextInputType.text,
        onChanged: onChanged,
      ),
    );
  }
}