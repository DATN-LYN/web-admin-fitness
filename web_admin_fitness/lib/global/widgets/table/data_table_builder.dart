import 'package:ferry/ferry.dart';
import 'package:ferry_flutter/ferry_flutter.dart';
import 'package:flutter/material.dart';

import '../../graphql/fragment/__generated__/meta_fragment.data.gql.dart';
import '../../themes/app_colors.dart';
import '../fitness_error.dart';
import 'table_pager.dart';

class DataTableBuilder<TData, TVars> extends StatefulWidget {
  const DataTableBuilder({
    Key? key,
    required this.client,
    required this.request,
    required this.changePageRequest,
    required this.builder,
    this.listener,
    required this.meta,
    required this.changeLimitRequest,
    this.loading,
  }) : super(key: key);

  final OperationRequest<TData, TVars> request;
  final OperationRequest<TData, TVars> Function(
    OperationResponse<TData, TVars>? data,
    int page,
  ) changePageRequest;
  final OperationRequest<TData, TVars> Function(
    OperationResponse<TData, TVars>? data,
    int limit,
  ) changeLimitRequest;
  final GMeta? Function(OperationResponse<TData, TVars>? data) meta;
  final OperationResponseBuilder<TData, TVars> builder;
  final void Function(OperationResponse<TData, TVars>)? listener;
  final Client client;
  final bool? loading;

  @override
  State<DataTableBuilder<TData, TVars>> createState() =>
      _DataTableBuilderState();
}

class _DataTableBuilderState<TData, TVars>
    extends State<DataTableBuilder<TData, TVars>> {
  GlobalKey key = GlobalKey();
  late OperationRequest<TData, TVars> request;
  late Stream<OperationResponse<TData, TVars>> stream;

  bool loading = false;

  @override
  void initState() {
    request = widget.request;
    initNewStream();
    showLoading();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DataTableBuilder<TData, TVars> oldWidget) {
    if (!identical(request, widget.request)) {
      final oldRequestId = request.requestId;
      request = widget.request;

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          if (oldRequestId != widget.request.requestId) {
            initNewStream();
          } else {
            widget.client.requestController.add(widget.request);
          }
        });
        showLoading();
      });
    }
    if (widget.loading != null && widget.loading != oldWidget.loading) {
      loading = widget.loading!;
    }
    super.didUpdateWidget(oldWidget);
  }

  void initNewStream() {
    stream = widget.client.request(widget.request).distinct();
    stream.listen((event) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.listener?.call(event);
      });
    });
  }

  void showLoading() async {
    setState(() => loading = true);
    await stream.firstWhere(
      (element) => element.dataSource == DataSource.Link,
    );
    setState(() => loading = false);
  }

  void handlePageIndexChanged(
    OperationResponse<TData, TVars>? data,
    int page,
  ) async {
    final req = widget.changePageRequest.call(data, page);
    widget.client.requestController.add(req);
    showLoading();
  }

  void handlePageLimitChanged(
      OperationResponse<TData, TVars>? data, int limit) async {
    final req = widget.changeLimitRequest.call(data, limit);
    widget.client.requestController.add(req);
    showLoading();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OperationResponse<TData, TVars>>(
      key: key,
      initialData: OperationResponse<TData, TVars>(
        operationRequest: widget.request,
        dataSource: DataSource.None,
      ),
      stream: stream,
      builder: (context, snapshot) {
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ColoredBox(
                      color: AppColors.white,
                      child: widget.builder(
                        context,
                        snapshot.data,
                        snapshot.error,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TablePager(
                  pageMeta: widget.meta(snapshot.data),
                  onPageChange: (page) {
                    handlePageIndexChanged(snapshot.data, page);
                  },
                  onPageLimitChange: (int value) {
                    handlePageLimitChanged(snapshot.data, value);
                  },
                ),
              ],
            ),
            if (snapshot.data?.hasErrors == true)
              FitnessError(response: snapshot.data),
            if (loading)
              Container(
                color: Colors.white38,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
          ],
        );
      },
    );
  }
}
