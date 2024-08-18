import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/app/theme/colors.dart';
import 'package:market/modules/authentication/logic/bloc/auth_bloc.dart';
import 'package:market/shared/models/order_list.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/modules/order_history/logic/bloc/history_bloc.dart';
import 'package:market/modules/order_history/presentation/widgets/order_card_widget.dart';

class HistoryScreen extends StatefulWidget {
  final String id;
  const HistoryScreen({
    super.key,
    required this.id,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckStatusEvent());
  }

  void _onStatusChanged(String status) {
    setState(() {
      _selectedStatus = status;
      _fetchOrders();
    });
  }

  void _fetchOrders() {
    if (context.read<AuthBloc>().state is AuthAuthenticated) {
      final authState = context.read<AuthBloc>().state as AuthAuthenticated;
      if (authState.role == 'customer') {
        context
            .read<HistoryBloc>()
            .add(FetchUserOrders(userId: widget.id, status: _selectedStatus));
      } else if (authState.role == 'super_admin') {
        context.read<HistoryBloc>().add(FetchOrders(status: _selectedStatus));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, stateAuth) {
        if (stateAuth is AuthInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (stateAuth is AuthAuthenticated) {
          _fetchOrders();
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Center(
                child: Text(
                  'Orders',
                  style: AppTextStyles.textTheme.headlineMedium,
                ),
              ),
              backgroundColor: AppColors.primaryColor,
            ),
            body: Column(
              children: [
                _buildStatusFilterRow(),
                Expanded(
                  child: BlocBuilder<HistoryBloc, HistoryState>(
                    builder: (context, state) {
                      if (state is HistoryLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is HistoryLoadedList) {
                        if (state.orders.isEmpty) {
                          return Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/—Pngtree—vector sad emoji icon_4186900.png',
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'You didn\'t order anything yet.',
                                  style: AppTextStyles.textTheme.displaySmall,
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: state.orders.length,
                          itemBuilder: (context, index) {
                            OrderList order = state.orders[index];
                            return OrderCard(orderList: order);
                          },
                        );
                      } else if (state is HistoryErrors) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Error: ${state.error}'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  _fetchOrders();
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }
                      return const Center(child: Text('No data available'));
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return const Center(child: Text('Unauthorized access'));
      },
    );
  }

  Widget _buildStatusFilterRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildStatusButton('All'),
            _buildStatusButton('Placed'),
            _buildStatusButton('Processing'),
            _buildStatusButton('Shipping'),
            _buildStatusButton('Completed'),
            _buildStatusButton('Return'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: () => _onStatusChanged(status),
        child: Text(
          status,
          style: TextStyle(
            color: _selectedStatus == status
                ? AppColors.accentColor
                : Colors.black,
            fontWeight:
                _selectedStatus == status ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
