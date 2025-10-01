import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360 || size.height < 640;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6), Color(0xFF60A5FA)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 16 : 20,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          // Logo Section
                          Expanded(
                            flex: isSmallScreen ? 6 : 7,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildAnimatedLogo(isSmallScreen),
                                  SizedBox(height: isSmallScreen ? 20 : 30),
                                  _buildTitleSection(isSmallScreen),
                                ],
                              ),
                            ),
                          ),

                          // Loading Section
                          Expanded(flex: 2, child: _buildLoadingSection()),

                          // Bottom Section
                          Expanded(
                            flex: 1,
                            child: _buildBottomSection(isSmallScreen),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo(bool isSmallScreen) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1500),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Transform.rotate(
            angle: (1 - value) * 2,
            child: Hero(
              tag: 'smk_logo',
              child: Container(
                padding: EdgeInsets.all(isSmallScreen ? 15 : 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: isSmallScreen ? 15 : 25,
                      spreadRadius: isSmallScreen ? 3 : 5,
                      offset: Offset(0, isSmallScreen ? 8 : 15),
                    ),
                  ],
                ),
                child: Container(
                  width: isSmallScreen ? 60 : 80,
                  height: isSmallScreen ? 60 : 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1E3A8A), Color(0xFFFBBF24)],
                    ),
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: isSmallScreen ? 30 : 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleSection(bool isSmallScreen) {
    return TweenAnimationBuilder<Offset>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: const Offset(0, 50), end: const Offset(0, 0)),
      curve: Curves.easeOutBack,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: offset,
          child: Opacity(
            opacity: offset == const Offset(0, 0) ? 1.0 : 0.0,
            child: Column(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Perpustakaan Digital',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 24 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'SMK ASSALAAM BANDUNG',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFBBF24),
                      letterSpacing: isSmallScreen ? 1 : 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12 : 20,
                    vertical: isSmallScreen ? 6 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFFBBF24).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    'Akses koleksi buku digital terlengkap',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 800),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.library_books_rounded,
                    color: Color(0xFFFBBF24),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Memuat perpustakaan...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 280),
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Obx(
                () => AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width:
                      (MediaQuery.of(Get.context!).size.width - 40).clamp(
                        0,
                        280,
                      ) *
                      controller.progress.value,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFBBF24), Color(0xFFFCD34D)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFBBF24).withOpacity(0.6),
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Obx(
          () => Text(
            '${(controller.progress.value * 100).toInt()}%',
            style: const TextStyle(
              color: Color(0xFFFBBF24),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection(bool isSmallScreen) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1200),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 20,
                  vertical: isSmallScreen ? 8 : 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFFFBBF24).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.school_rounded,
                      color: const Color(0xFFFBBF24),
                      size: isSmallScreen ? 16 : 18,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'SMK ASSALAAM BANDUNG',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 12 : 14,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 800 + (index * 150)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, -6 * value),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBBF24).withOpacity(0.8),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFBBF24).withOpacity(0.4),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
        const SizedBox(height: 10),
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1000),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: Text(
                'Version 1.0.0 • Perpustakaan Digital',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: isSmallScreen ? 10 : 11,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
