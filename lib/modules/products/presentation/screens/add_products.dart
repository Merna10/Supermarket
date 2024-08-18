import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/app/theme/colors.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/core/enum/fetch_method.dart';
import 'package:market/modules/products/logic/bloc/product_bloc.dart';
import 'package:market/modules/categories/logic/bloc/category_bloc.dart'; // Import your CategoryBloc
import 'package:market/modules/products/presentation/widgets/product_info.dart';

class AddProductScreen extends StatefulWidget {
  final String fetchId;
  final FetchMethod fetchMethod;
  const AddProductScreen({super.key,
    required this.fetchId,
    required this.fetchMethod,});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productForms = <ProductForm>[];
  bool _isLoading = false;
  int count = 1;
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(FetchCategories());
    _addProductForm();
  }

  void _addProductForm() {
    setState(() {
      _productForms.add(ProductForm());
    });
  }

  Future<void> _submitProducts() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final productBloc = context.read<ProductBloc>();

      try {
        for (var productForm in _productForms) {
          final product = productForm.getProductModel();
          final images = productForm.selectedImages;
          productBloc.add(AddToProducts(product: product, imageFiles: images,fetchId:widget.fetchId ,method: widget.fetchMethod,) );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Products added successfully!')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add products: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Add Products',
          style: AppTextStyles.textTheme.displaySmall,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ..._productForms
                          .map((productForm) => productForm.build(context))
                          ,
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _addProductForm();
                          //const Divider();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.accentColor,
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Add Another Product'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _submitProducts,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.accentColor,
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}


