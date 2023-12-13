import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mini_airbnb/service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchController;
  late Future<List<dynamic>> _allProducts;
  late ProductsServiceImp temp = ProductsServiceImp();

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _allProducts = temp.getProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _runFilter(String enteredKeyword) async {
    setState(() {
      _allProducts = temp.getProducts().then((products) {
        return products
            .where((product) => product.title
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Store'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _runFilter,
            decoration: InputDecoration(
              hintText: 'Search...',
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _allProducts,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data![index]['name']),
                        subtitle:
                            Text(snapshot.data![index]['price'].toString()),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}
