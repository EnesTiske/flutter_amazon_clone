import 'package:amazon_clone_tutorial/common/widgets/loader.dart';
import 'package:amazon_clone_tutorial/features/account/widgets/single_product.dart';
import 'package:amazon_clone_tutorial/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone_tutorial/features/admin/services/admin_services.dart';
import 'package:amazon_clone_tutorial/models/product.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Product>? products;
  final AdminServices _adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  fetchAllProducts() async {
    products = await _adminServices.fetchAllProducts(context);
    setState(() {});
  }

  void deleteProduct(Product product, int index) {
    _adminServices.deleteProduct(
      context: context,
      product: product,
      onSuccess: () {
        products!.removeAt(index);
        setState(() {});
      },
    );
    products!.removeAt(index);
    setState(() {});
  }

  void navigateToAddProductScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddProductScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Scaffold(
            body: GridView.builder(
              itemCount: products!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                final productData = products![index];
                return Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child: SingleProduct(
                        image: productData.images[0],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              productData.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => deleteProduct(productData, index),
                          icon: const Icon(
                            Icons.delete_outline,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: navigateToAddProductScreen,
              tooltip: 'Add a Product',
              backgroundColor: Colors.cyan[500],
              shape: const StadiumBorder(),
              child: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
