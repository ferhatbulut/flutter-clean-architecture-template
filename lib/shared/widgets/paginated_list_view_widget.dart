import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'loading_widget.dart';
import 'no_data_found_widget.dart';

class PaginatedListViewWidget<T> extends StatelessWidget {
  const PaginatedListViewWidget({
    super.key,
    required this.pagingController,
    required this.itemBuilder,
    this.onRefresh,
    this.noItemsFoundIndicatorBuilder,
    this.firstPageProgressIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.firstPageErrorIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.padding,
    this.separatorBuilder,
  });

  final PagingController<int, T> pagingController;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Future<void> Function()? onRefresh;
  final WidgetBuilder? noItemsFoundIndicatorBuilder;
  final WidgetBuilder? firstPageProgressIndicatorBuilder;
  final WidgetBuilder? newPageProgressIndicatorBuilder;
  final WidgetBuilder? firstPageErrorIndicatorBuilder;
  final WidgetBuilder? newPageErrorIndicatorBuilder;
  final EdgeInsetsGeometry? padding;
  final IndexedWidgetBuilder? separatorBuilder;

  @override
  Widget build(BuildContext context) {
    return PagingListener<int, T>(
      controller: pagingController,
      builder: (context, state, fetchNextPage) {
        final listConfig = PagedChildBuilderDelegate<T>(
          itemBuilder: itemBuilder,
          firstPageProgressIndicatorBuilder:
              firstPageProgressIndicatorBuilder ??
              (_) => const LoadingWidget(message: 'Loading data...'),
          newPageProgressIndicatorBuilder:
              newPageProgressIndicatorBuilder ??
              (_) => const Padding(
                padding: EdgeInsets.all(16.0),
                child: LoadingWidget(size: 24),
              ),
          noItemsFoundIndicatorBuilder:
              noItemsFoundIndicatorBuilder ?? (_) => const NoDataFoundWidget(),
          firstPageErrorIndicatorBuilder:
              firstPageErrorIndicatorBuilder ??
              (_) => _buildErrorWidget(context, state.error),
          newPageErrorIndicatorBuilder:
              newPageErrorIndicatorBuilder ??
              (_) => _buildErrorWidget(context, state.error, isNewPage: true),
        );

        final Widget child = separatorBuilder != null
            ? PagedListView<int, T>.separated(
                state: state,
                fetchNextPage: fetchNextPage,
                builderDelegate: listConfig,
                padding: padding,
                separatorBuilder: separatorBuilder!,
              )
            : PagedListView<int, T>(
                state: state,
                fetchNextPage: fetchNextPage,
                builderDelegate: listConfig,
                padding: padding,
              );

        if (onRefresh != null) {
          return RefreshIndicator(onRefresh: onRefresh!, child: child);
        }

        return child;
      },
    );
  }

  Widget _buildErrorWidget(
    BuildContext context,
    dynamic error, {
    bool isNewPage = false,
  }) {
    if (isNewPage) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Failed to load more items'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => pagingController.fetchNextPage(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(error?.toString() ?? 'An error occurred'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (onRefresh != null) {
                onRefresh!();
              } else {
                pagingController.fetchNextPage();
              }
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
