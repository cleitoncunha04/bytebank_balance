import 'package:flutter/material.dart';

void showErrorSnackbar({required BuildContext context, required message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(
        milliseconds: 1500,
      ),
      backgroundColor: Colors.red,
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const Icon(
              Icons.close,
              color: Colors.white,
            )
          ],
        ),
      ),
    ),
  );
}
