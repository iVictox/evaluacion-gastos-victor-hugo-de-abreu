import 'package:flutter/material.dart';
import '../models/gasto.dart';
import '../utils/categorias.dart';

class FormularioGastoScreen extends StatefulWidget {
  final Gasto? gasto; 

  const FormularioGastoScreen({super.key, this.gasto});

  @override
  State<FormularioGastoScreen> createState() => _FormularioGastoScreenState();
}

class _FormularioGastoScreenState extends State<FormularioGastoScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _descripcionController;
  late TextEditingController _montoController;
  String _categoriaSeleccionada = categorias.first;
  DateTime _fechaSeleccionada = DateTime.now();

  bool get _isEditing => widget.gasto != null;

  @override
  void initState() {
    super.initState();
    _descripcionController =
        TextEditingController(text: widget.gasto?.descripcion ?? '');
    _montoController =
        TextEditingController(text: widget.gasto?.monto.toString() ?? '');
    _categoriaSeleccionada = widget.gasto?.categoria ?? categorias.first;
    _fechaSeleccionada = widget.gasto?.fecha ?? DateTime.now();
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _montoController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = picked;
      });
    }
  }

  String _formatDate(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final monto = double.tryParse(_montoController.text) ?? 0.0;
      final id = widget.gasto?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

      final nuevoGasto = Gasto(
        id: id,
        descripcion: _descripcionController.text,
        monto: monto,
        categoria: _categoriaSeleccionada,
        fecha: _fechaSeleccionada,
      );

      Navigator.of(context).pop(nuevoGasto);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Gasto' : 'Agregar Gasto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _montoController,
                decoration: const InputDecoration(labelText: 'Monto', prefixText: 'Bs. '),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese un monto';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ingrese un número válido';
                  }
                  if (double.parse(value) <= 0) {
                    return 'El monto debe ser positivo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _categoriaSeleccionada,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: categorias.map((String categoria) {
                  return DropdownMenuItem<String>(
                    value: categoria,
                    child: Text(categoria),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _categoriaSeleccionada = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Fecha: ${_formatDate(_fechaSeleccionada)}'),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Seleccionar'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Botón Cancelar
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm, // Botón Guardar
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}