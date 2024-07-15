import 'package:flutter/material.dart';

//circular progress indicator with a message below
class CircularIndicatorWithMessage extends StatelessWidget {
  const CircularIndicatorWithMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          CircularProgressIndicator(
            color: Colors.black,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Generating Response Please Wait...',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'cera',
            ),
          ),
        ],
      ),
    );
  }
}

//feature box widget
class FeatureBox extends StatelessWidget {
  const FeatureBox({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title, subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontFamily: 'cera', fontWeight: FontWeight.bold, fontSize: 17),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontFamily: 'cera', fontSize: 12),
          ),
        ],
      ),
    );
  }
}
