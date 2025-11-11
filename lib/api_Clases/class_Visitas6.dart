import 'dart:convert';

class VisitaM6 {
  final String? pfFecha;
  final int? pnVisita;
  final String? pvCodigo;
  final String? pvCliente;
  final int? pvRecibida;
  final String? pvPropiedad;
  final String? pfHoraLlegada;
  final String? pvObservaciones;
  final String? pvVisitaMotivo;
  final String? pvVisitaNombre;
  final String? pvClienteNombre;
  final int? pnPermiteRecibir;
  final String? pvVisitaTelefono;
  final String? pvPropiedadNombre;
  final int? pnVisitaEntradaTipo;
  final String? pvVisitaVehiculoPlaca;
  final String? pvRecibidaObservaciones;
  final String? pvVisitaNoIdentificacion;
  final String? pvVisitaEntradaTipoDescripcion;

  VisitaM6({
    this.pfFecha,
    this.pnVisita,
    this.pvCodigo,
    this.pvCliente,
    this.pvRecibida,
    this.pvPropiedad,
    this.pfHoraLlegada,
    this.pvObservaciones,
    this.pvVisitaMotivo,
    this.pvVisitaNombre,
    this.pvClienteNombre,
    this.pnPermiteRecibir,
    this.pvVisitaTelefono,
    this.pvPropiedadNombre,
    this.pnVisitaEntradaTipo,
    this.pvVisitaVehiculoPlaca,
    this.pvRecibidaObservaciones,
    this.pvVisitaNoIdentificacion,
    this.pvVisitaEntradaTipoDescripcion,
  });

  factory VisitaM6.fromJson(Map<String, dynamic> json) => VisitaM6(
    pfFecha: json["pf_fecha"] as String?,
    pnVisita: json["pn_visita"] as int?,
    pvCodigo: json["pv_codigo"] as String?,
    pvCliente: json["pv_cliente"] as String?,
    pvRecibida: json["pv_recibida"] as int?,
    pvPropiedad: json["pv_propiedad"] as String?,
    pfHoraLlegada: json["pf_hora_llegada"] as String?,
    pvObservaciones: json["pv_observaciones"] as String?,
    pvVisitaMotivo: json["pv_visita_motivo"] as String?,
    pvVisitaNombre: json["pv_visita_nombre"] as String?,
    pvClienteNombre: json["pv_cliente_nombre"] as String?,
    pnPermiteRecibir: json["pn_permite_recibir"] as int?,
    pvVisitaTelefono: json["pv_visita_telefono"] as String?,
    pvPropiedadNombre: json["pv_propiedad_nombre"] as String?,
    pnVisitaEntradaTipo: json["pn_visita_entrada_tipo"] as int?,
    pvVisitaVehiculoPlaca: json["pv_visita_vehiculo_placa"] as String?,
    pvRecibidaObservaciones:
    json["pv_recibida_observaciones"] as String?,
    pvVisitaNoIdentificacion:
    json["pv_visita_no_identificacion"] as String?,
    pvVisitaEntradaTipoDescripcion:
    json["pv_visita_entrada_tipo_descripcion"] as String?,
  );

  Map<String, dynamic> toJson() => {
    "pf_fecha": pfFecha,
    "pn_visita": pnVisita,
    "pv_codigo": pvCodigo,
    "pv_cliente": pvCliente,
    "pv_recibida": pvRecibida,
    "pv_propiedad": pvPropiedad,
    "pf_hora_llegada": pfHoraLlegada,
    "pv_observaciones": pvObservaciones,
    "pv_visita_motivo": pvVisitaMotivo,
    "pv_visita_nombre": pvVisitaNombre,
    "pv_cliente_nombre": pvClienteNombre,
    "pn_permite_recibir": pnPermiteRecibir,
    "pv_visita_telefono": pvVisitaTelefono,
    "pv_propiedad_nombre": pvPropiedadNombre,
    "pn_visita_entrada_tipo": pnVisitaEntradaTipo,
    "pv_visita_vehiculo_placa": pvVisitaVehiculoPlaca,
    "pv_recibida_observaciones": pvRecibidaObservaciones,
    "pv_visita_no_identificacion": pvVisitaNoIdentificacion,
    "pv_visita_entrada_tipo_descripcion":
    pvVisitaEntradaTipoDescripcion,
  };

  static List<VisitaM6> listFromJson(String str) =>
      (json.decode(str)['VisitaM6'] as List)
          .map((e) => VisitaM6.fromJson(e))
          .toList();
}
