import 'package:flutter/material.dart';

import 'package:lista_de_jogos/models/jogos_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Jogos> jogos = [];

  late TextEditingController jogoController;
  late TextEditingController empresaController;
  late TextEditingController anoController;

  @override
  void initState() {
    jogoController = TextEditingController();
    empresaController = TextEditingController();
    anoController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    jogoController.dispose();
    empresaController.dispose();
    anoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          // Input de texto para adicionar nome do jogo
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: jogoController,
              decoration: InputDecoration(
                icon: Icon(Icons.videogame_asset),
                border: OutlineInputBorder(),
                labelText: "Adicionar nome do jogo",
              ),
            ),
          ),
          // Input de texto para adicionar empresa do jogo
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: empresaController,
              decoration: InputDecoration(
                icon: Icon(Icons.business),
                border: OutlineInputBorder(),
                labelText: "Adicionar empresa do jogo",
              ),
            ),
          ),
          // Input para adicionar o ano do jogo
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: anoController,
              readOnly: true,
              onTap: () async {
                showDatePicker(
                  initialDatePickerMode: DatePickerMode.year,
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1970),
                  lastDate: DateTime.now(),
                ).then((pickedDate) {
                  if (pickedDate != null) {
                    String formattedDate = pickedDate.year.toString();
                    setState(() {
                      anoController.text = formattedDate;
                    });
                  }
                });
              },
              decoration: InputDecoration(
                icon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
                labelText: "Adicionar ano do jogo",
              ),
            ),
          ),
          // Lista de jogos adicionados
          Expanded(
            child: ListView.builder(
              itemCount: jogos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.sports_esports),
                  title: Text(jogos[index].nJogo),
                  subtitle: Text(jogos[index].nEmpresa),
                  trailing: Text(jogos[index].anoJogo.toString()),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarJogo,
        tooltip: 'Adicionar Jogo',
        child: Icon(Icons.add),
      ),
    );
  }

  void _adicionarJogo() {
    var nomeJogo = jogoController.text;
    var nomeEmpresa = empresaController.text;
    var anoJogo = anoController.text;

    if (nomeJogo.isEmpty || nomeEmpresa.isEmpty || anoJogo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor, preencha todos os campos antes de adicionar.',
          ),
        ),
      );
      return;
    }

    setState(() {
      var adicionarJogo = Jogos(
        nJogo: nomeJogo,
        nEmpresa: nomeEmpresa,
        anoJogo: int.parse(anoJogo),
      );
      jogos.add(adicionarJogo);
      jogoController.clear();
      empresaController.clear();
      anoController.clear();
    });
  }
}
