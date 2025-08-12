import 'package:flutter/material.dart';
import 'package:flutter_smartcar_auth/flutter_smartcar_auth.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Smartcar Auth',
      home: SmartcarAuthMenu(),
    );
  }
}

class SmartcarAuthMenu extends StatefulWidget {
  const SmartcarAuthMenu({super.key});

  @override
  State<SmartcarAuthMenu> createState() => _SmartcarAuthMenuState();
}

class _SmartcarAuthMenuState extends State<SmartcarAuthMenu> {
  @override
  void initState() {
    super.initState();
    Smartcar.onSmartcarResponse.listen(_handleSmartcarResponse);
  }

  void _handleSmartcarResponse(SmartcarAuthResponse response) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    switch (response) {
      case SmartcarAuthSuccess success:
        scaffoldMessenger.showMaterialBanner(
          MaterialBanner(
            backgroundColor: Colors.green,
            content: Text(
              'Code: ${success.code}',
              style: const TextStyle(color: Colors.white),
            ),
            actions: const [SizedBox.shrink()],
          ),
        );
        break;
      case SmartcarAuthFailure failure:
        scaffoldMessenger.showMaterialBanner(
          MaterialBanner(
            backgroundColor: Colors.redAccent,
            content: Text(
              'Error: ${failure.description}',
              style: const TextStyle(color: Colors.white),
            ),
            actions: const [SizedBox.shrink()],
          ),
        );
        break;
    }

    Future.delayed(
      const Duration(seconds: 3),
    ).then((_) => scaffoldMessenger.hideCurrentMaterialBanner());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Smartcar Auth')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                await Smartcar.setup(
                  configuration: const SmartcarConfig(
                    clientId: "87747373-1bd6-48dc-a467-8c6e9f26c5ce",
                    redirectUri:
                        "sc87747373-1bd6-48dc-a467-8c6e9f26c5ce://myapp",
                    scopes: [SmartcarPermission.readOdometer],
                    mode: SmartcarMode.test,
                  ),
                );
              },
              child: const Text("Setup Smartcar"),
            ),
            const SizedBox(height: 16),
            MaterialButton(
              color: Colors.green,
              textColor: Colors.white,
              onPressed: () async {
                await Smartcar.launchAuthFlow();
              },
              child: const Text("Launch Auth Flow"),
            ),
            const SizedBox(height: 16),
            MaterialButton(
              color: Colors.deepPurple,
              textColor: Colors.white,
              onPressed: () async {
                await Smartcar.launchAuthFlow(
                  authUrlBuilder: const AuthUrlBuilder(
                    flags: ['tesla_auth:true'],
                    singleSelect: true,
                  ),
                );
              },
              child: const Text("Launch with Tesla Flag"),
            ),
          ],
        ),
      ),
    );
  }
}
