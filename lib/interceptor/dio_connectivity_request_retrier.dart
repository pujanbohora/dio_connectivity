import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';

class DioConnectivityRequestRetrier {
  final Dio dio;
  final Connectivity connectivity;

  DioConnectivityRequestRetrier(
      {required this.dio, required this.connectivity});

  Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    StreamSubscription? streamSubscription;
    final responseCompleter = Completer<Response>();
    connectivity.onConnectivityChanged.listen(
            (connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        streamSubscription!.cancel();
        responseCompleter.complete(
          dio.request(
            requestOptions.path,
            cancelToken: requestOptions.cancelToken,
            data: requestOptions.data,
            onReceiveProgress: requestOptions.onReceiveProgress,
            onSendProgress: requestOptions.onReceiveProgress,
            queryParameters: requestOptions.queryParameters,
            // options: requestOptions,
          ),
        );
      }
    });

    return responseCompleter.future;
  }
}
