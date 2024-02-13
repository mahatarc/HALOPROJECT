import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/seller%20mode/presentation/Bloc/addproducts_bloc/add_products_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddProductsBloc>(
      create: (context) => AddProductsBloc(),
      child: AddProductForm(),
    );
  }
}

class AddProductForm extends StatefulWidget {
  const AddProductForm({Key? key}) : super(key: key);

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  File? _image;
  late AddProductsBloc addProductsBloc;

  @override
  void initState() {
    addProductsBloc = BlocProvider.of<AddProductsBloc>(context);
    addProductsBloc.add(AddProductInitialEvent());
    super.initState();
  }

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddProductsBloc, AddProductsStates>(
      bloc: addProductsBloc,
      builder: (context, state) {
        if (state is AddProductInitialState) {
          _nameController.clear();
          _priceController.clear();
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green[200],
              title: Text('Add Product'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: _getImage,
                      child: _image == null
                          ? Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: Center(
                                child: Icon(Icons.add_a_photo),
                              ),
                            )
                          : Image.file(
                              _image!,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the product name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Product Price',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the product price';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        addProductsBloc.add(AddProductsButtonPressedEvent(
                            name: _nameController,
                            price: _priceController,
                            image: _image!));
                      },
                      child: Text('Add Product'),
                    ),
                    //_productNameController.clear();
                    // _productPriceController.clear();
                    // setState(() {
                    //   _image = null;
                    // });
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Scaffold();
        }
      },
    );
  }
}
