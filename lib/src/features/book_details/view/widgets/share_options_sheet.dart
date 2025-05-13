import 'dart:developer';

import 'package:e_reading/src/core/style/color.dart';
import 'package:e_reading/src/features/admin/model/book_model.dart';
import 'package:e_reading/src/features/book_details/view/widgets/share_option.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareOptionsSheet extends StatelessWidget {
  final BookModel book;
  final String shareText;

  const ShareOptionsSheet({
    super.key,
    required this.book,
    required this.shareText,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Share via',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            // WhatsApp
            ShareOption(
              icon: FontAwesomeIcons.whatsapp,
              title: 'WhatsApp',
              iconColor: Colors.green,
              onTap: () {
                _shareViaWhatsApp(shareText);
                Navigator.pop(context);
              },
            ),

            // Facebook
            ShareOption(
              icon: FontAwesomeIcons.facebookMessenger,
              title: 'Messenger',
              iconColor: Colors.blue,
              onTap: () {
                _shareViaMessenger(shareText);
                Navigator.pop(context);
              },
            ),

            // Telegram
            ShareOption(
              icon: FontAwesomeIcons.telegram,
              title: 'Telegram',
              iconColor: Colors.lightBlue,
              onTap: () {
                _shareViaTelegram(shareText);
                Navigator.pop(context);
              },
            ),

            // Other
            ShareOption(
              icon: FontAwesomeIcons.share,
              title: 'Other',
              iconColor: AppColors.primary,
              onTap: () {
                // ignore: deprecated_member_use
                Share.share(shareText);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Share via WhatsApp
  void _shareViaWhatsApp(String text) async {
    final whatsappUrl = "whatsapp://send?text=${Uri.encodeComponent(text)}";
    try {
      await launchUrl(Uri.parse(whatsappUrl));
    } catch (e) {
      print('WhatsApp not installed: $e');
      Get.snackbar('Error', 'WhatsApp not installed');
    }
  }

  void _shareViaMessenger(String text) async {
    // Extract URL from text if it exists, or use a fallback
    final RegExp urlRegex = RegExp(r'https?://\S+');
    final Match? match = urlRegex.firstMatch(text);
    final String url =
        match != null
            ? match.group(0)!
            : 'https://yourbookappwebsite.com'; // Use your website as fallback

    // For Facebook Messenger, we need a proper URL to share
    final messengerUrl =
        "fb-messenger://share?link=${Uri.encodeComponent(url)}&app_id=YOUR_FACEBOOK_APP_ID";

    try {
      final canLaunch = await canLaunchUrl(Uri.parse(messengerUrl));
      if (canLaunch) {
        await launchUrl(Uri.parse(messengerUrl));
      } else {
        // Try web fallback
        final webUrl =
            "https://www.facebook.com/dialog/send?app_id=YOUR_FACEBOOK_APP_ID&link=${Uri.encodeComponent(url)}&redirect_uri=${Uri.encodeComponent('https://yourbookappwebsite.com')}";
        await launchUrl(Uri.parse(webUrl));
      }
    } catch (e) {
      log('Messenger error: $e');
      Get.snackbar('Error', 'Could not open Messenger');
    }
  }

  // Share via Telegram
  void _shareViaTelegram(String text) async {
    final telegramUrl =
        "https://t.me/share/url?url=${Uri.encodeComponent(text)}";
    try {
      await launchUrl(Uri.parse(telegramUrl));
    } catch (e) {
      log('Telegram not installed: $e');
      Get.snackbar('Error', 'Telegram not installed');
    }
  }
}
