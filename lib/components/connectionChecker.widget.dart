import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/config.dart';
import '../constants/text_styles.dart';
import '../init.dart';

class ConnectionChecker extends StatelessWidget {
  const ConnectionChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Config.connectionStateStream.stream,
      builder: (context, snapshot) {
        if (snapshot.data == ConnectionStatus.connecting) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 10),
              Text(
                'connecting...',
                style: MyTextStyles.header2,
              ),
              SizedBox(width: 10),
              CircularProgressIndicator(
                color: Colors.grey,
              )
            ],
          );
        }
        if (snapshot.data == ConnectionStatus.connectionFailed) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 10),
              TextButton(
                onPressed: () => AppInit().initSocketClient(),
                child: Text(
                  'Disconnected',
                  style: MyTextStyles.header2,
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
