// lib/features/meals/widgets/quantity_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/theme.dart';
import '../../../core/models/consumed_product.dart';

/// Widget per selezionare la quantità di un prodotto
/// Supporta:
/// - Increment/decrement con bottoni
/// - Editing diretto del valore
/// - Cambio unità di misura
class QuantitySelector extends StatefulWidget {
  final double initialQuantity;
  final MeasurementUnit initialUnit;
  final Function(double quantity, MeasurementUnit unit) onChanged;
  final double step; // Incremento per i bottoni +/-

  const QuantitySelector({
    super.key,
    required this.initialQuantity,
    required this.initialUnit,
    required this.onChanged,
    this.step = 10.0,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late double _quantity;
  late MeasurementUnit _unit;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
    _unit = widget.initialUnit;
    _controller.text = _quantity.toInt().toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateQuantity(double newQuantity) {
    if (newQuantity <= 0) return;
    
    setState(() {
      _quantity = newQuantity;
      _controller.text = _quantity.toInt().toString();
    });
    
    widget.onChanged(_quantity, _unit);
  }

  void _changeUnit(MeasurementUnit newUnit) {
    setState(() {
      _unit = newUnit;
    });
    
    widget.onChanged(_quantity, _unit);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusButton),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bottone -
          _buildButton(
            icon: Icons.remove,
            onTap: () => _updateQuantity(_quantity - widget.step),
          ),

          const SizedBox(width: 8),

          // Campo quantità
          IntrinsicWidth(
            child: Container(
              constraints: const BoxConstraints(minWidth: 50),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                ),
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null && parsed > 0) {
                    _updateQuantity(parsed);
                  }
                },
              ),
            ),
          ),

          const SizedBox(width: 4),

          // Unità di misura (dropdown)
          PopupMenuButton<MeasurementUnit>(
            initialValue: _unit,
            onSelected: _changeUnit,
            offset: const Offset(0, 40),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _unit.displayName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                  color: AppTheme.primary,
                ),
              ],
            ),
            itemBuilder: (context) => MeasurementUnit.values.map((unit) {
              return PopupMenuItem(
                value: unit,
                child: Text(
                  unit.longName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }).toList(),
          ),

          const SizedBox(width: 8),

          // Bottone +
          _buildButton(
            icon: Icons.add,
            onTap: () => _updateQuantity(_quantity + widget.step),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: AppTheme.primary,
        ),
      ),
    );
  }
}
