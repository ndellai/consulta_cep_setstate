import 'package:consulta_cep/cep_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta CEP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: "Consulta CEP"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CepModel? _cepModel;
  late TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _obterCep() async {
    String cep = _textController.text;

    var url = Uri.parse("https://viacep.com.br/ws/$cep/json/");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _cepModel = CepModel.fromJson(response.body);
      });
    } else if (kDebugMode) {
      print("Erro no request");
    }
  }

  void _limparCampos() {
    setState(() {
      _textController.clear();
      _cepModel = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text("Entre com o CEP:"),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _textController,
                    cursorColor: Colors.black,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                const Text(
                  "Logradouro:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_cepModel?.logradouro ?? ""),
                const Text(
                  "Complemento:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_cepModel?.complemento ?? ""),
                const Text(
                  "Bairro:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_cepModel?.bairro ?? ""),
                const Text(
                  "Localidade:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_cepModel?.localidade ?? ""),
                const Text(
                  "UF:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_cepModel?.uf ?? ""),
              ],
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async => _obterCep(),
              tooltip: 'Pesquisar o CEP',
              child: const Icon(Icons.search),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              backgroundColor: Colors.blueGrey,
              onPressed: () => _limparCampos(),
              tooltip: 'Pesquisar o CEP',
              child: const Icon(Icons.clear),
            ),
          ],
        ));
  }
}
