import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String _username = '';
  late TabController _tabController;

  List<Meal> beefMeals = [];
  List<Meal> chickenMeals = [];
  List<Meal> porkMeals = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _tabController = TabController(length: 3, vsync: this);
    fetchAllMeals();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _username = prefs.getString('username') ?? 'User');
  }

  Future<void> fetchAllMeals() async {
    try {
      final beef = await ApiService.getMeals("Beef");
      final chicken = await ApiService.getMeals("Chicken");
      final pork = await ApiService.getMeals("Pork");

      setState(() {
        beefMeals = beef;
        chickenMeals = chicken;
        porkMeals = pork;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    }
  }

  Widget buildMealList(List<Meal> meals) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (meals.isEmpty) {
      return const Center(
        child: Text("Data makanan tidak tersedia"),
      );
    }

    return ListView.builder(
      itemCount: meals.length,
      itemBuilder: (context, index) {
        final meal = meals[index];

        return ListTile(
          leading: Image.network(
            meal.thumbnail,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          title: Text(meal.name),
          subtitle: Text(
            "${meal.category} - ${meal.area}",
          ),

          trailing: IconButton(
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Ditambahkan ke favorit"),
                ),
              );
            },
          ),

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailScreen(
                  meal: meal,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hai, $_username!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color.fromARGB(255, 76, 39, 209),
            child: const Center(
              child: Text(
                'Makan Bang!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Material(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Beef'),
                Tab(text: 'Chicken'),
                Tab(text: 'Pork'),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildMealList(beefMeals),
                buildMealList(chickenMeals),
                buildMealList(porkMeals),
              ],
            ),
          ),
        ],
      ),
    );
  }
}