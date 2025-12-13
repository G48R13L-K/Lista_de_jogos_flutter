import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:lista_de_jogos/models/jogos_model.dart';

class JogoEditPage extends StatefulWidget {
  final Jogos jogo;

  const JogoEditPage({super.key, required this.jogo});

  @override
  State<JogoEditPage> createState() => _JogoEditPageState();
}

class _JogoEditPageState extends State<JogoEditPage> {
  late TextEditingController _nomeController;
  late TextEditingController _empresaController;
  late TextEditingController _anoController;
  late TextEditingController _plataformaController;
  late TextEditingController _notaController;
  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.jogo.nJogo);
    _empresaController = TextEditingController(text: widget.jogo.nEmpresa);
    _plataformaController = TextEditingController(
      text: widget.jogo.nPlataforma,
    );
    _notaController = TextEditingController(
      text: widget.jogo.notaJogo.toString(),
    );
    _anoController = TextEditingController(
      text: widget.jogo.anoJogo.toString(),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _empresaController.dispose();
    _anoController.dispose();
    _plataformaController.dispose();
    _notaController.dispose();
    super.dispose();
  }

  Future<void> _salvarEdicao() async {
    final updatedJogo = Jogos(
      id: widget.jogo.id,
      nJogo: _nomeController.text,
      nEmpresa: _empresaController.text,
      nPlataforma: _plataformaController.text,
      notaJogo: _notaController.text,
      anoJogo: _anoController.text,
    );

    try {
      var dio = Dio(
        BaseOptions(
          connectTimeout: Duration(seconds: 30),
          baseUrl: 'https://6912666252a60f10c8218ad9.mockapi.io/api/v1',
        ),
      );
      await dio.put(
        '/lista_jogos/${widget.jogo.id}',
        data: {
          'nome': updatedJogo.nJogo,
          'empresa': updatedJogo.nEmpresa,
          'ano': updatedJogo.anoJogo,
          'plataforma': updatedJogo.nPlataforma,
          'nota': updatedJogo.notaJogo,
        },
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar edição: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Jogo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome do Jogo',
                  icon: Icon(Icons.videogame_asset),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _empresaController,
                decoration: InputDecoration(
                  labelText: 'Empresa',
                  icon: Icon(Icons.business),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _plataformaController,
                decoration: InputDecoration(
                  labelText: 'Plataforma Jogada',
                  icon: Icon(Icons.personal_video_rounded),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _notaController,
                decoration: InputDecoration(
                  labelText: 'Nota do Jogador',
                  icon: Icon(Icons.swap_vert_outlined),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _anoController,
                decoration: InputDecoration(
                  labelText: 'Ano de Lançamento',
                  filled: true,
                  icon: Icon(Icons.calendar_today),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                readOnly: true,
                onTap: _selectData,
              ),
            ),

            ElevatedButton.icon(
              onPressed: () => _salvarEdicao(),
              label: Text('Salvar'),
              icon: Icon(Icons.save_outlined),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectData() async {
    DateTime? ano = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (ano != null) {
      setState(() {
        _anoController.text = ano.year.toString();
      });
    }
  }
}
