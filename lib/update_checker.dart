import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateChecker {
  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse("https://raw.githubusercontent.com/Rifan7/rifan7.github.io/main/version.json")
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final storeVersion = data["version"];
        final apkUrl = data["apk_url"];
        final notes = data["notes"];

        final info = await PackageInfo.fromPlatform();
        final currentVersion = info.version;

        if (storeVersion != currentVersion) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Update Tersedia"),
              content: Text("Versi baru $storeVersion tersedia.\n\nCatatan:\n$notes"),
              actions: [
                TextButton(
                  child: Text("Nanti"),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: Text("Update"),
                  onPressed: () async {
                    Navigator.pop(context);
                    await launchUrl(Uri.parse(apkUrl), mode: LaunchMode.externalApplication);
                  },
                )
              ],
            ),
          );
        }
      }
    } catch (e) {
      print("Gagal cek update: $e");
    }
  }
}
