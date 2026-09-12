import 'package:flutter/material.dart';

class ProductPriceSection extends StatelessWidget {
  final double price;
  final double? discountPercentage;

  const ProductPriceSection({
    super.key,
    required this.price,
    this.discountPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final discount = discountPercentage ?? 0.0;
    final originalPrice = discount > 0 ? price / (1 - (discount / 100)) : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
        if (originalPrice != null) ...[
          const SizedBox(width: 8),
          Text(
            '\$${originalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${discount.toStringAsFixed(0)}% off',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ],
    );
  }
}
