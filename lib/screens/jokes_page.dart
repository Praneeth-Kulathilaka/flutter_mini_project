import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/joke.dart';
import '../widgets/jokes_list.dart';

class JokesPage extends StatefulWidget {
  @override
  _JokesPageState createState() => _JokesPageState();
}

class _JokesPageState extends State<JokesPage> {
  final String jokesKey = 'cachedJokes';
  List<Joke> jokes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchJokes();
  }

  Future<void> fetchJokes() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.get(Uri.parse('https://official-joke-api.appspot.com/jokes/programming/ten'));

      if (response.statusCode == 200) {
        List<dynamic> jokesData = jsonDecode(response.body);
        jokes = jokesData.take(5).map((data) => Joke.fromJson(data)).toList();
        await prefs.setString(jokesKey, jsonEncode(jokes.map((j) => {'setup': j.setup, 'punchline': j.punchline}).toList()));
      } else {
        throw Exception('Failed to load jokes');
      }
    } catch (e) {
      final cachedData = prefs.getString(jokesKey);
      if (cachedData != null) {
        List<dynamic> cachedJokes = jsonDecode(cachedData);
        jokes = cachedJokes.map((data) => Joke.fromJson(data)).toList();
      } else {
        jokes = [Joke(setup: 'No cached jokes available', punchline: '')];
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch jokes. Loaded cached jokes if available.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor : Colors.brown[600],
        title: Text('Jokes App',
          style: TextStyle(
              color: Colors.white,
          )),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : JokesList(jokes: jokes),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchJokes,
        backgroundColor: Colors.brown[300],
        child: Icon(Icons.refresh,
        color: Colors.white,),
      ),
    );
  }
}
