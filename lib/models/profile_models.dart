class Profiles {
  final int id;
  final String nombre;
  final String apellido;
  final String email;
  final String rol;
  final String telefono;
  final String documento;


  Profiles({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.rol,
    required this.telefono,
    required this.documento,
  });

  factory Profiles.fromJson(Map<String, dynamic> json) {
    return Profiles(
      id: json['id'] ?? "Sin uid",
      nombre: json['name'] ?? "Sin nombre",
      apellido: json['surname'] ?? "Sin apellido",
      email: json['email'] ?? "Sin correo electronico",
      rol: json['usertype'] ?? "Sin rol",
      telefono: json['phone'] ?? "Sin telefono",
      documento: json['cedula'] ?? "Sin documento",

    );
  }
}
