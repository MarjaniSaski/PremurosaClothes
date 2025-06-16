class Product {
  final String name;
  final double price;
  final String image;
  final double rating;
  final String description;
  final List<String> colors;
  final List<String> sizes;
  final int reviewCount;

  Product({
    required this.name,
    required this.price,
    required this.image,
    required this.rating,
    required this.description,
    required this.colors,
    required this.sizes,
    required this.reviewCount,
  });
}