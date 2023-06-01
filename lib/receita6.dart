import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class DataService {
  final ValueNotifier<List> tableStateNotifier = ValueNotifier([]);

  void carregar(index) {
    final funcoes = [carregarCafes, carregarCervejas, carregarNacoes];
    funcoes[index]();
  }

  void carregarCafes() {
    tableStateNotifier.value = [
      {
        "name": "Café Espresso",
        "preparation": "Máquina de espresso",
        "Caffeine": "63 mg",
        "Flavor": "Encorpado e concentrado"
      },
      {
        "name": "Icatu",
        "preparation":
            "Infusão (filtro, espresso, cafeteira italiana, entre outros",
        "Caffeine": "De 80 a 100 mg",
        "Flavor": "Suave e adocicado"
      },
      {
        "name": "Café Descafeinado",
        "preparation":
            "Infusão (filtro, prensa francesa), cafeteira italiana, espresso, entre outros.",
        "Caffeine": "De 2 a 3 mg",
        "Flavor": "Suave"
      }
    ];
  }

  void carregarCervejas() {
    tableStateNotifier.value = [
      {"name": "La Fin Du Monde", "style": "Bock", "ibu": "65"},
      {"name": "Sapporo Premiume", "style": "Sour Ale", "ibu": "54"},
      {"name": "Duvel", "style": "Pilsner", "ibu": "82"}
    ];
  }

  void carregarNacoes() {
    tableStateNotifier.value = [
      {
        "name": "Brasil",
        "worldCups": "5",
        "title": "Pentacampeão",
        "population": "213,99 milhões",
        "coin": "Real"
      },
      {
        "name": "Argentina",
        "worldCups": "3",
        "title": "Tricampeão",
        "population": "45,6 milhões",
        "coin": "peso argentino (ARS)"
      },
      {
        "name": "França",
        "worldCups": "2",
        "title": "Bicampeão",
        "population": "67,4 milhões",
        "coin": "euro (€)"
      }
    ];
  }
}

final dataService = DataService();

void main() {
  MyApp app = MyApp();
  runApp(app);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  static const List<Map<String, dynamic>> _itemsNavBar = [
    {
      "label": "Cafés",
      "icon": Icon(Icons.coffee_outlined),
      "columnNames": ["Nome", "Preparação", "Cafeína", "Sabor"],
      "propertyNames": ["name", "preparation", "Caffeine", "Flavor"],
    },
    {
      "label": "Cervejas",
      "icon": Icon(Icons.local_drink_outlined),
      "columnNames": ["Nome", "Estilo", "IBU"],
      "propertyNames": ["name", "style", "ibu"],
    },
    {
      "label": "Nações",
      "icon": Icon(Icons.flag_outlined),
      "columnNames": ["Nome", "Copas do mundo", "Titulo", "População", "Moeda"],
      "propertyNames": ["name", "worldCups", "title", "population", "coin"],
    },
  ];

  @override
  void initState() {
    super.initState();
    dataService.carregar(_selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      dataService.carregar(_selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemsNavBar = _itemsNavBar[_selectedIndex];

    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Dicas"),
          ),
          body: ValueListenableBuilder(
              valueListenable: dataService.tableStateNotifier,
              builder: (context, value, child) {
                return DataTableWidget(
                    jsonObjects: value,
                    columnNames: itemsNavBar["columnNames"],
                    propertyNames: itemsNavBar["propertyNames"]);
              }),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              for (var item in _itemsNavBar)
                BottomNavigationBarItem(
                  label: item["label"],
                  icon: item["icon"],
                ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ));
  }
}

class NewNavBar extends HookWidget {
  final void Function(int)? itemSelectedCallback;

  NewNavBar({this.itemSelectedCallback});

  @override
  Widget build(BuildContext context) {
    var state = useState(1);
    return BottomNavigationBar(
        onTap: (index) {
          state.value = index;
          itemSelectedCallback?.call(index);
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
              label: "Nações", icon: Icon(Icons.flag_outlined))
        ]);
  }
}

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;
  final List<String> columnNames;
  final List<String> propertyNames;

  DataTableWidget(
      {this.jsonObjects = const [],
      this.columnNames = const [],
      this.propertyNames = const []});

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: columnNames
            .map((name) => DataColumn(
                label: Expanded(
                    child: Text(name,
                        style: TextStyle(fontWeight: FontWeight.bold)))))
            .toList(),
        rows: jsonObjects
            .map((obj) => DataRow(
                cells: propertyNames
                    .map((propName) => DataCell(Text(obj[propName] ?? "")))
                    .toList()))
            .toList());
  }
}
