import 'package:flutter/material.dart';

var dataObjects = [
  {"name": "La Fin Du Monde", "style": "Bock", "ibu": "65"},
  {"name": "Sapporo Premiume", "style": "Sour Ale", "ibu": "54"},
  {"name": "Duvel", "style": "Pilsner", "ibu": "82"},
  {"name": "Gilgamesh Ridgeway IPA ", "style": "-", "ibu": "168"},
  {"name": "Starr Hill Double Platinum", "style": "-", "ibu": "180"},
  {"name": "Midnight Sun Gluttony", "style": "-", "ibu": "200"},
  {"name": " To Øl/Mikkeller Overall IIPA", "style": "-", "ibu": "408"},
  {"name": "Invicta", "style": "-", "ibu": "1000"},
  {"name": "Mikkeller", "style": "-", "ibu": "1000"},
  {
    "name": "Hart & Thistle Hop Mess Monster v2.0 ",
    "style": "-",
    "ibu": "1066"
  },
  {"name": "Flying Monkeys Alpha Fornication", "style": "-", "ibu": "2500"},
  {"name": "Imperial", "style": "-", "ibu": "120"},
];

void main() {
  ModifiedApp app = ModifiedApp();
  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.green),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Cervejas"),
          ),
          body: Center(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataBodyWidget(
                      objects: dataObjects,
                      columnNames: ["Nome", "Estilo", "IBU"],
                      propertyNames: ["name", "style", "ibu"]))),
          bottomNavigationBar: NewNavBar(),
        ));
  }
}

class ModifiedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.green),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Dicas",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: Center(
              child: MyTileWidget(
                  objects: dataObjects,
                  columnNames: ["Nome", "Estilo", "IBU"],
                  propertyNames: ["name", "style", "ibu"])),
          bottomNavigationBar: NewNavBar(),
        ));
  }
}

class NewNavBar extends StatelessWidget {
  NewNavBar();

  void botaoFoiTocado(int index) {
    print("Tocaram no botão $index");
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(onTap: botaoFoiTocado, items: const [
      BottomNavigationBarItem(
        label: "Cafés",
        icon: Icon(Icons.coffee_outlined),
      ),
      BottomNavigationBarItem(
          label: "Cervejas", icon: Icon(Icons.local_drink_outlined)),
      BottomNavigationBarItem(label: "Nações", icon: Icon(Icons.flag_outlined))
    ]);
  }
}

class DataBodyWidget extends StatelessWidget {
  final List<Map<String, dynamic>> objects;
  final List<String> columnNames;
  final List<String> propertyNames;

  const DataBodyWidget({
    this.objects = const [],
    this.columnNames = const [],
    this.propertyNames = const [],
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: List.generate(
        columnNames.length,
        (index) => DataColumn(
          label: Expanded(
            child: Text(
              columnNames[index],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      rows: List.generate(
        objects.length,
        (index) => DataRow(
          cells: List.generate(
            propertyNames.length,
            (cellIndex) => DataCell(
              Text(
                objects[index][propertyNames[cellIndex]].toString(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyTileWidget extends StatelessWidget {
  List<Map<String, dynamic>> objects;
  final List<String> columnNames;
  final List<String> propertyNames;

  MyTileWidget(
      {this.objects = const [],
      this.columnNames = const [],
      this.propertyNames = const []});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: objects.length,
      itemBuilder: (context, index) {
        final obj = objects[index];

        final columnTexts = columnNames.map((col) {
          final prop = propertyNames[columnNames.indexOf(col)];
          return Text("$col: ${obj[prop]}");
        }).toList();

        return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columnTexts,
          ),
        );
      },
    );
  }
}
