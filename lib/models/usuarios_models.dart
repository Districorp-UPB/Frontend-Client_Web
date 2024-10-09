class Usuarios {
  final String uid;
  final String nombre;
  final String apellido;
  final String email;
  final String rol;
  final String telefono;
  final String documento;


  Usuarios({
    required this.uid,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.rol,
    required this.telefono,
    required this.documento,
  });

  factory Usuarios.fromJson(Map<String, dynamic> json) {
    return Usuarios(
      uid: json['uid'] ?? "Sin uid",
      nombre: json['name'] ?? "Sin nombre",
      apellido: json['surname'] ?? "Sin apellido",
      email: json['email'] ?? "Sin correo electronico",
      rol: json['email'] ?? "Sin correo electronico",
      telefono: json['phone'] ?? "Sin telefono",
      documento: json['email'] ?? "Sin correo",

    );
  }
}
