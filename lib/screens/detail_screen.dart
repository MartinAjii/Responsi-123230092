import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final Meal meal;

  const DetailScreen({super.key, required this.meal});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Meal? detailMeal;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  Future<void> loadDetail() async {
    final result = await ApiService.getMealDetail(widget.meal.id);

    setState(() {
      detailMeal = result;
      isLoading = false;
    });
  }

  Future<void> openSource() async {
    if (detailMeal != null && detailMeal!.source.isNotEmpty) {
      await launchUrl(Uri.parse(detailMeal!.source));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final meal = detailMeal!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(meal.thumbnail),
            const SizedBox(height: 10),
            Text(
              meal.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text("Category: ${meal.category}"),
            Text("Area: ${meal.area}"),
            const SizedBox(height: 10),
            Text(meal.instructions),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: openSource,
              child: const Text("Open Source"),
            )
          ],
        ),
      ),
    );
  }
}