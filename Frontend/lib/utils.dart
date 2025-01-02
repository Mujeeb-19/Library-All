String parseBackendError(Map<String, dynamic> jsonData) {
  if (jsonData.containsKey('error')) {
    return jsonData['error'] as String;
  } else if (jsonData.containsKey('message')) {
    return jsonData['message'] as String;
  }
  return 'Something went wrong.';
}
