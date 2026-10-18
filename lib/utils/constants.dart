import 'package:flutter/material.dart';

class AppColors {
  static const primaryGreen = Color(0xFFADE97F);
  static const lightGreen = Color(0xFFE1FAC4);
  static const gray = Color(0xFFE5E5EA);
  static const darkText = Color(0xFF1C1C1E);
  static const borderGreen = Color(0xFFADE97F);
}

class AppStrings {
  static const List<String> wateringFrequencies = [
    '2 раза в день',
    '1 раз в день',
    '1 раз в 2 дня',
  ];

  static const List<String> wateringTypes = [
    'Верхний полив',
    'Нижний полив',
    'Другое',
  ];

  static const List<String> lightingOptions = [
    'Хорошее освещение',
    'Среднее освещение',
    'Тень',
    'Прямые солнечные лучи',
  ];

  static const List<String> ventilationOptions = [
    'Частое',
    'Редкое',
    'Не требуется',
  ];
}