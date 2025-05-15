import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(DeckOfCardsApp());
}

class DeckOfCardsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baralho',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DeckHomePage(),
    );
  }
}

class DeckHomePage extends StatefulWidget {
  @override
  _DeckHomePageState createState() => _DeckHomePageState();
}

class _DeckHomePageState extends State<DeckHomePage> {
  String? deckId;
  String? cardImage;
  int cartas =0;

  Future<void> createDeck() async {
    final response = await http.get(Uri.parse('https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1'));
    final data = json.decode(response.body);
    cartas =52;
    setState(() {
      deckId = data['deck_id'];
      cardImage = null;
    });
  }

  Future<void> drawCard() async {
    if (deckId == null) return;
    final response = await http.get(Uri.parse('https://deckofcardsapi.com/api/deck/mku3kc485r5k/draw/?count=1'));
    final data = json.decode(response.body);
    cartas = cartas -1;
    setState(() {
      cardImage = data['cards'][0]['image'];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Baralho')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (cardImage != null)
              Image.network(cardImage!)
            else
              Text('Nenhuma carta sorteada.', style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: createDeck,
              child: Text('Criar Novo Baralho'),
            ),
            ElevatedButton(
              onPressed: drawCard,
              child: Text('Comprar Carta'),
            ),
            Text('Cartas restantes: $cartas',style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}