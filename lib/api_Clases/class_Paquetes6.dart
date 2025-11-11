import 'dart:convert';

class PaqueteG6 {
  final int pnPaquete;
  final String pfFecha;
  final String pfFecha_In;
  final String pfFecha_Up;
  final String pvCliente;
  final String pvPropiedad;
  final String pvPropiedadDescripcion;
  final String pvDescripcion;
  final List<Fotografia> plFotografias;
  final String pvRecolectado;
  final String pvRecolectadoObservaciones;
  final String? pvRecolectadoFecha;
  final int pnPermiteEditar;
  final int pnPermiteRecolectar;

  PaqueteG6({
    required this.pnPaquete,
    required this.pfFecha,
    required this.pfFecha_In,
    required this.pfFecha_Up,
    required this.pvCliente,
    required this.pvPropiedad,
    required this.pvPropiedadDescripcion,
    required this.pvDescripcion,
    required this.plFotografias,
    required this.pvRecolectado,
    required this.pvRecolectadoObservaciones,
    required this.pnPermiteEditar,
    required this.pnPermiteRecolectar,
    required this.pvRecolectadoFecha
  });

  factory PaqueteG6.fromJson(Map<String, dynamic> json) {
    return PaqueteG6(
      pnPaquete: json['pn_paquete'] is int
          ? json['pn_paquete']
          : int.tryParse(json['pn_paquete'].toString()) ?? 0,
      pfFecha: json['pf_fecha']?.toString() ?? '',
      pvRecolectadoFecha: json['pf_recolectado_fecha']?.toString() ?? '',
      pfFecha_In: json['pf_fecha_in']?.toString() ?? '',
      pfFecha_Up: json['pf_fecha_up']?.toString() ?? '',
      pvCliente: json['pv_cliente']?.toString() ?? '',
      pvPropiedad: json['pv_propiedad']?.toString() ?? '',
      pvPropiedadDescripcion: json['pv_propiedad_descripcion']?.toString() ?? '',
      pvDescripcion: json['pv_descripcion']?.toString() ?? '',
      plFotografias: (json['pl_fotografias'] as List?)
          ?.map((e) => Fotografia.fromJson(e))
          .toList() ??
          [],
      pvRecolectado: json['pv_recolectado']?.toString() ?? '',
      pvRecolectadoObservaciones:
      json['pv_recolectado_observaciones']?.toString() ?? '',
      pnPermiteEditar: json['pn_permite_editar'] is int
          ? json['pn_permite_editar']
          : int.tryParse(json['pn_permite_editar'].toString()) ?? 0,
      pnPermiteRecolectar: json['pn_permite_recolectar'] is int
          ? json['pn_permite_recolectar']
          : int.tryParse(json['pn_permite_recolectar'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pn_paquete': pnPaquete,
      'pf_fecha': pfFecha,
      'pf_fecha_in': pfFecha_In,
      'pf_fecha_up': pfFecha_Up,
      'pv_cliente': pvCliente,
      'pv_propiedad': pvPropiedad,
      'pv_propiedad_descripcion': pvPropiedadDescripcion,
      'pv_descripcion': pvDescripcion,
      'pl_fotografias': plFotografias.map((e) => e.toJson()).toList(),
      'pv_recolectado': pvRecolectado,
      'pv_recolectado_observaciones': pvRecolectadoObservaciones,
      'pn_permite_editar': pnPermiteEditar,
      'pn_permite_recolectar': pnPermiteRecolectar,
    };
  }
}

class Fotografia {
  final int pnFotografia;
  final String pvFotografiaB64;

  Fotografia({
    required this.pnFotografia,
    required this.pvFotografiaB64,
  });

  factory Fotografia.fromJson(Map<String, dynamic> json) {
    return Fotografia(
      pnFotografia: json['pn_fotografia'] is int
          ? json['pn_fotografia']
          : int.tryParse(json['pn_fotografia'].toString()) ?? 0,
      pvFotografiaB64: json['pv_fotografiab64']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pn_fotografia': pnFotografia,
      'pv_fotografiab64': pvFotografiaB64,
    };
  }
}
