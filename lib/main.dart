import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';

// big thanks to youtube channel: Erico Darmawan Handoyo
// indonesian channel that provide this simplest example
// i only do some small changes and explanations

void main() {
  runApp(const Aplikasi());
}

class Aplikasi extends StatelessWidget {
  const Aplikasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tes Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @override
  void initState() {
    super.initState();
    getDevices();
  }

  getDevices() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'all devices that shown here\nmust be paired before, in your phone.\nopen your bluetooth setting and pair\nyour bluetooth printer first'),
            DropdownButton(
              value: selectedDevice,
              hint: const Text('Selecet Thermal Printer'),
              onChanged: (device) {
                selectedDevice = device;
                setState(() {});
              },
              items: [
                for (BluetoothDevice device in devices)
                  DropdownMenuItem(
                    value: device,
                    child: Text(device.name ?? '---'),
                  )
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: getDevices,
              child: const Text('refresh re-scan'),
            ),
            ElevatedButton(
              onPressed: () => printer.disconnect(),
              child: const Text('disconnect'),
            ),
            ElevatedButton(
              onPressed: selectedDevice == null
                  ? null
                  : () => printer.connect(selectedDevice!),
              child: const Text('connect'),
            ),
            ElevatedButton(
              onPressed: () async {
                if ((await printer.isConnected)!) {
                  printer.printNewLine();
                  // SIZE
                  // 0: normal
                  // 1: normal, bold
                  // 2: medium, bold
                  // 3: large, bold

                  // ALIGN
                  // 0: left
                  // 1: center
                  // 2: right
                  printer.printCustom('go test this', 0, 0);
                  printer.printCustom('go test this', 1, 1);
                  printer.printCustom('go test this', 2, 2);
                  printer.printCustom('go test this', 3, 1);
                  printer.printQRcode('yuuuhoooo', 350, 350, 1);
                  printer.printNewLine();
                  printer.printNewLine();
                  printer.disconnect(); // avoiding device overheat
                }
              },
              child: const Text('print'),
            ),
          ],
        ),
      ),
    );
  }
}
