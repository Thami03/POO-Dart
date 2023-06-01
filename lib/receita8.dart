import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

enum TableStatus { idle, loading, ready, error }

class DataService {
  final ValueNotifier<Map<String, dynamic>> tableStateNotifier =
      ValueNotifier({'status': TableStatus.idle, 'dataObjects': []});

  void carregar(index) {
    final funcoes = [
      carregarCafes,
      carregarCervejas,
      carregarNacoes,
      carregarbanks
    ];
    tableStateNotifier.value = {
      'status': TableStatus.loading,
      'dataObjects': []
    };
    funcoes[index]();
  }

  void carregarCafes() {
    return;
  }

  void carregarNacoes() {
    return;
  }

//

  ///

  void carregarbanks() async {
    var nacoesUri = Uri(
        scheme: 'http',
        host: 'random-data-api.com',
        path: 'api/bank/random_bank',
        queryParameters: {'size': '5'});

    var jsonString = await http.read(nacoesUri);
    var nacoesJson = jsonDecode(jsonString);
    tableStateNotifier.value = {
      'status': TableStatus.ready,
      'dataObjects': nacoesJson,
      'propertyNames': ["bank_name", "iban", "account_number"],
      'columnNames': ["Nome do banco", "Iban", "Número da conta"]
    };
  }

  void carregarCervejas() {
    var beersUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/beer/random_beer',
        queryParameters: {'size': '5'});

    http.read(beersUri).then((jsonString) {
      var beersJson = jsonDecode(jsonString);
      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': beersJson,
        'columnNames': ["Nome", "Estilo", "IBU"],
        'propertyNames': ["name", "style", "ibu"]
      };
    }).catchError((error) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': [],
        'columnNames': [],
      };
    });

    void carregarCafes() async {
      var coffeesUri = Uri(
          scheme: 'https',
          host: 'random-data-api.com',
          path: 'api/coffee/random_coffee',
          queryParameters: {'size': '5'});

      http.read(coffeesUri).then((jsonString) {
        var coffeesJson = jsonDecode(jsonString);
        tableStateNotifier.value = {
          'status': TableStatus.ready,
          'dataObjects': coffeesJson,
          'propertyNames': ["blend_name", "origin", "variety"],
          'columnNames': ["Nome", "Origem", "Tipo"]
        };
      }).catchError((error) {
        tableStateNotifier.value = {
          'status': TableStatus.error,
          'dataObjects': [],
          'columnNames': [],
        };
      });
    }

    void carregarNacoes() async {
      var nacoesUri = Uri(
          scheme: 'http',
          host: 'random-data-api.com',
          path: 'api/nation/random_nation',
          queryParameters: {'size': '5'});

      var jsonString = await http.read(nacoesUri);
      var nacoesJson = jsonDecode(jsonString);
      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': nacoesJson,
        'propertyNames': ["nationality", "capital", "national_sport"],
        'columnNames': ["Nacionalidade", "Capital", "Esporte Nacional"]
      };
    }
  }
}

final dataService = DataService();

void main() {
  MyApp app = const MyApp();

  runApp(app);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Bem-vind@s"),
          ),
          body: ValueListenableBuilder(
              valueListenable: dataService.tableStateNotifier,
              builder: (_, value, __) {
                switch (value['status']) {
                  case TableStatus.idle:
                    return Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image:
                                  'https://www.wallpaperflare.com/static/855/449/67/star-trek-movies-star-trek-wallpaper.jpg',
                              width: 500,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Aperte algum botão",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            )
                          ]),
                    );
                  case TableStatus.loading:
                    return const Center(child: CircularProgressIndicator());

                  case TableStatus.ready:
                    return DataTableWidget(
                        jsonObjects: value['dataObjects'],
                        columnNames: value['columnNames'],
                        propertyNames: value['propertyNames']);

                  case TableStatus.error:
                    return const Text("Sem conexão com internet");
                }

                return const Text("...");
              }),
          bottomNavigationBar:
              NewNavBar(itemSelectedCallback: dataService.carregar),
        ));
  }
}

class NewNavBar extends HookWidget {
  // ignore: prefer_typing_uninitialized_variables
  final _itemSelectedCallback;

  NewNavBar({super.key, itemSelectedCallback})
      : _itemSelectedCallback = itemSelectedCallback ?? (int) {}

  @override
  Widget build(BuildContext context) {
    var state = useState(1);
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          state.value = index;
          _itemSelectedCallback(index);
        },
        currentIndex: state.value,
        items: const [
          BottomNavigationBarItem(
            label: "Cafés",
            icon: Icon(Icons.coffee_outlined),
          ),
          BottomNavigationBarItem(
              label: "Cervejas", icon: Icon(Icons.local_drink_outlined)),
          BottomNavigationBarItem(
              label: "Nações", icon: Icon(Icons.flag_outlined)),
          BottomNavigationBarItem(label: "Bancos", icon: Icon(Icons.money))
        ]);
  }
}

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;
  final List<String> columnNames;
  final List<String> propertyNames;

  const DataTableWidget({
    super.key,
    this.jsonObjects = const [],
    this.columnNames = const [],
    this.propertyNames = const [],
  });

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      DataTable(
          columns: columnNames
              .map((name) => DataColumn(
                      label: Expanded(
                          child: Text(
                    name,
                  ))))
              .toList(),
          rows: jsonObjects
              .map((obj) => DataRow(
                  cells: propertyNames
                      .map((propName) => DataCell(Text(obj[propName] ?? "")))
                      .toList()))
              .toList())
    ]);
  }
}
