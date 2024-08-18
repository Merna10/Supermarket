import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/app/theme/colors.dart';
import 'package:market/modules/authentication/logic/bloc/auth_bloc.dart';
import 'package:market/modules/collection/logic/bloc/collection_bloc.dart';
import 'package:market/modules/collection/presentation/widgets/collection_card_widget.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<CollectionBloc>().add(FetchCollections());

    return BlocBuilder<CollectionBloc, CollectionState>(
      builder: (context, state) {
        if (state is CollectionLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        } else if (state is CollectionLoadedState) {
          final collections = state.collections;
          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authstate) {
              final canDelete = authstate is AuthAuthenticated &&
                  authstate.role == 'super_admin';
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: collections.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CollectionCard(
                      collection: collections[index],
                      canDelete: canDelete,
                    ),
                  );
                },
              );
            },
          );
        } else if (state is CollectionError) {
          return const Center(child: Text('Error'));
        }
        return  Container(
        );
      },
    );
  }
}
