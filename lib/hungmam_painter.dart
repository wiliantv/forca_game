import 'package:flutter/material.dart';

class HangmanPainter extends CustomPainter {
  final int incorrectGuesses;

  HangmanPainter(this.incorrectGuesses);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Desenhar a estrutura do jogo
    canvas.drawLine(Offset(50, size.height), Offset(50, 20), paint); // Post
    canvas.drawLine(Offset(50, 20), Offset(150, 20), paint); // Top
    canvas.drawLine(Offset(150, 20), Offset(150, 40), paint); // Cadeado

    // Desenhar o bonequinho
    if (incorrectGuesses > 0) {
      // Cabeça
      canvas.drawCircle(Offset(150, 60), 20, paint);
    }
    if (incorrectGuesses > 1) {
      // Corpo
      canvas.drawLine(Offset(150, 80), Offset(150, 140), paint);
    }
    if (incorrectGuesses > 2) {
      // Braço esquerdo
      canvas.drawLine(Offset(150, 90), Offset(120, 110), paint);
    }
    if (incorrectGuesses > 3) {
      // Braço direito
      canvas.drawLine(Offset(150, 90), Offset(180, 110), paint);
    }
    if (incorrectGuesses > 4) {
      // Perna esquerda
      canvas.drawLine(Offset(150, 140), Offset(120, 180), paint);
    }
    if (incorrectGuesses > 5) {
      // Perna direita
      canvas.drawLine(Offset(150, 140), Offset(180, 180), paint);
    }
  }

  @override
  bool shouldRepaint(HangmanPainter oldDelegate) {
    return oldDelegate.incorrectGuesses != incorrectGuesses;
  }
}
