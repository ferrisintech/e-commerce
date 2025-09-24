import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class AnimatedSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final Function() onClear;

  const AnimatedSearchBar({
    super.key,
    required this.onSearch,
    required this.onClear,
  });

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (value.isNotEmpty) {
      _controller.forward();
      setState(() => _isSearching = true);
    } else {
      _controller.reverse();
      setState(() => _isSearching = false);
    }
    widget.onSearch(value);
    // Force rebuild of parent widgets to update search results
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Trigger a rebuild by accessing context
      if (mounted) {
        // This ensures the parent widget rebuilds with new search results
        (context as Element).markNeedsBuild();
      }
    });
  }

  void _onClear() {
    _searchController.clear();
    _controller.reverse();
    setState(() => _isSearching = false);
    widget.onClear();
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).shadowColor.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search vintage treasures...',
                    prefixIcon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _isSearching
                          ? FadeIn(
                              key: const ValueKey('searching'),
                              child: const Icon(
                                Icons.search,
                                color: Colors.amber,
                              ),
                            )
                          : FadeIn(
                              key: const ValueKey('normal'),
                              child: Icon(
                                Icons.search,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? FadeIn(
                            child: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _onClear,
                              splashRadius: 20,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
