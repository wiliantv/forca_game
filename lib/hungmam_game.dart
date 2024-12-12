import 'package:flutter/material.dart';
import 'package:forca_game/hungmam_painter.dart';

class HangmanGame extends StatefulWidget {
  final String word;
  final String hint;

  HangmanGame({required this.word, required this.hint});

  @override
  _HangmanGameState createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> {
  List<String> _guessedLetters = [];
  List<String> _incorrectLetters = [];
  int _incorrectGuesses = 0;

  String _normalizeWord(String word) {
    // Substituir acentos por caracteres sem acento
    word = word.toLowerCase();
    word = word.replaceAll('á', 'a');
    word = word.replaceAll('é', 'e');
    word = word.replaceAll('í', 'i');
    word = word.replaceAll('ó', 'o');
    word = word.replaceAll('ú', 'u');
    word = word.replaceAll('ã', 'a');
    word = word.replaceAll('õ', 'o');
    word = word.replaceAll('â', 'a');
    word = word.replaceAll('ê', 'e');
    word = word.replaceAll('î', 'i');
    word = word.replaceAll('ô', 'o');
    word = word.replaceAll('û', 'u');
    word = word.replaceAll('ç', 'c');

    // Substituir espaços por hífens
    word = word.replaceAll(' ', '-');
    return word.toUpperCase();
  }

  void _guessLetter(String letter) {
    var normalizeWord = _normalizeWord(widget.word);
    if (!_guessedLetters.contains(letter)) {
      setState(() {
        _guessedLetters.add(letter);
        if (!normalizeWord.contains(letter)) {
          _incorrectGuesses++;
          _incorrectLetters.add(letter);
        }
      });

      if (_incorrectGuesses >= 6) {
        _showGameOverDialog(false);
      } else if (normalizeWord
          .replaceAll("-", "")
          .split('')
          .every((letter) => _guessedLetters.contains(letter))) {
        _showGameOverDialog(true);
      }
    }
  }

  void _showGameOverDialog(bool won) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(won ? 'Você ganhou!' : 'Você perdeu!'),
          content: Text('A palavra era ${widget.word}.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Volta para a tela inicial
              },
              child: Text('Voltar'),
            ),
          ],
        );
      },
    ).then(
      (value) {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var word = widget.word.replaceAll(" ", "-");
    return Scaffold(
      appBar: AppBar(title: Text('Jogo da Forca')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Exibir a dica
            Text('Dica: ${widget.hint}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            CustomPaint(
              size: Size(200, 200),
              painter: HangmanPainter(_incorrectGuesses),
            ),
            SizedBox(height: 20),
            Text(
              '${word.split('').map((letter) {
                if (letter == '-') {
                  return '-';
                }
                return _guessedLetters.contains(_normalizeWord(letter))
                    ? letter.toUpperCase()
                    : '_';
              }).join(' ')}',
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            ),
            // SizedBox(height: 20),
            // Text('Tentativas incorretas: $_incorrectGuesses'),
            SizedBox(height: 20),
            Text(
              'Letras erradas: ${_incorrectLetters.join(', ')}',
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((letter) {
                return ElevatedButton(
                  onPressed: _guessedLetters.contains(letter)
                      ? null
                      : () => _guessLetter(letter),
                  child: Text(letter),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
