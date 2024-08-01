import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:market/modules/authentication/logic/bloc/auth_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Container(
            decoration: BoxDecoration(
              color: HexColor('f1efde'),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              'Flourish',
              style: GoogleFonts.playfairDisplay(
                textStyle:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 60,
              color: HexColor('f1efde'),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Your Orders'),
                    onTap: () {
                      Navigator.pushNamed(context, '/history');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () {
                      Navigator.pop(context);
                      context.read<AuthBloc>().add(AuthLogoutEvent());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
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
            
          ],
        ),
      ),
    );
  }
}
