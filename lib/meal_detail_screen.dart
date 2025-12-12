import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:url_launcher/url_launcher.dart';


class MealDetailScreen extends StatefulWidget {
  final String id;
  const MealDetailScreen({super.key, required this.id});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final api = ApiService();
  Map meal = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    meal = await api.getMealDetails(widget.id);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(meal["strMeal"] ?? "Loading...")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(meal["strMealThumb"]),
            const SizedBox(height: 16),
            Text(
              meal["strMeal"],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Ingredients:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            for (int i = 1; i <= 20; i++)
              if (meal["strIngredient$i"] != null &&
                  meal["strIngredient$i"].toString().trim().isNotEmpty)
                Text(
                    "• ${meal["strIngredient$i"]} – ${meal["strMeasure$i"]}"),
            const SizedBox(height: 20),
            const Text(
              "Instructions:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(meal["strInstructions"] ?? "No instructions provided."),
            const SizedBox(height: 20),
            if (meal["strYoutube"] != null &&
                meal["strYoutube"].toString().trim().isNotEmpty)
              ElevatedButton.icon(
                onPressed: () async {

                  final url = Uri.parse(meal["strYoutube"]);
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text("Watch on YouTube"),
              )
          ],
        ),
      ),
    );
  }
}
