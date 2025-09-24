import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final String category;
  final String era;
  final String condition;
  final String material;
  final Map<String, String> dimensions;
  final String seller;
  final double rating;
  final int reviewCount;
  final bool isFavorite;
  final DateTime dateAdded;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
    required this.era,
    required this.condition,
    required this.material,
    required this.dimensions,
    required this.seller,
    required this.rating,
    required this.reviewCount,
    this.isFavorite = false,
    required this.dateAdded,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    List<String>? images,
    String? category,
    String? era,
    String? condition,
    String? material,
    Map<String, String>? dimensions,
    String? seller,
    double? rating,
    int? reviewCount,
    bool? isFavorite,
    DateTime? dateAdded,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      images: images ?? this.images,
      category: category ?? this.category,
      era: era ?? this.era,
      condition: condition ?? this.condition,
      material: material ?? this.material,
      dimensions: dimensions ?? this.dimensions,
      seller: seller ?? this.seller,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }

  static List<Product> getSampleProducts() {
    return [
      Product(
        id: '1',
        name: 'Victorian Walnut Writing Desk',
        description:
            'A beautifully crafted Victorian era writing desk made from solid walnut. Features intricate carvings and original brass hardware. Perfect for adding elegance to any study or home office.',
        price: 1250.00,
        images: [
          'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=800',
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800',
          'https://images.unsplash.com/photo-1519947486511-46149fa39225?w=800',
        ],
        category: 'Desks',
        era: 'Victorian (1837-1901)',
        condition: 'Excellent',
        material: 'Walnut',
        dimensions: {'Width': '48"', 'Depth': '24"', 'Height': '30"'},
        seller: 'Heritage Antiques',
        rating: 4.8,
        reviewCount: 23,
        dateAdded: DateTime.now().subtract(const Duration(days: 15)),
      ),
      Product(
        id: '2',
        name: 'Mid-Century Modern Teak Armchair',
        description:
            'Iconic mid-century modern armchair crafted from premium teak wood. Designed by a renowned Danish designer, this piece showcases clean lines and exceptional craftsmanship.',
        price: 890.00,
        images: [
          'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?w=800',
          'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?w=800',
          'https://images.unsplash.com/photo-1551298370-9c9ee8842b49?w=800',
        ],
        category: 'Seating',
        era: 'Mid-Century Modern (1950s-1960s)',
        condition: 'Very Good',
        material: 'Teak',
        dimensions: {'Width': '28"', 'Depth': '32"', 'Height': '34"'},
        seller: 'Modern Classics',
        rating: 4.6,
        reviewCount: 18,
        dateAdded: DateTime.now().subtract(const Duration(days: 8)),
      ),
      Product(
        id: '3',
        name: 'Art Deco Mahogany Sideboard',
        description:
            'Stunning Art Deco sideboard featuring exotic mahogany wood with geometric inlays. This piece exemplifies the glamour and sophistication of the Art Deco period.',
        price: 2100.00,
        images: [
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800',
          'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=800',
          'https://images.unsplash.com/photo-1519947486511-46149fa39225?w=800',
        ],
        category: 'Storage',
        era: 'Art Deco (1920s-1930s)',
        condition: 'Excellent',
        material: 'Mahogany',
        dimensions: {'Width': '72"', 'Depth': '18"', 'Height': '36"'},
        seller: 'Deco Dreams',
        rating: 4.9,
        reviewCount: 31,
        dateAdded: DateTime.now().subtract(const Duration(days: 22)),
      ),
      Product(
        id: '4',
        name: 'Rustic Oak Farmhouse Table',
        description:
            'Authentic farmhouse dining table handcrafted from reclaimed oak. This rustic piece brings warmth and character to any dining space with its natural wood grain and sturdy construction.',
        price: 1650.00,
        images: [
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
          'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800',
          'https://images.unsplash.com/photo-1519947486511-46149fa39225?w=800',
        ],
        category: 'Tables',
        era: 'Rustic American (1800s)',
        condition: 'Good',
        material: 'Reclaimed Oak',
        dimensions: {'Width': '84"', 'Depth': '42"', 'Height': '30"'},
        seller: 'Rustic Charm',
        rating: 4.4,
        reviewCount: 12,
        dateAdded: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Product(
        id: '5',
        name: 'French Provincial Bergère Chair',
        description:
            'Elegant French Provincial bergère chair upholstered in original toile fabric. This classic piece features carved wood frame and cabriole legs typical of Louis XV style.',
        price: 750.00,
        images: [
          'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?w=800',
          'https://images.unsplash.com/photo-1551298370-9c9ee8842b49?w=800',
          'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?w=800',
        ],
        category: 'Seating',
        era: 'French Provincial (1700s-1800s)',
        condition: 'Very Good',
        material: 'Walnut, Toile Fabric',
        dimensions: {'Width': '26"', 'Depth': '28"', 'Height': '38"'},
        seller: 'Provincial Treasures',
        rating: 4.7,
        reviewCount: 19,
        dateAdded: DateTime.now().subtract(const Duration(days: 12)),
      ),
      Product(
        id: '6',
        name: 'Industrial Steel and Wood Bookshelf',
        description:
            'Vintage industrial bookshelf combining reclaimed wood shelves with cast iron frame. This piece offers both functionality and industrial chic aesthetic.',
        price: 680.00,
        images: [
          'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=800',
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800',
          'https://images.unsplash.com/photo-1519947486511-46149fa39225?w=800',
        ],
        category: 'Storage',
        era: 'Industrial (Late 1800s-Early 1900s)',
        condition: 'Good',
        material: 'Reclaimed Wood, Cast Iron',
        dimensions: {'Width': '48"', 'Depth': '16"', 'Height': '72"'},
        seller: 'Industrial Revival',
        rating: 4.3,
        reviewCount: 15,
        dateAdded: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];
  }
}

class CartItem {
  final Product product;
  final int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
