import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/modules/authentication/logic/bloc/auth_bloc.dart';
import 'package:market/modules/collection/presentation/screens/collection_screen.dart';
import 'package:market/modules/review/presentation/screens/reviews_screen.dart';
import 'package:market/shared/widgets/drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Flourish', style: AppTextStyles.textTheme.headlineMedium),
        backgroundColor: HexColor('f1efde'),
        elevation: 0,
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5),
            Stack(
              children: [
                Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/supermarket-bd53a.appspot.com/o/main%2FWhatsApp%20Image%202024-07-30%20at%2001.45.00_280f45eb.jpg?alt=media&token=93a8d9c2-eea0-46bb-bab3-6651977033cb',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                ),
                Positioned.fill(
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/categories');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            const Color.fromARGB(137, 182, 172, 172),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        'Shop Now',
                        style: GoogleFonts.playfairDisplay(
                          textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  'Believing that you deserve the perfect blend of elegance and comfort, and with an intimate knowledge of your preferences, needs, and desires, we have lovingly created our unique works of art.',
                  style: GoogleFonts.playfairDisplay(
                    textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Distribute space evenly
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/R.png',
                  width: MediaQuery.sizeOf(context).width * 0.26,
                ),
                Center(
                  child: Text(
                    'Collections',
                    style: AppTextStyles.textTheme.headlineMedium,
                  ),
                ),
                Image.asset(
                  'assets/images/L.png',
                  width: MediaQuery.sizeOf(context).width * 0.26,
                ),
              ],
            ),
            const SizedBox(height: 15),
            const SizedBox(
              height: 300,
              child: CollectionScreen(),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Distribute space evenly
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/R.png',
                  width: MediaQuery.sizeOf(context).width * 0.3,
                ),
                Center(
                  child: Text(
                    'Reviews',
                    style: AppTextStyles.textTheme.headlineMedium,
                  ),
                ),
                Image.asset(
                  'assets/images/L.png',
                  width: MediaQuery.sizeOf(context).width * 0.3,
                ),
              ],
            ),
            const SizedBox(
              height: 250,
              child: ReviewScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
