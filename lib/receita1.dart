import 'package:flutter/material.dart';

void main() {
  MaterialApp app = MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(
            title: Text(
          "Spotiris",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        )),
        body: Center(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Text(
              "Nome: Saturno",
              style: TextStyle(
                  color: Color.fromARGB(255, 39, 63, 170),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            Text("""  

Você me ensinou a coragem das estrelas antes de partir
Como as luz continua infinitamente, mesmo após a morte

Com falta de ar, você explicou o infinito
E como é raro e bonito existir

Eu não pude deixar de pedir para você dizer tudo de novo
Eu tentei escrever, mas nunca consegui encontrar uma caneta

Eu daria qualquer coisa para ouvir você dizer isso mais uma vez
Que o universo foi feito só para ser visto pelos meus olhos

Com falta de ar, você explicou o infinito
E como é raro e bonito existir

                    - Sleeping At Last       
              """),
          ]),
        ),
        bottomNavigationBar: BottomNavigationBar(items: const [
          BottomNavigationBarItem(
            label: "Cifra",
            icon: Icon(Icons.music_note_rounded),
          ),
          BottomNavigationBarItem(
              label: "Letra", icon: Icon(Icons.music_note_rounded)),
          BottomNavigationBarItem(
              label: "Músicas", icon: Icon(Icons.music_note_rounded))
        ]),
      ));

  runApp(app);
}
