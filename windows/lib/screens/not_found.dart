import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundScreen extends StatelessWidget {
  final String? errorMessage;

  NotFoundScreen({this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              errorMessage.toString(),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: Text('Home'),
            )
          ],
        ),
      ),
    );
  }
}
