import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:dio_connectivity_app/interceptor/dio_connectivity_request_retrier.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final DioConnectivityRequestRetrier dioConnectivityRequestRetrier;

  RetryOnConnectionChangeInterceptor({required this.dioConnectivityRequestRetrier});

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      // TODO: implement onError
      //occurs when socket exception occurs
      try {
        return dioConnectivityRequestRetrier
            .scheduleRequestRetry(err.requestOptions);
      } catch (e) {
        return e;
      }
      err.requestOptions;
    }
    return err;
  }

  bool _shouldRetry(DioError err) {
    return err.type == DioErrorType.other &&
        err.error != null &&
        err.error is SocketException;
  }
}
