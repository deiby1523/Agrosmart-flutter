import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';

class BackgroundBlobsRegister extends StatefulWidget {
  const BackgroundBlobsRegister({super.key});

  @override
  State<BackgroundBlobsRegister> createState() =>
      _BackgroundBlobsRegisterState();
}

class _BackgroundBlobsRegisterState extends State<BackgroundBlobsRegister>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var _isDesktop = Responsive.isDesktop(context);
    var _isTablet = Responsive.isTablet(context);

    return IgnorePointer(
      ignoring: true, // No interactuar con gestos
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Blob 1 - Superior izquierda (pequeña)
          Positioned(
            top: _isDesktop
                ? 100
                : _isTablet
                ? 80
                : 30,
            left: _isDesktop
                ? 100
                : _isTablet
                ? 60
                : 40,
            child: Blob.animatedRandom(
              size: _isDesktop
                  ? 240 * 2.5
                  : _isTablet
                  ? 200 * 2.5
                  : 160 * 2.5,
              edgesCount: 6,
              minGrowth: 3,
              duration: const Duration(seconds: 8),
              loop: true,
              styles: BlobStyles(
                color: theme.colorScheme.primary,
                fillType: BlobFillType.fill,
              ),
            ),
          ),

          // Blob 2 - Superior derecha (mediana)
          Positioned(
            top: _isDesktop
                ? 160
                : _isTablet
                ? 120
                : 100,
            right: _isDesktop
                ? 200
                : _isTablet
                ? 140
                : 80,
            child: Blob.animatedRandom(
              size: _isDesktop
                  ? 300 * 2.5
                  : _isTablet
                  ? 240 * 2.5
                  : 180 * 2.5,
              edgesCount: 7,
              minGrowth: 4,
              duration: const Duration(seconds: 10),
              loop: true,
              styles: BlobStyles(
                color: theme.colorScheme.secondary,
                fillType: BlobFillType.fill,
              ),
            ),
          ),

          // Blob 3 - Centro izquierda
          Positioned(
            top: _isDesktop
                ? 600
                : _isTablet
                ? 500
                : 400,
            left: _isDesktop
                ? 60
                : _isTablet
                ? 40
                : 30,
            child: Blob.animatedRandom(
              size: _isDesktop
                  ? 300 * 2.5
                  : _isTablet
                  ? 160 * 2.5
                  : 120 * 2.5,
              edgesCount: 5,
              minGrowth: 2,
              duration: const Duration(seconds: 7),
              loop: true,
              styles: BlobStyles(
                color: Colors.greenAccent,
                fillType: BlobFillType.fill,
              ),
            ),
          ),

          // Blob 4 - Centro derecha
          Positioned(
            top: _isDesktop
                ? 700
                : _isTablet
                ? 560
                : 440,
            right: _isDesktop
                ? 120
                : _isTablet
                ? 80
                : 50,
            child: Blob.animatedRandom(
              size: _isDesktop
                  ? 260 * 2.5
                  : _isTablet
                  ? 200 * 2.5
                  : 140 * 2.5,
              edgesCount: 8,
              minGrowth: 3,
              duration: const Duration(seconds: 9),
              loop: true,
              styles: BlobStyles(
                color: theme.colorScheme.primary,
                fillType: BlobFillType.fill,
              ),
            ),
          ),

          // Blob 5 - Inferior izquierda
          Positioned(
            bottom: _isDesktop
                ? 200
                : _isTablet
                ? 160
                : 120,
            left: _isDesktop
                ? 160
                : _isTablet
                ? 120
                : 80,
            child: Blob.animatedRandom(
              size: _isDesktop
                  ? 240 * 2.5
                  : _isTablet
                  ? 220 * 2.5
                  : 170 * 2.5,
              edgesCount: 6,
              minGrowth: 4,
              duration: const Duration(seconds: 11),
              loop: true,
              styles: BlobStyles(
                color: theme.colorScheme.secondary,
                fillType: BlobFillType.fill,
              ),
            ),
          ),

          // Blob 6 - Inferior derecha (extra para más densidad)
          Positioned(
            bottom: _isDesktop
                ? 120
                : _isTablet
                ? 80
                : 60,
            right: _isDesktop
                ? 140
                : _isTablet
                ? 100
                : 70,
            child: Blob.animatedRandom(
              size: _isDesktop
                  ? 180 * 2.5
                  : _isTablet
                  ? 140 * 2.5
                  : 100 * 2.5,
              edgesCount: 5,
              minGrowth: 2,
              duration: const Duration(seconds: 6),
              loop: true,
              styles: BlobStyles(
                color: Colors.greenAccent,
                fillType: BlobFillType.fill,
              ),
            ),
          ),

          // Blobs grandes originales de fondo (opcionales - mantener el fondo)
          // Positioned(
          //   bottom: _isDesktop
          //       ? -600
          //       : _isTablet
          //       ? -400
          //       : -300,
          //   left: _isDesktop
          //       ? -500
          //       : _isTablet
          //       ? -400
          //       : -300,
          //   child: Blob.animatedRandom(
          //     size: _isDesktop
          //         ? 1500
          //         : _isTablet
          //         ? 800
          //         : 700,
          //     edgesCount: 10,
          //     minGrowth: 4,
          //     duration: const Duration(seconds: 9),
          //     loop: true,
          //     styles: BlobStyles(
          //       fillType: BlobFillType.fill,
          //       gradient: LinearGradient(
          //         colors: [
          //           theme.colorScheme.primary.withOpacity(0.1),
          //           theme.colorScheme.secondary.withOpacity(0.1),
          //         ],
          //         begin: Alignment.topLeft,
          //         end: Alignment.bottomRight,
          //       ).createShader(const Rect.fromLTWH(0, 1000, 500, 500)),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   top: _isDesktop
          //       ? -700
          //       : _isTablet
          //       ? -300
          //       : -300,
          //   right: _isDesktop
          //       ? -500
          //       : _isTablet
          //       ? -300
          //       : -300,
          //   child: Blob.animatedRandom(
          //     size: _isDesktop
          //         ? 1500
          //         : _isTablet
          //         ? 800
          //         : 700,
          //     edgesCount: 10,
          //     minGrowth: 4,
          //     duration: const Duration(seconds: 12),
          //     loop: true,
          //     styles: BlobStyles(
          //       color: Colors.greenAccent.withOpacity(0.05),
          //       fillType: BlobFillType.fill,
          //       gradient: LinearGradient(
          //         colors: [
          //           theme.colorScheme.secondary.withOpacity(0.08),
          //           theme.colorScheme.primary.withOpacity(0.08),
          //         ],
          //         begin: Alignment.topRight,
          //         end: Alignment.bottomLeft,
          //       ).createShader(const Rect.fromLTWH(0, 500, 500, 500)),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
