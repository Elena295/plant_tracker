import 'package:flutter/material.dart';
import '../utils/constants.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      height: 50, // Общая высота меню
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Кнопка "Растения" (Листик)
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Белый фон с ЖЕСТКИМИ размерами
                  if (currentIndex == 0)
                    Container(
                      width: 160,  // ← МЕНЯЙ ШИРИНУ ЗДЕСЬ (чем больше число, тем шире)
                      height: 35,  // ← МЕНЯЙ ВЫСОТУ ЗДЕСЬ (чем больше число, тем выше)
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  // Иконка поверх фона
                  const Icon(
                    Icons.eco_outlined,
                    color: Colors.black,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          // Кнопка "Календарь"
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(1),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Белый фон с ЖЕСТКИМИ размерами
                  if (currentIndex == 1)
                    Container(
                      width: 160,  // ← То же самое число, что и выше
                      height: 35,  // ← То же самое число, что и выше
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  // Иконка поверх фона
                  const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.black,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}