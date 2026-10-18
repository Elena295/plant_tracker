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
    );
  }
}