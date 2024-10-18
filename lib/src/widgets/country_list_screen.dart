import 'dart:async';
import 'package:flutter/material.dart';
import 'package:country_app/barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CountryListView extends StatefulWidget {
  const CountryListView({super.key});

  @override
  _CountryListViewState createState() => _CountryListViewState();
}

class _CountryListViewState extends State<CountryListView> {
  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = false;
  final TextEditingController _searchController = TextEditingController();
  SortOrder _selectedSortOrder = SortOrder.relevance;
  late final Connectivity _connectivity;
  late Stream<ConnectivityResult> _connectivityStream;
  late ConnectivityResult _previousResult;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _searchController.addListener(_onSearchChanged);

    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged;
    _previousResult = ConnectivityResult.none; // Initialize previous result
    bool _isInitialized = false; // Track initialization state

    _connectivityStream.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        showSnackbar('Internet is Off!');
      } else if (result != ConnectivityResult.none &&
          _previousResult == ConnectivityResult.none) {
        _fetchCountries();
        if (_isInitialized) {
          showSnackbar('Internet is On!');
        }
      }
      _previousResult = result; // Update the previous result

      _isInitialized = true;
    });
  }

  void _scrollListener() {
    final isAtBottom = _scrollController.position.atEdge &&
        _scrollController.position.pixels != 0;
    if (isAtBottom != _isAtBottom) {
      setState(() {
        _isAtBottom = isAtBottom;
      });
    }
  }

  void _onSearchChanged() {
    context.read<CountryCubit>().filterCountries(_searchController.text);
  }

  void _onSortSelected(SortOrder sortOrder) {
    setState(() {
      _selectedSortOrder = sortOrder;
    });
    context.read<CountryCubit>().sortCountries(sortOrder);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2193B0),
                Color(0xFF6DD5ED),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text('Countries'),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeNotifier>(context).isDarkTheme
                  ? Icons.wb_sunny
                  : Icons.nights_stay,
            ),
            onPressed: () {
              Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        slivers: [
          SliverPersistentHeader(
            delegate: SliverSearchAppBar(
              searchController: _searchController,
              onSortSelected: _onSortSelected,
              selectedSortOrder: _selectedSortOrder,
            ),
            pinned: true,
          ),
          BlocBuilder<CountryCubit, CountryState>(
            builder: (context, state) {
              if (state is CountryLoaded && state.countries.length > 1) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Current Sort Order: ${getSortOrderText(_selectedSortOrder)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        //color: Colors.black,
                      ),
                    ),
                  ),
                );
              } else {
                return const SliverToBoxAdapter();
              }
            },
          ),
          BlocBuilder<CountryCubit, CountryState>(
            builder: (context, state) {
              if (state is CountryLoading) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Center vertically
                      children: const [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Please wait while we load...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is CountryError) {
                return _buildNoCountriesFound(state.message, '');
              } else if (state is CountryLoaded) {
                if (state.countries.isEmpty) {
                  return _buildNoCountriesFound('No countries available.',
                      'Please try a different search.');
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return CountryTile(country: state.countries[index]);
                    },
                    childCount: state.countries.length,
                  ),
                );
              }
              return const SliverToBoxAdapter(
                child: Center(child: Text('No countries available.')),
              );
            },
          ),
        ],
      ),
      floatingActionButton: _isAtBottom
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward),
            )
          : null,
    );
  }

  Widget _buildNoCountriesFound(String msg1, String? msg2) {
    return SliverToBoxAdapter(
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning, size: 40, color: Colors.redAccent),
              const SizedBox(height: 10),
              Text(msg1,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              const SizedBox(height: 5),
              if (msg2 != null && msg2.isNotEmpty)
                Text(msg2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16, color: Colors.black.withOpacity(0.9))),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOut,
    );
  }

  void _fetchCountries() {
    context.read<CountryCubit>().loadCountries();
  }

  void showSnackbar(String message, {int duration = 3}) {
    final snackbar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFE0E0E0),
      duration: Duration(seconds: duration),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
