import 'package:flutter/material.dart';
import 'api_service.dart';
import 'meal_detail_screen.dart';
import 'favorites_service.dart';


class MealsScreen extends StatefulWidget {
  final String category;
  const MealsScreen({super.key, required this.category});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final api = ApiService();
  List meals = [];
  List filtered = [];
  bool loading = true;
  final favService = FavoritesService();


  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    meals = await api.getMeals(widget.category);
    filtered = meals;
    setState(() => loading = false);
  }

  void search(String text) {
    setState(() {
      filtered = meals
          .where((m) => m["strMeal"]
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search meals...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: search,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final meal = filtered[i];

                return Card(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MealDetailScreen(id: meal["idMeal"]),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.network(
                                meal["strMealThumb"],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                meal["strMeal"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          icon: Icon(
                            favService.isFavorite(meal["idMeal"])
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              favService.toggleFavorite(meal);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },

            ),
          ),
        ],
      ),
    );
  }
}
