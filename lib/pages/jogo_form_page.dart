import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class JogoFormPage extends StatefulWidget {
  const JogoFormPage({super.key});

  @override
  State<JogoFormPage> createState() => _JogoFormPageState();
}

class _JogoFormPageState extends State<JogoFormPage> {
  late TextEditingController controllerNome;
  late TextEditingController controllerEmpresa;
  late TextEditingController controllerAno;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    controllerNome = TextEditingController();
    controllerEmpresa = TextEditingController();
    controllerAno = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controllerNome.dispose();
    controllerEmpresa.dispose();
    controllerAno.dispose();
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
                  border: OutlineInputBorder(),
                  labelText: "Digite o nome do jogo:",
                ),
                validator: (value) => _validateNome(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerEmpresa,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Digite o nome da empresa:",
                ),
                validator: (value) => _validateEmpresa(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerAno,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Digite o ano:",
                ),
                validator: (value) => _validateAno(),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _salvarJogo(context),
              label: Text("Salvar jogo"),
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
    return null;
  }

  Future<void> _salvarJogo(BuildContext ctx) async {
    var nomeJogo = controllerNome.text;
    var empresaNome = controllerEmpresa.text;
    var anoJogo = controllerAno.text;

    if (formKey.currentState?.validate() == true) {
      var dio = Dio(
        BaseOptions(
          connectTimeout: Duration(seconds: 30),
          baseUrl: 'https://6912666252a60f10c8218ad9.mockapi.io/api/v1',
        ),
      );
      var response = await dio.post(
        "/lista_jogos",
        data: {'nome': nomeJogo, 'empresa': empresaNome, 'ano': anoJogo},
      );

      if (ctx.mounted) {
        if (response.statusCode == 200) {
          Navigator.pop(ctx);
        } else {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text(response.statusMessage ?? "")));
        }
      }
    }
  }
}
