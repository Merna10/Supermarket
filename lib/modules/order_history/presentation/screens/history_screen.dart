import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:market/shared/models/order_list.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/modules/order_history/logic/bloc/history_bloc.dart';
import 'package:market/modules/order_history/presentation/widgets/order_card_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Orders',
            style: AppTextStyles.textTheme.headlineMedium,
          ),
        ),
        backgroundColor: HexColor('f1efde'),
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryInitial) {
            context.read<HistoryBloc>().add(FetchOrders());
            return Center(
                child: CircularProgressIndicator(
              color: HexColor('f1efde'),
            ));
          } else if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistoryLoaded) {
            if (state.orders.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/—Pngtree—vector sad emoji icon_4186900.png',
                    fit: BoxFit.cover,
                  ),
                  Text(
                    'You didn\'t order anything yet.',
                    style: AppTextStyles.textTheme.displaySmall,
                  ),
                ],
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
          } else if (state is HistoryError) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return Container();
        },
      ),
    );
  }
}
