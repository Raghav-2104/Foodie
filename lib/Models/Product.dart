class Product {
  final String name;
  final String price;
  Product({required this.name, required this.price});
}
class CartItems{
  final Product product;
  final int quantity;
  CartItems({required this.product, required this.quantity});
}