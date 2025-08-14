import 'package:flutter/material.dart';
import '../model/delivery_agent_order_model.dart';
import '../networking/api_service.dart';

class OrderController extends ChangeNotifier {
  final ApiService apiService;
  List<DeliveryAgentOrder> orders = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  String? error;
  int currentPage = 1;
  int totalPages = 1;
  int limit = 5;
  String? _lastAgentId;
  DateTime? selectedDate;
  String? lastFetchedAgentId;
  DateTime? lastFetchedDate;

  OrderController(this.apiService);

  Future<void> fetchOrders(String agentId,
      {int page = 1, bool append = false, DateTime? date}) async {
    if (!append) {
      isLoading = true;
      error = null;
      currentPage = page;
      totalPages = 1;
      orders = [];
      _lastAgentId = agentId;
      if (date != null) selectedDate = date;
      lastFetchedAgentId = agentId;
      lastFetchedDate = date ?? selectedDate;
      notifyListeners();
    } else {
      isLoadingMore = true;
      notifyListeners();
    }
    try {
      String url = '/delivery-agents/$agentId/orders?page=$page&limit=$limit';
      final filterDate = date ?? selectedDate;
      if (filterDate != null) {
        final dateStr =
            "${filterDate.year.toString().padLeft(4, '0')}-${filterDate.month.toString().padLeft(2, '0')}-${filterDate.day.toString().padLeft(2, '0')}";
        url += '&date=$dateStr';
      }
      final response = await apiService.get(url);
      if (response['success'] == true && response['data'] != null) {
        final parsed = DeliveryAgentOrderListResponse.fromMap(response);
        int pageCount = parsed.data?.pageCount ?? 1;
        totalPages = pageCount == 0 ? 1 : pageCount;
        currentPage = page;
        if (append) {
          orders.addAll(parsed.data?.orders ?? []);
        } else {
          orders = parsed.data?.orders ?? [];
        }
      } else {
        error = response['error'] ?? 'Failed to fetch orders';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> fetchNextPage() async {
    if (_lastAgentId == null) return;
    if (isLoadingMore || currentPage >= totalPages) return;
    await fetchOrders(_lastAgentId!,
        page: currentPage + 1, append: true, date: selectedDate);
  }

  Future<void> refreshOrders() async {
    if (_lastAgentId == null) return;
    await fetchOrders(_lastAgentId!,
        page: 1, append: false, date: selectedDate);
  }

  void clearDateFilter() {
    selectedDate = null;
    notifyListeners();
  }
}
