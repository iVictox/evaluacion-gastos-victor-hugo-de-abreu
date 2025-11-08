class Gasto {
  String id;
  String descripcion;
  double monto;
  String categoria;
  DateTime fecha;

  Gasto({
    required this.id,
    required this.descripcion,
    required this.monto,
    required this.categoria,
    required this.fecha,
  });
}