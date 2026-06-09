abstract class BaseApiServices {
  Future<dynamic> getapi(String url, {Map<String, String>? headers});
  Future<dynamic> postapi(dynamic data, String url, {Map<String, String>? headers});
  Future<dynamic> patchapi(dynamic data, String url, {Map<String, String>? headers});
  Future<dynamic> deleteapi(String url, {Map<String, String>? headers});
}
