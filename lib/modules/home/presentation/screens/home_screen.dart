import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/app/theme/colors.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/modules/authentication/logic/bloc/auth_bloc.dart';
import 'package:market/modules/collection/data/models/collection.dart';
import 'package:market/modules/collection/logic/bloc/collection_bloc.dart';
import 'package:market/modules/collection/presentation/screens/collection_screen.dart';
import 'package:market/modules/review/presentation/screens/reviews_screen.dart';
import 'package:market/shared/widgets/drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String bannerImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/supermarket-bd53a.appspot.com/o/main%2FWhatsApp%20Image%202024-07-30%20at%2001.45.00_280f45eb.jpg?alt=media&token=93a8d9c2-eea0-46bb-bab3-6651977033cb';
  File? _selectedImageFile;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckStatusEvent());
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AuthAuthenticated) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Flourish',
                  style: AppTextStyles.textTheme.headlineMedium),
              backgroundColor: AppColors.primaryColor,
              elevation: 0,
              actions: [
                if (state.role == 'customer')
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/favorites'),
                    icon: const Icon(Icons.favorite),
                  ),
              ],
            ),
            drawer: const CustomDrawer(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  _buildBanner(),
                  const SizedBox(height: 12),
                  _buildIntroduction(),
                  const SizedBox(height: 15),
                  _buildCollectionsHeader(state),
                  const SizedBox(height: 15),
                  const SizedBox(height: 300, child: CollectionScreen()),
                  const SizedBox(height: 10),
                  _buildReviewsHeader(),
                  const SizedBox(height: 250, child: ReviewScreen()),
                ],
              ),
            ),
          );
        }
        if (state is AuthUnauthenticated) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Flourish',
                  style: AppTextStyles.textTheme.headlineMedium),
              backgroundColor: AppColors.primaryColor,
              elevation: 0,
            ),
            drawer: const CustomDrawer(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  _buildBanner(),
                  const SizedBox(height: 12),
                  _buildIntroduction(),
                  const SizedBox(height: 15),
                  _buildCollectionsHeaderUnAuth(),
                  const SizedBox(height: 15),
                  const SizedBox(height: 300, child: CollectionScreen()),
                  const SizedBox(height: 10),
                  _buildReviewsHeader(),
                  const SizedBox(height: 250, child: ReviewScreen()),
                ],
              ),
            ),
          );
        }

        return const Center(child: Text('Something went wrong!'));
      },
    );
  }

  Widget _buildBanner() {
    return Stack(
      children: [
        Image.network(
          bannerImageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 250,
        ),
        Positioned.fill(
          child: Center(
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, '/categories'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(137, 182, 172, 172),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
    );
  }

  Widget _buildIntroduction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: Text(
          'Believing that you deserve the perfect blend of elegance and comfort, and with an intimate knowledge of your preferences, needs, and desires, we have lovingly created our unique works of art.',
          style: GoogleFonts.playfairDisplay(
            textStyle: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCollectionsHeader(AuthAuthenticated state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Image.asset(
            'assets/images/R.png',
            width: MediaQuery.of(context).size.width * 0.26,
          ),
        ),
        Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Collections',
                  style: AppTextStyles.textTheme.headlineMedium),
              if (state.role == 'super_admin')
                IconButton(
                  onPressed: _showAddCollectionDialog,
                  icon: const Icon(Icons.add),
                  color: AppColors.accentColor,
                ),
            ],
          ),
        ),
        Flexible(
          child: Image.asset(
            'assets/images/L.png',
            width: MediaQuery.of(context).size.width * 0.26,
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionsHeaderUnAuth() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Image.asset(
            'assets/images/R.png',
            width: MediaQuery.of(context).size.width * 0.26,
          ),
        ),
        Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Collections',
                  style: AppTextStyles.textTheme.headlineMedium),
            ],
          ),
        ),
        Flexible(
          child: Image.asset(
            'assets/images/L.png',
            width: MediaQuery.of(context).size.width * 0.26,
          ),
        ),
      ],
    );
  }

  void _showAddCollectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Collection'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration:
                          const InputDecoration(labelText: 'Collection Name'),
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);

                        if (pickedFile != null) {
                          setState(() {
                            _selectedImageFile = File(pickedFile.path);
                          });
                        }
                      },
                      child: const Text('Pick Image from Gallery'),
                    ),
                    if (_selectedImageFile != null)
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          Image.file(
                            _selectedImageFile!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Selected Image: ${_selectedImageFile!.path.split('/').last}',
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final name = _nameController.text.trim();
                    final description = _descriptionController.text.trim();
                    final imageFile = _selectedImageFile;

                    if (name.isNotEmpty) {
                      final newCollection = Collection(
                        id: const Uuid().v4(),
                        name: name,
                        imageUrl: '', // URL will be set later if needed
                        dateAdded: DateTime.now(),
                        description: description,
                      );
                      context.read<CollectionBloc>().add(AddCollectionItem(
                          collection: newCollection, imageFile: imageFile));
                    }

                    _nameController.clear();
                    _descriptionController.clear();
                    setState(() {
                      _selectedImageFile = null;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildReviewsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/R.png',
          width: MediaQuery.of(context).size.width * 0.3,
        ),
        Center(
          child: Text('Reviews', style: AppTextStyles.textTheme.headlineMedium),
        ),
        Image.asset(
          'assets/images/L.png',
          width: MediaQuery.of(context).size.width * 0.3,
        ),
      ],
    );
  }
}
