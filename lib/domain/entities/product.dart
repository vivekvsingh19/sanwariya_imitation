import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String title;
  final String description;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final String category;
  final double rating;
  final bool isFeatured;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.category,
    required this.rating,
    this.isFeatured = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        price,
        originalPrice,
        imageUrl,
        category,
        rating,
        isFeatured,
      ];
}
