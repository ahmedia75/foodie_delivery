import 'package:flutter/material.dart';
import '../model/delivery_agent_order_model.dart';
import '../networking/api_service.dart';
import '../controller/order_controller.dart';
import '../controller/login_controller.dart';
import '../constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatelessWidget {
  final DeliveryAgentOrder order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundlightColor,
      appBar: AppBar(
        title: Text(
          'Order #${order.orderId}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.secondaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status Card
          _buildStatusCard(),
          const SizedBox(height: 16),

          // Update Proof Button for Dispatched Orders
          if (order.status == 'DISPATCHED') _buildUpdateProofButton(context),

          const SizedBox(height: 16),

          // Order Summary Card
          _buildOrderSummaryCard(),
          const SizedBox(height: 16),

          // Customer Info Card
          _buildCustomerCard(),
          const SizedBox(height: 16),

          // Delivery Address Card
          _buildDeliveryAddressCard(),
          const SizedBox(height: 16),

          // Items Card
          _buildItemsCard(),
          const SizedBox(height: 16),

          // Special Instructions Card
          if (order.specialInstructions.isNotEmpty)
            _buildSpecialInstructionsCard(),

          if (order.specialInstructions.isNotEmpty) const SizedBox(height: 16),

          // Timeline Card
          // _buildTimelineCard(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    Color statusColor;
    IconData statusIcon;
    Color backgroundColor;

    switch (order.status.toUpperCase()) {
      case 'PLACED':
        statusColor = const Color(0xFFE65100);
        backgroundColor = const Color(0xFFFFF3E0);
        statusIcon = Icons.schedule;
        break;
      case 'CONFIRMED':
        statusColor = const Color(0xFF1565C0);
        backgroundColor = const Color(0xFFE3F2FD);
        statusIcon = Icons.check_circle_outline;
        break;
      case 'COOKING':
        statusColor = const Color(0xFF2E7D32);
        backgroundColor = const Color(0xFFE8F5E9);
        statusIcon = Icons.restaurant;
        break;
      case 'DISPATCHED':
        statusColor = const Color(0xFF7B1FA2);
        backgroundColor = const Color(0xFFF3E5F5);
        statusIcon = Icons.delivery_dining;
        break;
      case 'DELIVERED':
        statusColor = const Color(0xFF2E7D32); // Using brand color as fallback
        backgroundColor = const Color(0xFFE8F5E9);
        statusIcon = Icons.done_all;
        break;
      case 'CANCELLED':
        statusColor = const Color(0xFFC62828);
        backgroundColor = const Color(0xFFFFEBEE);
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = const Color(0xFF616161);
        backgroundColor = const Color(0xFFF5F5F5);
        statusIcon = Icons.info;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(statusIcon, color: statusColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Status',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateProofButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.upload_file, size: 20),
        label: const Text(
          'Update Delivery Proof',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onPressed: () => _showProofDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryColor,
          foregroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return _buildCard(
      title: 'Order Summary',
      icon: Icons.receipt_long,
      children: [
        _buildSummaryRow('Order ID', '#${order.orderId}', isHighlighted: true),
        _buildSummaryRow('Payment Method', order.paymentMethod),
        _buildSummaryRow('Subtotal',
            '₹${(order.totalAmount - order.deliveryCharge - order.gstCharge!).toStringAsFixed(2)}'),
        _buildSummaryRow(
            'Delivery Charge', '₹${order.deliveryCharge.toStringAsFixed(2)}'),
        if ((order.gstCharge ?? 0) > 0)
          _buildSummaryRow(
              'GST Charge', '₹${order.gstCharge!.toStringAsFixed(2)}'),
        if ((order.discountAmount ?? 0) > 0)
          _buildSummaryRow('Reward Discount',
              '- ₹${order.discountAmount!.toStringAsFixed(2)}'),
        const Divider(height: 24),
        _buildSummaryRow(
            'Total Amount', '₹${order.totalAmount.toStringAsFixed(2)}',
            isTotal: true),
        const SizedBox(height: 8),
        // _buildSummaryRow('Created', _formatDateTime(order.createdAt)),
        // _buildSummaryRow('Last Updated', _formatDateTime(order.updatedAt)),
      ],
    );
  }

  Widget _buildCustomerCard() {
    return _buildCard(
      title: 'Customer Details',
      icon: Icons.person,
      children: [
        _buildSummaryRow(
          'Name',
          order.deliveryAddress.customerName.isNotEmpty
              ? order.deliveryAddress.customerName
              : order.customer.name!,

          // order.customer.name?.isNotEmpty == true
          //     ? order.customer.name!
          //     : 'Not provided'
        ),
        _buildPhoneRow(
            'Phone',
            order.deliveryAddress.receiverPhone.isNotEmpty
                ? order.deliveryAddress.receiverPhone
                : order.customer.number),

        // _buildSummaryRow(
        //     'Email',
        //     order.customer.email.isNotEmpty
        //         ? order.customer.email
        //         : 'Not provided'),
      ],
    );
  }

  Widget _buildDeliveryAddressCard() {
    return _buildCard(
      title: 'Delivery Address',
      icon: Icons.location_on,
      children: [
        _buildSummaryRow('Address',
            '${order.deliveryAddress.addressLine1}, ${order.deliveryAddress.addressLine2}, '),
        // _buildSummaryRow('City', order.deliveryAddress.city),
        // _buildSummaryRow('State', order.deliveryAddress.state),
        // _buildSummaryRow('Pincode', order.deliveryAddress.pincode),
        if (order.deliveryAddress.landmark.isNotEmpty)
          _buildSummaryRow('Landmark', order.deliveryAddress.landmark),
      ],
    );
  }

  Widget _buildItemsCard() {
    return _buildCard(
      title: 'Order Items',
      icon: Icons.restaurant_menu,
      children: [
        ...order.items.map((item) => _buildItemTile(item)).toList(),
      ],
    );
  }

  Widget _buildSpecialInstructionsCard() {
    return _buildCard(
      title: 'Special Instructions',
      icon: Icons.note,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.statusWaiting.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.statusWaiting.withOpacity(0.3)),
          ),
          child: Text(
            order.specialInstructions,
            style: const TextStyle(
              color: AppColors.statusWaiting,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.midtoneColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.secondaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isHighlighted = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textGray,
                fontWeight: FontWeight.w500,
                fontSize: isTotal ? 16 : 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isHighlighted || isTotal
                    ? FontWeight.bold
                    : FontWeight.w600,
                fontSize: isTotal ? 18 : 14,
                color: isTotal
                    ? AppColors.statusAccepted
                    : AppColors.secondaryColor,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneRow(String label, String phoneNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textGray,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    phoneNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.secondaryColor,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _makePhoneCall(phoneNumber),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.phone,
                      size: 16,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(OrderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgrounddarklightColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.midtoneColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.menuItem.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.secondaryColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Qty: ${item.quantity}',
                  style: const TextStyle(
                    color: AppColors.secondaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          // if (item.menuItem.description != null &&
          //     item.menuItem.description!.isNotEmpty)
          //   Padding(
          //     padding: const EdgeInsets.only(top: 4),
          //     child: Text(
          //       item.menuItem.description!,
          //       style: TextStyle(
          //         color: Colors.grey[600],
          //         fontSize: 13,
          //       ),
          //     ),
          //   ),
          if (item.variation != null && item.variation!.variationType != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.shadow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.shadow.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.tune, size: 16, color: AppColors.shadow),
                    const SizedBox(width: 6),
                    Text(
                      item.variation!.variationType!.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.shadow,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '₹${item.variation!.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.shadow,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Unit Price: ₹${item.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.textGray,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              Text(
                'Total: ₹${item.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.secondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Handle error - could show a snackbar or dialog
      debugPrint('Could not launch phone dialer');
    }
  }

  void _showProofDialog(BuildContext context) {
    final TextEditingController _controller =
        TextEditingController(text: order.deliveryProof ?? '');
    bool isLoading = false;
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(Icons.upload_file, color: AppColors.secondaryColor),
                  SizedBox(width: 8),
                  Text('Update Delivery Proof'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      // labelText: 'Proof (URL or Note)',
                      labelText: 'Add Proof',
                      // hintText: 'Enter delivery proof URL or note...',
                      hintText: 'Enter the proof message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.secondaryColor),
                      ),
                      filled: true,
                      fillColor: AppColors.backgrounddarklightColor,
                    ),
                    minLines: 3,
                    maxLines: 5,
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed:
                      isLoading ? null : () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    foregroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final proof = _controller.text.trim();
                          if (proof.isEmpty) return;
                          setState(() => isLoading = true);
                          final api =
                              Provider.of<ApiService>(context, listen: false);
                          final response = await api.put(
                            '/orders/${order.id}/delivery-proof',
                            body: {'proofUrl': proof},
                          );
                          setState(() => isLoading = false);
                          Navigator.of(context).pop();
                          if (response['success'] == true) {
                            // Refresh order list in home screen
                            final orderController =
                                Provider.of<OrderController>(context,
                                    listen: false);
                            final loginController =
                                Provider.of<LoginController>(context,
                                    listen: false);
                            final user = loginController.user;

                            if (user != null) {
                              // Refresh the order list to get latest data
                              await orderController.refreshOrders();
                            }

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      const Text('Proof updated successfully!'),
                                  backgroundColor: AppColors.statusAccepted,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );

                              // Navigate back to home screen to show updated data
                              Navigator.of(context).pop();
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(response['error'] ??
                                      'Failed to update proof'),
                                  backgroundColor: AppColors.statusRejected,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    foregroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: AppColors.primaryColor))
                      : Text((order.deliveryProof == null ||
                              order.deliveryProof!.isEmpty)
                          ? 'Submit'
                          : 'Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
