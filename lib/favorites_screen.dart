import 'package:flutter/material.dart';
import 'meal_detail_screen.dart';
import 'favorites_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final favService = FavoritesService();

  @override
  Widget build(BuildContext context) {
    final favorites = favService.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: favorites.isEmpty
          ? const Center(child: Text("No favorites yet"))
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .8,
        ),
        itemCount: favorites.length,
        itemBuilder: (_, i) {
          final meal = favorites[i];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      MealDetailScreen(id: meal["idMeal"]),
                ),
              );
            },
            child: Card(
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(meal["strMealThumb"]),
                  ),
                  Text(meal["strMeal"]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
