class Usuario {
  int? id;
  String nome;
  String telefone;
  String email;

  Usuario({
    this.id,
    required this.nome,
    required this.telefone,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'nome': nome,
      'telefone': telefone,
      'email': email,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      telefone: map['telefone'],
      email: map['email'],
    );
  }
}
