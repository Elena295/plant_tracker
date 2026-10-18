import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../services/storage_service.dart';
import '../widgets/plant_card.dart';
import '../widgets/bottom_nav.dart';
import '../utils/constants.dart';
import 'new_plant_screen.dart';
import 'plant_detail_screen.dart';
import 'calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  List<Plant> _plants = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPlants();
  }

  Future<void> _loadPlants() async {
    final plants = await _storageService.getPlants();
    setState(() {
      _plants = plants;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _plants.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _plants.length,
                      itemBuilder: (context, index) {
                        return PlantCard(
                          plant: _plants[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlantDetailScreen(
                                  plant: _plants[index],
                                  onUpdate: _loadPlants,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
            _buildAddButton(),
            BottomNav(
              currentIndex: _currentIndex,
              onTap: (index) {
                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CalendarScreen(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  
Widget _buildHeader() {
  return Stack(
    children: [
      // Картинка на всю ширину (без закруглений)
      Image.asset(
        'assets/images/plant_header.png',
        height: 171,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 171,
            width: double.infinity,
            color: AppColors.primaryGreen.withOpacity(0.3),
            child: const Center(
              child: Icon(Icons.eco, size: 80, color: Colors.black54),
            ),
          );
        },
      ),
      const Positioned(
        left: 36,
        bottom: 50,
        child: Text(
          'Мои растения',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C1C1E),
          ),
        ),
      ),
    ],
  );
}
  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.gray,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewPlantScreen(),
                ),
              );
              if (result == true) {
                _loadPlants();
              }
            },
            borderRadius: BorderRadius.circular(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 24,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Добавить растение',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.eco_outlined,
            size: 100,
            color: AppColors.primaryGreen.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Нет растений',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Добавьте первое растение',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}