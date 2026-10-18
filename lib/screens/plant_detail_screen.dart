import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../utils/constants.dart';
import '../services/storage_service.dart';
import 'edit_plant_screen.dart';

class PlantDetailScreen extends StatefulWidget {
  final Plant plant;
  final VoidCallback onUpdate;

  const PlantDetailScreen({
    super.key,
    required this.plant,
    required this.onUpdate,
  });

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  final StorageService _storageService = StorageService();

Future<void> _deletePlant() async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Удалить растение?'),
      content: Text('Вы уверены, что хотите удалить "${widget.plant.name}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Отмена', style: TextStyle(color: Colors.black)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Удалить', style: TextStyle(color: Colors.black)),
        ),
      ],
    ),
  );

    if (shouldDelete == true) {
      await _storageService.deletePlant(widget.plant.id);
      widget.onUpdate();
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Верхняя зеленая полоса с названием и иконкой удаления
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: AppColors.primaryGreen,  // #ADE97F
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.plant.name,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,  // #1C1C1E
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _deletePlant,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      'Полив',
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.plant.wateringFrequency,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              if (widget.plant.firstWateringTime != null)
                                Text(
                                  _formatTime(widget.plant.firstWateringTime!),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              if (widget.plant.secondWateringTime != null) ...[
                                const SizedBox(width: 8),
                                Text(
                                  _formatTime(widget.plant.secondWateringTime!),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                              const SizedBox(width: 8),
                              Text(
                                widget.plant.wateringType,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildSection(
                      'Освещение',
                      Text(
                        widget.plant.lighting.isNotEmpty
                            ? widget.plant.lighting
                            : 'Не указано',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    _buildSection(
                      'Температура',
                      Text(
                        widget.plant.temperature.isNotEmpty
                            ? widget.plant.temperature
                            : 'Не указано',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    _buildSection(
                      'Проветривание',
                      Text(
                        widget.plant.ventilation.isNotEmpty
                            ? widget.plant.ventilation
                            : 'Не указано',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    _buildSection(
                      'Дополнительная информация',
                      Text(
                        widget.plant.additionalInfo.isNotEmpty
                            ? widget.plant.additionalInfo
                            : 'Не указано',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.gray,  // #E5E5EA
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_back, color: Colors.black),
                                SizedBox(width: 8),
                                Text(
                                  'Назад',
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
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPlantScreen(
                                    plant: widget.plant,
                                  ),
                                ),
                              );
                              if (result == true) {
                                widget.onUpdate();
                                if (mounted) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,  // #ADE97F
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.edit, color: Colors.black),
                                SizedBox(width: 8),
                                Text(
                                  'Изменить',
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
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        content,
        const SizedBox(height: 16),
        Divider(
          color: AppColors.primaryGreen,  // #ADE97F — зелёная линия как в дизайне
          thickness: 2,
        ),
      ],
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}