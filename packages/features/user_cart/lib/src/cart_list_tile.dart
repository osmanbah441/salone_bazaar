import 'package:flutter/material.dart';

class CartListTile extends StatelessWidget {
  const CartListTile({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.quantity,
    required this.price,
    this.onItemTap,
    this.onIncrement,
    this.onDecrement,
  });

  final String imageUrl, name;
  final int quantity;
  final double price;
  final VoidCallback? onItemTap;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Card(
        elevation: 0,
        child: InkWell(
          onTap: onItemTap,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  imageUrl,
                  width: 120.0,
                  height: 96.0,
                  fit: BoxFit.cover,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: textTheme.titleSmall,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'SLE ${price.toStringAsFixed(2)}',
                              style: textTheme.labelLarge,
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: onDecrement,
                                    icon: const Icon(Icons.remove)),
                                Text(quantity.toString()),
                                IconButton(
                                    color: Colors.green,
                                    onPressed: onIncrement,
                                    icon: const Icon(Icons.add)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
