import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/product/product_bloc.dart';
import '../../blocs/product/product_state.dart';
import '../../blocs/product/product_event.dart';
import '../../widgets/product_card.dart';
import '../../core/constants/colors.dart';
import '../shop/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const FetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SANWARIYA', style: TextStyle(letterSpacing: 4)),
        leading: const Icon(Icons.menu),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is ProductLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Banner
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1599643478524-fb66f70d00f7?q=80&w=600&auto=format&fit=crop'),
                        fit: BoxFit.cover,
                      ),
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      )
                    ),
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('NEW ARRIVAL', style: Theme.of(context).textTheme.bodyMedium?.copyWith(letterSpacing: 2, color: AppColors.primary)),
                        const SizedBox(height: 8),
                        Text('The Wedding Edit', style: Theme.of(context).textTheme.displayLarge),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('EXPLORE COLLECTION'),
                        )
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Featured Masterpieces', style: Theme.of(context).textTheme.displayMedium),
                  ),
                  const SizedBox(height: 16),
                  
                  // Horizontal list of featured products
                  SizedBox(
                    height: 280,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      scrollDirection: Axis.horizontal,
                      itemCount: state.featuredProducts.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final product = state.featuredProducts[index];
                        return SizedBox(
                          width: 200,
                          child: ProductCard(
                            product: product, 
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
                            }
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Browse Collection', style: Theme.of(context).textTheme.displayMedium),
                  ),
                  const SizedBox(height: 16),
                  
                  // Category Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      _buildCategoryCard('Necklaces', 'https://images.unsplash.com/photo-1599643478524-fb66f70d00f7?q=80&w=400&auto=format&fit=crop'),
                      _buildCategoryCard('Earrings', 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?q=80&w=400&auto=format&fit=crop'),
                      _buildCategoryCard('Bangles', 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?q=80&w=400&auto=format&fit=crop'),
                      _buildCategoryCard('Rings', 'https://images.unsplash.com/photo-1605100804763-247f67b254a4?q=80&w=400&auto=format&fit=crop'),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Failed to load products.'));
          }
        },
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
        )
      ),
      alignment: Alignment.center,
      child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
    );
  }
}
