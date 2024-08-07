import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/modules/collection/data/models/collection.dart';
import 'package:market/modules/products/presentation/screens/product_screen.dart';
import 'package:market/shared/widgets/scaffold_with_nav_bar.dart';

class CollectionCard extends StatelessWidget {
  final Collection collection;

  const CollectionCard({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
}
