import 'package:flutter/material.dart';
import 'api_service.dart';
import 'meals_screen.dart';
import 'meal_detail_screen.dart';
import 'favorites_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final api = ApiService();
  List categories = [];
  List filtered = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    categories = await api.getCategories();
    filtered = categories;
    setState(() => loading = false);
  }

  void search(String text) {
    setState(() {
      filtered = categories
          .where((c) => c["strCategory"]
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase()))
          .toList();
    });
  }

  Future<void> openRandom() async {
    final meal = await api.getRandomMeal();
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MealDetailScreen(id: meal["idMeal"]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        actions: [
          IconButton(
            onPressed: openRandom, // ✅ FIXED
            icon: const Icon(Icons.shuffle),
            tooltip: 'Random recipe',
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const FavoritesScreen(),
                ),
              );
            },
            icon: const Icon(Icons.favorite),
            tooltip: 'Favorites',
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search categories...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: search,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final cat = filtered[i];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      cat["strCategoryThumb"],
                      width: 60,
                    ),
                    title: Text(cat["strCategory"]),
                    subtitle: Text(
                      cat["strCategoryDescription"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MealsScreen(category: cat["strCategory"]),
                        ),
                      );
                    },
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
