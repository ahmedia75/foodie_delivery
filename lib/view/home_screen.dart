import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodie_delivery/constants/app_colors.dart';
import 'package:foodie_delivery/widgets/notification_badge.dart';
import 'package:provider/provider.dart';
import '../controller/login_controller.dart';
import '../controller/order_controller.dart';
import 'login_screen.dart';
import '../model/delivery_agent_order_model.dart';
import 'order_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  DateTime? _lastProfileFetch;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<LoginController>().user;
    final controller = context.read<LoginController>();
    final isAvailable = user?.isAvailable ?? false;
    final orderController = context.watch<OrderController>();

    // Fetch orders when Home tab is selected and user is available
    if (_currentIndex == 0 &&
        user != null &&
        !orderController.isLoading &&
        (orderController.lastFetchedAgentId != user.id ||
            orderController.lastFetchedDate != orderController.selectedDate)) {
      Future.microtask(() => orderController.fetchOrders(user.id!));
    }

    // Fetch profile data when Profile tab is selected
    if (_currentIndex == 1 &&
        user != null &&
        !controller.isLoading &&
        (_lastProfileFetch == null ||
            DateTime.now().difference(_lastProfileFetch!).inMinutes > 1)) {
      Future.microtask(() async {
        await controller.fetchLatestProfileData();
        _lastProfileFetch = DateTime.now();
      });
    }

    return Scaffold(
      backgroundColor: AppColors.backgrounddarklightColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        foregroundColor: AppColors.secondaryColor,
        title: Row(
          children: [
            // const Text(
            //   'Ahmedia',
            //   style: TextStyle(
            //       fontSize: 14,
            //       fontWeight: FontWeight.bold,
            //       color: AppColors.secondaryColor),
            // ),
            // const SizedBox(width: 2),

            SvgPicture.asset(
              'assets/logo/Ahmedia_Delivery_Logo.svg',
              height: 28,
              errorBuilder: (_, __, ___) => const Icon(Icons.delivery_dining,
                  color: AppColors.secondaryColor),
            ),
            // const SizedBox(width: 2),
            // const Text(
            //   'Agent',
            //   style: TextStyle(
            //       fontSize: 14,
            //       fontWeight: FontWeight.bold,
            //       color: AppColors.secondaryColor),
            // ),
          ],
        ),
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () async {
                  final result =
                      await controller.toggleAvailability(!isAvailable);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result == true
                              ? 'Agent is active'
                              : result == false
                                  ? 'Agent is inactive'
                                  : 'Failed to update availability',
                        ),
                        backgroundColor: result == true
                            ? AppColors.statusAccepted
                            : result == false
                                ? AppColors.statusRejected
                                : AppColors.statusWaiting,
                      ),
                    );
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: isAvailable
                        ? AppColors.statusAccepted.withOpacity(0.1)
                        : AppColors.statusRejected.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isAvailable
                          ? AppColors.statusAccepted
                          : AppColors.statusRejected,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isAvailable ? Icons.check_circle : Icons.cancel,
                        color: isAvailable
                            ? AppColors.statusAccepted
                            : AppColors.statusRejected,
                        size: 20,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        isAvailable ? 'Active' : 'Inactive',
                        style: TextStyle(
                          color: isAvailable
                              ? AppColors.statusAccepted
                              : AppColors.statusRejected,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 3),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 36,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isAvailable
                              ? AppColors.statusAccepted
                              : AppColors.statusRejected,
                        ),
                        child: Align(
                          alignment: isAvailable
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.secondaryColor.withOpacity(0.1),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const Padding(
            padding: EdgeInsets.only(right: 8, top: 4),
            child: NotificationBadge(
              backgroundColor: AppColors.offers,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.secondaryColor),
            onPressed: () async {
              await context.read<LoginController>().logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: _currentIndex == 1
          ? controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : controller.error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppColors.statusRejected,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Error loading profile',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.statusRejected,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.statusRejected,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              await controller.fetchLatestProfileData();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.secondaryColor
                                      .withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 36,
                                    backgroundColor: AppColors.secondaryColor,
                                    child: Text(
                                      (user?.name?.isNotEmpty == true
                                          ? user!.name![0].toUpperCase()
                                          : '?'),
                                      style: const TextStyle(
                                          fontSize: 32,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    user?.name ?? 'N/A',
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        isAvailable
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: isAvailable
                                            ? AppColors.statusAccepted
                                            : AppColors.statusRejected,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        isAvailable ? 'Active' : 'Inactive',
                                        style: TextStyle(
                                          color: isAvailable
                                              ? AppColors.statusAccepted
                                              : AppColors.statusRejected,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Profile Info
                          _sectionCard(
                            title: 'Profile',
                            icon: Icons.person,
                            children: [
                              _infoTile(
                                  Icons.phone, 'Phone', user?.phone ?? 'N/A'),
                              _infoTile(Icons.home, 'Address',
                                  user?.address ?? 'N/A'),
                              _infoTile(Icons.location_city, 'Branch',
                                  user?.branchId?.name ?? 'N/A'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _sectionCard(
                            title: 'Vehicle',
                            icon: Icons.directions_bike,
                            children: [
                              _infoTile(
                                  Icons.confirmation_number,
                                  'Vehicle Number',
                                  user?.vehicleNumber ?? 'N/A'),
                              _infoTile(Icons.directions_car, 'Vehicle Model',
                                  user?.vehicleModel ?? 'N/A'),
                              _infoTile(Icons.category, 'Vehicle Type',
                                  user?.vehicleType ?? 'N/A'),
                              _infoTile(Icons.badge, 'License Number',
                                  user?.licenseNumber ?? 'N/A'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _sectionCard(
                            title: 'Statistics',
                            icon: Icons.bar_chart,
                            children: [
                              _infoTile(
                                  Icons.assignment_turned_in,
                                  'Total Deliveries',
                                  user?.totalDeliveries?.toString() ?? '0'),
                              // _infoTile(Icons.today, 'Daily Deliveries',
                              //     user?.dailyDeliveries?.toString() ?? '0'),
                              _infoTile(
                                Icons.toggle_on,
                                'Status',
                                isAvailable ? 'Available' : 'Not Available',
                                valueColor: isAvailable
                                    ? AppColors.statusAccepted
                                    : AppColors.statusRejected,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
          : _buildOrdersTab(orderController, user),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) async {
          setState(() {
            _currentIndex = index;
          });

          // Fetch profile data when profile tab is tapped
          if (index == 1 && user != null && !controller.isLoading) {
            await controller.fetchLatestProfileData();
            _lastProfileFetch = DateTime.now();
          }
        },
        selectedItemColor: AppColors.secondaryColor,
        unselectedItemColor: AppColors.textGray,
        backgroundColor: AppColors.primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(
      {required String title,
      required IconData icon,
      required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.secondaryColor, size: 22),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textGray, size: 20),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: AppColors.secondaryColor),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppColors.secondaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersTab(OrderController orderController, user) {
    // Always default to today if no date is selected
    DateTime today = DateTime.now();
    DateTime? selectedDate = orderController.selectedDate ?? today;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.secondaryColor,
                    backgroundColor: AppColors.primaryColor,
                  ),
                  icon: const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: AppColors.secondaryColor,
                  ),
                  label: Text(
                    '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryColor),
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2023, 1, 1),
                      lastDate: today, // Only allow today and past
                      selectableDayPredicate: (date) => !date.isAfter(today),
                    );
                    if (picked != null && picked != selectedDate) {
                      await orderController.fetchOrders(
                        user.id!,
                        date: picked,
                        append: false,
                      );
                    }
                  },
                ),
              ),
              if (orderController.selectedDate != null &&
                  orderController.selectedDate != today)
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.red),
                  tooltip: 'Clear date filter',
                  onPressed: () async {
                    orderController.clearDateFilter();
                    await orderController.fetchOrders(user.id!,
                        date: today, append: false);
                  },
                ),
            ],
          ),
        ),
        Expanded(
          child: _ordersList(orderController, user),
        ),
      ],
    );
  }

  Widget _ordersList(OrderController orderController, user) {
    if (orderController.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (orderController.error != null) {
      return const Center(
          // child: Text(orderController.error!,
          child: Text('Error loading orders',
              style: TextStyle(color: AppColors.statusRejected)));
    }
    if (orderController.orders.isEmpty) {
      return const Center(
          child: Text('No orders found.', style: TextStyle(fontSize: 16)));
    }
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            await orderController.refreshOrders();
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!orderController.isLoadingMore &&
                  orderController.currentPage < orderController.totalPages &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 100) {
                orderController.fetchNextPage();
              }
              return false;
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orderController.orders.length +
                  (orderController.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < orderController.orders.length) {
                  final order = orderController.orders[index];
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => OrderDetailsScreen(order: order),
                        ),
                      );
                      // Refresh orders when returning from order details
                      if (user != null) {
                        await orderController.refreshOrders();
                      }
                    },
                    child: _orderCard(order),
                  );
                } else {
                  // Loading indicator at the bottom
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                        child: CircularProgressIndicator(
                      color: AppColors.secondaryColor,
                    )),
                  );
                }
              },
            ),
          ),
        ),
        if (orderController.totalPages > 1)
          Positioned(
            bottom: 24,
            right: 24,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.midtoneColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondaryColor.withOpacity(0.08),
                    blurRadius: 8,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: orderController.currentPage > 1 &&
                            !orderController.isLoading
                        ? () {
                            orderController.fetchOrders(user.id!,
                                page: orderController.currentPage - 1,
                                append: false,
                                date: orderController.selectedDate);
                          }
                        : null,
                  ),
                  ..._buildPageButtons(orderController, user),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: orderController.currentPage <
                                orderController.totalPages &&
                            !orderController.isLoading
                        ? () {
                            orderController.fetchOrders(user.id!,
                                page: orderController.currentPage + 1,
                                append: false,
                                date: orderController.selectedDate);
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildPageButtons(OrderController orderController, user) {
    const int maxButtons = 5;
    int startPage = (orderController.currentPage - (maxButtons ~/ 2)).clamp(
        1,
        (orderController.totalPages - maxButtons + 1)
            .clamp(1, orderController.totalPages));
    int endPage =
        (startPage + maxButtons - 1).clamp(1, orderController.totalPages);
    if (endPage - startPage + 1 < maxButtons) {
      startPage =
          (endPage - maxButtons + 1).clamp(1, orderController.totalPages);
    }
    List<Widget> buttons = [];
    for (int i = startPage; i <= endPage; i++) {
      buttons.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(36, 36),
              padding: EdgeInsets.zero,
              backgroundColor: i == orderController.currentPage
                  ? AppColors.secondaryColor
                  : AppColors.backgrounddarklightColor,
              foregroundColor: i == orderController.currentPage
                  ? AppColors.primaryColor
                  : AppColors.secondaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              elevation: 0,
            ),
            onPressed:
                i == orderController.currentPage || orderController.isLoading
                    ? null
                    : () {
                        orderController.fetchOrders(user.id!,
                            page: i, append: false);
                      },
            child:
                Text('$i', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      );
    }
    return buttons;
  }

  Widget _orderCard(DeliveryAgentOrder order) {
    Color statusColor;
    Color backgroundColor;

    switch (order.status.toUpperCase()) {
      case 'PLACED':
        statusColor = const Color(0xFFE65100);
        backgroundColor = const Color(0xFFFFF3E0);
        break;
      case 'CONFIRMED':
        statusColor = const Color(0xFF1565C0);
        backgroundColor = const Color(0xFFE3F2FD);
        break;
      case 'COOKING':
        statusColor = const Color(0xFF2E7D32);
        backgroundColor = const Color(0xFFE8F5E9);
        break;
      case 'DISPATCHED':
        statusColor = const Color(0xFF7B1FA2);
        backgroundColor = const Color(0xFFF3E5F5);
        break;
      case 'DELIVERED':
        statusColor = const Color(0xFF2e7d32);
        backgroundColor = const Color(0xFFe8f5e9);
        break;
      case 'CANCELLED':
        statusColor = const Color(0xFFC62828);
        backgroundColor = const Color(0xFFFFEBEE);
        break;
      default:
        statusColor = const Color(0xFF616161);
        backgroundColor = const Color(0xFFF5F5F5);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  order.orderId,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 18, color: AppColors.textGray),
                const SizedBox(width: 6),
                Text(
                    order.customer.name?.isNotEmpty == true
                        ? order.customer.name!
                        : order.customer.number,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                const Spacer(),
                Text('${order.items.length} item(s)',
                    style: const TextStyle(color: AppColors.textGray)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on,
                    size: 18, color: AppColors.textGray),
                const SizedBox(width: 6),
                Expanded(
                    child: Text(order.deliveryAddress.addressLine1,
                        style:
                            const TextStyle(color: AppColors.secondaryColor))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.attach_money,
                    size: 18, color: AppColors.textGray),
                const SizedBox(width: 6),
                Text('₹${order.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(order.paymentMethod,
                    style: const TextStyle(color: AppColors.textGray)),
              ],
            ),
            if (order.specialInstructions.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.notes,
                      size: 18, color: AppColors.statusWaiting),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Text(order.specialInstructions,
                          style:
                              const TextStyle(color: AppColors.statusWaiting))),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time,
                    size: 16, color: AppColors.textGray),
                const SizedBox(width: 4),
                Text(
                    'Placed: ${order.createdAt.toLocal().toString().substring(0, 16)}',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textGray)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
