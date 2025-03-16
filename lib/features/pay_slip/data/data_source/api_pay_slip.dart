import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiPaySlip {
  final Dio httpclient;
  ApiPaySlip(this.httpclient);

  // لیست ماه هایی که فیش حقوق دارند
  Future<dynamic> payslipList() async {
    final response = await httpclient.get('payroll/payslip');
    return response;
  }

  // فیش حقوقی برای یک ماه
  Future<dynamic> payslipDetail(String id) async {
    final response = await httpclient.get('payroll/payslip/$id');
    return response;
  }
}
