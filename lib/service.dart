import 'package:dio/dio.dart';
import 'package:mini_airbnb/modle.dart';

abstract class BaseService {
  Dio dio = Dio();
  String baseUrl = 'https://dummyjson.com/products';
}

abstract class ProductsService extends BaseService {
  Future<List> getProducts();
}

class ProductsServiceImp extends ProductsService {
  @override
  Future<List<productsModel>> getProducts() async {
    Response response = await dio.get(baseUrl);
    print('0');
    print(response.data);
    if (response.statusCode == 200) {
      print('200');
      dynamic temp = response.data;
      print('stored');
      List<productsModel> questions = List.generate(
          temp.length, (index) => productsModel.fromMap(temp[index]));
      print('P is good');
      return questions;
    } else {
      return [];
    }
  }
}
