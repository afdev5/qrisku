part of 'qris_bloc.dart';

class QrisState {
  final List<ConvertQrisModel> datas;
  final bool isLoading;
  final bool isError;
  final String? message;

  QrisState(
      {required this.datas,
      this.isError = false,
      this.isLoading = false,
      this.message});

  QrisState copyWith({
    List<ConvertQrisModel>? datas,
    bool? isLoading,
    bool? isError,
    String? message,
  }) {
    return QrisState(
        datas: datas ?? this.datas,
        isLoading: isLoading ?? this.isLoading,
        isError: isError ?? this.isError,
        message: message ?? this.message);
  }
}
