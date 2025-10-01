import 'package:keytype/core/helper/extensions/app_extensions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/init/dependency_injection.dart';
import '../../core/models/template_model/parent_category_res_model.dart';
import '../../core/models/template_model/template_res_model.dart';
import '../../core/network/templates/templates_api_calls.dart';
import '../../ui_imports.dart';

class TemplateController extends GetxController {

  final templatesApiCalls = getIt<TemplatesApiCalls>();

  var currentIndex = 0.obs;
  final selectedCategory = 0.obs;


  final isLoadingCategory = false.obs;
  final isLoadingTemplates = false.obs;

  final listTemplates = <TemplateModel>[].obs;
  final listCategory = <ParentCategoryResModel>[].obs;

  final searchCnt = TextEditingController();
  int offset = 0;
  final refreshController = RefreshController();
  @override
  void onReady() {
    super.onReady();
    _callApiTemplated();
    _getCategories();
  }




  void _callApiTemplated()async{
    isLoadingTemplates.value = true;
    await _apiTemplated(onSuccess: (List<TemplateModel> data) {
      listTemplates.clear();
      listTemplates.addAll(data.toList());

    }, onError: () {
    });
    isLoadingTemplates.value = false;

  }

  Future<void> _apiTemplated({
    required Function(List<TemplateModel> data) onSuccess,
    required Function() onError,
    int? categoryId,
    String? query,
    int take = 16,
    int offset = 0,
  }) async {
    final res = await templatesApiCalls.publicTemplates(
      limit: take,
      offset: offset,
      query: query,
      categoryId: categoryId,
    );
    res.fold(
          (left) {
            onError();
      },
          (data) {
            onSuccess(data);


      },
    );
  }


  Future<void> changeCategory({required int categoryId , bool isRefresh = false}) async {
    if (categoryId == selectedCategory.value && !isRefresh ) return;
    refreshController.loadComplete();
    offset = 0;
    listTemplates.value = [];
    selectedCategory.value = categoryId;
    isLoadingTemplates.value = true;
    searchCnt.clear();
    update();
    if (categoryId == 0) {
      _callApiTemplated();
      return;
    }
    await _apiTemplated(
      categoryId: categoryId,
      onSuccess: (data) {
        listTemplates.clear();
        listTemplates.addAll(data);
      },
      onError: () {
      },
    );
    isLoadingTemplates.value = false;

  }



  Future<void> _getCategories() async {
    if (listCategory.isNotEmpty) return;
    isLoadingCategory.value= true;
    final res = await templatesApiCalls.getCategories();
    res.fold(
          (left) {
         },
          (data) {
            listCategory.clear();
            listCategory.insert(0, ParentCategoryResModel(name: 'All', id: 0));
            listCategory.addAll(data.toList());
      },
    );
    isLoadingCategory.value= false;

  }

  Future<void> loadMoreData() async {
    if (offset == 0) {
      offset = 16;
    } else {
      offset = offset * 2;
    }

    await _apiTemplated(
      offset: offset,
      query: searchCnt.text,
      categoryId: selectedCategory.value,
      onSuccess: (data) {
        if (data.isNullOrEmpty) {
          refreshController.loadNoData();
          return;
        }
        listTemplates.addAll(data);
        refreshController.loadComplete();
      },
      onError: () {
        refreshController.loadNoData();
      },
    );
  }



}