import '../../../app/theme.dart';
import '../../../core/models/user.dart';
import '../../../core/models/enums/gender.dart';
import '../../../core/models/enums/activity_level.dart';
import '../../../core/models/enums/goal.dart';
import '../../../core/services/nutrition_service.dart';
import '../../../core/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Pagina di modifica del profilo con validazioni e UI dedicata
class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final StorageService _storageService = StorageService();
  
  late TextEditingController _nomeController;
  late TextEditingController _dataNascitaController;
  late TextEditingController _altezzaController;
  late TextEditingController _pesoAttualeController;
  late TextEditingController _pesoObiettivoController;

  late Gender _sesso;
  late ActivityLevel _livelloAttivita;
  late Goal _obiettivoMain;
  
  int _eta = 0;
  double _bmi = 0.0;
  double _bmr = 0.0;
  double _tdee = 0.0;
  int _calorieGiornaliere = 0;
  double _proteineTarget = 0.0;
  double _carboidratiTarget = 0.0;
  double _grassiTarget = 0.0;

  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _initValues();
    _calcolaValori();
  }

  void _initControllers() {
    _nomeController = TextEditingController(text: widget.user.name);
    _dataNascitaController = TextEditingController(text: _formatDate(widget.user.birthDate));
    _altezzaController = TextEditingController(text: widget.user.heightCm.toStringAsFixed(0));
    _pesoAttualeController = TextEditingController(text: widget.user.weightKg.toStringAsFixed(1));
    _pesoObiettivoController = TextEditingController(
      text: widget.user.targetWeightKg?.toStringAsFixed(1) ?? '',
    );
  }

  void _initValues() {
    _sesso = widget.user.gender;
    _livelloAttivita = widget.user.activityLevel;
    _obiettivoMain = widget.user.goal;
    _eta = widget.user.age;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      debugPrint('Errore parsing data: $e');
    }
    return null;
  }

  void _calcolaEta() {
    final birthDate = _parseDate(_dataNascitaController.text);
    if (birthDate != null) {
      final oggi = DateTime.now();
      int eta = oggi.year - birthDate.year;
      
      if (oggi.month < birthDate.month ||
          (oggi.month == birthDate.month && oggi.day < birthDate.day)) {
        eta--;
      }

      setState(() {
        _eta = eta;
      });
      _calcolaValori();
    }
  }

  void _calcolaValori() {
    final altezza = double.tryParse(_altezzaController.text);
    final peso = double.tryParse(_pesoAttualeController.text);
    final pesoObiettivo = double.tryParse(_pesoObiettivoController.text);

    if (altezza == null || peso == null || _eta == 0) return;

    // Calcola BMI
    final altezzaMetri = altezza / 100;
    _bmi = peso / (altezzaMetri * altezzaMetri);

    // Calcola BMR
    _bmr = NutritionService.calculateBMR(
      gender: _sesso,
      weightKg: peso,
      heightCm: altezza,
      age: _eta,
    );

    // Calcola TDEE
    _tdee = NutritionService.calculateTDEE(
      bmr: _bmr,
      activityLevel: _livelloAttivita,
    );

    // Calcola calorie target
    double adjustment = 0.0;

    if (pesoObiettivo != null && (_obiettivoMain == Goal.loseWeight || _obiettivoMain == Goal.gainWeight)) {
      final weightDifference = (pesoObiettivo - peso).abs();

      if (_obiettivoMain == Goal.loseWeight) {
        final deficit = (weightDifference * 100).clamp(300, 800).toDouble();
        adjustment = -deficit;
      } else if (_obiettivoMain == Goal.gainWeight) {
        final surplus = (weightDifference * 80).clamp(200, 500).toDouble();
        adjustment = surplus;
      }
    } else {
      adjustment = _obiettivoMain.calorieAdjustment.toDouble();
    }

    _calorieGiornaliere = (_tdee + adjustment).round();

    // Calcola macros
    _proteineTarget = NutritionService.calculateProteinGoal(peso);
    _grassiTarget = NutritionService.calculateFatGoal(peso);
    _carboidratiTarget = NutritionService.calculateCarbGoal(
      dailyCalories: _calorieGiornaliere,
      proteinGrams: _proteineTarget,
      fatGrams: _grassiTarget,
    );

    setState(() {});
  }

  String _getBMICategoria() {
    if (_bmi < 18.5) return 'Sottopeso';
    if (_bmi < 25) return 'Normale';
    if (_bmi < 30) return 'Sovrappeso';
    return 'Obeso';
  }

  Future<void> _salvaProfilo() async {
    if (_formKey.currentState!.validate()) {
      // Validazioni età
      if (_eta < 10 || _eta > 120) {
        _mostraErrore('L\'età deve essere tra 10 e 120 anni');
        return;
      }

      // Validazione peso obiettivo
      final pesoObiettivo = double.tryParse(_pesoObiettivoController.text);
      if ((_obiettivoMain == Goal.loseWeight || _obiettivoMain == Goal.gainWeight) && 
          pesoObiettivo == null) {
        _mostraErrore('Inserisci un peso obiettivo');
        return;
      }

      final peso = double.parse(_pesoAttualeController.text);
      if (_obiettivoMain == Goal.loseWeight && pesoObiettivo != null && pesoObiettivo >= peso) {
        _mostraErrore('Il peso obiettivo deve essere inferiore al peso attuale');
        return;
      }

      if (_obiettivoMain == Goal.gainWeight && pesoObiettivo != null && pesoObiettivo <= peso) {
        _mostraErrore('Il peso obiettivo deve essere superiore al peso attuale');
        return;
      }

      setState(() {
        _isSaving = true;
      });

      try {
        final birthDate = _parseDate(_dataNascitaController.text);
        if (birthDate == null) {
          _mostraErrore('Data di nascita non valida');
          setState(() {
            _isSaving = false;
          });
          return;
        }

        // Aggiorna l'utente mantenendo l'ID esistente
        final updatedUser = widget.user.copyWith(
          name: _nomeController.text,
          gender: _sesso,
          birthDate: birthDate,
          heightCm: double.parse(_altezzaController.text),
          weightKg: peso,
          targetWeightKg: pesoObiettivo,
          activityLevel: _livelloAttivita,
          goal: _obiettivoMain,
        );

        // Salva l'utente aggiornato
        await _storageService.saveUser(updatedUser);

        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Profilo aggiornato con successo!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.surface,
                    ),
              ),
              backgroundColor: AppTheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusButton),
              ),
            ),
          );
        }
      } catch (e) {
        debugPrint('Errore salvataggio profilo: $e');
        _mostraErrore('Errore durante il salvataggio');
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _mostraErrore(String messaggio) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          messaggio,
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
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _dataNascitaController.dispose();
    _altezzaController.dispose();
    _pesoAttualeController.dispose();
    _pesoObiettivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifica Profilo'),
        backgroundColor: AppTheme.background,
        elevation: 0,
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            )
          else
            TextButton.icon(
              onPressed: _salvaProfilo,
              icon: const Icon(Icons.check, size: 20),
              label: const Text('Salva'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primary,
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.paddingStandard),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============ DATI ANAGRAFICI ============
              _buildSectionTitle('Dati anagrafici', textTheme),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _nomeController,
                label: 'Nome completo',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci il tuo nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _dataNascitaController,
                label: 'Data di nascita (gg/mm/aaaa)',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci la data di nascita';
                  }
                  final parts = value.split('/');
                  if (parts.length != 3) {
                    return 'Formato non valido (usa gg/mm/aaaa)';
                  }
                  return null;
                },
                onChanged: (_) => _calcolaEta(),
              ),
              const SizedBox(height: 16),
              _buildReadOnlyField(
                label: 'Età',
                value: '$_eta anni',
                icon: Icons.cake,
              ),
              const SizedBox(height: 16),
              _buildSessoSelector(textTheme),

              const SizedBox(height: AppTheme.sectionGap * 1.5),

              // ============ DATI FISICI ============
              _buildSectionTitle('Dati fisici', textTheme),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _altezzaController,
                label: 'Altezza (cm)',
                icon: Icons.height,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci l\'altezza';
                  }
                  final altezza = int.tryParse(value);
                  if (altezza == null || altezza < 130 || altezza > 250) {
                    return 'L\'altezza deve essere tra 130 e 250 cm';
                  }
                  return null;
                },
                onChanged: (_) => _calcolaValori(),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _pesoAttualeController,
                label: 'Peso attuale (kg)',
                icon: Icons.monitor_weight,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}'))],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci il peso attuale';
                  }
                  final peso = double.tryParse(value);
                  if (peso == null || peso < 35 || peso > 300) {
                    return 'Il peso deve essere tra 35 e 300 kg';
                  }
                  return null;
                },
                onChanged: (_) => _calcolaValori(),
              ),
              const SizedBox(height: 16),
              if (_obiettivoMain == Goal.loseWeight || _obiettivoMain == Goal.gainWeight)
                _buildTextField(
                  controller: _pesoObiettivoController,
                  label: 'Peso obiettivo (kg)',
                  icon: Icons.flag,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}'))],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci il peso obiettivo';
                    }
                    final peso = double.tryParse(value);
                    if (peso == null || peso < 35 || peso > 300) {
                      return 'Il peso deve essere tra 35 e 300 kg';
                    }
                    return null;
                  },
                  onChanged: (_) => _calcolaValori(),
                ),
              if (_obiettivoMain == Goal.loseWeight || _obiettivoMain == Goal.gainWeight)
                const SizedBox(height: 16),
              _buildReadOnlyField(
                label: 'IMC (Indice Massa Corporea)',
                value: '${_bmi.toStringAsFixed(1)} (${_getBMICategoria()})',
                icon: Icons.analytics,
              ),

              const SizedBox(height: AppTheme.sectionGap * 1.5),

              // ============ OBIETTIVI E ATTIVITÀ ============
              _buildSectionTitle('Obiettivi e attività', textTheme),
              const SizedBox(height: 12),
              _buildDropdown(
                label: 'Obiettivo principale',
                value: _obiettivoMain,
                items: Goal.values,
                icon: Icons.flag_outlined,
                displayText: (goal) => goal.displayName,
                onChanged: (value) {
                  setState(() {
                    _obiettivoMain = value!;
                    if (_obiettivoMain == Goal.maintain) {
                      _pesoObiettivoController.clear();
                    }
                  });
                  _calcolaValori();
                },
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Livello di attività',
                value: _livelloAttivita,
                items: ActivityLevel.values,
                icon: Icons.directions_run,
                displayText: (level) => level.displayName,
                onChanged: (value) {
                  setState(() {
                    _livelloAttivita = value!;
                  });
                  _calcolaValori();
                },
              ),

              const SizedBox(height: AppTheme.sectionGap * 1.5),

              // ============ PIANO NUTRIZIONALE (READ-ONLY) ============
              _buildSectionTitle('Piano nutrizionale calcolato', textTheme),
              const SizedBox(height: 12),
              _buildNutritionInfoCard(textTheme),

              const SizedBox(height: AppTheme.sectionGap * 2),

              // ============ PULSANTE SALVA ============
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _salvaProfilo,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.surface,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isSaving ? 'Salvataggio...' : 'Salva modifiche'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusButton),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.paddingStandard),
            ],
          ),
        ),
      ),
    );
  }

  // ============ WIDGET BUILDER ============

  Widget _buildSectionTitle(String title, TextTheme textTheme) {
    return Text(
      title,
      style: textTheme.headlineSmall,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusButton),
          borderSide: BorderSide(color: AppTheme.primary.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusButton),
          borderSide: const BorderSide(color: AppTheme.primary, width: 2),
        ),
        filled: true,
        fillColor: AppTheme.surface,
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusButton),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary.withValues(alpha: 0.6)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          Icon(
            Icons.lock_outline,
            size: 18,
            color: AppTheme.textSecondary.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }

  Widget _buildSessoSelector(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusButton),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wc, color: AppTheme.primary),
              const SizedBox(width: 12),
              Text(
                'Sesso',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSessoOption(Gender.male),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSessoOption(Gender.female),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSessoOption(Gender gender) {
    final isSelected = _sesso == gender;
    return InkWell(
      onTap: () {
        setState(() {
          _sesso = gender;
        });
        _calcolaValori();
      },
      borderRadius: BorderRadius.circular(AppTheme.radiusButton),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusButton),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.primary.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            gender.displayName,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isSelected ? AppTheme.surface : AppTheme.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required IconData icon,
    required String Function(T) displayText,
    required void Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusButton),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                isExpanded: true,
                style: Theme.of(context).textTheme.bodyLarge,
                items: items.map((item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Text(displayText(item)),
                  );
                }).toList(),
                onChanged: onChanged,
                dropdownColor: AppTheme.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionInfoCard(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.cardPadding),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          _buildNutritionRow('BMR (metabolismo basale)', '${_bmr.toStringAsFixed(0)} kcal', textTheme),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          _buildNutritionRow('TDEE (fabbisogno totale)', '${_tdee.toStringAsFixed(0)} kcal', textTheme),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          _buildNutritionRow('Calorie giornaliere', '$_calorieGiornaliere kcal', textTheme, highlight: true),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          _buildNutritionRow('Proteine', '${_proteineTarget.toStringAsFixed(0)} g/giorno', textTheme),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          _buildNutritionRow('Carboidrati', '${_carboidratiTarget.toStringAsFixed(0)} g/giorno', textTheme),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          _buildNutritionRow('Grassi', '${_grassiTarget.toStringAsFixed(0)} g/giorno', textTheme),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value, TextTheme textTheme, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: Row(
            children: [
              Icon(
                Icons.lock_outline,
                size: 16,
                color: AppTheme.textSecondary.withValues(alpha: 0.4),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: highlight ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              color: highlight ? AppTheme.primary : null,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}