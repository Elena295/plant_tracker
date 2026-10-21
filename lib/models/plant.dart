import 'package:flutter/material.dart';

class Plant {
  final String id;
  final DateTime createdAt;
  String name;
  String wateringFrequency; 
  TimeOfDay? firstWateringTime;
  TimeOfDay? secondWateringTime;
  String wateringType; 
  String lighting;
  String temperature;
  String ventilation;
  String additionalInfo;
  DateTime? nextWateringDate; // НОВОЕ: дата следующего полива
  bool isWatered; //  НОВОЕ: полито или нет

  Plant({
    required this.id,
    DateTime? createdAt,
    required this.name,
    required this.wateringFrequency,
    this.firstWateringTime,
    this.secondWateringTime,
    required this.wateringType,
    this.lighting = '',
    this.temperature = '',
    this.ventilation = '',
    this.additionalInfo = '',
    this.nextWateringDate,
    this.isWatered = false, // По умолчанию растение не полито
  }) : this.createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'name': name,
      'wateringFrequency': wateringFrequency,
      'firstWateringHour': firstWateringTime?.hour,
      'firstWateringMinute': firstWateringTime?.minute,
      'secondWateringHour': secondWateringTime?.hour,
      'secondWateringMinute': secondWateringTime?.minute,
      'wateringType': wateringType,
      'lighting': lighting,
      'temperature': temperature,
      'ventilation': ventilation,
      'additionalInfo': additionalInfo,
      'nextWateringDate': nextWateringDate?.millisecondsSinceEpoch,
      'isWatered': isWatered,
    };
  }

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'] ?? '',
      createdAt: map['createdAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt']) 
          : DateTime.now(),
      name: map['name'] ?? '',
      wateringFrequency: map['wateringFrequency'] ?? '',
      firstWateringTime: map['firstWateringHour'] != null && 
          map['firstWateringMinute'] != null
          ? TimeOfDay(
              hour: map['firstWateringHour'],
              minute: map['firstWateringMinute'],
            )
          : null,
      secondWateringTime: map['secondWateringHour'] != null && 
          map['secondWateringMinute'] != null
          ? TimeOfDay(
              hour: map['secondWateringHour'],
              minute: map['secondWateringMinute'],
            )
          : null,
      wateringType: map['wateringType'] ?? '',
      lighting: map['lighting'] ?? '',
      temperature: map['temperature'] ?? '',
      ventilation: map['ventilation'] ?? '',
      additionalInfo: map['additionalInfo'] ?? '',
      nextWateringDate: map['nextWateringDate'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['nextWateringDate']) 
          : null,
      isWatered: map['isWatered'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => toMap();
  factory Plant.fromJson(Map<String, dynamic> json) => Plant.fromMap(json);

  Plant copyWith({
    String? id,
    DateTime? createdAt,
    String? name,
    String? wateringFrequency,
    TimeOfDay? firstWateringTime,
    TimeOfDay? secondWateringTime,
    String? wateringType,
    String? lighting,
    String? temperature,
    String? ventilation,
    String? additionalInfo,
    DateTime? nextWateringDate,
    bool? isWatered,
  }) {
    return Plant(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      wateringFrequency: wateringFrequency ?? this.wateringFrequency,
      firstWateringTime: firstWateringTime ?? this.firstWateringTime,
      secondWateringTime: secondWateringTime ?? this.secondWateringTime,
      wateringType: wateringType ?? this.wateringType,
      lighting: lighting ?? this.lighting,
      temperature: temperature ?? this.temperature,
      ventilation: ventilation ?? this.ventilation,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      nextWateringDate: nextWateringDate ?? this.nextWateringDate,
      isWatered: isWatered ?? this.isWatered,
    );
  }

  // НОВЫЙ МЕТОД: Отмечает полив и считает следующую дату
  void markAsWatered() {
    isWatered = true;
    
    // Считаем, через сколько дней поливать в следующий раз
    int daysToAdd = 1; 
    if (wateringFrequency.contains('2 дня')) daysToAdd = 2;
    if (wateringFrequency.contains('2 раза')) daysToAdd = 0; // Если 2 раза в день, то сегодня же
    
    final now = DateTime.now();
    final hour = firstWateringTime?.hour ?? 10;
    final minute = firstWateringTime?.minute ?? 0;
    
    nextWateringDate = DateTime(now.year, now.month, now.day + daysToAdd, hour, minute);
  }
}