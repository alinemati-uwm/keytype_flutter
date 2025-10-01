import 'package:json_annotation/json_annotation.dart';
import 'task_model.dart';
part 'task_response_model.g.dart';

@JsonSerializable()
class TaskResponseModel {
  final TaskResponseMeta? meta;
  final List<TaskModel>? results;

  const TaskResponseModel({
    this.meta,
    this.results,
  });

  /// Creates a TaskResponseModel from JSON
  factory TaskResponseModel.fromJson(Map<String, dynamic> json) => _$TaskResponseModelFromJson(json);

  /// Converts TaskResponseModel to JSON
  Map<String, dynamic> toJson() => _$TaskResponseModelToJson(this);

  /// Creates a copy of this TaskResponseModel with the given fields replaced with new values
  TaskResponseModel copyWith({
    TaskResponseMeta? meta,
    List<TaskModel>? results,
  }) {
    return TaskResponseModel(
      meta: meta ?? this.meta,
      results: results ?? this.results,
    );
  }

  /// Returns true if there are any results
  bool get hasResults => results?.isNotEmpty == true;

  /// Returns the number of results
  int get resultCount => results?.length ?? 0;

  /// Returns true if there is a next page
  bool get hasNextPage => meta?.hasNext == true;

  /// Returns true if there is a previous page
  bool get hasPreviousPage => meta?.hasPrevious == true;

  /// Returns the current page number
  int get currentPage => meta?.currentPage ?? 1;

  /// Returns the total number of pages
  int get totalPages => meta?.totalPages ?? 0;

  /// Returns the total number of items
  int get totalItems => meta?.totalItems ?? 0;

  /// Returns completed tasks only
  List<TaskModel> get completedTasks {
    return results?.where((task) => task.isCompleted).toList() ?? [];
  }

  /// Returns tasks with errors only
  List<TaskModel> get tasksWithErrors {
    return results?.where((task) => task.hasError).toList() ?? [];
  }

  /// Returns pending tasks only
  List<TaskModel> get pendingTasks {
    return results?.where((task) => task.isPending).toList() ?? [];
  }

  /// Returns in-progress tasks only
  List<TaskModel> get inProgressTasks {
    return results?.where((task) => task.isInProgress).toList() ?? [];
  }

  @override
  String toString() {
    return 'TaskResponseModel(meta: $meta, resultCount: $resultCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskResponseModel &&
        other.meta == meta &&
        _listEquals(other.results, results);
  }

  @override
  int get hashCode {
    return Object.hash(meta, results);
  }

  /// Helper method to compare lists
  bool _listEquals(List<TaskModel>? a, List<TaskModel>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}

@JsonSerializable()
class TaskResponseMeta {
  @JsonKey(name: 'current_page')
  final int? currentPage;
  @JsonKey(name: 'total_pages')
  final int? totalPages;
  @JsonKey(name: 'total_items')
  final int? totalItems;
  @JsonKey(name: 'has_next')
  final bool? hasNext;
  @JsonKey(name: 'has_previous')
  final bool? hasPrevious;

  const TaskResponseMeta({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.hasNext,
    this.hasPrevious,
  });

  /// Creates a TaskResponseMeta from JSON
  factory TaskResponseMeta.fromJson(Map<String, dynamic> json) => _$TaskResponseMetaFromJson(json);

  /// Converts TaskResponseMeta to JSON
  Map<String, dynamic> toJson() => _$TaskResponseMetaToJson(this);

  /// Creates a copy of this TaskResponseMeta with the given fields replaced with new values
  TaskResponseMeta copyWith({
    int? currentPage,
    int? totalPages,
    int? totalItems,
    bool? hasNext,
    bool? hasPrevious,
  }) {
    return TaskResponseMeta(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
    );
  }

  /// Returns true if this is the first page
  bool get isFirstPage => currentPage == 1;

  /// Returns true if this is the last page
  bool get isLastPage => currentPage == totalPages;

  /// Returns the next page number if available
  int? get nextPage => hasNext == true ? (currentPage ?? 0) + 1 : null;

  /// Returns the previous page number if available
  int? get previousPage => hasPrevious == true ? (currentPage ?? 1) - 1 : null;

  /// Returns the percentage of pages completed
  double get pageProgress {
    if (totalPages == null || totalPages == 0) return 0.0;
    return (currentPage ?? 0) / totalPages!;
  }

  @override
  String toString() {
    return 'TaskResponseMeta(currentPage: $currentPage, totalPages: $totalPages, totalItems: $totalItems)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskResponseMeta &&
        other.currentPage == currentPage &&
        other.totalPages == totalPages &&
        other.totalItems == totalItems &&
        other.hasNext == hasNext &&
        other.hasPrevious == hasPrevious;
  }

  @override
  int get hashCode {
    return Object.hash(
      currentPage,
      totalPages,
      totalItems,
      hasNext,
      hasPrevious,
    );
  }
}