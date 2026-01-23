// lib/features/onboarding/screens/body_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/theme.dart';
import '../../../providers/onboarding_provider.dart';

/// Schermata per inserire altezza e peso
class BodyScreen extends StatefulWidget {
  const BodyScreen({super.key});

  @override
  State<BodyScreen> createState() => _BodyScreenState();
}

class _BodyScreenState extends State<BodyScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final provider = context.read<OnboardingProvider>();
    if (provider.heightCm != null) {
      _heightController.text = provider.heightCm!.toStringAsFixed(0);
    }
    if (provider.weightKg != null) {
      _weightController.text = provider.weightKg!.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
      final height = double.parse(_heightController.text);
      final weight = double.parse(_weightController.text);
      
      final provider = context.read<OnboardingProvider>();
      provider.setHeight(height);
      provider.setWeight(weight);
      
      context.go('/onboarding/activity');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/onboarding/birthdate'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingStandard * 2),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Progress indicator
                _buildProgress(4, 7),

                const SizedBox(height: 40),

                // Titolo
                Text(
                  'Misure corporee',
                  style: Theme.of(context).textTheme.displaySmall,
                ),

                const SizedBox(height: 12),

                // Sottotitolo
                Text(
                  'Altezza e peso sono essenziali per calcolare le tue calorie',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 40),

                // Altezza
                TextFormField(
                  controller: _heightController,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Altezza',
                    hintText: 'Es. 175',
                    suffixText: 'cm',
                    prefixIcon: Icon(Icons.height),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci la tua altezza';
                    }
                    final height = double.tryParse(value);
                    if (height == null) {
                      return 'Inserisci un numero valido';
                    }
                    if (height < 130) {
                      return 'L\'altezza deve essere almeno 130 cm';
                    }
                    if (height > 250) {
                      return 'L\'altezza deve essere massimo 250 cm';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Peso
                TextFormField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Peso',
                    hintText: 'Es. 70.5',
                    suffixText: 'kg',
                    prefixIcon: Icon(Icons.monitor_weight_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci il tuo peso';
                    }
                    final weight = double.tryParse(value);
                    if (weight == null) {
                      return 'Inserisci un numero valido';
                    }
                    if (weight < 35) {
                      return 'Il peso deve essere almeno 35 kg';
                    }
                    if (weight > 300) {
                      return 'Il peso deve essere massimo 300 kg';
                    }
                    
                    // Validazione aggiuntiva: controllo BMI estremi
                    final height = double.tryParse(_heightController.text);
                    if (height != null && height >= 130 && height <= 250) {
                      final heightM = height / 100;
                      final bmi = weight / (heightM * heightM);
                      
                      if (bmi < 13) {
                        return 'Questi valori danno un BMI troppo basso. Verifica i dati inseriti.';
                      }
                      if (bmi > 60) {
                        return 'Questi valori danno un BMI troppo alto. Verifica i dati inseriti.';
                      }
                    }
                    
                    return null;
                  },
                  onFieldSubmitted: (_) => _continue(),
                ),

                const SizedBox(height: 24),

                // BMI Preview (se entrambi i campi sono validi)
                Consumer<OnboardingProvider>(
                  builder: (context, provider, _) {
                    final height = double.tryParse(_heightController.text);
                    final weight = double.tryParse(_weightController.text);

                    if (height != null && weight != null && 
                        height >= 130 && height <= 250 && 
                        weight >= 35 && weight <= 300) {
                      final heightM = height / 100;
                      final bmi = weight / (heightM * heightM);
                      String category;
                      Color categoryColor;

                      if (bmi < 18.5) {
                        category = 'Sottopeso';
                        categoryColor = AppTheme.warning;
                      } else if (bmi < 25) {
                        category = 'Normopeso';
                        categoryColor = AppTheme.success;
                      } else if (bmi < 30) {
                        category = 'Sovrappeso';
                        categoryColor = AppTheme.warning;
                      } else {
                        category = 'Obesità';
                        categoryColor = AppTheme.error;
                      }

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          border: Border.all(
                            color: categoryColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline, 
                                 size: 20, 
                                 color: categoryColor),
                            const SizedBox(width: 8),
                            Text(
                              'BMI: ${bmi.toStringAsFixed(1)} - $category',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: categoryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),

                const Spacer(),

                // Continue button
                ElevatedButton(
                  onPressed: _continue,
                  child: const Text('Continua'),
                ),

                const SizedBox(height: 20),
              ],
            ),
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