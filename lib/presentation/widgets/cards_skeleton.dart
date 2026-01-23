import 'package:flutter/material.dart';

class CardsSkeleton extends StatefulWidget {
  final int quantity;

  const CardsSkeleton({
    super.key,
    this.quantity = 5,
  });

  @override
  State<CardsSkeleton> createState() => _CardsSkeletonState();
}

class _CardsSkeletonState extends State<CardsSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.quantity,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return FadeTransition(
          opacity: _opacityAnimation,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Estructura de información simulada
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Simulación Nombre (animal.name)
                        _buildSkeletonBlock(width: 140, height: 16),
                        const SizedBox(height: 10),

                        // Simulación Código (animal.code)
                        _buildSkeletonBlock(width: 100, height: 14),
                        const SizedBox(height: 10),

                        // Simulación Sexo y Raza (animal.sex • animal.breed.name)
                        _buildSkeletonBlock(width: 180, height: 14),
                        const SizedBox(height: 10),

                        // Simulación Fila de Estado
                        Row(
                          children: [
                            _buildSkeletonBlock(width: 50, height: 14),
                            const SizedBox(width: 8),
                            // Simulación del Container del status
                            _buildSkeletonBlock(
                              width: 70,
                              height: 22,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Simulación de CustomActions (Iconos a la derecha)
                  Row(
                    children: [
                      _buildSkeletonBlock(width: 24, height: 24, isCircle: true),
                      const SizedBox(width: 8),
                      _buildSkeletonBlock(width: 24, height: 24, isCircle: true),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonBlock({
    required double width,
    required double height,
    BorderRadius? borderRadius,
    bool isCircle = false,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : (borderRadius ?? BorderRadius.circular(4)),
      ),
    );
  }
}