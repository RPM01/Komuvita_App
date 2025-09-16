class DatosReservaF1 {
  final int pnAmenidad;
  final String pvAmenidadDescripcion;
  final String? pvAmenidadReglamentoUso;
  final String? pvTerminosCondiciones;
  final String pvIdentificador;
  final int pnMoneda;
  final String pvMonedaDescripcion;
  final String pvMonedaSimbolo;
  final double pmValor;
  final int pnCupo;
  final int pnPeriodoTiempo;
  final String pvPeriodoTiempoDescripcion;
  final int pnPeriodoTiempoValorMaximo;
  final int pnPeriodoTiempoRequiereHorario;
  final int pnDisponibleEnMora;
  final double pnMoraMontoMinimo;
  final int pnMoraDiasMinimo;
  final int pnBloqueada;
  final String pvBloqueoDescripcion;
  final int pnEnServicio;
  final String? pvNoEnServicioObservaciones;

  final List<Horario> plHorario;
  final List<Fotografia> plFotografias;
  final List<Reserva> plReservas;

  DatosReservaF1({
    required this.pnAmenidad,
    required this.pvAmenidadDescripcion,
    required this.pvAmenidadReglamentoUso,
    required this.pvTerminosCondiciones,
    required this.pvIdentificador,
    required this.pnMoneda,
    required this.pvMonedaDescripcion,
    required this.pvMonedaSimbolo,
    required this.pmValor,
    required this.pnCupo,
    required this.pnPeriodoTiempo,
    required this.pvPeriodoTiempoDescripcion,
    required this.pnPeriodoTiempoValorMaximo,
    required this.pnPeriodoTiempoRequiereHorario,
    required this.pnDisponibleEnMora,
    required this.pnMoraMontoMinimo,
    required this.pnMoraDiasMinimo,
    required this.pnBloqueada,
    required this.pvBloqueoDescripcion,
    required this.pnEnServicio,
    required this.pvNoEnServicioObservaciones,
    required this.plHorario,
    required this.plFotografias,
    required this.plReservas,
  });

  factory DatosReservaF1.fromJson(Map<String, dynamic> json) {
    return DatosReservaF1(
      pnAmenidad: json["pn_amenidad"] ?? 0,
      pvAmenidadDescripcion: json["pv_amenidad_descripcion"] ?? "",
      pvAmenidadReglamentoUso: json["pv_amenidad_reglamento_uso"],
      pvTerminosCondiciones: json["pv_terminos_condiciones"],
      pvIdentificador: json["pv_identificador"] ?? "",
      pnMoneda: json["pn_moneda"] ?? 0,
      pvMonedaDescripcion: json["pv_moneda_descripcion"] ?? "",
      pvMonedaSimbolo: json["pv_moneda_simbolo"] ?? "",
      pmValor: (json["pm_valor"] ?? 0).toDouble(),
      pnCupo: json["pn_cupo"] ?? 0,
      pnPeriodoTiempo: json["pn_periodo_tiempo"] ?? 0,
      pvPeriodoTiempoDescripcion: json["pv_periodo_tiempo_descripcion"] ?? "",
      pnPeriodoTiempoValorMaximo: json["pn_periodo_tiempo_valor_maximo"] ?? 0,
      pnPeriodoTiempoRequiereHorario:
      json["pn_periodo_tiempo_requiere_horario"] ?? 0,
      pnDisponibleEnMora: json["pn_disponible_en_mora"] ?? 0,
      pnMoraMontoMinimo: (json["pn_mora_monto_minimo"] ?? 0).toDouble(),
      pnMoraDiasMinimo: json["pn_mora_dias_minimo"] ?? 0,
      pnBloqueada: json["pn_bloqueada"] ?? 0,
      pvBloqueoDescripcion: json["pv_bloqueo_descripcion"] ?? "",
      pnEnServicio: json["pn_en_servicio"] ?? 0,
      pvNoEnServicioObservaciones: json["pv_no_en_servicio_observaciones"],
      plHorario: (json["pl_horario"] as List?)
          ?.map((e) => Horario.fromJson(e))
          .toList() ??
          [],
      plFotografias: (json["pl_fotografias"] as List?)
          ?.map((e) => Fotografia.fromJson(e))
          .toList() ??
          [],
      plReservas: (json["pl_reservas"] as List?)
          ?.map((e) => Reserva.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class Horario {
  final String pvDia;
  final String pvHorarioInicio;
  final String pvHorarioFin;
  final String pvHorarioInicioDescanso;
  final String pvHorarioFinDescanso;

  Horario({
    required this.pvDia,
    required this.pvHorarioInicio,
    required this.pvHorarioFin,
    required this.pvHorarioInicioDescanso,
    required this.pvHorarioFinDescanso,
  });

  factory Horario.fromJson(Map<String, dynamic> json) {
    return Horario(
      pvDia: json["pv_dia"] ?? "",
      pvHorarioInicio: json["pv_horario_inicio"] ?? "",
      pvHorarioFin: json["pv_horario_fin"] ?? "",
      pvHorarioInicioDescanso: json["pv_horario_inicio_descanso"] ?? "",
      pvHorarioFinDescanso: json["pv_horario_fin_descanso"] ?? "",
    );
  }
}

class Fotografia {
  final int pnFotografia;
  final String? pvFotografiaB64;

  Fotografia({
    required this.pnFotografia,
    required this.pvFotografiaB64,
  });

  factory Fotografia.fromJson(Map<String, dynamic> json) {
    return Fotografia(
      pnFotografia: json["pn_fotografia"] ?? 0,
      pvFotografiaB64: json["pv_fotografiab64"],
    );
  }
}

class Reserva {
  final int pnReserva;
  final String pfFecha;
  final String pfInicio;
  final String pfFin;
  final int peEstado;
  final String poObservaciones;
  final int pnCupoReservado;
  final String pvUsuarioNombre;
  final String pvEstadoDescripcion;
  final String pvPropiedadDescripcion;
  final int pnMostrarDetalleReserva;

  Reserva({
    required this.pnReserva,
    required this.pfFecha,
    required this.pfInicio,
    required this.pfFin,
    required this.peEstado,
    required this.poObservaciones,
    required this.pnCupoReservado,
    required this.pvUsuarioNombre,
    required this.pvEstadoDescripcion,
    required this.pvPropiedadDescripcion,
    required this.pnMostrarDetalleReserva,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      pnReserva: json["pn_reserva"] ?? 0,
      pfFecha: json["pf_fecha"] ?? "",
      pfInicio: json["pf_inicio"] ?? "",
      pfFin: json["pf_fin"] ?? "",
      peEstado: json["pe_estado"] ?? 0,
      poObservaciones: json["po_observaciones"] ?? "",
      pnCupoReservado: json["pn_cupo_reservado"] ?? 0,
      pvUsuarioNombre: json["pv_usuario_nombre"] ?? "",
      pvEstadoDescripcion: json["pv_estado_descripcion"] ?? "",
      pvPropiedadDescripcion: json["pv_propiedad_descripcion"] ?? "",
      pnMostrarDetalleReserva: json["pn_mostrar_detalle_reserva"] ?? 0,
    );
  }
}
