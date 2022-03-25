import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, HomeNotifier homeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Video Call App'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: SizedBox(
              height: 150,
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _channelController,
                    decoration: InputDecoration(
                      errorText: homeNotifier.validateError
                          ? 'Channel name is mandatory'
                          : null,
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                      hintText: 'Channel name',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            onPressed: () => {
                              homeNotifier.onJoin(context, _channelController.text),
                            },
                            child: const Text('Join'),
                            color: Colors.teal,
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }
}
