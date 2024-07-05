import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';

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
      theme: ThemeData(
          primarySwatch: Colors
              .blue), // bisa juga ThemeData(appBarTheme: AppBarTheme(backgroundColor: Colors.blue))
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
    print(devices.map((e) => e.address));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                  printer.printCustom('coba-coba', 0, 0);
                  printer.printCustom('coba-coba', 1, 1);
                  printer.printCustom('coba-coba', 2, 2);
                  printer.printCustom('coba-coba', 3, 1);
                  printer.printQRcode('yuuuhoooo', 350, 350, 1);
                  printer.printNewLine();
                  printer.printNewLine();
                  printer.disconnect();
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
