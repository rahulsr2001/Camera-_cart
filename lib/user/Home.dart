import 'dart:convert';

import 'package:camera_cart/user/search%20screen/search_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:camera_cart/admindatabase/Product_category.dart';
import 'package:camera_cart/user/details.dart';
import 'package:camera_cart/user/favbutton.dart';
import 'package:camera_cart/user/wishlist/wishlist_page.dart';

import 'package:camera_cart/user/homesub/homesub.dart';
import 'dart:typed_data';

import 'package:camera_cart/user/wishlist/wishlist_db.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
  final page = [
    const Homepage(),
  ];

  final List<String> imageUrls = [
    'assets/user/banner.jpg',
    'assets/user/banner2.jpg',
    'assets/user/banner4.jpg',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Center(
            child: Text(
          'camera cart',
          style: TextStyle(color: Colors.white),
        )),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: ((ctx) => const SearchPage())));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 86, 83, 83),
              ),
              child: Center(
                child: Text(
                  'Camera Cart',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((ctx) => const wishlistpage())));
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Featured Products',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            height: 200,
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: BannerCarousel(imageUrls: imageUrls),
            ),
          ),
          const Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
                  child: Text(
                    'Popular brands',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: HorizontalListView1(),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'New Arrivals',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 500, child: UserCatListing1()),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Uint8List imageUrl;
  final String name;
  final String price;
  final String category;
  final String discription;
  final int id;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.category,
    required this.discription,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final Imageready = base64Decode(imageUrl.toString());

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Details(
                    imageUrl: Imageready,
                    name: name,
                    price: price,
                    category: category,
                    description: discription,
                    id: id,
                  )),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(border: Border.all(width: 0.1)),
          height: 320,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ColorChangingButton(
                  wishlistItem: WishlistItem(
                      name: name,
                      price: price,
                      image: imageUrl.toString(),
                      description: discription,
                      id: id)),
              Image.memory(
                imageUrl,
                height: 100,
                width: double.infinity,
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class HorizontalListView1 extends StatelessWidget {
  const HorizontalListView1({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          const SizedBox(width: 10),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const UserCatListing2(category: 'Nikon')),
                  );
                },
                child: const CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      AssetImage('assets/user/nikon-logo-CTNWXN.jpg'),
                ),
              ),
              const Text('Nikon'),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const UserCatListing2(category: 'Canon')),
                  );
                },
                child: const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/user/images (2).png'),
                ),
              ),
              const Text('Canon'),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const UserCatListing2(category: 'Fujifilim')),
                  );
                },
                child: const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/user/fuji.png'),
                ),
              ),
              const Text('Fujifilm'),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const UserCatListing2(category: 'Sony')),
                  );
                },
                child: const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/user/download.png'),
                ),
              ),
              const Text('Sony'),
            ],
          ),
        ],
      ),
    );
  }
}
// banner

class BannerCarousel extends StatefulWidget {
  final List<String> imageUrls;

  const BannerCarousel({
    Key? key,
    required this.imageUrls,
  }) : super(key: key);

  @override
  _BannerCarouselState createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          items: widget.imageUrls.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            height: 200.0,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        Positioned(
          bottom: 10.0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.imageUrls.map((url) {
              int index = widget.imageUrls.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentIndex == index ? Colors.white : Colors.grey[400],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
