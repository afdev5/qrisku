part of 'default_qris_bloc.dart';

class DefaultQrisState {
  final bool isLoading;
  final bool isError;
  final String? message;
  final InfoQrisModel? data;

  DefaultQrisState({this.isLoading = false, this.isError = false, this.message, this.data});

  DefaultQrisState copyWith({
    InfoQrisModel? data,
    bool? isLoading,
    bool? isError,
    String? message,
  }) {
    return DefaultQrisState(
        data: data ?? this.data,
        isLoading: isLoading ?? this.isLoading,
        isError: isError ?? this.isError,
        message: message ?? this.message);
  }
}

