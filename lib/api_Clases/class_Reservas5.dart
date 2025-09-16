class ReservasF5Response {
  final List<ReservasF5> reservas;

  ReservasF5Response({required this.reservas});

  factory ReservasF5Response.fromJson(Map<String, dynamic> json) {
    var list = json['ReservasF5'] as List? ?? [];
    List<ReservasF5> reservasList = list.map((item) => ReservasF5.fromJson(item)).toList();
    return ReservasF5Response(reservas: reservasList);
  }
}

class ReservasF5 {
  final String pfFecha;
  final double pmValor;
  final int pnEstado;
  final int pnMoneda;
  final int pnReserva;
  final int pnAmenidad;
  final String? pvVerPago;
  final int pnDocumento;
  final String? pvVerCobro;
  final String? pvObservaciones;
  final String? pvMonedaSimbolo;
  final int pnPermiteRechazar;
  final int pnPermiteVerPago;
  final int pnPermiteAutorizar;
  final int pnPermiteVerCobro;
  final String? pvEstadoDescripcion;
  final String? pvMonedaDescripcion;
  final int pnPermiteAplicarPago;
  final String? pvAmenidadDescripcion;
  final String? pvVerComprobantePago;
  final String? pvPropiedadDescripcion;
  final String? pvRechazoObservaciones;
  final String? pfFechaAutorizadaRechazada;

  ReservasF5({
    required this.pfFecha,
    required this.pmValor,
    required this.pnEstado,
    required this.pnMoneda,
    required this.pnReserva,
    required this.pnAmenidad,
    this.pvVerPago,
    required this.pnDocumento,
    this.pvVerCobro,
    this.pvObservaciones,
    this.pvMonedaSimbolo,
    required this.pnPermiteRechazar,
    required this.pnPermiteVerPago,
    required this.pnPermiteAutorizar,
    required this.pnPermiteVerCobro,
    this.pvEstadoDescripcion,
    this.pvMonedaDescripcion,
    required this.pnPermiteAplicarPago,
    this.pvAmenidadDescripcion,
    this.pvVerComprobantePago,
    this.pvPropiedadDescripcion,
    this.pvRechazoObservaciones,
    this.pfFechaAutorizadaRechazada,
  });

  factory ReservasF5.fromJson(Map<String, dynamic> json) {
    return ReservasF5(
      pfFecha: json['pf_fecha'] ?? '',
      pmValor: (json['pm_valor'] ?? 0).toDouble(),
      pnEstado: json['pn_estado'] ?? 0,
      pnMoneda: json['pn_moneda'] ?? 0,
      pnReserva: json['pn_reserva'] ?? 0,
      pnAmenidad: json['pn_amenidad'] ?? 0,
      pvVerPago: json['pv_ver_pago'],
      pnDocumento: json['pn_documento'] ?? 0,
      pvVerCobro: json['pv_ver_cobro'],
      pvObservaciones: json['pv_observaciones'],
      pvMonedaSimbolo: json['pv_moneda_simbolo'],
      pnPermiteRechazar: json['pn_permite_rechazar'] ?? 0,
      pnPermiteVerPago: json['pn_permite_ver_pago'] ?? 0,
      pnPermiteAutorizar: json['pn_permite_autorizar'] ?? 0,
      pnPermiteVerCobro: json['pn_permite_ver_cobro'] ?? 0,
      pvEstadoDescripcion: json['pv_estado_descripcion'],
      pvMonedaDescripcion: json['pv_moneda_descripcion'],
      pnPermiteAplicarPago: json['pn_permite_aplicar_pago'] ?? 0,
      pvAmenidadDescripcion: json['pv_amenidad_descripcion'],
      pvVerComprobantePago: json['pv_ver_comprobante_pago'],
      pvPropiedadDescripcion: json['pv_propiedad_descripcion'],
      pvRechazoObservaciones: json['pv_rechazo_observaciones'],
      pfFechaAutorizadaRechazada: json['pf_fecha_autorizada_rechazada'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pf_fecha': pfFecha,
      'pm_valor': pmValor,
      'pn_estado': pnEstado,
      'pn_moneda': pnMoneda,
      'pn_reserva': pnReserva,
      'pn_amenidad': pnAmenidad,
      'pv_ver_pago': pvVerPago,
      'pn_documento': pnDocumento,
      'pv_ver_cobro': pvVerCobro,
      'pv_observaciones': pvObservaciones,
      'pv_moneda_simbolo': pvMonedaSimbolo,
      'pn_permite_rechazar': pnPermiteRechazar,
      'pn_permite_ver_pago': pnPermiteVerPago,
      'pn_permite_autorizar': pnPermiteAutorizar,
      'pn_permite_ver_cobro': pnPermiteVerCobro,
      'pv_estado_descripcion': pvEstadoDescripcion,
      'pv_moneda_descripcion': pvMonedaDescripcion,
      'pn_permite_aplicar_pago': pnPermiteAplicarPago,
      'pv_amenidad_descripcion': pvAmenidadDescripcion,
      'pv_ver_comprobante_pago': pvVerComprobantePago,
      'pv_propiedad_descripcion': pvPropiedadDescripcion,
      'pv_rechazo_observaciones': pvRechazoObservaciones,
      'pf_fecha_autorizada_rechazada': pfFechaAutorizadaRechazada,
    };
  }
}
