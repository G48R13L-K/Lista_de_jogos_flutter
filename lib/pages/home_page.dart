import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:lista_de_jogos/models/jogos_model.dart';
import 'package:lista_de_jogos/pages/jogo_form_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Jogos> jogos = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getJogos();
  }

  Future<void> _getJogos() async {
    setState(() {
      isLoading = true;
    });

    var dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: 30),
        baseUrl: 'https://6912666252a60f10c8218ad9.mockapi.io/api/v1',
      ),
    );
    var response = await dio.get('/lista_jogos');
    var listaData = response.data as List;
    for (var data in listaData) {
      var jogo = Jogos(
        nJogo: data['nome'],
        nEmpresa: data['empresa'],
        anoJogo: data['ano'],
      );
      jogos.add(jogo);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Row(children: [Text(widget.title), SizedBox(width: 8)]),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: jogos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.videogame_asset_outlined),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jogo: ${jogos[index].nJogo}'),
                      Text('Empresa: ${jogos[index].nEmpresa}'),
                      Text('Ano de Lançamento: ${jogos[index].anoJogo}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Deletar Jogo'),
                          content: const Text(
                            'Tem certeza que deseja deletar este jogo?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _deleteJogo(index);
                              },
                              child: const Text('Deletar'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarJogo,
        tooltip: 'Adicionar jogo',
        child: Icon(Icons.add_box_outlined),
      ),
    );
  }

  void _adicionarJogo() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) {
              return JogoFormPage();
            },
          ),
        )
        .then((_) {
          jogos.clear();
          _getJogos();
        });
  }

  void _deleteJogo(int index) {
    setState(() {
      jogos.removeAt(index);
    });
  }
}
