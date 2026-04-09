import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(FetchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final featured = await productRepository.getFeaturedProducts();
      final products = await productRepository.getProducts(category: event.category);
      emit(ProductLoaded(products: products, featuredProducts: featured));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
