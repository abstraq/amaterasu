import "package:amaterasu/core/exceptions/http_exception.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "async_value_dialog_extension.freezed.dart";

extension AsyncValueDialogExtension on AsyncValue {
  void showAlertOnError(BuildContext context) {
    if (!isRefreshing && hasError) {
      final message = _errorMessage(error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.body),
        ),
      );
    }
  }

  ErrorMessage _errorMessage(Object? e) {
    if (e is HttpException) {
      final error = e;
      return ErrorMessage(
        title: "Failed to perform request.",
        body:
            "While trying to connect to ${error.uri?.host} we got a ${error.statusCode} error. Please try again later.",
      );
    } else {
      return ErrorMessage(
        title: "Encountered an unknown error.",
        body: "Sorry, something went wrong while trying to perform this action but I don't know how to deal with it."
            "Please contact support if this keeps happening and tell them you encountered: $error.",
      );
    }
  }
}

@freezed
class ErrorMessage with _$ErrorMessage {
  const factory ErrorMessage({required String title, required String body}) = _ErrorMessage;
}
