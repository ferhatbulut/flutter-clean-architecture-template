import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/safe_call.dart';
import '../../../../shared/models/pagination/pagination_params.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_data_source.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ProductEntity>>> getProduct(
    PaginationParams params,
  ) {
    return safeCall(() async {
      // Get the products from the local
      final cachedProducts = localDataSource.fetchProducts(params: params);
      if (cachedProducts.isNotEmpty) {
        return cachedProducts;
      }

      // Get the products from the remote
      final remoteProducts = await remoteDataSource.fetchProduct(params);

      return remoteProducts;
    });
  }
}
