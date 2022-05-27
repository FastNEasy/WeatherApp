import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NFCWidget extends StatefulWidget {
  const NFCWidget({Key? key}) : super(key: key);

  @override
  State<NFCWidget> createState() => _NFCWidgetState();
}

class _NFCWidgetState extends State<NFCWidget> {
  ValueNotifier<Map<String, dynamic>?> result = ValueNotifier(null);
  String bitString = "";
  String hexString = "";
  String bString = "";
  List<bool> switchStates = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  void _tagRead() {
    NfcManager.instance.stopSession();
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      print(tag.data);
      Map tagNdef = result.value?['ndef'];
      Map cachedMsg = tagNdef['cachedMessage'];
      Map records = cachedMsg['records'][0];
      Uint8List payload = records['payload'];
      String payloadAsString = utf8.decode(payload);
      print(payloadAsString.split("en")[1]);
      NfcManager.instance.stopSession();
    });
    setState(() {
      bString =
          int.parse(hexString, radix: 16).toRadixString(2).padLeft(8, '0');
      for (var i = 0; i < switchStates.length; i++) {
        //switchStates[i] =
      }
    });

    print(bString);
  }

  void _ndefWrite() {
    _saveConfigToBinary();
    NfcManager.instance.stopSession();
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result.value = {'Bye ': 'Tag is not ndef writable'};
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText(hexString),
        // NdefRecord.createMime(
        //     'text/plain', Uint8List.fromList('Hello'.codeUnits)),
        // NdefRecord.createExternal(
        //     'com.example', 'mytype', Uint8List.fromList('mydata'.codeUnits)),
      ]);

      try {
        await ndef.write(message);
        result.value = {'Hi': 'Success to "Ndef Write"'};
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = {"Error ": e};
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }

  void _saveConfigToBinary() {
    String temp = "";
    for (var i = 0; i < switchStates.length; i++) {
      temp += (switchStates[i] ? 1 : 0).toString();
      //print(temp);
    }
    setState(() {
      bitString = temp;
      hexString = int.parse(bitString, radix: 2).toRadixString(16).trim();
    });
    print(bitString);
    print(hexString);
    print(hexString.codeUnits);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NFC reader"),
      ),
      body: Center(
        child: FutureBuilder<bool>(
          future: NfcManager.instance.isAvailable(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Text("NfcManager.isAvailable(): ${snapshot.data}"),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Column(
              children: [
                SizedBox(
                  height: 430.0,
                  child: ListView.builder(
                      itemCount: switchStates.length,
                      itemBuilder: (context, index) {
                        return SwitchListTile(
                            title: Text("Switch: $index"),
                            value: switchStates[index],
                            onChanged: (value) {
                              setState(() {
                                switchStates[index] = value;
                              });
                              print("Theme is: $value for switch: $index");
                            });
                      }),
                ),
                ValueListenableBuilder<Map<String, dynamic>?>(
                  valueListenable: result,
                  builder: (context, value, _) {
                    return Text('${value?.entries ?? ''}');
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _tagRead,
                      child: const Text("Tag read"),
                    ),
                    ElevatedButton(
                      child: const Text('Ndef Write'),
                      onPressed: _ndefWrite,
                    ),
                  ],
                ),
                // ElevatedButton(
                //   onPressed: _saveConfigToBinary,
                //   child: const Text("Turn config to binary string!"),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}
