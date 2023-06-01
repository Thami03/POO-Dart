import 'package:flutter/material.dart';

void main() {
  Myapp app = Myapp();

  runApp(app);
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

class Myapp extends StatelessWidget {
  Myapp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Dicas"),
          ),
          body: Column(children: [
            Expanded(
              child: Text("La Fin Du Monde - Bock - 65 ibu"),
            ),
            Expanded(
              child: Text("Sapporo Premiume - Sour Ale - 54 ibu"),
            ),
            Expanded(
              child: Text("Duvel - Pilsner - 82 ibu"),
            )
          ]),
          bottomNavigationBar: NewNavBar(),
        ));
  }
}
