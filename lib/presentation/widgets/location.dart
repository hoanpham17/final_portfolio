import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeLocation extends StatelessWidget {
  const HomeLocation({super.key, required this.nameLocation});

  final String nameLocation;

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd-MM-yyyy');
    final tf = DateFormat('HH:mm');

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/icons/location.png'),
            const SizedBox(width: 10),
            Text(
              nameLocation,
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 17),
        Text(
          '${tf.format(DateTime.now())}\n${df.format(DateTime.now())}',
          style: const TextStyle(
            fontSize: 28,
            color: Colors.white,
            height: 1.5, 
          ),
          textAlign: TextAlign.center, 
        ),
      ],
    );
  }
}
