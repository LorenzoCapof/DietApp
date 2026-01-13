import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'DietApp',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E7F6D),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CaloriesOverview(),
            const SizedBox(height: 24),
            _MacrosCard(),
            const SizedBox(height: 24),
            const Text(
              'Pasti di oggi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _MealTile(
              title: 'Colazione',
              calories: 420,
              icon: Icons.free_breakfast,
            ),
            _MealTile(
              title: 'Pranzo',
              calories: 650,
              icon: Icons.lunch_dining,
            ),
            _MealTile(
              title: 'Cena',
              calories: 520,
              icon: Icons.dinner_dining,
            ),
            _MealTile(
              title: 'Snack',
              calories: 180,
              icon: Icons.apple,
            ),
          ],
        ),
      ),
    );
  }
}

class _CaloriesOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const int targetCalories = 2200;
    const int consumedCalories = 1350;
    const int burnedCalories = 320;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E7F6D), Color(0xFF4CB8A5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text(
            'Calorie rimanenti',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            '${targetCalories - consumedCalories + burnedCalories}',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CaloriesInfo(label: 'Target', value: targetCalories),
              _CaloriesInfo(label: 'Assunte', value: consumedCalories),
              _CaloriesInfo(label: 'Bruciate', value: burnedCalories),
            ],
          ),
        ],
      ),
    );
  }
}

class _CaloriesInfo extends StatelessWidget {
  final String label;
  final int value;

  const _CaloriesInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          '$value kcal',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _MacrosCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Macronutrienti',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _MacroBar(label: 'Carboidrati', value: 0.55, color: Color(0xFF4CB8A5)),
          _MacroBar(label: 'Proteine', value: 0.25, color: Color(0xFF1E7F6D)),
          _MacroBar(label: 'Grassi', value: 0.20, color: Color(0xFFF2C94C)),
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _MacroBar({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _MealTile extends StatelessWidget {
  final String title;
  final int calories;
  final IconData icon;

  const _MealTile({
    required this.title,
    required this.calories,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF4CB8A5).withOpacity(0.2),
          child: Icon(icon, color: const Color(0xFF1E7F6D)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('$calories kcal'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
