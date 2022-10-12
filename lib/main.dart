import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

// Top level function
void main() {
  runApp(const MyApp());
}

// Material app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random words',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.black,
        ),
      ),
      home: const RandomWords(),
    );
  }
}

// StatefulWidget
class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  // Create an instance of State class
  @override
  State<RandomWords> createState() => _RandomWordsState();
}

// State class
class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[]; // Expandable words list
  final _liked = <WordPair>{}; // Liked set
  final _biggerFont = const TextStyle(fontSize: 18);

  // Whenever there is change in state, build method is called
  // StatefulWidget object is regenerated while State object persists over the lifetime of the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random words'),
        actions: [
          IconButton(
            onPressed: _pushLiked,
            icon: const Icon(
              Icons.list,
            ),
            tooltip: 'Liked words',
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider(); // divider after each element

          final index = i ~/ 2; // Integer division

          // Expand list
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          final alreadyLiked = _liked.contains(_suggestions[index]);

          return ListTile(
            title: Text(
              _suggestions[index].asPascalCase,
              style: _biggerFont,
            ),
            trailing: Icon(
              alreadyLiked ? Icons.favorite : Icons.favorite_border,
              color: alreadyLiked ? Colors.red : null,
              semanticLabel: alreadyLiked ? 'Remove from liked' : 'Like',
            ),
            onTap: () {
              setState(() {
                if (alreadyLiked) {
                  _liked.remove(_suggestions[index]);
                } else {
                  _liked.add(_suggestions[index]);
                }
              });
            },
          );
        },
      ),
    );
  }

  void _pushLiked() {
    // Pushing route to Navigator
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          // List of liked words --> Iterable of liked words
          final tiles = _liked.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );

          // Liked words list with dividers
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          // Liked words screen
          return Scaffold(
            appBar: AppBar(
              title: const Text('Liked words'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}
