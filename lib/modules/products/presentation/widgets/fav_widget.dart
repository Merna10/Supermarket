import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/modules/authentication/logic/bloc/auth_bloc.dart';
import 'package:market/modules/products/data/models/product.dart';
import 'package:market/modules/products/logic/bloc/product_bloc.dart';

import 'package:market/core/enum/fetch_method.dart';

class FavWidget extends StatefulWidget {
  final Product product;
  final FetchMethod fetchMethod;

  const FavWidget({
    super.key,
    required this.product,
    required this.fetchMethod,
  });

  @override
  State<FavWidget> createState() => _FavWidgetState();
}

class _FavWidgetState extends State<FavWidget> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckStatusEvent());

    _checkIfFavorite();
  }

  void _checkIfFavorite() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    final userId = user.uid;
    BlocProvider.of<ProductBloc>(context).add(CheckIfFavorite(
      userId: userId,
      productId: widget.product.id,
      method: widget.fetchMethod,
      fetchId: widget.fetchMethod == FetchMethod.byCollection
          ? widget.product.collectionID
          : widget.product.categoryID,
    ));
  }

  void _toggleFavorite() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final event = _isFavorite
        ? RemoveFromFavorites(
            userId: userId,
            product: widget.product,
            method: widget.fetchMethod,
            fetchId: widget.fetchMethod == FetchMethod.byCollection
                ? widget.product.collectionID
                : widget.product.categoryID)
        : AddToFavorites(
            userId: userId,
            product: widget.product,
            method: widget.fetchMethod,
            fetchId: widget.fetchMethod == FetchMethod.byCollection
                ? widget.product.collectionID
                : widget.product.categoryID);

    BlocProvider.of<ProductBloc>(context).add(event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, stateAuth) {
        return BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is FavoriteStatus) {
              print('FavoriteStatus received: ${state.isFavorite}');
              setState(() {
                _isFavorite = state.isFavorite;
              });
            }
          },
          builder: (context, state) {
            return IconButton(
              icon: Icon(
                size: 35,
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                if (stateAuth is AuthAuthenticated) {
                  if (stateAuth.role == 'customer') {
                    _toggleFavorite();
                  }
                  if (stateAuth.role != 'customer') {
                    _showErrorRequiredMessage(context);
                  }
                } else if (stateAuth is AuthUnauthenticated) {
                  _showLoginRequiredMessage(context);
                }
              },
            );
          },
        );
      },
    );
  }

  void _showErrorRequiredMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You must Be Customer to add favorites.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showLoginRequiredMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You must log in to add favorites.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
