class DatosImportantes {
  final int pnDatoImportante;
  final String pvDescripcion;
  final int pnTipoContacto;
  final String pvTipoContactoDescripcion;
  final int pnFormaContacto;
  final String pvContactoDescripcion;
  final String pvDetalle;

  DatosImportantes({
    required this.pnDatoImportante,
    required this.pvDescripcion,
    required this.pnTipoContacto,
    required this.pvTipoContactoDescripcion,
    required this.pnFormaContacto,
    required this.pvContactoDescripcion,
    required this.pvDetalle,
  });

  factory DatosImportantes.fromJson(Map<String, dynamic> json) => DatosImportantes(
    pnDatoImportante: json['pn_dato_importante'],
    pvDescripcion: json['pv_descripcion'],
    pnTipoContacto: json['pn_tipo_contacto'],
    pvTipoContactoDescripcion: json['pv_tipo_contacto_descripcion'],
    pnFormaContacto: json['pn_forma_contacto'],
    pvContactoDescripcion: json['pv_contacto_descripcion'],
    pvDetalle: json['pv_detalle'],
  );

  Map<String, dynamic> toJson() => {
    'pn_dato_importante': pnDatoImportante,
    'pv_descripcion': pvDescripcion,
    'pn_tipo_contacto': pnTipoContacto,
    'pv_tipo_contacto_descripcion': pvTipoContactoDescripcion,
    'pn_forma_contacto': pnFormaContacto,
    'pv_contacto_descripcion': pvContactoDescripcion,
    'pv_detalle': pvDetalle,
  };
}
