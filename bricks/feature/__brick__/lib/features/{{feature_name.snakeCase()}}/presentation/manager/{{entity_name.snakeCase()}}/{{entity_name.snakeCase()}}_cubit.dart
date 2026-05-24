import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_{{entity_name.snakeCase()}}s_usecase.dart';
import '{{entity_name.snakeCase()}}_state.dart';

class {{entity_name.pascalCase()}}Cubit extends Cubit<{{entity_name.pascalCase()}}State> {
  final Get{{entity_name.pascalCase()}}sUseCase _get{{entity_name.pascalCase()}}sUseCase;

  {{entity_name.pascalCase()}}Cubit(this._get{{entity_name.pascalCase()}}sUseCase)
      : super({{entity_name.pascalCase()}}Initial());

  Future<void> loadData() async {
    emit({{entity_name.pascalCase()}}Loading());
    final result = await _get{{entity_name.pascalCase()}}sUseCase.call();
    result.fold(
      (failure) => emit({{entity_name.pascalCase()}}Error(failure.message)),
      (items) => emit({{entity_name.pascalCase()}}Loaded(items)),
    );
  }
}
