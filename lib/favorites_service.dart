class FavoritesService {
  FavoritesService._internal();
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;

  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String id) {
    return _favorites.any((m) => m['idMeal'] == id);
  }

  void toggleFavorite(Map<String, dynamic> meal) {
    final id = meal['idMeal'];
    final index = _favorites.indexWhere((m) => m['idMeal'] == id);
    if (index == -1) {
      _favorites.add(meal);
    } else {
      _favorites.removeAt(index);
    }
  }
}
