import '../../../app/theme.dart';

import 'package:flutter/material.dart';


/// Screen profilo utente - UI only con dati mock completi
/// Replica la mockup usando esclusivamente AppTheme con Google Fonts
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingStandard),
        child: Column(
          children: [
            const SizedBox(height: AppTheme.sectionGap * 2.5),
            // ============ HEADER: AVATAR + NOME ============
            _buildProfileHeader(textTheme),

            const SizedBox(height: AppTheme.sectionGap * 1.5),

            // ============ SEZIONE: DATI ANAGRAFICI ============
            _buildSectionTitle('Dati anagrafici', textTheme),
            const SizedBox(height: 12),
            _buildInfoCard(
              textTheme: textTheme,
              items: [
                ('Data di nascita', '12/12/1982'),
                ('Età', '42 anni'),
                ('Sesso', 'Maschio'),
              ],
            ),

            const SizedBox(height: AppTheme.sectionGap * 1.5),

            // ============ SEZIONE: DATI FISICI ============
            _buildSectionTitle('Dati fisici', textTheme),
            const SizedBox(height: 12),
            _buildInfoCard(
              textTheme: textTheme,
              items: [
                ('Altezza', '187 cm'),
                ('Peso attuale', '89 kg'),
                ('Peso obiettivo', '82 kg'),
                ('IMC', '25.4 (Sovrappeso)'),
              ],
            ),

            const SizedBox(height: AppTheme.sectionGap * 1.5),

            // ============ SEZIONE: OBIETTIVI E ATTIVITÀ ============
            _buildSectionTitle('Obiettivi e attività', textTheme),
            const SizedBox(height: 12),
            _buildInfoCard(
              textTheme: textTheme,
              items: [
                ('Obiettivo principale', 'Perdere peso'),
                ('Ritmo dimagrimento', '0.5 kg/settimana'),
                ('Livello attività', 'Moderatamente attivo'),
                ('Allenamenti settimanali', '3-4 volte'),
              ],
            ),

            const SizedBox(height: AppTheme.sectionGap * 1.5),

            // ============ SEZIONE: ALIMENTAZIONE ============
            _buildSectionTitle('Alimentazione', textTheme),
            const SizedBox(height: 12),
            _buildInfoCard(
              textTheme: textTheme,
              items: [
                ('Tipo di dieta', 'Vegetariana'),
                ('Calorie giornaliere', '1848 kcal'),
                ('Proteine target', '92 g/giorno'),
                ('Carboidrati target', '208 g/giorno'),
                ('Grassi target', '51 g/giorno'),
                ('Pasti al giorno', '4'),
              ],
            ),

            const SizedBox(height: AppTheme.sectionGap * 1.5),

            // ============ SEZIONE: ALLERGIE E PREFERENZE ============
            _buildSectionTitle('Allergie e preferenze', textTheme),
            const SizedBox(height: 12),
            _buildInfoCard(
              textTheme: textTheme,
              items: [
                ('Allergie', 'Glutine'),
                ('Intolleranze', 'Lattosio (lieve)'),
                ('Cibi da evitare', 'Carne, pesce'),
                ('Idratazione giornaliera', '2.5 litri'),
              ],
            ),

            const SizedBox(height: AppTheme.sectionGap * 1.5),

            // ============ CTA MODIFICA PROFILO ============
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to edit profile
                },
                child: const Text('Modifica il tuo profilo'),
              ),
            ),

            const SizedBox(height: AppTheme.paddingStandard),
          ],
        ),
      ),
    );
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

        // Nome utente - Crimson Pro 700, 36sp
        Text(
          'Marco Ploy',
          style: textTheme.displayLarge,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 4),

        // Email o username secondario
        Text(
          'marco.ploy@email.com',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
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
        style: textTheme.headlineSmall, // Poppins 600, 18sp
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label - bodyMedium (Poppins 400, 14sp, textSecondary)
            Expanded(
              flex: 5,
              child: Text(
                label,
                style: textTheme.bodyMedium,
              ),
            ),

            const SizedBox(width: 12),

            // Value - bodyLarge (Poppins 400, 16sp, textPrimary)
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