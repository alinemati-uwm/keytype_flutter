enum ChatBotRoles { user, assistant }


enum BlocStatus { initial, error, success, loading }

extension BlocStatusX on BlocStatus {
  bool get isInitial => this == BlocStatus.initial;

  bool get isError => this == BlocStatus.error;

  bool get isSuccess => this == BlocStatus.success;

  bool get isLoading => this == BlocStatus.loading;

}