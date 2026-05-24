import 'package:hive/hive.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_consumer.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../../../shared/models/pagination/pagination_params.dart';
import '../../domain/entities/product_entity.dart';
import '../models/product_model.dart';
import 'home_local_data_source.dart';

abstract class HomeRemoteDataSource {
  Future<List<ProductEntity>> fetchProduct(PaginationParams params);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiConsumer _dio;
  final HomeLocalDataSource homeLocalDataSource;

  HomeRemoteDataSourceImpl(this._dio, {required this.homeLocalDataSource});

  @override
  Future<List<ProductEntity>> fetchProduct(PaginationParams params) async {
    final response = await _dio.get(
      ApiEndpoints.products,
      queryParameters: params.toJson(),
    );

    final List<ProductEntity> products = (response['products'] as List)
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // Cache the products
    final productBox = Hive.box<ProductEntity>(StorageKeys.product_box);
    productBox.addAll(products.map((e) => (e as ProductModel).toEntity()).toList());

    return products;
  }
}
