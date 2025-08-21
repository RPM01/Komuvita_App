class ApiResponse {
  final List<DacumentosH5> datos;

  ApiResponse({required this.datos});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var list = json['datos'] as List;
    List<DacumentosH5> datosList = list.map((i) => DacumentosH5.fromJson(i)).toList();
    return ApiResponse(datos: datosList);
  }
}

class DacumentosH5 {
  final List<Detalle> plDetalle;
  final List<dynamic> plPagos; // no fields info, so kept dynamic
  final int? pnDocumento;
  final int? pnDocumentoTipo;
  final String? pvDocumentoTipoDescripcion;
  final int? pnPropiedad;
  final String? pvPropiedadDescripcion;
  final String? pvPropiedadDireccion;
  final String? pfFecha;
  final String? pvNit;
  final String? pvNombre;
  final String? pvSerie;
  final String? pvNumero;
  final String? pvUuid;
  final int? pnMoneda;
  final String? pvMonedaDescripcion;
  final String? pvMonedaSimbolo;
  final double? pmValor;
  final double? pmValorPendiente;
  final int? pnEstado;
  final String? pvEstadoDescripcion;
  final int? pnPermiteVerCobro;
  final String? pvVerCobro;
  final int? pnPermiteAplicaPago;

  DacumentosH5({
    required this.plDetalle,
    required this.plPagos,
    this.pnDocumento,
    this.pnDocumentoTipo,
    this.pvDocumentoTipoDescripcion,
    this.pnPropiedad,
    this.pvPropiedadDescripcion,
    this.pvPropiedadDireccion,
    this.pfFecha,
    this.pvNit,
    this.pvNombre,
    this.pvSerie,
    this.pvNumero,
    this.pvUuid,
    this.pnMoneda,
    this.pvMonedaDescripcion,
    this.pvMonedaSimbolo,
    this.pmValor,
    this.pmValorPendiente,
    this.pnEstado,
    this.pvEstadoDescripcion,
    this.pnPermiteVerCobro,
    this.pvVerCobro,
    this.pnPermiteAplicaPago,
  });

  factory DacumentosH5.fromJson(Map<String, dynamic> json) {
    var detalleList = json['pl_detalle'] as List? ?? [];
    List<Detalle> detalles = detalleList.map((i) => Detalle.fromJson(i)).toList();

    var pagosList = json['pl_pagos'] as List? ?? [];

    return DacumentosH5(
      plDetalle: detalles,
      plPagos: pagosList,
      pnDocumento: json['pn_documento'],
      pnDocumentoTipo: json['pn_documento_tipo'],
      pvDocumentoTipoDescripcion: json['pv_documento_tipo_descripcion'],
      pnPropiedad: json['pn_propiedad'],
      pvPropiedadDescripcion: json['pv_propiedad_descripcion'],
      pvPropiedadDireccion: json['pv_propiedad_direccion'],
      pfFecha: json['pf_fecha'],
      pvNit: json['pv_nit'],
      pvNombre: json['pv_nombre'],
      pvSerie: json['pv_serie'],
      pvNumero: json['pv_numero'],
      pvUuid: json['pv_uuid'],
      pnMoneda: json['pn_moneda'],
      pvMonedaDescripcion: json['pv_moneda_descripcion'],
      pvMonedaSimbolo: json['pv_moneda_simbolo'],
      pmValor: (json['pm_valor'] != null) ? (json['pm_valor'] as num).toDouble() : null,
      pmValorPendiente: (json['pm_valor_pendiente'] != null) ? (json['pm_valor_pendiente'] as num).toDouble() : null,
      pnEstado: json['pn_estado'],
      pvEstadoDescripcion: json['pv_estado_descripcion'],
      pnPermiteVerCobro: json['pn_permite_ver_cobro'],
      pvVerCobro: json['pv_ver_cobro'],
      pnPermiteAplicaPago: json['pn_permite_aplica_pago'],
    );
  }
}

class Detalle {
  final int? pnDetalle;
  final String? pvDescripcion;
  final double? pmCantidad;
  final double? pmPrecio;
  final double? pmDescuento;
  final double? pmSubtotal;

  Detalle({
    this.pnDetalle,
    this.pvDescripcion,
    this.pmCantidad,
    this.pmPrecio,
    this.pmDescuento,
    this.pmSubtotal,
  });

  factory Detalle.fromJson(Map<String, dynamic> json) {
    return Detalle(
      pnDetalle: json['pn_detalle'],
      pvDescripcion: json['pv_descripcion'],
      pmCantidad: (json['pm_cantidad'] != null) ? (json['pm_cantidad'] as num).toDouble() : null,
      pmPrecio: (json['pm_precio'] != null) ? (json['pm_precio'] as num).toDouble() : null,
      pmDescuento: (json['pm_descuento'] != null) ? (json['pm_descuento'] as num).toDouble() : null,
      pmSubtotal: (json['pm_subtotal'] != null) ? (json['pm_subtotal'] as num).toDouble() : null,
    );
  }
}
