import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ConnectedProductsModel extends Model {
  bool _isLoading = false;
  List<Product> _products = [];
  int _selSelectedIndex;
  User _authenticatedUser;
  Future<Null> addProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'http://tes77.com/wp-content/uploads/2017/10/dark-chocolate-bar-squares.jpg',
      'price': price,
      'email': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    return http
        .post('https://flutter-app-32074.firebaseio.com/products.json',
            body: jsonEncode(productData))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      final Product product = new Product(
          id: responseData['name'],
          description: description,
          title: title,
          image: image,
          price: price,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _products.add(product);
      _isLoading = false;
      notifyListeners();
    });
  }
}

class ProductsModel extends ConnectedProductsModel {
  bool _showFavourite = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedproducts {
    if (_showFavourite) {
      return _products.where((x) => x.isFavourite == true).toList();
    }
    return List.from(_products);
  }

  int get slectedProductIndex {
    return _selSelectedIndex;
  }

  Product get selectedProduct {
    if (slectedProductIndex == null) {
      return null;
    }
    return _products[slectedProductIndex];
  }

  bool get displayFavouriteOnly {
    return _showFavourite;
  }

  void updateProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Product updatedProduct = new Product(
        description: description,
        title: title,
        image:
            "http://tes77.com/wp-content/uploads/2017/10/dark-chocolate-bar-squares.jpg",
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    _products[slectedProductIndex] = updatedProduct;
    _isLoading = false;
    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(slectedProductIndex);
  }

  void selectProduct(int index) {
    _selSelectedIndex = index;
  }

  void setSelectedProductIndex(int index) {
    _selSelectedIndex = index;
  }

  void fetchProducts() {
    _isLoading = true;
    notifyListeners();
    http
        .get('https://flutter-app-32074.firebaseio.com/products.json')
        .then((http.Response response) {
      print(json.decode(response.body));
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      productListData.forEach((String productId, dynamic productData) {
        final Product product = new Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            image: productData['image'],
            userEmail: productData['email'],
            userId: productData['UserId']);
        fetchedProductList.add(product);
      });
      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
    });
  }

  void toggleProductFavouriteToggle() {
    final bool isCurrentlyFavourite = selectedProduct.isFavourite;
    final bool newFavouriteStatus = !isCurrentlyFavourite;
    final Product updatedProduct = Product(
        description: selectedProduct.description,
        title: selectedProduct.title,
        image: selectedProduct.image,
        price: selectedProduct.price,
        isFavourite: newFavouriteStatus,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    _products[slectedProductIndex] = updatedProduct;

    notifyListeners();
  }

  void toggleDisplayModel() {
    _showFavourite = !_showFavourite;
    notifyListeners();
  }
}

class UserModel extends ConnectedProductsModel {
  void login(String email1, String password) {
    _authenticatedUser = User(id: 'sdc', email: email1, password: password);
  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}