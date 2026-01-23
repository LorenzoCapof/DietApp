// lib/features/onboarding/screens/birthdate_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../app/theme.dart';
import '../../../providers/onboarding_provider.dart';

/// Schermata per selezionare la data di nascita
class BirthDateScreen extends StatefulWidget {
  const BirthDateScreen({super.key});

  @override
  State<BirthDateScreen> createState() => _BirthDateScreenState();
}

class _BirthDateScreenState extends State<BirthDateScreen> {
  static const int minAge = 10;
  static const int maxAge = 120;

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final provider = context.read<OnboardingProvider>();
    _selectedDate = provider.birthDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final maxBirthDate = DateTime(now.year - minAge, now.month, now.day);
    final minBirthDate = DateTime(now.year - maxAge, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? maxBirthDate,
      firstDate: minBirthDate,
      lastDate: maxBirthDate,
      locale: const Locale('it', 'IT'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: Colors.white,
              surface: AppTheme.surface,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _continue() {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleziona la tua data di nascita'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    final age = _calculateAge(_selectedDate!);
    if (age < minAge || age > maxAge) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('L\'età deve essere compresa tra $minAge e $maxAge anni'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    context.read<OnboardingProvider>().setBirthDate(_selectedDate!);
    context.go('/onboarding/body');
  }

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE d MMM', 'it_IT');
    final age = _selectedDate != null ? _calculateAge(_selectedDate!) : null;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/onboarding/gender'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingStandard * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildProgress(3, 7),
              const SizedBox(height: 40),
              Text(
                'Quando sei nato?',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 12),
              Text(
                'L\'età influenza il calcolo del metabolismo basale',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
              InkWell(
                onTap: () => _selectDate(context),
                borderRadius: BorderRadius.circular(AppTheme.radiusButton),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(AppTheme.radiusButton),
                    border: Border.all(
                      color: _selectedDate != null
                          ? AppTheme.primary
                          : AppTheme.primary.withValues(alpha: 0.15),
                      width: _selectedDate != null ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _selectedDate != null
                              ? AppTheme.primary
                              : AppTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.cake_outlined,
                          color: _selectedDate != null
                              ? Colors.white
                              : AppTheme.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Data di nascita',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedDate != null
                                  ? dateFormat.format(_selectedDate!)
                                  : 'Seleziona data',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: _selectedDate != null
                                        ? AppTheme.primary
                                        : AppTheme.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        color: _selectedDate != null
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_selectedDate != null && age != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    border: Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 20,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        age < minAge || age > maxAge
                            ? 'Età non valida'
                            : 'Hai $age anni',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: age < minAge || age > maxAge
                                  ? AppTheme.error
                                  : AppTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              ElevatedButton(
                onPressed: _continue,
                child: const Text('Continua'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgress(int current, int total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step $current di $total',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: current / total,
          backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
          valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }
}
