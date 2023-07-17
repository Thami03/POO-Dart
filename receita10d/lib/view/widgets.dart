import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../data/data_service.dart';

class MenuOptions {
  static const menuOptions = [3, 15, 7];
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: const PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: MyAppBar()),
          body: ValueListenableBuilder(
              valueListenable: dataService.tableStateNotifier,
              builder: (_, value, __) {
                switch (value['status']) {
                  case TableStatus.idle:
                    return Center(child: Text("Toque em algum botão"));

                  case TableStatus.loading:
                    return Center(child: CircularProgressIndicator());

                  case TableStatus.ready:
                    return SingleChildScrollView(
                        child: DataTableWidget(
                            jsonObjects: value['dataObjects'],
                            propertyNames: value['propertyNames'],
                            columnNames: value['columnNames']));

                  case TableStatus.error:
                    return Text("Error");
                }
                return Text("...");
              }),
          bottomNavigationBar:
              NewNavBar(itemSelectedCallback: dataService.carregar),
        ));
  }
}

class NewNavBar extends HookWidget {
  final _itemSelectedCallback;

  NewNavBar({itemSelectedCallback})
      : _itemSelectedCallback = itemSelectedCallback ?? (int) {}

  @override
  Widget build(BuildContext context) {
    var state = useState(1);

    return BottomNavigationBar(
        onTap: (index) {
          state.value = index;
          _itemSelectedCallback(index);
        },
        currentIndex: state.value,
        items: const [
          BottomNavigationBarItem(
            label: "Café",
            icon: Icon(Icons.coffee),
          ),
          BottomNavigationBarItem(
              label: "Bebida", icon: Icon(Icons.local_drink)),
          BottomNavigationBarItem(
              label: "Nações", icon: Icon(Icons.location_city))
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
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            columns: columnNames
                .map((name) => DataColumn(
                    onSort: (columnIndex, ascending) => dataService
                        .ordenarEstadoAtual(propertyNames[columnIndex]),
                    label: Expanded(
                        child: Text(
                      name,
                    ))))
                .toList(),
            rows: jsonObjects
                .map((obj) => DataRow(
                    cells: propertyNames
                        .map((propName) => DataCell(Text(obj[propName])))
                        .toList()))
                .toList()));
  }
}

class MyAppBar extends HookWidget {
  final loadMenuOptions = MenuOptions.menuOptions;
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = useState(7);

    return AppBar(title: Text("Dicas"), actions: [
      SearchBar(),
      PopupMenuButton(
        initialValue: state.value,
        itemBuilder: (_) => loadMenuOptions
            .map((num) => PopupMenuItem(
                  value: num,
                  child: Text("Carregar $num itens por vez"),
                ))
            .toList(),
        onSelected: (number) {
          state.value = number;
          dataService.numberOfItems = number;
        },
      )
    ]);
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 1.0,
        maxWidth: 280.0,
      ),
      child: TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          hintText: 'Buscar',
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
        onChanged: (filter) {
          if (filter.length >= 3) {
            dataService.filtrarEstadoAtual(filter);
          } else {
            dataService.filtrarEstadoAtual('');
          }
        },
      ),
    );
  }
}
