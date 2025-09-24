import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/app_provider.dart';
import '../providers/favorites_provider.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  List<Product> _filteredProducts = [];

  // Filter state variables (now using provider)
  // String _selectedCondition = 'All';
  // RangeValues _priceRange = const RangeValues(0, 5000);
  // String _currentSort = 'Featured';

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    final products = Product.getSampleProducts();
    var filteredProducts = _filterProducts(products, appProvider);

    // Apply sorting to the filtered products
    filteredProducts = _applySorting(filteredProducts);

    return Scaffold(
      appBar: AppBar(
        title: FadeTransition(
          opacity: _fadeController,
          child: Text(
            'All Products',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        leading: FadeInLeft(
          delay: const Duration(milliseconds: 200),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          FadeInRight(
            delay: const Duration(milliseconds: 300),
            child: IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showFilterDialog(context),
            ),
          ),
        ].where((action) => MediaQuery.of(context).size.width > 350).toList(),
      ),
      body: FadeTransition(
        opacity: _fadeController,
        child: Column(
          children: [
            // Search and Filter Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Search Bar
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -0.5),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _slideController,
                      curve: Curves.easeOut,
                    )),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white70),
                        suffixIcon: appProvider.searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear,
                                    color: Colors.white70),
                                onPressed: () => appProvider.clearSearch(),
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: const TextStyle(color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        appProvider.setSearchQuery(value);
                        // Force immediate rebuild
                        setState(() {});
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Category Filter
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _slideController,
                      curve: Curves.easeOut,
                    )),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          'All',
                          'Desks',
                          'Seating',
                          'Storage',
                          'Tables',
                          'Lighting',
                          'Decor',
                        ].map((category) {
                          final isSelected =
                              appProvider.selectedCategory == category;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  appProvider.setSelectedCategory(category);
                                  // Force rebuild
                                  setState(() {});
                                }
                              },
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              selectedColor:
                                  Theme.of(context).colorScheme.primary,
                              checkmarkColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Results Count
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filteredProducts.length} products found',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  TextButton(
                    onPressed: () => _showSortOptions(context),
                    child: Row(
                      children: [
                        Text(
                          'Sort: ${appProvider.currentSort}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const Icon(Icons.arrow_drop_down, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Products Grid
            Expanded(
              child: filteredProducts.isEmpty
                  ? _buildEmptyState()
                  : AnimationLimiter(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            columnCount: 2,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: ProductCard(
                                  product: product,
                                  onTap: () => _navigateToProductDetail(
                                      context, product),
                                  onFavoriteToggle: () =>
                                      favoritesProvider.toggleFavorite(product),
                                  isFavorite:
                                      favoritesProvider.isFavorite(product),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
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

    // Filter by condition
    if (appProvider.selectedCondition != 'All') {
      filtered = filtered
          .where(
              (product) => product.condition == appProvider.selectedCondition)
          .toList();
    }

    // Filter by price range
    filtered = filtered.where((product) {
      return product.price >= appProvider.priceRange.start &&
          product.price <= appProvider.priceRange.end;
    }).toList();

    return filtered;
  }

  List<Product> _applySorting(List<Product> products) {
    final appProvider = Provider.of<AppProvider>(context);
    final sorted = List<Product>.from(products);

    switch (appProvider.currentSort) {
      case 'Price: Low to High':
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Newest First':
        sorted.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
        break;
      case 'Rating':
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Featured':
      default:
        // Keep original order for Featured
        break;
    }

    return sorted;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter criteria',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Provider.of<AppProvider>(context, listen: false).clearSearch();
              Provider.of<AppProvider>(context, listen: false)
                  .setSelectedCategory('All');
            },
            child: const Text('Clear Filters'),
          ),
        ],
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

  void _showFilterDialog(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    // Local state for the dialog
    String selectedCondition = appProvider.selectedCondition;
    RangeValues priceRange = appProvider.priceRange;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter by Condition',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    'All',
                    'Excellent',
                    'Very Good',
                    'Good',
                    'Fair',
                  ].map((condition) {
                    return FilterChip(
                      label: Text(condition),
                      selected: selectedCondition == condition,
                      onSelected: (selected) {
                        setState(() {
                          selectedCondition = condition;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  'Price Range',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                RangeSlider(
                  values: priceRange,
                  min: 0,
                  max: 5000,
                  divisions: 50,
                  labels: RangeLabels(
                    '\$${priceRange.start.round()}',
                    '\$${priceRange.end.round()}',
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      priceRange = values;
                    });
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Apply the filters using provider
                      appProvider.setSelectedCondition(selectedCondition);
                      appProvider.setPriceRange(priceRange);
                      Navigator.pop(context);
                      // Force immediate rebuild by calling setState on the parent
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          // Find the parent state and trigger rebuild
                          context
                              .findAncestorStateOfType<
                                  _ProductListingScreenState>()
                              ?.setState(() {});
                        }
                      });
                    },
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);

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
              'Sort by',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Price: Low to High'),
              leading: const Icon(Icons.arrow_upward),
              trailing: appProvider.currentSort == 'Price: Low to High'
                  ? Icon(Icons.check,
                      color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                appProvider.setCurrentSort('Price: Low to High');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Price: High to Low'),
              leading: const Icon(Icons.arrow_downward),
              trailing: appProvider.currentSort == 'Price: High to Low'
                  ? Icon(Icons.check,
                      color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                appProvider.setCurrentSort('Price: High to Low');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Newest First'),
              leading: const Icon(Icons.access_time),
              trailing: appProvider.currentSort == 'Newest First'
                  ? Icon(Icons.check,
                      color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                appProvider.setCurrentSort('Newest First');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Rating'),
              leading: const Icon(Icons.star),
              trailing: appProvider.currentSort == 'Rating'
                  ? Icon(Icons.check,
                      color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                appProvider.setCurrentSort('Rating');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
