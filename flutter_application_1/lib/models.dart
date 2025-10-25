import 'package:flutter/material.dart';

class MetaAhorro {
  final int? id;
  final String nombre;
  final double montoObjetivo;
  final double montoActual;
  final DateTime fechaObjetivo;
  final Color color;
  final IconData icono;
  final DateTime creadoEn;

  MetaAhorro({
    this.id,
    required this.nombre,
    required this.montoObjetivo,
    required this.montoActual,
    required this.fechaObjetivo,
    required this.color,
    required this.icono,
    required this.creadoEn,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'monto_objetivo': montoObjetivo,
      'monto_actual': montoActual,
      'fecha_objetivo': fechaObjetivo.toIso8601String(),
      'color': color.value.toString(),
      'icono': _iconToStr(icono),
      'creado_en': creadoEn.toIso8601String(),
    };
  }

  factory MetaAhorro.fromMap(Map<String, dynamic> map) {
    return MetaAhorro(
      id: map['id'],
      nombre: map['nombre'],
      montoObjetivo: map['monto_objetivo'],
      montoActual: map['monto_actual'],
      fechaObjetivo: DateTime.parse(map['fecha_objetivo']),
      color: Color(int.parse(map['color'])),
      icono: _strToIcon(map['icono']),
      creadoEn: DateTime.parse(map['creado_en']),
    );
  }

  static String _iconToStr(IconData icon) {
    // Mapeo simple de iconos a strings
    if (icon == Icons.laptop) return 'laptop';
    if (icon == Icons.beach_access) return 'beach_access';
    if (icon == Icons.phone_iphone) return 'phone_iphone';
    if (icon == Icons.savings) return 'savings';
    if (icon == Icons.home) return 'home';
    if (icon == Icons.directions_car) return 'directions_car';
    if (icon == Icons.movie) return 'movie';
    return 'savings'; // default
  }

  static IconData _strToIcon(String str) {
    switch (str) {
      case 'laptop':
        return Icons.laptop;
      case 'beach_access':
        return Icons.beach_access;
      case 'phone_iphone':
        return Icons.phone_iphone;
      case 'savings':
        return Icons.savings;
      case 'home':
        return Icons.home;
      case 'directions_car':
        return Icons.directions_car;
      case 'movie':
        return Icons.movie;
      default:
        return Icons.savings;
    }
  }
}

class Presupuesto {
  final int? id;
  final String categoria;
  final double limiteGasto;
  final double gastado;
  final double metaAhorro;
  final Color color;
  final DateTime creadoEn;

  Presupuesto({
    this.id,
    required this.categoria,
    required this.limiteGasto,
    required this.gastado,
    required this.metaAhorro,
    required this.color,
    required this.creadoEn,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoria': categoria,
      'limite_gasto': limiteGasto,
      'gastado': gastado,
      'meta_ahorro': metaAhorro,
      'color': color.value.toString(),
      'creado_en': creadoEn.toIso8601String(),
    };
  }

  factory Presupuesto.fromMap(Map<String, dynamic> map) {
    return Presupuesto(
      id: map['id'],
      categoria: map['categoria'],
      limiteGasto: map['limite_gasto'],
      gastado: map['gastado'],
      metaAhorro: map['meta_ahorro'],
      color: Color(int.parse(map['color'])),
      creadoEn: DateTime.parse(map['creado_en']),
    );
  }
}

class Transaccion {
  final int? id;
  final double monto;
  final String categoria;
  final String? descripcion;
  final String tipo; // 'ingreso' o 'gasto'
  final DateTime fecha;
  final DateTime creadoEn;

  Transaccion({
    this.id,
    required this.monto,
    required this.categoria,
    this.descripcion,
    required this.tipo,
    required this.fecha,
    required this.creadoEn,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'monto': monto,
      'categoria': categoria,
      'descripcion': descripcion,
      'tipo': tipo,
      'fecha': fecha.toIso8601String(),
      'creado_en': creadoEn.toIso8601String(),
    };
  }

  factory Transaccion.fromMap(Map<String, dynamic> map) {
    return Transaccion(
      id: map['id'],
      monto: map['monto'],
      categoria: map['categoria'],
      descripcion: map['descripcion'],
      tipo: map['tipo'],
      fecha: DateTime.parse(map['fecha']),
      creadoEn: DateTime.parse(map['creado_en']),
    );
  }
}
