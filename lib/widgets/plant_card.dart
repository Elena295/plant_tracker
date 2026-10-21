import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback onTap;
  final VoidCallback onUpdate; // Добавила коллбэк для обновления

  const PlantCard({
    super.key,
    required this.plant,
    required this.onTap,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
  String timeText = '';

if (plant.isWatered && plant.nextWateringDate != null) {
  // Если полито — показываем дату следующего полива
  final date = plant.nextWateringDate!;
  timeText = 'Следующий полив: ${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')} в ${_formatTime(TimeOfDay.fromDateTime(date))}';
} else if (plant.firstWateringTime != null) {
  // Если не полито — показываем сегодняшнее время
  timeText = 'Полить сегодня в ${_formatTime(plant.firstWateringTime!)}';
}
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timeText,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        plant.wateringType,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // НОВАЯ КНОПКА "ПОЛИТО"
                IconButton(
                  icon: Icon(
                    plant.isWatered ? Icons.check_circle : Icons.water_drop,
                    color: plant.isWatered ? Colors.green : Colors.blue,
                    size: 28,
                  ),
                  onPressed: () async {
                    plant.markAsWatered();
                    await StorageService().updatePlant(plant);
                    onUpdate(); // Обновляем экран
                  },
                ),

                const Icon(
                  Icons.chevron_right,
                  color: Colors.black,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}