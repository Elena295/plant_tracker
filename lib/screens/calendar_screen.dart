import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/plant.dart';
import '../services/storage_service.dart';
import '../widgets/bottom_nav.dart';
import '../utils/constants.dart';
import 'home_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final StorageService _storageService = StorageService();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<Plant> _plants = [];
  int _currentIndex = 1;

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

bool _isWateringDay(Plant plant, DateTime selectedDay) {
  final plantDate = DateTime(plant.createdAt.year, plant.createdAt.month, plant.createdAt.day);
  final selectedDate = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
  
  final daysDifference = selectedDate.difference(plantDate).inDays;

  if (plant.wateringFrequency == '1 раз в 2 дня') {
    return daysDifference.abs() % 2 == 0;
  }
  
  return true;
}
    

  List<Plant> _getPlantsForDay(DateTime day) {
    return _plants.where((plant) => _isWateringDay(plant, day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Календарь',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.grey, fontSize: 12),
                  weekendStyle: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                calendarStyle: CalendarStyle(
                  selectedDecoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _buildScheduleList(),
            ),
            BottomNav(
              currentIndex: _currentIndex,
              onTap: (index) {
                if (index == 0) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
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

  Widget _buildScheduleList() {
    final plantsForDay = _getPlantsForDay(_selectedDay);
    
    if (plantsForDay.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_florist_outlined,
              size: 60,
              color: AppColors.primaryGreen.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Нет полива на ${_selectedDay.day} число',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    final Map<String, List<Plant>> schedule = {};
    for (var plant in plantsForDay) {
      if (plant.firstWateringTime != null) {
        final time = _formatTime(plant.firstWateringTime!);
        if (!schedule.containsKey(time)) schedule[time] = [];
        schedule[time]!.add(plant);
      }
      if (plant.secondWateringTime != null) {
        final time = _formatTime(plant.secondWateringTime!);
        if (!schedule.containsKey(time)) schedule[time] = [];
        schedule[time]!.add(plant);
      }
    }

    final sortedTimes = schedule.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedTimes.length,
      itemBuilder: (context, index) {
        final time = sortedTimes[index];
        final plants = schedule[time]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            ...plants.map((plant) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      plant.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    plant.wateringType,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            )),
          ],
        );
      },
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}