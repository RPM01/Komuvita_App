import 'dart:convert';

/// Root model to parse the full response
class DatosResponse {
  final List<TickestG5> tickets;

  DatosResponse({required this.tickets});

  factory DatosResponse.fromJson(Map<String, dynamic> json) {
    var list = json['TickestG5'] as List? ?? [];
    return DatosResponse(
      tickets: list.map((e) => TickestG5.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'TickestG5': tickets.map((e) => e.toJson()).toList(),
  };
}

/// Individual ticket
class TickestG5 {
  final String pfFecha;
  final int pnEstado;
  final int pnGestion;
  final String pvCliente;
  final String pvPropiedad;
  final List<Fotografia> plFotografias;
  final List<Seguimiento>? plSeguimiento;
  final String pvDescripcion;
  final int pnCalificacion;
  final int pnGestionTipo;
  final int pnPermiteCerrar;
  final String? pvTiempoAtencion;
  final int pvTiempoCreacion;
  final int pnCantidadCerrados;
  final int pnPermiteFinalizar;
  final int pnPermiteEnProceso;
  final String pvEstadoDescripcion;
  final int pnCantidadEnProceso;
  final int pnCantidadIngresados;
  final int pnPermiteSeguimiento;
  final String pvPropiedadDireccion;
  final String pvPropiedadDescripcion;
  final String pvGestionTipoDescripcion;

  TickestG5({
    required this.pfFecha,
    required this.pnEstado,
    required this.pnGestion,
    required this.pvCliente,
    required this.pvPropiedad,
    required this.plFotografias,
    this.plSeguimiento,
    required this.pvDescripcion,
    required this.pnCalificacion,
    required this.pnGestionTipo,
    required this.pnPermiteCerrar,
    this.pvTiempoAtencion,
    required this.pvTiempoCreacion,
    required this.pnCantidadCerrados,
    required this.pnPermiteFinalizar,
    required this.pnPermiteEnProceso,
    required this.pvEstadoDescripcion,
    required this.pnCantidadEnProceso,
    required this.pnCantidadIngresados,
    required this.pnPermiteSeguimiento,
    required this.pvPropiedadDireccion,
    required this.pvPropiedadDescripcion,
    required this.pvGestionTipoDescripcion,
  });

  factory TickestG5.fromJson(Map<String, dynamic> json) => TickestG5(
    pfFecha: json['pf_fecha']?.toString() ?? '',
    pvCliente: json['pv_cliente']?.toString() ?? '',
    pvPropiedad: json['pv_propiedad']?.toString() ?? '',
    pnEstado: json['pn_estado'] ?? 0,
    pnGestion: json['pn_gestion'] ?? 0,
    pvEstadoDescripcion: json['pv_estado_descripcion']?.toString() ?? '',
    pvPropiedadDireccion: json['pv_propiedad_direccion']?.toString() ?? '',
    pvPropiedadDescripcion: json['pv_propiedad_descripcion']?.toString() ?? '',
    pvGestionTipoDescripcion: json['pv_gestion_tipo_descripcion']?.toString() ?? '',
    plFotografias: (json['pl_fotografias'] as List? ?? [])
        .map((e) => Fotografia.fromJson(e))
        .toList(),
    plSeguimiento: json['pl_seguimiento'] == null
        ? null
        : (json['pl_seguimiento'] as List)
        .map((e) => Seguimiento.fromJson(e))
        .toList(),
    pvDescripcion: json['pv_descripcion'] ?? '',
    pnCalificacion: json['pn_calificacion'] ?? 0,
    pnGestionTipo: json['pn_gestion_tipo'] ?? 0,
    pnPermiteCerrar: json['pn_permite_cerrar'] ?? 0,
    pvTiempoAtencion: json['pv_tiempo_atencion']?.toString(),
    pvTiempoCreacion: json['pv_tiempo_creacion'] ?? 0,
    pnCantidadCerrados: json['pn_cantidad_cerrados'] ?? 0,
    pnPermiteFinalizar: json['pn_permite_finalizar'] ?? 0,
    pnPermiteEnProceso: json['pn_permite_en_proceso'] ?? 0,
    pnCantidadEnProceso: json['pn_cantidad_en_proceso'] ?? 0,
    pnCantidadIngresados: json['pn_cantidad_ingresados'] ?? 0,
    pnPermiteSeguimiento: json['pn_permite_seguimiento'] ?? 0,

  );

  Map<String, dynamic> toJson() => {
    'pf_fecha': pfFecha,
    'pn_estado': pnEstado,
    'pn_gestion': pnGestion,
    'pv_cliente': pvCliente,
    'pv_propiedad': pvPropiedad,
    'pl_fotografias': plFotografias.map((e) => e.toJson()).toList(),
    'pl_seguimiento': plSeguimiento?.map((e) => e.toJson()).toList(),
    'pv_descripcion': pvDescripcion,
    'pn_calificacion': pnCalificacion,
    'pn_gestion_tipo': pnGestionTipo,
    'pn_permite_cerrar': pnPermiteCerrar,
    'pv_tiempo_atencion': pvTiempoAtencion,
    'pv_tiempo_creacion': pvTiempoCreacion,
    'pn_cantidad_cerrados': pnCantidadCerrados,
    'pn_permite_finalizar': pnPermiteFinalizar,
    'pn_permite_en_proceso': pnPermiteEnProceso,
    'pv_estado_descripcion': pvEstadoDescripcion,
    'pn_cantidad_en_proceso': pnCantidadEnProceso,
    'pn_cantidad_ingresados': pnCantidadIngresados,
    'pn_permite_seguimiento': pnPermiteSeguimiento,
    'pv_propiedad_direccion': pvPropiedadDireccion,
    'pv_propiedad_descripcion': pvPropiedadDescripcion,
    'pv_gestion_tipo_descripcion': pvGestionTipoDescripcion,
  };
}

/// Fotografía model
class Fotografia {
  final int pnFotografia;
  final String pvFotografiaB64;

  Fotografia({
    required this.pnFotografia,
    required this.pvFotografiaB64,
  });

  factory Fotografia.fromJson(Map<String, dynamic> json) => Fotografia(
    pnFotografia: json['pn_fotografia'] ?? 0,
    pvFotografiaB64: json['pv_fotografiab64'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'pn_fotografia': pnFotografia,
    'pv_fotografiab64': pvFotografiaB64,
  };
}

/// Seguimiento model
class Seguimiento {
  final String pfFecha;
  final String pvUsuario;
  final String pvComentario;
  final List<Fotografia2> plFotografiasB;
  final int pnSeguimiento;

  Seguimiento({
    required this.pfFecha,
    required this.pvUsuario,
    required this.pvComentario,
    required this.plFotografiasB,
    required this.pnSeguimiento,
  });

  factory Seguimiento.fromJson(Map<String, dynamic> json) => Seguimiento(
    pfFecha: json['pf_fecha'] ?? '',
    pvUsuario: json['pv_usuario'] ?? '',
    pvComentario: json['pv_comentario'] ?? '',
    plFotografiasB: (json['pl_fotografias'] as List? ?? [])
        .map((e) => Fotografia2.fromJson(e))
        .toList(),
    pnSeguimiento: json['pn_seguimiento'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'pf_fecha': pfFecha,
    'pv_usuario': pvUsuario,
    'pv_comentario': pvComentario,
    'pl_fotografias': plFotografiasB.map((e) => e.toJson()).toList(),
    'pn_seguimiento': pnSeguimiento,
  };
}

class Fotografia2 {
  final int pnFotografia2;
  final String pvFotografiaB642;

  Fotografia2({
    required this.pnFotografia2,
    required this.pvFotografiaB642,
  });

  factory Fotografia2.fromJson(Map<String, dynamic> json) => Fotografia2(
    pnFotografia2: json['pn_fotografia'] ?? 0,
    pvFotografiaB642: json['pv_fotografiab64'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'pn_fotografia': pnFotografia2,
    'pv_fotografiab64': pvFotografiaB642,
  };
}