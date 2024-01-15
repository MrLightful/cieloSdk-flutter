import 'package:cielo_flutter/cielo_flutter.dart';
import 'package:credit_card_form/credit_card_form.dart';
import 'package:flutter/material.dart';

void main() {

  // Initialize Cielo once at start.
  const options = CieloOptions(
    provider: CieloProvider.braspag,
    environment: CieloEnvironment.sandbox,
    language: CieloLanguage.pt,
  );
  const sop = CieloSOPOptions(enableTokenize: true);
  Cielo.init(options);
  Cielo.initSOP(sop);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cielo Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final controller = CreditCardController();
  CieloCard? card;
  String? accessToken;
  dynamic response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Cielo Flutter'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CreditCardForm(
              controller: controller,
              theme: CreditCardLightTheme(),
              onChanged: (CreditCardResult result) {
                card = CieloCard(
                  rawNumber: result.cardNumber,
                  holderName: result.cardHolderName,
                  expirationDate: '${result.expirationMonth}/20${result.expirationYear}',
                  securityCode: result.cvc,
                );
              },
            ),
            TextField(
              onChanged: (value) {
                accessToken = value;
              },
              decoration: const InputDecoration(
                labelText: 'SOP Access Token',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (card != null && accessToken != null) {
                  try {
                    final r = await Cielo.sop.sendCard(
                        card!, accessToken: accessToken!);
                    setState(() {
                      response = r;
                    });
                  } on CieloAPIException catch (e) {
                    setState(() {
                      response = e.toString();
                    });
                  } on CieloCardValidationException catch (e) {
                    setState(() {
                      // use e.message for user-friendly part of the message.
                      response = e.toString();
                    });
                  } on CieloException catch (e) {
                    setState(() {
                      response = e.toString();
                    });
                  }
                }
              },
              child: const Text('Save Card'),
            ),
            const SizedBox(height: 24),
            if (response != null) Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(response!.toString(), textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
