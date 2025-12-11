import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_jogos/models/jogos_model.dart';

class JogoFormPage extends StatefulWidget {
  final Jogos? jogo;

  const JogoFormPage({super.key, this.jogo});

  @override
  State<JogoFormPage> createState() => _JogoFormPageState();
}

class _JogoFormPageState extends State<JogoFormPage> {
  late TextEditingController controllerNome;
  late TextEditingController controllerEmpresa;
  late TextEditingController controllerAno;
  late TextEditingController controllerPlataforma;
  late TextEditingController controllerNota;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isSaving = false; // Para desabilitar o botão durante salvamento

  @override
  void initState() {
    controllerNome = TextEditingController();
    controllerEmpresa = TextEditingController();
    controllerAno = TextEditingController();
    controllerPlataforma = TextEditingController();
    controllerNota = TextEditingController();
    super.initState();

    if (mounted && widget.jogo != null) {
      var jogo = widget.jogo!;
      controllerNome.text = jogo.nJogo;
      controllerEmpresa.text = jogo.nEmpresa;
      controllerPlataforma.text = jogo.nPlataforma;
      controllerNota.text = jogo.notaJogo.toString();
      controllerAno.text = jogo.anoJogo
          .toString(); // Converta para string para o controller
    }
  }

  @override
  void dispose() {
    controllerNome.dispose();
    controllerEmpresa.dispose();
    controllerPlataforma.dispose();
    controllerAno.dispose();
    controllerNota.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastrar jogo")),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerNome,
                decoration: InputDecoration(
                  labelText: "Digite o nome do jogo:",
                  icon: Icon(Icons.videogame_asset),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                validator: (value) => _validateNome(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerEmpresa,
                decoration: InputDecoration(
                  labelText: "Digite o nome da empresa:",
                  icon: Icon(Icons.business),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                validator: (value) => _validateEmpresa(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerPlataforma,
                decoration: InputDecoration(
                  labelText: "Digite o nome da plataforma utilizada:",
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
                controller: controllerNota,
                decoration: InputDecoration(
                  labelText: 'Digite a sua nota para o jogo:',
                  icon: Icon(Icons.swap_vert_outlined),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerAno,
                decoration: InputDecoration(
                  labelText: 'Ano de Lançamento',
                  filled: true,
                  icon: Icon(Icons.calendar_today),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                validator: (value) => _validateAno(),
                readOnly: true,
                onTap: _selectData,
              ),
            ),

            ElevatedButton.icon(
              onPressed: isSaving ? null : () => _salvarJogo(context),
              label: Text(isSaving ? "Salvando..." : "Salvar jogo"),
              icon: Icon(Icons.save_outlined),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateNome() {
    var nomeJogo = controllerNome.text;
    if (nomeJogo.trim().isEmpty) {
      return "Você precisa digitar um nome!";
    }
    return null;
  }

  String? _validateEmpresa() {
    var empresaNome = controllerEmpresa.text;
    if (empresaNome.trim().isEmpty) {
      return "Você precisa digitar o nome da empresa!";
    }
    return null;
  }

  String? _validateAno() {
    var anoJogo = controllerAno.text;
    if (anoJogo.trim().isEmpty) {
      return "Você precisa informar um ano!";
    }

    if (int.tryParse(anoJogo) == null) {
      return "Ano deve ser um número válido!";
    }
    return null;
  }

  Future<void> _salvarJogo(BuildContext ctx) async {
    var nomeJogo = controllerNome.text;
    var empresaNome = controllerEmpresa.text;
    var plataformaJogo = controllerPlataforma.text;
    var notaParaJogo = int.tryParse(controllerNota.text) ?? 0;
    var anoJogo = int.tryParse(controllerAno.text) ?? 0; // Converta para int

    if (formKey.currentState?.validate() == true) {
      setState(() {
        isSaving = true;
      });

      try {
        var dio = Dio(
          BaseOptions(
            connectTimeout: Duration(seconds: 30),
            baseUrl: 'https://6912666252a60f10c8218ad9.mockapi.io/api/v1',
          ),
        );

        Response response;
        if (widget.jogo == null) {
          // Adicionar novo jogo (POST)
          response = await dio.post(
            "/lista_jogos",
            data: {
              'nome': nomeJogo,
              'empresa': empresaNome,
              'ano': anoJogo,
              'plataforma': plataformaJogo,
              'nota': notaParaJogo,
            },
          );
        } else {
          // Editar jogo existente (PUT)
          response = await dio.put(
            "/lista_jogos/${widget.jogo!.id}",
            data: {
              'nome': nomeJogo,
              'empresa': empresaNome,
              'ano': anoJogo,
              'plataforma': plataformaJogo,
              'nota': notaParaJogo,
            },
          );
        }

        if (ctx.mounted) {
          if (response.statusCode == 200 || response.statusCode == 201) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(
                  widget.jogo == null
                      ? 'Jogo adicionado com sucesso!'
                      : 'Jogo editado com sucesso!',
                ),
              ),
            );
            Navigator.pop(ctx); // Volte para a lista
          } else {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(
                  'Erro: ${response.statusMessage ?? "Erro desconhecido"}',
                ),
              ),
            );
          }
        }
      } catch (e) {
        if (ctx.mounted) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text('Erro ao salvar jogo: $e')));
        }
      } finally {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Future<void> _selectData() async {
    DateTime? _ano = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (_ano != null) {
      setState(() {
        controllerAno.text = _ano.year.toString();
      });
    }
  }
}
