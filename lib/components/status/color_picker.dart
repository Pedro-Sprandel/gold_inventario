import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final String label;
  final List<Color> colors;
  final Color selectedColor;
  final void Function(Color) onChangeColor;

  const ColorPicker({
    super.key,
    required this.label,
    required this.colors,
    required this.selectedColor,
    required this.onChangeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 82,
          child: GridView.count(
            crossAxisCount: 8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              ...colors.map(
                (color) => ColorCard(
                  color: color,
                  isSelected: color.value == selectedColor.value,
                  onPressed: onChangeColor,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class ColorCard extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final Function(Color) onPressed;

  const ColorCard({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(color),
      style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color,
          border: isSelected
              ? Border.all(
                  color: color == Colors.black ? Colors.white : Colors.black,
                  width: 2,
                )
              : Border.all(color: color, width: 2),
        ),
      ),
    );
  }
}
