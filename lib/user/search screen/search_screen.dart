import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:camera_cart/admindatabase/product.dart';
import 'package:camera_cart/user/details.dart';
import 'package:camera_cart/user/favbutton.dart';
import 'package:camera_cart/user/wishlist/wishlist_db.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Box<Product> productBox;
  late List<Product> _filteredProducts = [];
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchTextChanged);
    _initializeProductBox();
  }

  Future<void> _initializeProductBox() async {
    productBox = await Hive.openBox<Product>('dbname');
    _filteredProducts.addAll(productBox.values);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = productBox.values.where((product) {
        final productName = product.name.toLowerCase();
        return productName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: const TextStyle(
              color: Colors.white), // Set text color while typing
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.75,
          ),
          itemCount: _filteredProducts.length,
          itemBuilder: (context, index) {
            final product = _filteredProducts[index];
            final imageData = product.image != null
                ? base64Decode(product.image)
                : Uint8List(0);
            return ProductCard(
              imageUrl: imageData,
              name: product.name,
              price: product.price,
              discription: product.description,
              category: product.category,
              id: product.id,
            );
          },
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Uint8List imageUrl;
  final String name;
  final String price;
  final String discription;
  final String category;
  final int id;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.discription,
    required this.category,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrlString = base64Encode(imageUrl);

    const double dummyRating = 3.5;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Details(
              imageUrl: imageUrl,
              name: name,
              price: price,
              category: category,
              description: discription,
              id: id,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all(width: 0.1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ColorChangingButton(
              wishlistItem: WishlistItem(
                name: name,
                price: price,
                image: imageUrlString,
                category: category,
                description: discription,
                id: id,
              ),
            ),
            if (imageUrl != null)
              Image.memory(
                imageUrl,
                height: 100,
                width: 200,
              )
            else
              const Placeholder(),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                price,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: RatingBar.builder(
                ignoreGestures: true,
                initialRating: dummyRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 20,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
