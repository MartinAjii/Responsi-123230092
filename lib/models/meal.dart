class Meal {
  final String id;
  final String name;
  final String thumbnail;
  final String area;
  final String category;
  final String instructions;
  final String source;

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.area,
    required this.category,
    required this.instructions,
    required this.source,
  });

  factory Meal.fromJson(Map<String,dynamic> json){
    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      area: json['strArea'] ?? '',
      category: json['strCategory'] ?? '',
      instructions: json['strInstructions'] ?? '',
      source: json['strSource'] ?? '',
    );
  }

  Map<String,dynamic> toMap()=> {
    'idMeal':id,
    'strMeal':name,
    'strMealThumb':thumbnail,
    'strArea':area,
    'strCategory':category,
    'strInstructions':instructions,
    'strSource':source,
  };
}
