import 'package:flutter/material.dart';
import 'package:country_app/barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';


class CountryListView extends StatefulWidget {
  const CountryListView({super.key});

  @override
  _CountryListViewState createState() => _CountryListViewState();
}

class _CountryListViewState extends State<CountryListView> {
  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = false;
  final TextEditingController _searchController = TextEditingController();
  SortOrder _selectedSortOrder = SortOrder.aToZ;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _searchController.addListener(_onSearchChanged);
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
        physics: BouncingScrollPhysics(),
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
              if (state is CountryLoading) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
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
              if (msg2 != null && msg2 != '')
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
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
