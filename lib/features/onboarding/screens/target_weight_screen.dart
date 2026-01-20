// lib/features/onboarding/screens/target_weight_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/theme.dart';
import '../../../core/models/enums/goal.dart';
import '../../../providers/onboarding_provider.dart';

/// Schermata per inserire il peso obiettivo (solo per lose/gain weight)
class TargetWeightScreen extends StatefulWidget {
  const TargetWeightScreen({super.key});

  @override
  State<TargetWeightScreen> createState() => _TargetWeightScreenState();
}

class _TargetWeightScreenState extends State<TargetWeightScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final provider = context.read<OnboardingProvider>();
    
    // Verifica che sia necessario (solo per lose/gain weight)
    if (!provider.needsTargetWeight) {
      // Salta questa schermata
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/onboarding/summary');
      });
      return;
    }
    
    if (provider.targetWeightKg != null) {
      _controller.text = provider.targetWeightKg!.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
      final targetWeight = double.parse(_controller.text);
      context.read<OnboardingProvider>().setTargetWeight(targetWeight);
      context.go('/onboarding/summary');
    }
  }

  String _getTitle(Goal? goal) {
    if (goal == Goal.loseWeight) return 'Quale peso vuoi raggiungere?';
    if (goal == Goal.gainWeight) return 'Quale peso vuoi raggiungere?';
    return 'Peso obiettivo';
  }

  String _getSubtitle(Goal? goal) {
    if (goal == Goal.loseWeight) {
      return 'Inserisci il peso target per la tua perdita di peso';
    }
    if (goal == Goal.gainWeight) {
      return 'Inserisci il peso target per il tuo aumento di massa';
    }
    return 'Inserisci il tuo peso obiettivo';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/onboarding/goal'),
        ),
      ),
      body: SafeArea(
        child: Consumer<OnboardingProvider>(
          builder: (context, provider, _) {
            // Se non serve peso obiettivo, non mostrare nulla
            if (!provider.needsTargetWeight) {
              return const SizedBox.shrink();
            }

            final currentWeight = provider.weightKg ?? 0;
            final goal = provider.goal;

            return Padding(
              padding: const EdgeInsets.all(AppTheme.paddingStandard * 2),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    // Progress indicator
                    _buildProgress(7, 8), // Ora sono 8 step totali se serve target

                    const SizedBox(height: 40),

                    // Titolo
                    Text(
                      _getTitle(goal),
                      style: Theme.of(context).textTheme.displaySmall,
                    ),

                    const SizedBox(height: 12),

                    // Sottotitolo
                    Text(
                      _getSubtitle(goal),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 40),

                    // Current weight indicator
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
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
                            'Peso attuale: ${currentWeight.toStringAsFixed(1)} kg',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Target weight input
                    TextFormField(
                      controller: _controller,
                      autofocus: true,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Peso obiettivo',
                        hintText: 'Es. 70.0',
                        suffixText: 'kg',
                        prefixIcon: Icon(Icons.flag_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci il peso obiettivo';
                        }
                        
                        final targetWeight = double.tryParse(value);
                        if (targetWeight == null) {
                          return 'Inserisci un numero valido';
                        }
                        
                        if (targetWeight < 30 || targetWeight > 300) {
                          return 'Inserisci un peso valido (30-300 kg)';
                        }
                        
                        // Validazione in base all'obiettivo
                        if (goal == Goal.loseWeight) {
                          if (targetWeight >= currentWeight) {
                            return 'Il peso obiettivo deve essere minore del peso attuale';
                          }
                          if (currentWeight - targetWeight > 50) {
                            return 'La differenza è troppo grande (max 50 kg)';
                          }
                        } else if (goal == Goal.gainWeight) {
                          if (targetWeight <= currentWeight) {
                            return 'Il peso obiettivo deve essere maggiore del peso attuale';
                          }
                          if (targetWeight - currentWeight > 30) {
                            return 'La differenza è troppo grande (max 30 kg)';
                          }
                        }
                        
                        return null;
                      },
                      onFieldSubmitted: (_) => _continue(),
                    ),

                    const SizedBox(height: 24),

                    // Preview differenza e tempo stimato
                    if (_controller.text.isNotEmpty)
                      Builder(
                        builder: (context) {
                          final targetWeight = double.tryParse(_controller.text);
                          if (targetWeight == null) return const SizedBox.shrink();

                          final difference = (targetWeight - currentWeight).abs();
                          int estimatedWeeks;
                          
                          if (goal == Goal.loseWeight) {
                            estimatedWeeks = (difference / 0.625).ceil();
                          } else {
                            estimatedWeeks = (difference / 0.325).ceil();
                          }

                          final months = (estimatedWeeks / 4.33).round();

                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.accent2.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                              border: Border.all(
                                color: AppTheme.accent2.withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildMetric(
                                      context,
                                      icon: Icons.straighten,
                                      label: 'Differenza',
                                      value: '${difference.toStringAsFixed(1)} kg',
                                    ),
                                    Container(
                                      height: 40,
                                      width: 1,
                                      color: AppTheme.accent2.withOpacity(0.3),
                                    ),
                                    _buildMetric(
                                      context,
                                      icon: Icons.calendar_today,
                                      label: 'Tempo stimato',
                                      value: months > 0 
                                          ? '~$months ${months == 1 ? "mese" : "mesi"}'
                                          : '~$estimatedWeeks ${estimatedWeeks == 1 ? "settimana" : "settimane"}',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  goal == Goal.loseWeight
                                      ? 'Perdita sana: 0.5-0.75 kg/settimana'
                                      : 'Aumento sano: 0.25-0.4 kg/settimana',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.accent2,
                                        fontStyle: FontStyle.italic,
                                      ),
                                ),
                              ],
                            ),
                          );
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
          value: current / total,
          backgroundColor: AppTheme.primary.withOpacity(0.1),
          valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  Widget _buildMetric(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppTheme.accent2),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppTheme.accent2,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}