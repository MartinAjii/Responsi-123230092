import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';

class ApiService {
  static Future<List<Meal>> getMeals(String category) async {
    final res = await http.get(
      Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category',
      ),
    );

    final data = jsonDecode(res.body);

    if (data['meals'] == null) {
      return [];
    }

    List meals = data['meals'];

    return meals.map<Meal>((m) {
      return Meal(
        id: m['idMeal'],
        name: m['strMeal'],
        thumbnail: m['strMealThumb'],
        area: '',
        category: category,
        instructions: '',
        source: '',
      );
    }).toList();
  }

  static Future<Meal> getMealDetail(String id) async {
    final res = await http.get(
      Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id',
      ),
    );

    final data = jsonDecode(res.body);

    return Meal.fromJson(data['meals'][0]);
  }
}