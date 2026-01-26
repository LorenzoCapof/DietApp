import '../../../app/theme.dart';
import '../../../core/models/user.dart';
import '../../../core/services/nutrition_service.dart';
import '../../../core/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'editprofile_screen.dart';

/// Screen profilo utente con visualizzazione dei dati reali dall'onboarding
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final NutritionService _nutritionService = NutritionService(StorageService());
  
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Carica i dati dell'utente dal servizio
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _nutritionService.getUser();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Errore caricamento utente: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Naviga alla pagina di modifica
  Future<void> _navigateToEdit() async {
    if (_user == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(user: _user!),
      ),
    );

    // Se i dati sono stati salvati, ricarica il profilo
    if (result == true) {
      await _loadUserData();
    }
  }

  // Mostra dialog di conferma logout
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        ),
        title: Text(
          'Logout',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        content: Text(
          'Sei sicuro di voler uscire?',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annulla',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            onPressed: () {
              // TODO: Implementare logout reale
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Logout effettuato',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.surface,
                        ),
                  ),
                  backgroundColor: AppTheme.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusButton),
                  ),
                ),
              );
            },
            child: const Text('Esci'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.primary,
          ),
        ),
      );
    }

    if (_user == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_off,
                size: 64,
                color: AppTheme.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Nessun utente trovato',
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Completa l\'onboarding per iniziare',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingStandard),
        child: Column(
          children: [
            const SizedBox(height: AppTheme.sectionGap * 2),

            // ============ PULSANTI IN ALTO ============
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showLogoutDialog,
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('Logout'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.error,
                      side: const BorderSide(color: AppTheme.error),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _navigateToEdit,
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Modifica'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.sectionGap * 1.5),

            // ============ HEADER: AVATAR + NOME ============
            _buildProfileHeader(textTheme),

            const SizedBox(height: AppTheme.sectionGap * 1.5),

            // ============ SEZIONE: DATI ANAGRAFICI ============
            _buildSectionTitle('Dati anagrafici', textTheme),
            const SizedBox(height: 12),
            _buildInfoCard(
              textTheme: textTheme,
              items: [
                ('Data di nascita', _formatDate(_user!.birthDate)),
                ('Età', '${_user!.age} anni'),
                ('Sesso', _user!.gender.displayName),
              ],
            ),

            const SizedBox(height: AppTheme.sectionGap * 1.5),

            // ============ SEZIONE: DATI FISICI ============
            _buildSectionTitle('Dati fisici', textTheme),
            const SizedBox(height: 12),
            _buildInfoCard(
              textTheme: textTheme,
              items: [
                ('Altezza', '${_user!.heightCm.toStringAsFixed(0)} cm'),
                ('Peso attuale', '${_user!.weightKg.toStringAsFixed(1)} kg'),
                if (_user!.targetWeightKg != null)
                  ('Peso obiettivo', '${_user!.targetWeightKg!.toStringAsFixed(1)} kg'),
                ('IMC', '${_user!.bmi.toStringAsFixed(1)} (${_getBMICategory(_user!.bmi)})'),
              ],
            ),

            const SizedBox(height: AppTheme.sectionGap * 1.5),

            // ============ SEZIONE: OBIETTIVI E ATTIVITÀ ============
            _buildSectionTitle('Obiettivi e attività', textTheme),
            const SizedBox(height: 12),
            _buildInfoCard(
              textTheme: textTheme,
              items: [
                ('Obiettivo principale', _user!.goal.displayName),
                ('Livello attività', _user!.activityLevel.displayName),
                if (_user!.targetWeightKg != null) ...[
                  ('Peso da raggiungere', '${(_user!.targetWeightKg! - _user!.weightKg).abs().toStringAsFixed(1)} kg'),
                ],
              ],
            ),

            const SizedBox(height: AppTheme.sectionGap * 1.5),

            // ============ SEZIONE: NUTRIZIONE ============
            _buildSectionTitle('Piano nutrizionale', textTheme),
            const SizedBox(height: 12),
            _buildInfoCard(
              textTheme: textTheme,
              items: [
                ('BMR (metabolismo basale)', '${_user!.bmr.toStringAsFixed(0)} kcal'),
                ('TDEE (fabbisogno totale)', '${_user!.tdee.toStringAsFixed(0)} kcal'),
                ('Calorie giornaliere', '${_user!.dailyCalories} kcal'),
                ('Proteine target', '${_user!.proteinGrams.toStringAsFixed(0)} g/giorno'),
                ('Carboidrati target', '${_user!.carbsGrams.toStringAsFixed(0)} g/giorno'),
                ('Grassi target', '${_user!.fatsGrams.toStringAsFixed(0)} g/giorno'),
              ],
            ),

            const SizedBox(height: AppTheme.paddingStandard),
          ],
        ),
      ),
    );
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Sottopeso';
    if (bmi < 25) return 'Normale';
    if (bmi < 30) return 'Sovrappeso';
    return 'Obeso';
  }

  // ============ HEADER: AVATAR CIRCOLARE + NOME ============
  Widget _buildProfileHeader(TextTheme textTheme) {
    return Column(
      children: [
        // Avatar circolare con bordo
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.accent2.withValues(alpha: 0.2),
            border: Border.all(
              color: AppTheme.accent2,
              width: 3,
            ),
          ),
          child: const Icon(
            Icons.person,
            size: 64,
            color: AppTheme.accent2,
          ),
        ),

        const SizedBox(height: AppTheme.paddingStandard),

        // Nome utente
        Text(
          _user!.name,
          style: textTheme.displayLarge,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 4),

        // Badge obiettivo
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _user!.goal.displayName,
            style: textTheme.bodyMedium?.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ============ TITOLO SEZIONE ============
  Widget _buildSectionTitle(String title, TextTheme textTheme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: textTheme.headlineSmall,
      ),
    );
  }

  // ============ CARD INFORMAZIONI PERSONALI ============
  Widget _buildInfoCard({
    required TextTheme textTheme,
    required List<(String, String)> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.cardPadding),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.06),
          width: 1,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _buildInfoRow(
              label: items[i].$1,
              value: items[i].$2,
              textTheme: textTheme,
              isLast: i == items.length - 1,
            ),
            if (i < items.length - 1) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }

  // ============ SINGOLA RIGA INFO (Label → Value) ============
  Widget _buildInfoRow({
    required String label,
    required String value,
    required TextTheme textTheme,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label
              Expanded(
                flex: 5,
                child: Text(
                  label,
                  style: textTheme.bodyMedium,
                ),
              ),

              const SizedBox(width: 12),

              // Value
              Expanded(
                flex: 4,
                child: Text(
                  value,
                  style: textTheme.bodyLarge,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),

        // Divider tra righe (tranne l'ultima)
        if (!isLast) ...[
          const SizedBox(height: 14),
          Divider(
            height: 1,
            thickness: 1,
            color: AppTheme.primary.withValues(alpha: 0.06),
          ),
        ],
      ],
    );
  }
}