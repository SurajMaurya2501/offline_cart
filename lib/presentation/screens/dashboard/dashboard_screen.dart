import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_cart/presentation/controllers/cart_controller.dart';
import 'package:offline_cart/presentation/controllers/dashboard_controller.dart';
import 'package:offline_cart/presentation/controllers/favourites_controller.dart';
import 'package:offline_cart/presentation/screens/cart/cart_screen.dart';
import 'package:offline_cart/presentation/screens/dashboard/widgets/actions_section.dart';
import 'package:offline_cart/presentation/screens/dashboard/widgets/stats_section.dart';
import 'package:offline_cart/presentation/screens/dashboard/widgets/sync_card.dart';
import 'package:offline_cart/presentation/screens/dashboard/widgets/user_profile_card.dart';
import 'package:offline_cart/presentation/screens/favourites/favourites_screen.dart';
import 'package:offline_cart/presentation/widgets/sync_status_banner.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final DashboardController controller;
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final CartController _cartController;
  late final FavouritesController _favController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(DashboardController());
    _cartController = Get.put(CartController());
    _favController = Get.put(FavouritesController());

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Obx(
            () => IconButton(
              tooltip: 'Favourites',
              icon: Badge.count(
                offset: Offset(8, -8),
                textStyle: TextStyle(fontSize: 10),
                count: _favController.favourites.length,
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Color(0xFFE11D48),
                ),
              ),
              onPressed: () => Get.to(() => const FavouritesScreen()),
            ),
          ),
          Obx(
            () => IconButton(
              tooltip: 'Cart',
              icon: Badge.count(
                offset: Offset(8, -8),
                textStyle: TextStyle(fontSize: 10),
                count: _cartController.itemCount,
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Color(0xFF2563EB),
                ),
              ),
              onPressed: () => Get.to(() => const CartScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Logout',
            icon: Icon(Icons.logout_rounded, color: Colors.red.shade600),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: RefreshIndicator(
            onRefresh: controller.refreshData,
            color: const Color(0xFF2563EB),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserProfileCard(controller: controller),
                  const SizedBox(height: 20),
                  StatsSection(controller: controller),
                  const SizedBox(height: 16),
                  const SyncStatusBanner(),
                  SyncCard(controller: controller),
                  const SizedBox(height: 28),
                  ActionsSection(controller: controller),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
