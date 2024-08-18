import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market/app/theme/colors.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/modules/categories/logic/bloc/category_bloc.dart';
import 'package:market/modules/collection/logic/bloc/collection_bloc.dart';
import 'package:market/modules/products/data/models/product.dart';
import 'package:uuid/uuid.dart';

class ProductForm {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _dimensionController = TextEditingController();

  String? _selectedCollection;
  String? _selectedCategory;
  List<File> selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  Product getProductModel() {
    return Product(
      id: const Uuid().v4(),
      name: _productNameController.text,
      categoryID: _selectedCategory!,
      collectionID: _selectedCollection!,
      dateAdded: DateTime.now(),
      dimension: _dimensionController.text,
      isFavorite: false,
      availability: true,
      price: double.parse(_priceController.text),
      quantity: double.parse(_quantityController.text),
      productImage: selectedImages.map((image) => image.path).toList(),
    );
  }

  Future<void> _getImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    selectedImages
        .addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
  }

  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoryLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Product Info',
                  style: AppTextStyles.textTheme.headlineMedium,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Select Category',
                  border: OutlineInputBorder(),
                ),
                items: state.categories.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  _selectedCategory = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<CollectionBloc, CollectionState>(
                  builder: (context, stateCollection) {
                if (stateCollection is CategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (stateCollection is CollectionLoadedState) {
                  return DropdownButtonFormField<String>(
                    value: _selectedCollection,
                    decoration: const InputDecoration(
                      labelText: 'Select Collection',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _selectedCollection = value;
                    },
                    items: stateCollection.collections.map((collection) {
                      return DropdownMenuItem(
                        value: collection.id,
                        child: Text(collection.name),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a collection';
                      }
                      return null;
                    },
                  );
                } else {
                  return Container();
                }
              }),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _dimensionController,
                decoration: const InputDecoration(
                  labelText: 'Dimension',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product dimensions';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _getImages,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.accentColor,
                  backgroundColor: AppColors.primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Pick Images'),
              ),
              const SizedBox(height: 16),
              selectedImages.isEmpty
                  ? const Text('No images selected')
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selectedImages.map((image) {
                        return Image.file(
                          image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        );
                      }).toList(),
                    ),
              const Divider(),
            ],
          );
        } else if (state is CategoryError) {
          return Text('Failed to load categories: ${state.error}');
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  void dispose() {
    _productNameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _dimensionController.dispose();
  }
}
