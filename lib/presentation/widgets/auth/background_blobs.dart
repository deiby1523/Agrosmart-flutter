import 'dart:developer';

import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';

class BackgroundBlobs extends StatefulWidget {
  const BackgroundBlobs({super.key});

  @override
  State<BackgroundBlobs> createState() => _BackgroundBlobsState();
}

class _BackgroundBlobsState extends State<BackgroundBlobs> 
    with SingleTickerProviderStateMixin {
  
  // late final bool _isDesktop;
  // late final bool _isTablet;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-calcular valores responsivos una sola vez
      // _isDesktop = Responsive.isDesktop(context);
      // _isTablet = Responsive.isTablet(context);
  }

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
          Positioned(
            bottom: _isDesktop ? -600 : _isTablet ? -400 : -300,
            left: _isDesktop ? -500 : _isTablet ? -400 : -300,
            child: Blob.animatedRandom(
              size: _isDesktop ? 1500 : _isTablet ? 800 : 700,
              edgesCount: 10,
              minGrowth: 4,
              duration: const Duration(seconds: 9),
              loop: true,
              styles: BlobStyles(
                fillType: BlobFillType.fill,
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(const Rect.fromLTWH(0, 1000, 500, 500)),
              ),
            ),
          ),
          Positioned(
            top: _isDesktop ? -700 : _isTablet ? -300 : -300,
            right: _isDesktop ? -500 : _isTablet ? -300 : -300,
            child: Blob.animatedRandom(
              size: _isDesktop ? 1500 : _isTablet ? 800 : 700,
              edgesCount: 10,
              minGrowth: 4,
              duration: const Duration(seconds: 12),
              loop: true,
              styles: BlobStyles(
                color: Colors.greenAccent.shade100,
                fillType: BlobFillType.fill,
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.secondary,
                    theme.colorScheme.primary,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ).createShader(const Rect.fromLTWH(0, 500, 500, 500)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}