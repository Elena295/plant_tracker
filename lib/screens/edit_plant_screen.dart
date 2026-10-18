import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class EditPlantScreen extends StatefulWidget {
  final Plant plant;

  const EditPlantScreen({
    super.key,
    required this.plant,
  });

  @override
  State<EditPlantScreen> createState() => _EditPlantScreenState();
}

class _EditPlantScreenState extends State<EditPlantScreen> {
  late TextEditingController _nameController;
  late TextEditingController _temperatureController;
  late TextEditingController _additionalInfoController;
  
  late String _selectedFrequency;
  late String _selectedWateringType;
  late String _selectedLighting;
  late String _selectedVentilation;
  late TimeOfDay? _firstWateringTime;
  late TimeOfDay? _secondWateringTime;

  final StorageService _storageService = StorageService();

  bool get _showSecondTime => _selectedFrequency == '2 раза в день';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plant.name);
    _temperatureController = TextEditingController(text: widget.plant.temperature);
    _additionalInfoController = TextEditingController(text: widget.plant.additionalInfo);
    _selectedFrequency = widget.plant.wateringFrequency;
    _selectedWateringType = widget.plant.wateringType;
    _selectedLighting = widget.plant.lighting.isNotEmpty
        ? widget.plant.lighting
        : AppStrings.lightingOptions.first;
    _selectedVentilation = widget.plant.ventilation.isNotEmpty
        ? widget.plant.ventilation
        : AppStrings.ventilationOptions.first;
    _firstWateringTime = widget.plant.firstWateringTime;
    _secondWateringTime = widget.plant.secondWateringTime;
  }

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
      initialTime: isFirst
          ? (_firstWateringTime ?? TimeOfDay.now())
          : (_secondWateringTime ?? TimeOfDay.now()),
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

  Future<void> _saveChanges() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите название растения')),
      );
      return;
    }

    final updatedPlant = widget.plant.copyWith(
      name: _nameController.text,
      wateringFrequency: _selectedFrequency,
      secondWateringTime: _showSecondTime ? _secondWateringTime : null,
      wateringType: _selectedWateringType,
      lighting: _selectedLighting,
      temperature: _temperatureController.text,
      ventilation: _selectedVentilation,
      additionalInfo: _additionalInfoController.text,
    );

    await _storageService.updatePlant(updatedPlant);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Изменение',
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
              _buildTextField(_temperatureController),
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
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Применить изменения',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
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