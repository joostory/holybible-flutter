
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator()
    );
  }
}


class MessageLoading extends StatelessWidget {
  final String message;

  const MessageLoading({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message)
    );
  }
}
