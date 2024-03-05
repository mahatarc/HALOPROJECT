import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/seller%20mode/presentation/Bloc/your_products_bloc/your_products_bloc.dart';
import 'package:flutterproject/features/seller%20mode/presentation/UI/edit_product.dart';

class YourProducts extends StatefulWidget {
  const YourProducts({Key? key});

  @override
  State<YourProducts> createState() => _YourProductsState();
}

class _YourProductsState extends State<YourProducts> {
  late YourProductsBloc yourProductsBloc;

  @override
  void initState() {
    yourProductsBloc = BlocProvider.of<YourProductsBloc>(context);
    yourProductsBloc.add(YourProductsInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<YourProductsBloc>(
      create: (context) => yourProductsBloc,
      child: BlocBuilder<YourProductsBloc, YourProductsState>(
        bloc: yourProductsBloc,
        builder: (context, state) {
          if (state is YourProductsLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is YourProductsLoadedState) {
            final listOfProducts =
                state.products; //access productModelList from Bloc
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green[100],
                  title: Text('Your Products'),
                ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    yourProductsBloc.add((YourProductsInitialEvent()));
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: listOfProducts.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SingleProduct(
                              productname: listOfProducts[index].productname,
                              productpicture:
                                  listOfProducts[index].productpicture,
                              productprice: listOfProducts[index].productprice,
                              categorytype: listOfProducts[index].categorytype,
                              productdetails:
                                  listOfProducts[index].productdetails,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ));
          } else {
            return Scaffold(); // Return a default Scaffold for other states
          }
        },
      ),
    );
  }
}

class SingleProduct extends StatelessWidget {
  final productname;
  final productpicture;
  final productprice;
  final productdetails;
  final categorytype;

  SingleProduct({
    this.productname,
    this.productpicture,
    this.productprice,
    this.productdetails,
    this.categorytype,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditProduct(
                edit_name: productname,
                edit_price: productprice,
                edit_picture: productpicture,
              ),
            ),
          ),
          child: ListTile(
            leading: Image.network(
              productpicture,
              fit: BoxFit.contain,
              width: 80.0,
              height: 80.0,
            ),
            title: Text(
              productname,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\रु$productprice",
                  style: TextStyle(
                    color: Colors.brown,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  "Category: $categorytype",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
