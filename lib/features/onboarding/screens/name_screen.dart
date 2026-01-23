// lib/features/onboarding/screens/name_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/theme.dart';
import '../../../providers/onboarding_provider.dart';

/// Schermata per inserire il nome
class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Precarica il valore se già presente
    final provider = context.read<OnboardingProvider>();
    if (provider.name != null) {
      _controller.text = provider.name!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
      context.read<OnboardingProvider>().setName(_controller.text);
      context.go('/onboarding/gender');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/onboarding'),
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
                _buildProgress(1, 7),

                const SizedBox(height: 40),

                // Titolo
                Text(
                  'Come ti chiami?',
                  style: Theme.of(context).textTheme.displaySmall,
                ),

                const SizedBox(height: 12),

                // Sottotitolo
                Text(
                  'Useremo il tuo nome per personalizzare l\'esperienza',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 40),

                // Input field
                TextFormField(
                  controller: _controller,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Inserisci il tuo nome';
                    }
                    if (value.trim().length < 2) {
                      return 'Il nome deve contenere almeno 2 caratteri';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _continue(),
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
          style: Theme.of(context).textTheme.labelSmall,
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