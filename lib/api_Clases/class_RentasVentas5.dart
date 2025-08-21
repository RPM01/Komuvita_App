class RentaResponse {
  final List<RentaVentaD5> datos;

  RentaResponse({required this.datos});

  factory RentaResponse.fromJson(Map<String, dynamic> json) {
    var list = json['datos'] as List;
    List<RentaVentaD5> datosList = list.map((i) => RentaVentaD5.fromJson(i)).toList();
    return RentaResponse(datos: datosList);
  }
}

class RentaVentaD5 {
  final String? pfFecha;
  final double? pmValor;
  final int? pnRenta;
  final int? pnMoneda;
  final String? pvContacto;
  final int? pnRechazado;
  final int? pnAutorizado;
  final int? pnRentaTipo;
  final int? pnVisualizar;
  final List<Fotografia> plFotografias;
  final String? pvDetalleRenta;
  final String? pvMonedaSimbolo;
  final String? pvMonedaDescripcion;
  final String? pvRentaTipoDescripcion;
  final String? pvRechazadoObservaciones;
  final int? pnPermiteAutorizarRechazar;

  RentaVentaD5({
    this.pfFecha,
    this.pmValor,
    this.pnRenta,
    this.pnMoneda,
    this.pvContacto,
    this.pnRechazado,
    this.pnAutorizado,
    this.pnRentaTipo,
    this.pnVisualizar,
    required this.plFotografias,
    this.pvDetalleRenta,
    this.pvMonedaSimbolo,
    this.pvMonedaDescripcion,
    this.pvRentaTipoDescripcion,
    this.pvRechazadoObservaciones,
    this.pnPermiteAutorizarRechazar,
  });

  factory RentaVentaD5.fromJson(Map<String, dynamic> json) {
    var fotosList = json['pl_fotografias'] as List? ?? [];
    List<Fotografia> fotos = fotosList.map((i) => Fotografia.fromJson(i)).toList();

    return RentaVentaD5(
      pfFecha: json['pf_fecha'] as String?,
      pmValor: (json['pm_valor'] != null) ? (json['pm_valor'] as num).toDouble() : null,
      pnRenta: json['pn_renta'] as int?,
      pnMoneda: json['pn_moneda'] as int?,
      pvContacto: json['pv_contacto'] as String?,
      pnRechazado: json['pn_rechazado'] as int?,
      pnAutorizado: json['pn_autorizado'] as int?,
      pnRentaTipo: json['pn_renta_tipo'] as int?,
      pnVisualizar: json['pn_visualizar'] as int?,
      plFotografias: fotos,
      pvDetalleRenta: json['pv_detalle_renta'] as String?,
      pvMonedaSimbolo: json['pv_moneda_simbolo'] as String?,
      pvMonedaDescripcion: json['pv_moneda_descripcion'] as String?,
      pvRentaTipoDescripcion: json['pv_renta_tipo_descripcion'] as String?,
      pvRechazadoObservaciones: json['pv_rechazado_observaciones'] as String?,
      pnPermiteAutorizarRechazar: json['pn_permite_autorizar_rechazar'] as int?,
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
