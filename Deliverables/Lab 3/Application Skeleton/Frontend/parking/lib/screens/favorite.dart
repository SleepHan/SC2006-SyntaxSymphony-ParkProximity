import 'package:flutter/material.dart';
import 'package:parking/controller/favoriteprovider.dart';
//import 'package:parking/screens/markFavorites.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(builder: (context, provider, child) {
      final provider = FavoriteProvider.of(context);
      final words = provider.words;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
          backgroundColor: Colors.lightGreen,
          // leading: TextButton(
          //   child: Text('Mark Favorites Page'),
          //   onPressed: () {
          //     Navigator.of(context).push(
          //           MaterialPageRoute(
          //             builder: (BuildContext context) => InheritedProvider(
          //               create: (context) => FavoriteProvider(),
          //               builder: (context, child) => MarkFavorites(),
          //             ),
          //           ),
          //         );
          //   },
          //   ),
        ),
        body: ListView.separated(
          itemCount: words.length,
          separatorBuilder: (BuildContext context, index) {
            return const Divider(height: 20);
          },
          itemBuilder: (context, index) {
            final word = words[index];
            return ListTile(
                title: Text("Parking Location: $word"),
                subtitle: Text("Other Things:\n"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        provider.toggleFavorite(word);
                      },
                      icon: provider.isExist(word)
                          ? const Icon(Icons.star,
                              color: Color.fromARGB(255, 247, 224, 10))
                          : const Icon(Icons.star_border),
                    ),
                    IconButton(
                      onPressed: () {
                        // Add your logic for the second button here
                        // This is where you define what happens when the button is pressed.
                      },
                      icon: Icon(Icons
                          .assistant_navigation), // Replace with your desired icon
                    ),
                  ],
                ));
          },
        ),
      );
    });
  }
}
