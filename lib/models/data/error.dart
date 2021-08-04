import 'package:equatable/equatable.dart';

/// This class models error messages generated/returned from calls to HERE Geocdding and Search REST API
class Error extends Equatable {
  /// The HTTP status code
  final int status;

  /// Human-readable error description
  final String title;

  /// Error code
  final String code;

  /// Human-readable explanation for the error
  final String cause;

  /// Human-readable action for the user
  final String action;

  /// Request identifier provided by the user
  final String requestId;

  /// Auto-generated ID univocally identifying this request
  final String correlationId;

  const Error._({
    this.status = 0,
    this.title = "",
    this.code = "",
    this.cause = "",
    this.action = "",
    this.requestId = "",
    this.correlationId = "",
  });

  factory Error({
    int? status = 0,
    String? title = "",
    String? code = "",
    String? cause = "",
    String? action = "",
    String? requestId = "",
    String? correlationId = "",
  }) =>
      Error._(
        status: status ?? 0,
        title: title ?? "",
        code: code ?? "",
        cause: cause ?? "",
        action: action ?? "",
        correlationId: correlationId ?? "",
        requestId: requestId ?? "",
      );

  factory Error.fromJson(Map<String?, dynamic>? json) => Error(
        status: json?["status"] ?? 0,
        title: json?["title"] ?? "",
        code: json?["code"] ?? "",
        cause: json?["cause"] ?? "",
        action: json?["action"] ?? "",
        requestId: json?["requestId"] ?? "",
        correlationId: json?["correlationId"] ?? "",
      );

  static Map<String, dynamic> toJson(Error? error) => {
        "status": error?.status ?? 0,
        "title": error?.title ?? "",
        "code": error?.code ?? "",
        "cause": error?.cause ?? "",
        "action": error?.action ?? "",
        "requestId": error?.requestId ?? "",
        "correlationId": error?.correlationId ?? "",
      };

  @override
  List<Object?> get props =>
      [status, title, code, cause, action, correlationId, requestId];
}
