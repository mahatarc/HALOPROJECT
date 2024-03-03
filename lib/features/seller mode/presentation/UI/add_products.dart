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
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  File? _image;
  TextEditingController _detailsController = TextEditingController();
  String? _categorytype;
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
          _detailsController.clear();

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green[200],
              title: Text('Add Product'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
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
                        // SizedBox(height: 16),
                        // TextFormField(
                        //   controller: _nameController,
                        //   decoration: InputDecoration(
                        //     labelText: 'Product Category',
                        //     border: OutlineInputBorder(),
                        //     filled: true,
                        //     fillColor: Colors.grey[200],
                        //   ),
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Please enter the product category';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _categorytype,
                          items: [
                            // Replace this with your list of category options
                            DropdownMenuItem<String>(
                              value: 'Seed',
                              child: Text('Seed'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Tools',
                              child: Text('Tools'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Plant',
                              child: Text('Plant'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Fertilizer',
                              child: Text('Fertilizer'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Micronutrients',
                              child: Text('Micronutrients  '),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Pesticides and Insecticides',
                              child: Text('Pesticides and Insecticides'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Pots',
                              child: Text('Pots'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Animal Feed',
                              child: Text('Animal Feed'),
                            ),
                          ],
                          onChanged: (value) {
                            _categorytype = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'Product Category',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please select the product category';
                          //   }
                          //   return null;
                          // },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _detailsController,
                          decoration: InputDecoration(
                            labelText: 'Product Details',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the product description';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (_image != null && _categorytype != null) {
                              addProductsBloc.add(AddProductsButtonPressedEvent(
                                name: _nameController,
                                price: _priceController,
                                image: _image!,
                                details: _detailsController,
                                categorytype: _categorytype!,
                              ));
                            } else {
                              // Handle the case where _image or _categorytype is null
                              // For example, you can show a snackbar or a dialog to inform the user
                              // or perform some other action based on your app's requirements.
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Please select an image and product category.'),
                                ),
                              );
                            }
                          },
                          child: Text('Add Product'),
                        ),
                      ],
                    ),
                  ),
                ],
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
