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
    // Берем системный отступ снизу, чтобы на Samsung и iPhone меню стояло идеально
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      // Если снизу есть системная полоска (как на iPhone), добавляем её высоту. Иначе оставляем 16.
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding > 0 ? bottomPadding : 16),
      child: Container(
        height: 50, 
        decoration: BoxDecoration(
          color: AppColors.primaryGreen,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // Левая кнопка (Растения)
            Expanded(
              child: GestureDetector(
                onTap: () => onTap(0),
                behavior: HitTestBehavior.opaque,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (currentIndex == 0)
                      FractionallySizedBox(
                        widthFactor: 0.85, // 👈 Занимает 85% ширины от своей половины
                        child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    const Icon(
                      Icons.eco_outlined,
                      color: Colors.black,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
            // Правая кнопка (Календарь)
            Expanded(
              child: GestureDetector(
                onTap: () => onTap(1),
                behavior: HitTestBehavior.opaque,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (currentIndex == 1)
                      FractionallySizedBox(
                        widthFactor: 0.85, // 👈 То же самое для правой кнопки
                        child: Container(
                          height: 35, 
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
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
      ),
    );
  }
}