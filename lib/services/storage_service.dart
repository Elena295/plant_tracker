import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/plant.dart';

class StorageService {
  static const String _plantsKey = 'plants';

  Future<List<Plant>> getPlants() async {
    final prefs = await SharedPreferences.getInstance();
    final String? plantsJson = prefs.getString(_plantsKey);
    if (plantsJson == null) return [];
    final List<dynamic> decoded = jsonDecode(plantsJson);
    return decoded.map((json) => Plant.fromJson(json)).toList();
  }

  Future<void> savePlants(List<Plant> plants) async {
    final prefs = await SharedPreferences.getInstance();
    final String plantsJson = jsonEncode(plants.map((p) => p.toJson()).toList());
    await prefs.setString(_plantsKey, plantsJson);
  }

  Future<void> addPlant(Plant plant) async {
    final plants = await getPlants();
    plants.add(plant);
    await savePlants(plants);
  }

  Future<void> updatePlant(Plant plant) async {
    final plants = await getPlants();
    final index = plants.indexWhere((p) => p.id == plant.id);
    if (index != -1) {
      plants[index] = plant;
      await savePlants(plants);
    }
  }

  Future<void> deletePlant(String id) async {
    final plants = await getPlants();
    plants.removeWhere((p) => p.id == id);
    await savePlants(plants);
  }
}