// repositories/otp_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/verification.dart';

class OtpRepository {
  final String apiUrl = "https://yourapi.com/verify-otp"; // Replace with your API URL

  Future<bool> verifyOtp(OtpVerificationModel otpData) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(otpData.toJson()),
      );

      if (response.statusCode == 200) {
        // Assuming API returns a success message in JSON
        final responseData = jsonDecode(response.body);
        return responseData['success'] == true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error verifying OTP: $e");
      return false;
    }
  }
}


class ResetPasswordRepository {
  final String _baseUrl = 'http://192.168.143.149:8000/api'; // Adjust based on your setup

  Future<String> resetPassword(ResetPasswordModel model) async {
    final url = Uri.parse('$_baseUrl/reset-password');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(model.toJson());

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['message'];
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Password reset failed.');
      }
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }
}

final repository = ResetPasswordRepository();

void resetUserPassword() async {
  final resetModel = ResetPasswordModel(
    phone: '1234567890',
    otp: '1234',
    newPassword: 'newPassword123',
    confirmPassword: 'newPassword123',
  );

  try {
    final message = await repository.resetPassword(resetModel);
    print(message); // Password reset successfully.
  } catch (e) {
    print(e); // Error message if password reset fails.
  }
}
