import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forca_game/hungmam_game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Forca',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: InputScreen(),
    );
  }
}

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _wordController = TextEditingController();
  List<Map<String, String>> _wordHints = [];

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    final String response = await rootBundle.loadString('assets/palavras.txt');
    setState(() {
      _wordHints = response.split('\n').map((line) {
        final parts = line.split('|');
        if (line == "") {
          return {
            'word': "ERRO",
            'hint': "Algo que ocorreu neste codigo agora"
          };
        }
        return {'word': parts[0].trim().toUpperCase(), 'hint': parts[1].trim()};
      }).toList();
    });
  }

  Map<String, String> _getRandomWord() {
    if (_wordHints.isNotEmpty) {
      final random = Random();
      return _wordHints[random.nextInt(_wordHints.length)];
    }
    return {'word': '', 'hint': ''};
  }

  void _startGame(BuildContext context, String word, String hint) {
    if (word.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HangmanGame(word: word, hint: hint),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jogo da Forca')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _wordController,
              decoration: InputDecoration(labelText: 'Digite uma palavra'),
              textCapitalization: TextCapitalization.characters,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _startGame(context, _wordController.text.toUpperCase(), '');
              },
              child: Text('Jogar'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                var randomWord = _getRandomWord();
                _startGame(context, randomWord["word"] ?? '',
                    randomWord["hint"] ?? "");
              },
              child: Text('Jogar com palavra aleatória'),
            ),
          ],
        ),
      ),
    );
  }
}
