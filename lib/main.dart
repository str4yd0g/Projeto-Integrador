import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'models/usuario.dart';
import 'screens/user_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teste do banco de dados',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Usuario> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _loadUsuarios();
  }

  Future<void> _loadUsuarios() async {
    List<Usuario> usuarios = await _dbHelper.fetchUsuarios();
    setState(() {
      _usuarios = usuarios;
    });
  }

  void _navigateToAddUser() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddUserScreen()),
    );
    _loadUsuarios(); // Atualiza a lista após retornar
  }

  void _fetchUsuarios() async {
    try {
      final usuarios = await DatabaseHelper.instance.getUsuarios();

      // Certifique-se de que 'usuarios' não seja nulo
      if (usuarios != null) {
        setState(() {
          _usuarios = usuarios;
        });
      } else {
        setState(() {
          _usuarios = []; // Define como lista vazia se não houver dados
        });
      }
    } catch (e) {
      print('Erro ao buscar usuários: $e');
      // Exibe uma mensagem de erro se algo der errado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar usuários')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Usuários')),
      body: _usuarios.isEmpty
          ? const Center(child: Text('Nenhum usuário cadastrado.'))
          : ListView.builder(
              itemCount: _usuarios.length,
              itemBuilder: (context, index) {
                final usuario = _usuarios[index];
                return ListTile(
                  title: Text(usuario.nome),
                  subtitle: Text(usuario.email),
                  onTap: () async {
                    // Ao clicar no nome do usuário, abre a tela de detalhes
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserDetailScreen(usuario: usuario),
                      ),
                    );
                    // Se o resultado for verdadeiro (usuário editado ou excluído), atualiza a lista
                    if (result == true) {
                      _fetchUsuarios(); // Atualiza a lista após edições ou exclusões
                    }
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddUser,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value!.isEmpty ? 'Insira um nome válido' : null,
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                validator: (value) =>
                    value!.isEmpty ? 'Insira um telefone válido' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Insira um email válido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _dbHelper.insertUsuario(Usuario(
                      nome: _nomeController.text,
                      telefone: _telefoneController.text,
                      email: _emailController.text,
                    ));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
