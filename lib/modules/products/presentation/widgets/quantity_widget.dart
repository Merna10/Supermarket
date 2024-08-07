import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';

class QuantityWidget extends StatelessWidget {
  final int quantity;
  final int maxQuantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantityWidget({
    super.key,
    required this.quantity,
    required this.maxQuantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: HexColor('fddfe1'),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onDecrement,
            icon: const Icon(Icons.remove),
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$quantity',
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          decoration: BoxDecoration(
            color: HexColor('f1efde'),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: quantity < maxQuantity ? onIncrement : null,
            icon: const Icon(Icons.add),
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
