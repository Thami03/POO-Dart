import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../util/filtro.dart';
import '../util/ordenador.dart';

enum TableStatus { idle, loading, ready, error }

enum ItemType {
  food,
  address,
  device,
  none;

  String get asString => '$name';

  List<String> get columns => this == food
      ? ["Nome", "Ingrediente", "Medida"]
      : this == address
          ? ["Cidade", "Comunidade", "Rua"]
          : this == device
              ? ["Fabricante", "Plataforma", "Modelo"]
              : [];

  List<String> get properties => this == food
      ? ["dish", "ingredient", "measurement"]
      : this == address
          ? ["city", "community", "street_name"]
          : this == device
              ? ["manufacturer", "platform", "model"]
              : [];
}

class DataService {
  static const MAX_N_ITEMS = 15;
  static const MIN_N_ITEMS = 3;
  static const DEFAULT_N_ITEMS = 7;

  int _numberOfItems = DEFAULT_N_ITEMS;

  set numberOfItems(n) {
    _numberOfItems = n < 0
        ? MIN_N_ITEMS
        : n > MAX_N_ITEMS
            ? MAX_N_ITEMS
            : n;
  }

  final ValueNotifier<Map<String, dynamic>> tableStateNotifier = ValueNotifier({
    'status': TableStatus.idle,
    'dataObjects': [],
    'itemType': ItemType.none
  });

  void carregar(index) {
    final carregarParametro = [
      ItemType.address,
      ItemType.food,
      ItemType.device
    ];

    carregarPorTipo(carregarParametro[index]);
  }
// ----------------------------------------------------------------------------------------

  void ordenarEstadoAtual(String propriedade, [bool crescente = true]) {
    List objetos = tableStateNotifier.value['dataObjects'] ?? [];

    if (objetos.isEmpty) return;

    Ordenador ord = Ordenador();

    var objetosOrdenados = [];

    bool precisaTrocarEstadoAtual(atual, proximo) {
      final ordemCorreta = crescente ? [atual, proximo] : [proximo, atual];
      return ordemCorreta[0][propriedade]
              .compareTo(ordemCorreta[1][propriedade]) >
          0;
    }

    objetosOrdenados =
        ord.ordenarItensModoDecrescente(objetos, precisaTrocarEstadoAtual);

    emitirEstadoOrdenado(objetosOrdenados, propriedade);
  }

  void filtrarEstadoAtual(final String filtro) {
    List objetos = tableStateNotifier.value['previousObjects'] ?? [];

    if (objetos == []) return;

    List propriedades = tableStateNotifier.value['propertyNames'];

    Filtrador pesquisa = Filtrador();

    DecididorFiltragem decidindo = DecididorFiltragemJson(propriedades);

    var objetosFiltrados =
        pesquisa.filtrar(objetos, filtro, decidindo.filtragem);

    emitirEstadoFiltrado(objetos, objetosFiltrados, filtro);
  }

// ----------------------------------------------------------------------------------------

  Uri montarUri(ItemType type) {
    return Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/${type.asString}/random_${type.asString}',
        queryParameters: {'size': '$_numberOfItems'});
  }

  Future<List<dynamic>> acessarApi(Uri uri) async {
    var jsonString = await http.read(uri);
    var json = jsonDecode(jsonString);
    json = [...tableStateNotifier.value['dataObjects'], ...json];

    return json;
  }

  void emitirEstadoFiltrado(
      List objetos, List objetosFiltrados, String filtro) {
    var estado = Map<String, dynamic>.from(tableStateNotifier.value);
    estado['previousObjects'] = objetos;
    estado['dataObjects'] = objetosFiltrados;
    estado['filterCriteria'] = filtro;
    tableStateNotifier.value = estado;
  }

  void emitirEstadoOrdenado(List objetosOrdenados, String propriedade) {
    var estado = Map<String, dynamic>.from(tableStateNotifier.value);
    estado['dataObjects'] = objetosOrdenados;
    estado['sortCriteria'] = propriedade;
    estado['ascending'] = true;

    tableStateNotifier.value = estado;
  }

  void emitirEstadoCarregando(ItemType type) {
    tableStateNotifier.value = {
      'status': TableStatus.loading,
      'dataObjects': [],
      'itemType': type,
      'previousObjects': []
    };
  }

  void emitirEstadoPronto(ItemType type, var json) {
    tableStateNotifier.value = {
      'itemType': type,
      'status': TableStatus.ready,
      'dataObjects': json,
      'propertyNames': type.properties,
      'columnNames': type.columns,
      'previousObjects': json
    };
  }

  bool temRequisicaoEmCurso() =>
      tableStateNotifier.value['status'] == TableStatus.loading;
  bool mudouTipoDeItemRequisitado(ItemType type) =>
      tableStateNotifier.value['itemType'] != type;

  void carregarPorTipo(ItemType type) async {
    //ignorar solicitação se uma requisição já estiver em curso

    if (temRequisicaoEmCurso()) return;

    if (mudouTipoDeItemRequisitado(type)) {
      emitirEstadoCarregando(type);
    }

    var uri = montarUri(type);
    var json = await acessarApi(uri);
    emitirEstadoPronto(type, json);
  }
}

final dataService = DataService();

class DecididorJson implements Decididor {
  final String propriedade;
  final bool crescente;
  DecididorJson(this.propriedade, [this.crescente = true]);

  @override
  bool precisaTrocarAtualPeloProximo(atual, proximo) {
    try {
      final ordemCorreta = crescente ? [atual, proximo] : [proximo, atual];
      return ordemCorreta[0][propriedade]
              .compareTo(ordemCorreta[1][propriedade]) >
          0;
    } catch (error) {
      return false;
    }
  }
}

class DecididorFiltragemJson extends DecididorFiltragem {
  final List propriedades;

  DecididorFiltragemJson(this.propriedades);

  @override
  bool filtragem(objeto, filtro) {
    bool achouAoMenosUm = false;
    for (int i = 0; i < propriedades.length - 1; i++) {
      achouAoMenosUm = objeto[propriedades[i]].contains(filtro) ? true : false;
      if (achouAoMenosUm) break;
    }
    return achouAoMenosUm;
  }
}
