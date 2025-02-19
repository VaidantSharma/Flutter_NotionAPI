import 'package:flutter/material.dart';

class HexagonalBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(0xFF161C1E)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    Path path = Path()
      ..moveTo(
          size.width, size.height - 40) // Start at the right bottom sharp cut
      ..lineTo(size.width - 70, size.height) // Bottom right sharp cut
      ..lineTo(70, size.height) // Bottom left sharp cut
      ..lineTo(0, size.height - 40); // Move up to the left sharp cut

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class HexagonalBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, 0); // Top left corner
    path.lineTo(size.width, 0); // Top right corner
    path.lineTo(
        size.width, size.height - 40); // Move down 40 pixels from the right
    path.lineTo(size.width - 70, size.height); // Bottom right sharp cut
    path.lineTo(70, size.height); // Bottom left sharp cut
    path.lineTo(0, size.height - 40); // Move up 40 pixels from the left
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
