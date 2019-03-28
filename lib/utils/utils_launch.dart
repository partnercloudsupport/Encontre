import 'package:url_launcher/url_launcher.dart';

class UtilsLaunch {

  static openPhone(String phone) async {
      if (await canLaunch("tel:${phone}")) {
        await launch("tel:${phone}");
      } else {
        throw 'Could not launch';
      }
  }

  static openEmail(String email) async {
      if (await canLaunch("mailto:${email}")) {
        await launch("mailto:${email}");
      } else {
        throw 'Could not launch';
      }
  }

  static openMaps(String address)  async {
    if (await canLaunch(address)) {
      await launch(address);
    } else {
      throw 'Could not open the map.';
    }
  }

  static openFacebook(String facebook)  async {
    if (await canLaunch(facebook)) {
      await launch(facebook);
    } else {
      throw 'Could not open the facebook.';
    }
  }

  static openWhatsApp(String wpp)  async {
    if (await canLaunch(wpp)) {
      await launch(wpp);
    } else {
      throw 'Could not open the whatsapp.';
    }
  }

}