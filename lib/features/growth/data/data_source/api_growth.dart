import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiGrowth {
  final Dio httpclient;
  ApiGrowth(this.httpclient);

  // // اطلاعات توسعه فردی
  // Future<dynamic> userSelf() async {
  //   final response = await httpclient.get('user-self-improvement');
  //   return response;
  // }

  // اطلاعات توسعه فردی (با تغییرات جدید)
  // جایگزین userSelf
  Future<dynamic> userImprovementParameters({int? parentId}) async {
    final response =
        await httpclient.get('user-improvement-parameters', queryParameters: {
      'parentId': parentId,
    });
    return response;
  }

  // ثبت گزارش توسعه فردی
  Future<dynamic> userSelfAdd(int improvementId, String description) async {
    final response = await httpclient.post('user-self-improvement', data: {
      "improvementId": improvementId,
      "userScore": 13,
      "description": description,
    });
    return response;
  }

  // لیست امتیازدهی به هر هوش
  Future<dynamic> subitems(int itemId) async {
    final response =
        await httpclient.get('user-self-improvement/subitems/$itemId');
    return response;
  }

  // امتیاز دهی به ساب آیتم های هر هوش
  Future<dynamic> subitemsScore(
      int itemId, int subItemId, int userScore) async {
    final response = await httpclient.post('user-self-improvement/subitem',
        data: {
          "itemId": itemId,
          "subItemId": subItemId,
          "userScore": userScore
        });
    return response;
  }
}
