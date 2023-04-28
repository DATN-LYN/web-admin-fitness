import 'package:ferry/ferry.dart';
import 'package:ferry_flutter/ferry_flutter.dart';
import 'package:flutter/material.dart';

class InfinityList<TData, TVars> extends StatefulWidget {
  const InfinityList({
    Key? key,
    required this.client,
    required this.request,
    required this.loadMoreRequest,
    required this.builder,
    required this.refreshRequest,
    this.listener,
    this.disabledRefresh = false,
  }) : super(key: key);

  final bool disabledRefresh;
  final OperationRequest<TData, TVars> request;
  final OperationRequest<TData, TVars>? Function(
      OperationResponse<TData, TVars>? data)? loadMoreRequest;
  final OperationRequest<TData, TVars> Function() refreshRequest;
  final OperationResponseBuilder<TData, TVars> builder;
  final void Function(OperationResponse<TData, TVars>)? listener;
  final Client client;

  @override
  State<InfinityList<TData, TVars>> createState() => _InfinityListState();
}

class _InfinityListState<TData, TVars>
    extends State<InfinityList<TData, TVars>> {
  GlobalKey key = GlobalKey();
  late OperationRequest<TData, TVars> request;
  late Stream<OperationResponse<TData, TVars>> stream;

  @override
  void initState() {
    request = widget.request;
    stream = widget.client.request(widget.request);
    stream.listen((event) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.listener?.call(event);
      });
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant InfinityList<TData, TVars> oldWidget) {
    if (!identical(request, widget.request)) {
      final oldRequestId = request.requestId;
      request = widget.request;

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          if (oldRequestId != widget.request.requestId) {
            stream = widget.client.request(widget.request);
            stream.listen((event) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                widget.listener?.call(event);
              });
            });
          } else {
            widget.client.requestController.add(widget.request);
          }
          key = GlobalKey();
        });
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  bool handleScrollNotification({
    required ScrollNotification notification,
    OperationResponse<TData, TVars>? data,
  }) {
    if (notification is ScrollEndNotification) {
      if (notification.metrics.extentAfter == 0) {
        final req = widget.loadMoreRequest?.call(data);
        if (req != null) {
          widget.client.requestController.add(req);
        }
      }
    }
    return false;
  }

  Future<void> handleRefresh() async {
    request = widget.refreshRequest();
    widget.client.requestController.add(request);
    await stream.firstWhere(
      (element) => element.dataSource == DataSource.Link,
    );
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
        Widget child = NotificationListener<ScrollNotification>(
          onNotification: (notification) => handleScrollNotification(
            notification: notification,
            data: snapshot.data,
          ),
          child: widget.builder(
            context,
            snapshot.data,
            snapshot.error,
          ),
        );
        if (widget.disabledRefresh == true) {
          return child;
        } else {
          return RefreshIndicator(
            onRefresh: handleRefresh,
            child: child,
          );
        }
      },
    );
  }
}
