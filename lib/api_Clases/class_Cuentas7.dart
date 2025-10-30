class CuentasH7 {
  final String pvCliente;
  final int plDocumento;
  final int pnDetalle;
  final String pfFecha;
  final String pvTransaccion;
  final String pvDescripcionMovimiento;
  final int pnMoneda;
  final String pvMonedaDescripcion;
  final String pvMonedaAbreviatura;
  final double pmSaldoInicial;
  final double pmDebito;
  final double pmCredito;
  final double pmSaldoActual;
  final int pnPositivo;
  final double pmSaldoAFavor;
  final int pnPermiteVerComprobante;
  final String pvVerComprobante;
  final String pvEstadoCuentaUrl;
  final int pnDiasMora;
  final String pvComprobantePagob64;
  final String pvPagoEnLineaUrl;

  CuentasH7({
    required this.pvCliente,
    required this.plDocumento,
    required this.pnDetalle,
    required this.pfFecha,
    required this.pvTransaccion,
    required this.pvDescripcionMovimiento,
    required this.pnMoneda,
    required this.pvMonedaDescripcion,
    required this.pvMonedaAbreviatura,
    required this.pmSaldoInicial,
    required this.pmDebito,
    required this.pmCredito,
    required this.pmSaldoActual,
    required this.pnPositivo,
    required this.pmSaldoAFavor,
    required this.pnPermiteVerComprobante,
    required this.pvVerComprobante,
    required this.pvEstadoCuentaUrl,
    required this.pnDiasMora,
    required this.pvComprobantePagob64,
    required this.pvPagoEnLineaUrl,
  });

  factory CuentasH7.fromJson(Map<String, dynamic> json) {
    return CuentasH7(
      pvCliente: json['pv_cliente'] ?? '',
      plDocumento: json['pl_documento'] ?? 0,
      pnDetalle: json['pn_detalle'] ?? 0,
      pfFecha: json['pf_fecha'] ?? '',
      pvTransaccion: json['pv_transaccion'] ?? '',
      pvDescripcionMovimiento: json['pv_descripcion_movimiento'] ?? '',
      pnMoneda: json['pn_moneda'] ?? 0,
      pvMonedaDescripcion: json['pv_moneda_descripcion'] ?? '',
      pvMonedaAbreviatura: json['pv_moneda_abreviatura'] ?? '',
      pmSaldoInicial: (json['pm_saldo_inicial'] ?? 0).toDouble(),
      pmDebito: (json['pm_debito'] ?? 0).toDouble(),
      pmCredito: (json['pm_credito'] ?? 0).toDouble(),
      pmSaldoActual: (json['pm_saldo_actual'] ?? 0).toDouble(),
      pnPositivo: json['pn_positivo'] ?? 0,
      pmSaldoAFavor: (json['pm_saldo_a_favor'] ?? 0).toDouble(),
      pnPermiteVerComprobante: json['pn_permite_ver_comprobante'] ?? 0,
      pvVerComprobante: json['pv_ver_comprobante'] ?? '',
      pvEstadoCuentaUrl: json['pv_estado_cuenta_url'] ?? '',
      pnDiasMora: json['pn_dias_mora'] ?? 0,
      pvComprobantePagob64: json['pv_comprobante_pagob64'] ?? '',
      pvPagoEnLineaUrl: json['pv_pago_en_linea_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pv_cliente': pvCliente,
      'pl_documento': plDocumento,
      'pn_detalle': pnDetalle,
      'pf_fecha': pfFecha,
      'pv_transaccion': pvTransaccion,
      'pv_descripcion_movimiento': pvDescripcionMovimiento,
      'pn_moneda': pnMoneda,
      'pv_moneda_descripcion': pvMonedaDescripcion,
      'pv_moneda_abreviatura': pvMonedaAbreviatura,
      'pm_saldo_inicial': pmSaldoInicial,
      'pm_debito': pmDebito,
      'pm_credito': pmCredito,
      'pm_saldo_actual': pmSaldoActual,
      'pn_positivo': pnPositivo,
      'pm_saldo_a_favor': pmSaldoAFavor,
      'pn_permite_ver_comprobante': pnPermiteVerComprobante,
      'pv_ver_comprobante': pvVerComprobante,
      'pv_estado_cuenta_url': pvEstadoCuentaUrl,
      'pn_dias_mora': pnDiasMora,
      'pv_comprobante_pagob64': pvComprobantePagob64,
      'pv_pago_en_linea_url': pvPagoEnLineaUrl,
    };
  }
}