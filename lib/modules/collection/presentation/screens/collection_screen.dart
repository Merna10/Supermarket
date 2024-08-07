import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:market/modules/collection/logic/bloc/collection_bloc.dart';
import 'package:market/modules/collection/presentation/widgets/collection_card_widget.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionBloc, CollectionState>(
      builder: (context, state) {
        if (state is CollectionInitial) {
          context.read<CollectionBloc>().add(FetchCollections());
          return const Center(child: CircularProgressIndicator());
        } else if (state is CollectionLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: HexColor('f1efde'),
            ),
          );
        } else if (state is CollectionLoaded) {
          final collections = state.collections;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: collections.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CollectionCard(collection: collections[index]),
              );
            },
          );
        } else if (state is CollectionError) {
          return Center(child: Text('Error: ${state.error}'));
        }
        return Container();
      },
    );
  }
}
