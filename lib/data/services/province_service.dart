import 'package:dio/dio.dart';
import 'package:vdiary_internship/core/constants/api/end_point.dart';
import 'package:vdiary_internship/core/exception/exception_type.dart';
import '../models/province/province_model.dart';

class ProvinceService {
  final Dio _dio = Dio();

  // Hàm lấy tên các tỉnh thành ở Việt Nam
  Future<List<ProvinceModel>> getVietNamProvinces() async {
    try {
      final response = await _dio.get(ApiEndPoint.provinceUrl);

      if (response.statusCode == 200) {
        // Trường hợp data là list
        if (response.data is List) {
          final List<dynamic> data = response.data;
          final List<ProvinceModel> provinces =
              data
                  .map(
                    (json) =>
                        ProvinceModel.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();
          return provinces;

          // Trường hợp data không phải là list -> là object
        } else {
          if (response.data is Map<String, dynamic>) {
            final Map<String, dynamic> dataMap = response.data;

            if (dataMap.containsKey('data')) {
              final List<dynamic> data = dataMap['data'];
              return data
                  .map(
                    (json) =>
                        ProvinceModel.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();
            } else if (dataMap.containsKey('results')) {
              final List<dynamic> data = dataMap['results'];
              return data
                  .map(
                    (json) =>
                        ProvinceModel.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();
            }
          }

          throw ServerException(
            errorMessage: 'Định dạng dữ liệu không đúng',
            code: '400',
          );
        }
      } else {
        throw ServerException(
          errorMessage: 'Lỗi server: ${response.statusCode}',
          code: '${response.statusCode}',
        );
      }
    } catch (e) {
      throw ServerException(errorMessage: e.toString(), code: 'UNKNOWN');
    }
  }
}
