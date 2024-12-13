import 'package:flutter/material.dart';
import '../models/usuario.dart'; // Substitua pelo caminho correto para o modelo 'Usuario'
import '../database/database_helper.dart'; // Substitua pelo caminho correto para o helper do banco de dados

class UserDetailScreen extends StatefulWidget {
  final Usuario usuario;

  UserDetailScreen({required this.usuario});

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _telefoneController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.usuario.nome);
    _emailController = TextEditingController(text: widget.usuario.email);
    _telefoneController = TextEditingController(text: widget.usuario.telefone);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final updatedUser = Usuario(
                      id: widget.usuario.id,
                      nome: _nomeController.text,
                      email: _emailController.text,
                      telefone: _telefoneController.text,
                    );

                    await DatabaseHelper.instance.updateUsuario(updatedUser);

                    Navigator.pop(context, true); // Retorna true ao salvar
                  }
                },
                child: Text('Salvar alterações'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  if (widget.usuario.id != null) {
                    await DatabaseHelper.instance
                        .deleteUsuario(widget.usuario.id!);
                    Navigator.pop(context, true); // Retorna true ao excluir
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Erro: ID do usuário não pode ser nulo')),
                    );
                  }
                },
                child: Text('Deletar Usuário'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
