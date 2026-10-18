import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/plant.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class NewPlantScreen extends StatefulWidget {
  const NewPlantScreen({super.key});

  @override
  State<NewPlantScreen> createState() => _NewPlantScreenState();
}

class _NewPlantScreenState extends State<NewPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _additionalInfoController = TextEditingController();
  
  String _selectedFrequency = '2 раза в день';
  String _selectedWateringType = 'Верхний полив';
  String _selectedLighting = 'Хорошее освещение';
  String _selectedVentilation = 'Частое';
  TimeOfDay? _firstWateringTime;
  TimeOfDay? _secondWateringTime;

  final StorageService _storageService = StorageService();

  // ЛОГИКА: показываем второе поле только если выбрано "2 раза в день"
  bool get _showSecondTime => _selectedFrequency == '2 раза в день';

  @override
  void dispose() {
    _nameController.dispose();
    _temperatureController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(bool isFirst) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryGreen,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isFirst) {
          _firstWateringTime = picked;
        } else {
          _secondWateringTime = picked;
        }
      });
    }
  }

    Future<void> _savePlant() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите название растения')),
      );
      return;
    }

    final plant = Plant(
      id: const Uuid().v4(),
      name: _nameController.text,
      wateringFrequency: _selectedFrequency,
      firstWateringTime: _firstWateringTime,
      secondWateringTime: _showSecondTime ? _secondWateringTime : null,
      wateringType: _selectedWateringType,
      lighting: _selectedLighting,
      temperature: _temperatureController.text,
      ventilation: _selectedVentilation,
      additionalInfo: _additionalInfoController.text,
      // createdAt установится автоматически в конструкторе модели (DateTime.now())
    );

    await _storageService.addPlant(plant);
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Новое растение',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _buildInputLabel('Название'),
                const SizedBox(height: 8),
                _buildTextField(_nameController),
                const SizedBox(height: 24),
                _buildInputLabel('Регулярность полива'),
                const SizedBox(height: 8),
                _buildSegmentedControl(
                  AppStrings.wateringFrequencies,
                  _selectedFrequency,
                  (value) => setState(() => _selectedFrequency = value),
                ),
                const SizedBox(height: 24),
                _buildInputLabel('Время первого полива'),
                const SizedBox(height: 8),
                _buildTimePickerButton(_firstWateringTime, () => _selectTime(true)),
                
                // ВТОРОЕ ПОЛЕ: появляется только при выборе "2 раза в день"
                if (_showSecondTime) ...[
                  const SizedBox(height: 24),
                  _buildInputLabel('Время второго полива'),
                  const SizedBox(height: 8),
                  _buildTimePickerButton(_secondWateringTime, () => _selectTime(false)),
                ],

                const SizedBox(height: 24),
                _buildInputLabel('Тип полива'),
                const SizedBox(height: 8),
                _buildDropdown(
                  AppStrings.wateringTypes,
                  _selectedWateringType,
                  (value) => setState(() => _selectedWateringType = value!),
                ),
                const SizedBox(height: 24),
                _buildInputLabel('Освещение'),
                const SizedBox(height: 8),
                _buildDropdown(
                  AppStrings.lightingOptions,
                  _selectedLighting,
                  (value) => setState(() => _selectedLighting = value!),
                ),
                const SizedBox(height: 24),
                _buildInputLabel('Температура'),
                const SizedBox(height: 8),
                _buildTextField(_temperatureController, hint: '20-35 C'),
                const SizedBox(height: 24),
                _buildInputLabel('Проветривание'),
                const SizedBox(height: 8),
                _buildDropdown(
                  AppStrings.ventilationOptions,
                  _selectedVentilation,
                  (value) => setState(() => _selectedVentilation = value!),
                ),
                const SizedBox(height: 24),
                _buildInputLabel('Дополнительная информация'),
                const SizedBox(height: 8),
                _buildTextField(_additionalInfoController),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _savePlant,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.black),
                        SizedBox(width: 10),
                        Text(
                          'Добавить',
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
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {String? hint}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderGreen, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl(
    List<String> options,
    String selected,
    Function(String) onChanged,
  ) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderGreen, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: options.map((option) {
          final isSelected = option == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.lightGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  option,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimePickerButton(TimeOfDay? time, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderGreen, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(
              time != null
                  ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
                  : 'Выберите время',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    List<String> items,
    String value,
    Function(String?) onChanged,
  ) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderGreen, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}