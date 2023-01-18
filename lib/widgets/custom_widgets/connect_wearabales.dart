import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectWearables extends StatelessWidget {
  const ConnectWearables({Key? key}) : super(key: key);

  Future<void> _launchInWebViewWithJavaScript(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.09,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.02),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 230, 246, 254),
              ),
            ),
            onPressed: () {
              _launchInWebViewWithJavaScript(Uri.parse('https://cure.science/GHPWearables'));
            },
            child: Wrap(
              children: [
                Icon(Icons.watch, color: Theme.of(context).primaryColor),
                SizedBox(
                  width: MediaQuery.of(context).size.height * 0.015,
                ),
                Text(
                  "Connect Wearables",
                  style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
