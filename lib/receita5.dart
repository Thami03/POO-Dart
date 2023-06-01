import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

var dataObjects = [];

void main() {
  MyApp app = MyApp();

  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Dicas"),
          ),
          body: DataTableWidget(jsonObjects: dataObjects),
          bottomNavigationBar: NewNavBar2(),
        ));
  }
}

class NewNavBar extends HookWidget {
  NewNavBar();

  @override
  Widget build(BuildContext context) {
    print("no build da classe Newbar");
    var state = useState(1);

    return BottomNavigationBar(
        onTap: (index) {
          state.value = index;
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

  DataTableWidget({this.jsonObjects = const []});

  @override
  Widget build(BuildContext context) {
    var columnNames = ["Nome", "Estilo", "IBU"],
        propertyNames = ["name", "style", "ibu"];

    return DataTable(
        columns: columnNames
            .map((name) => DataColumn(
                label: Expanded(
                    child: Text(name,
                        style: TextStyle(fontStyle: FontStyle.italic)))))
            .toList(),
        rows: jsonObjects
            .map((obj) => DataRow(
                cells: propertyNames
                    .map((propName) => DataCell(Text(obj[propName])))
                    .toList()))
            .toList());
  }
}

///////////// Newbar2
class NewNavBar2 extends StatefulWidget {
  @override
  NewNavBar2State createState() => NewNavBar2State();
}

class NewNavBar2State extends State<NewNavBar2> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    print("no build da classe Newbar2");

    return BottomNavigationBar(
      onTap: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      currentIndex: selectedIndex,
      items: const [
        BottomNavigationBarItem(
          label: "Cafés",
          icon: Icon(Icons.coffee_outlined),
        ),
        BottomNavigationBarItem(
            label: "Cervejas", icon: Icon(Icons.local_drink_outlined)),
        BottomNavigationBarItem(
            label: "Nações", icon: Icon(Icons.flag_outlined))
      ],
    );
  }
}
