class DatosResponse {
  final List<TickestG5> datos;

  DatosResponse({required this.datos});

  factory DatosResponse.fromJson(Map<String, dynamic> json) {
    var list = json['datos'] as List;
    List<TickestG5> datosList = list.map((i) => TickestG5.fromJson(i)).toList();
    return DatosResponse(datos: datosList);
  }
}

class TickestG5 {
  final String? pfFecha;
  final int? pnEstado;
  final int? pnGestion;
  final String? pvCliente;
  final String? pvPropiedad;
  final List<Fotografia> plFotografias;
  final int? pnSeguimiento;
  final String? pvDescripcion;
  final int? pnCalificacion;
  final int? pnGestionTipo;
  final int? pnPermiteCerrar;
  final String? pvTiempoAtencion;
  final String? pvTiempoCreacion;
  final int? pnCantidadCerrados;
  final int? pnPermiteFinalizar;
  final int? pnPermiteEnProceso;
  final String? pvEstadoDescripcion;
  final int? pnCantidadEnProceso;
  final int? pnCantidadIngresados;
  final int? pnPermiteSeguimiento;
  final String? pvPropiedadDireccion;
  final String? pvPropiedadDescripcion;
  final String? pvGestionTipoDescripcion;

  TickestG5({
    this.pfFecha,
    this.pnEstado,
    this.pnGestion,
    this.pvCliente,
    this.pvPropiedad,
    required this.plFotografias,
    this.pnSeguimiento,
    this.pvDescripcion,
    this.pnCalificacion,
    this.pnGestionTipo,
    this.pnPermiteCerrar,
    this.pvTiempoAtencion,
    this.pvTiempoCreacion,
    this.pnCantidadCerrados,
    this.pnPermiteFinalizar,
    this.pnPermiteEnProceso,
    this.pvEstadoDescripcion,
    this.pnCantidadEnProceso,
    this.pnCantidadIngresados,
    this.pnPermiteSeguimiento,
    this.pvPropiedadDireccion,
    this.pvPropiedadDescripcion,
    this.pvGestionTipoDescripcion,
  });

  factory TickestG5.fromJson(Map<String, dynamic> json) {
    var fotosList = json['pl_fotografias'] as List? ?? [];
    List<Fotografia> fotos = fotosList.map((i) => Fotografia.fromJson(i)).toList();

    return TickestG5(
      pfFecha: json['pf_fecha'] as String?,
      pnEstado: json['pn_estado'] as int?,
      pnGestion: json['pn_gestion'] as int?,
      pvCliente: json['pv_cliente'] as String?,
      pvPropiedad: json['pv_propiedad'] as String?,
      plFotografias: fotos,
      pnSeguimiento: json['pn_seguimiento'] as int?,
      pvDescripcion: json['pv_descripcion'] as String?,
      pnCalificacion: json['pn_calificacion'] as int?,
      pnGestionTipo: json['pn_gestion_tipo'] as int?,
      pnPermiteCerrar: json['pn_permite_cerrar'] as int?,
      pvTiempoAtencion: json['pv_tiempo_atencion'] as String?,
      pvTiempoCreacion: json['pv_tiempo_creacion']?.toString(),
      pnCantidadCerrados: json['pn_cantidad_cerrados'] as int?,
      pnPermiteFinalizar: json['pn_permite_finalizar'] as int?,
      pnPermiteEnProceso: json['pn_permite_en_proceso'] as int?,
      pvEstadoDescripcion: json['pv_estado_descripcion'] as String?,
      pnCantidadEnProceso: json['pn_cantidad_en_proceso'] as int?,
      pnCantidadIngresados: json['pn_cantidad_ingresados'] as int?,
      pnPermiteSeguimiento: json['pn_permite_seguimiento'] as int?,
      pvPropiedadDireccion: json['pv_propiedad_direccion'] as String?,
      pvPropiedadDescripcion: json['pv_propiedad_descripcion'] as String?,
      pvGestionTipoDescripcion: json['pv_gestion_tipo_descripcion'] as String?,
    );
  }
}

class Fotografia {
  final int? pnFotografia;
  final String? pvFotografiab64;

  Fotografia({
    this.pnFotografia,
    this.pvFotografiab64,
  });

  factory Fotografia.fromJson(Map<String, dynamic> json) {
    return Fotografia(
      pnFotografia: json['pn_fotografia'] as int?,
      pvFotografiab64: json['pv_fotografiab64'] as String?,
    );
  }
}
