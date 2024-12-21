import 'package:flutter/material.dart';
import '../models/joke_model.dart';

class JokesList extends StatelessWidget {
  final List<Joke> jokes;

  JokesList({required this.jokes});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[50],
      child: ListView.builder(
        itemCount: jokes.length,
        itemBuilder: (context, index) {
          final joke = jokes[index];
          return Card(
            color: Colors.green[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    joke.setup,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    joke.punchline,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.white
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
