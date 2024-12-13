class Usuario {
  int? id; // Opcional, será gerado automaticamente pelo banco de dados
  String nome;
  String telefone;
  String email;

  // Construtor
  Usuario({
    this.id,
    required this.nome,
    required this.telefone,
    required this.email,
  });

  // Converte um objeto Usuario em um Map (necessário para salvar no banco de dados)
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'nome': nome,
      'telefone': telefone,
      'email': email,
    };
    if (id != null) {
      map['id'] = id; // Adiciona 'id' ao Map se ele existir
    }
    return map;
  }

  // Cria um objeto Usuario a partir de um Map (necessário ao buscar do banco)
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      telefone: map['telefone'],
      email: map['email'],
    );
  }
}
