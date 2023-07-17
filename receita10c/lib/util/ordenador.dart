abstract class Decididor {
  bool precisaTrocarAtualPeloProximo(dynamic atual, dynamic proximo);
}

abstract class DecididorFiltragem {
  bool filtragem(dynamic objeto, dynamic filtro);
}

class Ordenador {
  List ordenarItensDeModoCrescente(List itens,
      bool Function(dynamic, dynamic, bool) callback, bool crescente) {
    List itensOrdenados = List.of(itens);
    bool trocouAoMenosUm;

    do {
      trocouAoMenosUm = false;

      for (int i = 0; i < itensOrdenados.length - 1; i++) {
        var atual = itensOrdenados[i];
        var proximo = itensOrdenados[i + 1];

        if (callback(atual, proximo, crescente)) {
          var aux = itensOrdenados[i];
          itensOrdenados[i] = itensOrdenados[i + 1];
          itensOrdenados[i + 1] = aux;
          trocouAoMenosUm = true;
        }
      }
    } while (trocouAoMenosUm);

    return itensOrdenados;
  }

  List ordenarItensModoDecrescente(List item, Function funcaoCall) {
    List itensOrdenados = List.of(item);
    bool trocouAoMenosUm;
    final funcao = funcaoCall;

    do {
      trocouAoMenosUm = false;
      for (int i = 0; i < itensOrdenados.length - 1; i++) {
        var atual = itensOrdenados[i];
        var proximo = itensOrdenados[i + 1];

        if (funcao(atual, proximo)) {
          var aux = itensOrdenados[i];
          itensOrdenados[i] = itensOrdenados[i + 1];
          itensOrdenados[i + 1] = aux;
          trocouAoMenosUm = true;
        }
      }
    } while (trocouAoMenosUm);

    return itensOrdenados;
  }
}
