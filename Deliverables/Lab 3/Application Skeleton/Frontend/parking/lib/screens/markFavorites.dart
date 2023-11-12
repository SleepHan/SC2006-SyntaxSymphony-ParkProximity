import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:parking/screens/favorite.dart';
import 'package:parking/controller/favoriteprovider.dart';
import 'package:provider/provider.dart';

class MarkFavorites extends StatelessWidget {
  const MarkFavorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final words = nouns.take(50).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('English Words'),
      ),
      body: ListView.builder(
        itemCount: words.length,
        itemBuilder: (context, index) {
          final word = words[index];
          return ListTile(
            title: Text(word),
            trailing: ElevatedButton(
              child: Text("Click Here"),
              onPressed: () {
                _favouriteModalBottomSheet(context, word);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final route = MaterialPageRoute(
            builder: (context) => const FavoritePage(),
          );
          Navigator.push(context, route);
        },
        label: const Text('Favorites'),
      ),
    );
  }

  void _favouriteModalBottomSheet(context, word) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      backgroundColor: Color.fromARGB(255, 219, 255, 178),
      builder: (BuildContext context) {
        return Consumer<FavoriteProvider>(
          builder: (context, provider, child) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * .40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Row(
                    children: [
                      Text("Favourite Carpark",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          FavoriteProvider.of(context).toggleFavorite(word);
                        },
                        icon: FavoriteProvider.of(context).isExist(word)
                            ? const Icon(Icons.star,
                                color: Color.fromARGB(255, 247, 224, 10),
                                size: 30)
                            : const Icon(Icons.star_border, size: 30),
                      ),
                    ],
                  ),
                  Row(children: [
                    Text(
                      "Carpark Location: $word",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ])
                ]),
              ),
            );
          },
        );
      },
    );
  }
}
