class DatosResponse {
  final List<ReservasF5> datos;

  DatosResponse({required this.datos});

  factory DatosResponse.fromJson(Map<String, dynamic> json) {
    var list = json['datos'] as List;
    List<ReservasF5> datosList = list.map((i) => ReservasF5.fromJson(i)).toList();
    return DatosResponse(datos: datosList);
  }
}

class ReservasF5 {
  final String? pfFecha;
  final double? pmValor;
  final int? pnEstado;
  final int? pnMoneda;
  final int? pnReserva;
  final int? pnAmenidad;
  final String? pvVerPago;
  final int? pnDocumento;
  final String? pvVerCobro;
  final String? pvObservaciones;
  final String? pvMonedaSimbolo;
  final int? pnPermiteVerPago;
  final int? pnPermiteVerCobro;
  final String? pvEstadoDescripcion;
  final String? pvMonedaDescripcion;
  final int? pnPermiteAplicarPago;
  final String? pvAmenidadDescripcion;
  final String? pvVerComprobantePago;
  final String? pvPropiedadDescripcion;
  final String? pvRechazoObservaciones;
  final String? pfFechaAutorizadaRechazada;

  ReservasF5({
    this.pfFecha,
    this.pmValor,
    this.pnEstado,
    this.pnMoneda,
    this.pnReserva,
    this.pnAmenidad,
    this.pvVerPago,
    this.pnDocumento,
    this.pvVerCobro,
    this.pvObservaciones,
    this.pvMonedaSimbolo,
    this.pnPermiteVerPago,
    this.pnPermiteVerCobro,
    this.pvEstadoDescripcion,
    this.pvMonedaDescripcion,
    this.pnPermiteAplicarPago,
    this.pvAmenidadDescripcion,
    this.pvVerComprobantePago,
    this.pvPropiedadDescripcion,
    this.pvRechazoObservaciones,
    this.pfFechaAutorizadaRechazada,
  });

  factory ReservasF5.fromJson(Map<String, dynamic> json) {
    return ReservasF5(
      pfFecha: json['pf_fecha'] as String?,
      pmValor: (json['pm_valor'] != null) ? (json['pm_valor'] as num).toDouble() : null,
      pnEstado: json['pn_estado'] as int?,
      pnMoneda: json['pn_moneda'] as int?,
      pnReserva: json['pn_reserva'] as int?,
      pnAmenidad: json['pn_amenidad'] as int?,
      pvVerPago: json['pv_ver_pago'] as String?,
      pnDocumento: json['pn_documento'] as int?,
      pvVerCobro: json['pv_ver_cobro'] as String?,
      pvObservaciones: json['pv_observaciones'] as String?,
      pvMonedaSimbolo: json['pv_moneda_simbolo'] as String?,
      pnPermiteVerPago: json['pn_permite_ver_pago'] as int?,
      pnPermiteVerCobro: json['pn_permite_ver_cobro'] as int?,
      pvEstadoDescripcion: json['pv_estado_descripcion'] as String?,
      pvMonedaDescripcion: json['pv_moneda_descripcion'] as String?,
      pnPermiteAplicarPago: json['pn_permite_aplicar_pago'] as int?,
      pvAmenidadDescripcion: json['pv_amenidad_descripcion'] as String?,
      pvVerComprobantePago: json['pv_ver_comprobante_pago'] as String?,
      pvPropiedadDescripcion: json['pv_propiedad_descripcion'] as String?,
      pvRechazoObservaciones: json['pv_rechazo_observaciones'] as String?,
      pfFechaAutorizadaRechazada: json['pf_fecha_autorizada_rechazada'] as String?,
    );
  }
}
