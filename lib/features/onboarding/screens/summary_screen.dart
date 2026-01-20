// lib/features/onboarding/screens/summary_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../app/theme.dart';
import '../../../providers/onboarding_provider.dart';

/// Schermata di riepilogo con tutti i calcoli - completa l'onboarding
class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  Future<void> _complete(BuildContext context) async {
    final provider = context.read<OnboardingProvider>();
    
    // Mostra loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppTheme.primary),
      ),
    );

    // Completa onboarding e salva utente
    final success = await provider.completeOnboarding();

    if (!context.mounted) return;
    
    // Chiudi loading
    Navigator.of(context).pop();

    if (success) {
      // Vai alla home
      context.go('/home');
    } else {
      // Mostra errore
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Errore durante il salvataggio. Riprova.'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Se c'è target weight, torna a target-weight, altrimenti a goal
            final provider = context.read<OnboardingProvider>();
            if (provider.needsTargetWeight) {
              context.go('/onboarding/target-weight');
            } else {
              context.go('/onboarding/goal');
            }
          },
        ),
      ),
      body: SafeArea(
        child: Consumer<OnboardingProvider>(
          builder: (context, provider, _) {
            if (!provider.isComplete) {
              return const Center(
                child: Text('Dati incompleti'),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.paddingStandard * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // Progress indicator (dinamico in base a se serve target weight)
                  _buildProgress(
                    provider.needsTargetWeight ? 8 : 7,
                    provider.needsTargetWeight ? 8 : 7,
                  ),

                  const SizedBox(height: 40),

                  // Titolo
                  Text(
                    'Il tuo piano',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),

                  const SizedBox(height: 12),

                  // Sottotitolo
                  Text(
                    'Ecco i tuoi obiettivi giornalieri personalizzati',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 32),

                  // Card calorie principali
                  _buildMainCalorieCard(context, provider),

                  const SizedBox(height: 16),

                  // Card macronutrienti
                  _buildMacroCard(context, provider),

                  const SizedBox(height: 16),

                  // Card dati personali
                  _buildPersonalDataCard(context, provider),

                  const SizedBox(height: 32),

                  // CTA Button
                  ElevatedButton(
                    onPressed: provider.isCompleting 
                        ? null 
                        : () => _complete(context),
                    child: provider.isCompleting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text('Inizia il tuo percorso'),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
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
          value: 1.0,
          backgroundColor: AppTheme.primary.withOpacity(0.1),
          valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  Widget _buildMainCalorieCard(BuildContext context, OnboardingProvider provider) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.cardPadding),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.15),
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Text(
            'Obiettivo giornaliero',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            '${provider.calculatedDailyCalories}',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppTheme.primary,
                ),
          ),
          Text(
            'kcal al giorno',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetric(
                  context,
                  label: 'BMR',
                  value: '${provider.calculatedBMR?.toStringAsFixed(0)} kcal',
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: AppTheme.primary.withOpacity(0.2),
                ),
                _buildMetric(
                  context,
                  label: 'TDEE',
                  value: '${provider.calculatedTDEE?.toStringAsFixed(0)} kcal',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard(BuildContext context, OnboardingProvider provider) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.cardPadding),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.15),
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Macronutrienti',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildMacroRow(
            context,
            label: 'Proteine',
            value: '${provider.calculatedProtein?.toStringAsFixed(0)}g',
            color: AppTheme.protein,
          ),
          const SizedBox(height: 12),
          _buildMacroRow(
            context,
            label: 'Carboidrati',
            value: '${provider.calculatedCarbs?.toStringAsFixed(0)}g',
            color: AppTheme.carbs,
          ),
          const SizedBox(height: 12),
          _buildMacroRow(
            context,
            label: 'Grassi',
            value: '${provider.calculatedFats?.toStringAsFixed(0)}g',
            color: AppTheme.fats,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDataCard(BuildContext context, OnboardingProvider provider) {
    final bmi = provider.calculatedBMI?.toStringAsFixed(1) ?? '-';
    String bmiCategory = 'N/A';
    if (provider.calculatedBMI != null) {
      final bmiValue = provider.calculatedBMI!;
      if (bmiValue < 18.5) {
        bmiCategory = 'Sottopeso';
      } else if (bmiValue < 25) bmiCategory = 'Normopeso';
      else if (bmiValue < 30) bmiCategory = 'Sovrappeso';
      else bmiCategory = 'Obesità';
    }

    final birthDateFormat = DateFormat('d MMMM yyyy', 'it_IT');
    final birthDateStr = provider.birthDate != null 
        ? birthDateFormat.format(provider.birthDate!)
        : '-';

    return Container(
      padding: const EdgeInsets.all(AppTheme.cardPadding),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Il tuo profilo',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(context, 'Nome', provider.name ?? '-'),
          _buildInfoRow(context, 'Genere', provider.gender?.displayName ?? '-'),
          _buildInfoRow(context, 'Data di nascita', birthDateStr),
          _buildInfoRow(context, 'Età', '${provider.age} anni'),
          _buildInfoRow(context, 'Altezza', '${provider.heightCm?.toStringAsFixed(0)} cm'),
          _buildInfoRow(context, 'Peso attuale', '${provider.weightKg?.toStringAsFixed(1)} kg'),
          if (provider.targetWeightKg != null) ...[
            _buildInfoRow(context, 'Peso obiettivo', '${provider.targetWeightKg?.toStringAsFixed(1)} kg'),
            _buildInfoRow(context, 'Da raggiungere', '${provider.weightDifference?.abs().toStringAsFixed(1)} kg'),
            if (provider.estimatedWeeks != null) ...[
              _buildInfoRow(
                context,
                'Tempo stimato',
                provider.estimatedWeeks! > 4
                    ? '~${(provider.estimatedWeeks! / 4.33).round()} ${(provider.estimatedWeeks! / 4.33).round() == 1 ? "mese" : "mesi"}'
                    : '~${provider.estimatedWeeks} ${provider.estimatedWeeks == 1 ? "settimana" : "settimane"}',
              ),
            ],
          ],
          _buildInfoRow(context, 'BMI', '$bmi ($bmiCategory)'),
          _buildInfoRow(context, 'Attività', provider.activityLevel?.displayName ?? '-'),
          _buildInfoRow(context, 'Obiettivo', provider.goal?.displayName ?? '-', isLast: true),
        ],
      ),
    );
  }

  Widget _buildMetric(BuildContext context, {required String label, required String value}) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.primary,
              ),
        ),
      ],
    );
  }

  Widget _buildMacroRow(BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
              ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}