class CuentasH7 {
  final int pnDetalle;
  final String pfFecha;
  final String pvTransaccion;
  final String pvDescripcionMovimiento;
  final int pnMoneda;
  final String pvMonedaDescripcion;
  final String pvMonedaAbreviatura;
  final double pmDebito;
  final double pmCredito;
  final double pmSaldoActual;
  late final int pnPermiteVerComprobante;
  final String pvVerComprobante;
  final String pvEstadoCuentaUrl;

  CuentasH7({
    required this.pnDetalle,
    required this.pfFecha,
    required this.pvTransaccion,
    required this.pvDescripcionMovimiento,
    required this.pnMoneda,
    required this.pvMonedaDescripcion,
    required this.pvMonedaAbreviatura,
    required this.pmDebito,
    required this.pmCredito,
    required this.pmSaldoActual,
    required this.pnPermiteVerComprobante,
    required this.pvVerComprobante,
    required this.pvEstadoCuentaUrl,
  });

  factory CuentasH7.fromJson(Map<String, dynamic> json) {
    return CuentasH7(
      pnDetalle: json['pn_detalle'] ?? 0,
      pfFecha: json['pf_fecha'] ?? '',
      pvTransaccion: json['pv_transaccion'] ?? '',
      pvDescripcionMovimiento: json['pv_descripcion_movimiento'] ?? '',
      pnMoneda: json['pn_moneda'] ?? 0,
      pvMonedaDescripcion: json['pv_moneda_descripcion'] ?? '',
      pvMonedaAbreviatura: json['pv_moneda_abreviatura'] ?? '',
      pmDebito: (json['pm_debito'] ?? 0).toDouble(),
      pmCredito: (json['pm_credito'] ?? 0).toDouble(),
      pmSaldoActual: (json['pm_saldo_actual'] ?? 0).toDouble(),
      pnPermiteVerComprobante: json['pn_permite_ver_comprobante'] ?? 0,
      pvVerComprobante: json['pv_ver_comprobante'] ?? '',
      pvEstadoCuentaUrl: json['pv_estado_cuenta_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pn_detalle': pnDetalle,
      'pf_fecha': pfFecha,
      'pv_transaccion': pvTransaccion,
      'pv_descripcion_movimiento': pvDescripcionMovimiento,
      'pn_moneda': pnMoneda,
      'pv_moneda_descripcion': pvMonedaDescripcion,
      'pv_moneda_abreviatura': pvMonedaAbreviatura,
      'pm_debito': pmDebito,
      'pm_credito': pmCredito,
      'pm_saldo_actual': pmSaldoActual,
      'pn_permite_ver_comprobante': pnPermiteVerComprobante,
      'pv_ver_comprobante': pvVerComprobante,
      'pv_estado_cuenta_url': pvEstadoCuentaUrl,
    };
  }
}
