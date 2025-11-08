import 'package:flutter/material.dart';
import '../models/gasto.dart';

class ResumenMensualScreen extends StatelessWidget {
  final List<Gasto> gastos;

  const ResumenMensualScreen({super.key, required this.gastos});

  String _formatCurrency(double monto) {
    return 'Bs. ${monto.toStringAsFixed(2)}';
  }

  // --- Cálculos ---

  double get _totalMesActual {
    final ahora = DateTime.now();
    double total = 0.0;
    for (var gasto in gastos) {
      if (gasto.fecha.month == ahora.month && gasto.fecha.year == ahora.year) {
        total += gasto.monto;
      }
    }
    return total;
  }

  Map<String, double> get _desgloseCategorias {
    final ahora = DateTime.now();
    Map<String, double> desglose = {};

    for (var gasto in gastos) {
      if (gasto.fecha.month == ahora.month && gasto.fecha.year == ahora.year) {
        desglose.update(
          gasto.categoria,
          (valorExistente) => valorExistente + gasto.monto,
          ifAbsent: () => gasto.monto, 
        );
      }
    }
    return desglose;
  }

  @override
  Widget build(BuildContext context) {
    final total = _totalMesActual;
    final desglose = _desgloseCategorias;
    final itemsDesglose = desglose.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen Mensual'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'TOTAL GASTADO (MES ACTUAL)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatCurrency(total),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Desglose por Categoría',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: itemsDesglose.length,
                itemBuilder: (context, index) {
                  final item = itemsDesglose[index];
                  return ListTile(
                    title: Text(item.key), 
                    trailing: Text(
                      _formatCurrency(item.value), 
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}