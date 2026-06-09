class AppUrl {
  static const String baseUrl = 'http://10.0.2.2:5000/api/v1';
  // static const String baseUrl =
  //     'http://localhost:5000/api/v1'; // Replace with YOUR IP

  static const String loginApi = '$baseUrl/auth/login';
  static const String registerApi = '$baseUrl/auth/register';
  static const String logoutApi = '$baseUrl/auth/logout';
  static const String channelsApi = '$baseUrl/channels';
  static const String feedApi = '$baseUrl/posts';
  static const String discoverApi = '$baseUrl/search/discover';
  static const String searchApi = '$baseUrl/search';
  static const String groupsApi = '$baseUrl/groups';
  static const String jobsApi = '$baseUrl/jobs';
  static const String profileApi = '$baseUrl/auth/me';
  static const String updateProfileApi = '$baseUrl/auth/profile';
  static const String uploadAvatarApi = '$baseUrl/auth/avatar';
  static const String myPostsApi = '$baseUrl/auth/posts';
  static const String myStatsApi = '$baseUrl/auth/stats';
  static const String aiChatApi = '$baseUrl/ai/chat';
  static const String aiSuggestionsApi = '$baseUrl/ai/suggestions';

  // Test route added earlier
  static const String testDbApi = 'http://10.0.2.2:5000/test-db';
}
