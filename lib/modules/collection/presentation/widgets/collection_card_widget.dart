import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/core/enum/fetch_method.dart';
import 'package:market/modules/collection/data/models/collection.dart';
import 'package:market/modules/collection/logic/bloc/collection_bloc.dart';
import 'package:market/modules/products/presentation/screens/product_screen.dart';
import 'package:market/shared/widgets/scaffold_with_nav_bar.dart';

class CollectionCard extends StatelessWidget {
  final Collection collection;
  final bool canDelete;

  const CollectionCard({
    super.key,
    required this.collection,
    required this.canDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        if (canDelete) {
          _showDeleteConfirmationDialog(context);
        }
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScaffoldWithNavBar(
              child: ProductScreen(
                id: collection.id,
                fetchMethod: FetchMethod.byCollection,
              ),
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                child: Stack(
                  children: [
                    Image.network(
                      collection.imageUrl,
                      fit: BoxFit.cover,
                      height: double.infinity,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        color: const Color.fromARGB(137, 182, 172, 172),
                        child: Text(
                          collection.name,
                          style: GoogleFonts.playfairDisplay(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _sendNotificationToAdmin() async {
  //   const adminEmail = 'zefyiciyda@gufum.com';
  //   const subject = 'Product Out of Stock/Unavailable Notification';
  //   final body = 'Product ${collection.name} is out of stock or unavailable.';

  //   await ProductService().sendEmailNotification(adminEmail, subject, body);
  // }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Collection'),
          content:
              const Text('Are you sure you want to delete this collection?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<CollectionBloc>()
                    .add(RemoveCollectionItem(collection: collection));
             //   _sendNotificationToAdmin();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
