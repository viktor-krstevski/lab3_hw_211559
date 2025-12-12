import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const base = "www.themealdb.com";

  Future<List<dynamic>> getCategories() async {
    final url = Uri.https(base, "/api/json/v1/1/categories.php");
    final res = await http.get(url);
    return jsonDecode(res.body)["categories"];
  }

  Future<List<dynamic>> getMeals(String category) async {
    final url = Uri.https(base, "/api/json/v1/1/filter.php", {"c": category});
    final res = await http.get(url);
    return jsonDecode(res.body)["meals"];
  }

  Future<List<dynamic>> searchMeals(String query) async {
    final url = Uri.https(base, "/api/json/v1/1/search.php", {"s": query});
    final res = await http.get(url);
    return jsonDecode(res.body)["meals"] ?? [];
  }

  Future<dynamic> getMealDetails(String id) async {
    final url = Uri.https(base, "/api/json/v1/1/lookup.php", {"i": id});
    final res = await http.get(url);
    return jsonDecode(res.body)["meals"][0];
  }

  Future<dynamic> getRandomMeal() async {
    final url = Uri.https(base, "/api/json/v1/1/random.php");
    final res = await http.get(url);
    return jsonDecode(res.body)["meals"][0];
  }
}
