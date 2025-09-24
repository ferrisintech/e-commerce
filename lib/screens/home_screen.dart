import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/app_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../models/product.dart';
import '../widgets/animated_search_bar.dart';
import '../widgets/category_chips.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeController.forward();
    _slideController.forward();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 100) {
      // Trigger any scroll-based animations here
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    final products = Product.getSampleProducts();
    final filteredProducts = _filterProducts(products, appProvider);
    final featuredProducts = filteredProducts.take(3).toList();

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeController,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              flexibleSpace: FlexibleSpaceBar(
                title: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _slideController,
                    curve: Curves.easeOut,
                  )),
                  child: Text(
                    'Antique Lane',
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                FadeInRight(
                  delay: const Duration(milliseconds: 300),
                  child: IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () =>
                        _showFavorites(context, favoritesProvider, products),
                  ),
                ),
                FadeInRight(
                  delay: const Duration(milliseconds: 400),
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                  ),
                ),
              ],
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: AnimationConfiguration.synchronized(
                child: SlideAnimation(
                  verticalOffset: 50,
                  child: FadeInAnimation(
                    delay: const Duration(milliseconds: 200),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: AnimatedSearchBar(
                        onSearch: (query) {
                          appProvider.setSearchQuery(query);
                          setState(() {}); // Force rebuild
                        },
                        onClear: () {
                          appProvider.clearSearch();
                          setState(() {}); // Force rebuild
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Categories
            SliverToBoxAdapter(
              child: AnimationConfiguration.synchronized(
                child: SlideAnimation(
                  verticalOffset: 50,
                  child: FadeInAnimation(
                    delay: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CategoryChips(
                        selectedCategory: appProvider.selectedCategory,
                        onCategorySelected: (category) {
                          appProvider.setSelectedCategory(category);
                          setState(() {}); // Force rebuild
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Featured Products Section
            SliverToBoxAdapter(
              child: AnimationConfiguration.synchronized(
                child: SlideAnimation(
                  verticalOffset: 50,
                  child: FadeInAnimation(
                    delay: const Duration(milliseconds: 400),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Featured Pieces',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/products'),
                                child: Text(
                                  'View All',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 280,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: featuredProducts.length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 600),
                                  child: SlideAnimation(
                                    horizontalOffset: 50,
                                    child: FadeInAnimation(
                                      child: Container(
                                        width: 200,
                                        margin: EdgeInsets.only(
                                          right: index <
                                                  featuredProducts.length - 1
                                              ? 16
                                              : 0,
                                        ),
                                        child: ProductCard(
                                          product: featuredProducts[index],
                                          onTap: () => _navigateToProductDetail(
                                            context,
                                            featuredProducts[index],
                                          ),
                                          onFavoriteToggle: () =>
                                              favoritesProvider.toggleFavorite(
                                            featuredProducts[index],
                                          ),
                                          isFavorite:
                                              favoritesProvider.isFavorite(
                                            featuredProducts[index],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // All Products Section
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = filteredProducts[index];
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      columnCount: 2,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: ProductCard(
                            product: product,
                            onTap: () =>
                                _navigateToProductDetail(context, product),
                            onFavoriteToggle: () =>
                                favoritesProvider.toggleFavorite(product),
                            isFavorite: favoritesProvider.isFavorite(product),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: filteredProducts.length,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FadeInUp(
        delay: const Duration(milliseconds: 600),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
          child: BottomNavigationBar(
            currentIndex: 0,
            onTap: (index) => _onBottomNavTap(context, index),
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            iconSize: 24,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToProductDetail(BuildContext context, Product product) {
    Navigator.pushNamed(
      context,
      '/product-detail',
      arguments: product,
    );
  }

  void _showFavorites(BuildContext context, FavoritesProvider favoritesProvider,
      List<Product> products) {
    final favoriteProducts = favoritesProvider.getFavoriteProducts(products);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Favorites',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            favoriteProducts.isEmpty
                ? const Text('No favorites yet')
                : SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: favoriteProducts.length,
                      itemBuilder: (context, index) {
                        final product = favoriteProducts[index];
                        return ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: product.images.first,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.image),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            ),
                          ),
                          title: Text(product.name),
                          subtitle:
                              Text('\$${product.price.toStringAsFixed(2)}'),
                          onTap: () {
                            Navigator.pop(context);
                            _navigateToProductDetail(context, product);
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _onBottomNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/products');
        break;
      case 2:
        Navigator.pushNamed(context, '/cart');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  List<Product> _filterProducts(
      List<Product> products, AppProvider appProvider) {
    var filtered = products;

    // Filter by category
    if (appProvider.selectedCategory != 'All') {
      filtered = filtered
          .where((product) => product.category == appProvider.selectedCategory)
          .toList();
    }

    // Filter by search query
    if (appProvider.searchQuery.isNotEmpty) {
      final query = appProvider.searchQuery.toLowerCase();
      filtered = filtered.where((product) {
        return product.name.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query) ||
            product.category.toLowerCase().contains(query) ||
            product.era.toLowerCase().contains(query) ||
            product.material.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }
}
