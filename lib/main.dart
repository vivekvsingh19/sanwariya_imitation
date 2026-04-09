import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';

// Repositories
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/repositories/cart_repository.dart';
import 'domain/repositories/order_repository.dart';

import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/repositories/cart_repository_impl.dart';
import 'data/repositories/order_repository_impl.dart';

// BLoCs
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/product/product_bloc.dart';
import 'presentation/blocs/cart/cart_bloc.dart';
import 'presentation/blocs/order/order_bloc.dart';

// Screens
import 'presentation/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepositoryImpl()),
        RepositoryProvider<ProductRepository>(create: (_) => ProductRepositoryImpl()),
        RepositoryProvider<CartRepository>(create: (_) => CartRepositoryImpl()),
        RepositoryProvider<OrderRepository>(create: (_) => OrderRepositoryImpl()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider<ProductBloc>(
            create: (context) => ProductBloc(productRepository: context.read<ProductRepository>()),
          ),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(cartRepository: context.read<CartRepository>()),
          ),
          BlocProvider<OrderBloc>(
            create: (context) => OrderBloc(orderRepository: context.read<OrderRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'Sanwariya Imitation',
          theme: AppTheme.darkTheme,
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
