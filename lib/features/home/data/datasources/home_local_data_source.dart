import 'package:hive/hive.dart';

import '../../../../core/storage/storage_keys.dart';
import '../../../../shared/models/pagination/pagination_params.dart';
import '../../domain/entities/product_entity.dart';

abstract class HomeLocalDataSource {
  List<ProductEntity> fetchProducts({required PaginationParams params});
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  HomeLocalDataSourceImpl();

  @override
  List<ProductEntity> fetchProducts({required PaginationParams params}) {
    final products = Hive.box<ProductEntity>(StorageKeys.product_box);

    return products.values.toList();
  }
}
