// main.dart
// Smart Home Dashboard - Single file Flutter app

import 'package:flutter/material.dart';

void main() => runApp(const SmartHomeApp());

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Home Dashboard',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          bodyMedium: TextStyle(fontSize: 14),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

/// Simple device model used for UI state only (in-memory)
class DeviceModel {
  String name;
  DeviceType type;
  String room;
  bool isOn;
  double value; // brightness or speed (0.0 - 100.0)

  DeviceModel({
    required this.name,
    required this.type,
    required this.room,
    this.isOn = false,
    this.value = 50.0,
  });
}

enum DeviceType { light, fan, ac, camera }

String deviceTypeToString(DeviceType t) {
  switch (t) {
    case DeviceType.light:
      return 'Light';
    case DeviceType.fan:
      return 'Fan';
    case DeviceType.ac:
      return 'AC';
    case DeviceType.camera:
      return 'Camera';
  }
}

IconData deviceIcon(DeviceType t) {
  switch (t) {
    case DeviceType.light:
      return Icons.lightbulb_outline;
    case DeviceType.fan:
      return Icons.toys; // nice fan-ish icon
    case DeviceType.ac:
      return Icons.ac_unit;
    case DeviceType.camera:
      return Icons.videocam;
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<DeviceModel> devices = [
    DeviceModel(name: 'Living Room Light', type: DeviceType.light, room: 'Living Room', isOn: true, value: 80),
    DeviceModel(name: 'Bedroom Fan', type: DeviceType.fan, room: 'Bedroom', isOn: false, value: 40),
    DeviceModel(name: 'Window AC', type: DeviceType.ac, room: 'Bedroom', isOn: false, value: 20),
    DeviceModel(name: 'Front Door Camera', type: DeviceType.camera, room: 'Entrance', isOn: true, value: 0),
  ];

  // Used to provide a subtle tap animation state per index
  final Map<int, bool> _pressedStates = {};

  void _toggleDevice(int index, bool val) {
    setState(() {
      devices[index].isOn = val;
    });
  }

  void _updateDeviceValue(int index, double newValue) {
    setState(() {
      devices[index].value = newValue;
    });
  }

  void _addDevice(DeviceModel device) {
    setState(() {
      devices.add(device);
    });
  }

  void _showAddDeviceDialog() {
    showDialog(
      context: context,
      builder: (_) => AddDeviceDialog(onAdd: _addDevice),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = (width / 220).clamp(1, 4).toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Home Dashboard'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Menu tapped'))),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile tapped'))),
              child: const CircleAvatar(
                child: Text('U'),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Summary/header row (responsive)
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Home Status', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text('${devices.where((d) => d.isOn).length} devices ON · ${devices.length} total'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: const [
                        Icon(Icons.home, size: 28),
                        SizedBox(height: 6),
                        Text('My Home', style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Devices grid
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.05,
                ),
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  final pressed = _pressedStates[index] ?? false;

                  return GestureDetector(
                    onTapDown: (_) => setState(() => _pressedStates[index] = true),
                    onTapUp: (_) => setState(() => _pressedStates[index] = false),
                    onTapCancel: () => setState(() => _pressedStates[index] = false),
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 120),
                      scale: pressed ? 0.98 : 1.0,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          // open details screen and wait for possible changes
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DeviceDetailScreen(
                                device: device,
                                onChanged: (isOn, value) {
                                  setState(() {
                                    device.isOn = isOn;
                                    device.value = value;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: Icon(deviceIcon(device.type), size: 28),
                                        ),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          width: width / (crossAxisCount * 2.2),
                                          child: Text(device.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                        ),
                                      ],
                                    ),
                                    Switch(
                                      value: device.isOn,
                                      onChanged: (val) => _toggleDevice(index, val),
                                    )
                                  ],
                                ),

                                // Status Text
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(),
                                    Text(
                                      '${deviceTypeToString(device.type)} is ${device.isOn ? 'ON' : 'OFF'}',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    if (device.type == DeviceType.light || device.type == DeviceType.fan)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6.0),
                                        child: LinearProgressIndicator(value: device.value / 100),
                                      ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDeviceDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DeviceDetailScreen extends StatefulWidget {
  final DeviceModel device;
  final void Function(bool isOn, double value)? onChanged;

  const DeviceDetailScreen({super.key, required this.device, this.onChanged});

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  late bool isOn;
  late double value;

  @override
  void initState() {
    super.initState();
    isOn = widget.device.isOn;
    value = widget.device.value;
  }

  void _applyChanges() {
    widget.device.isOn = isOn;
    widget.device.value = value;
    if (widget.onChanged != null) widget.onChanged!(isOn, value);
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.device.type;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _applyChanges();
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Large icon
            Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                    ),
                    padding: const EdgeInsets.all(28),
                    child: Icon(deviceIcon(type), size: 72),
                  ),
                  const SizedBox(height: 12),
                  Text(deviceTypeToString(type), style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text('Room: ${widget.device.room}'),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Current status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Status', style: Theme.of(context).textTheme.titleLarge),
                Switch(
                  value: isOn,
                  onChanged: (v) => setState(() => isOn = v),
                )
              ],
            ),

            const SizedBox(height: 12),

            // Control slider for lights/fans
            if (type == DeviceType.light || type == DeviceType.fan) ...[
              Text(type == DeviceType.light ? 'Brightness' : 'Speed'),
              Slider(
                value: value,
                min: 0,
                max: 100,
                divisions: 100,
                label: value.round().toString(),
                onChanged: isOn
                    ? (v) => setState(() => value = v)
                    : null, // disable slider when device is OFF
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: isOn
                    ? () => setState(() => value = (value >= 100 ? 0 : (value + 10).clamp(0, 100)))
                    : null,
                child: const Text('Quick +10'),
              ),
            ],

            if (type == DeviceType.ac) ...[
              const Text('AC controls coming soon — simple ON/OFF in this demo.'),
            ],

            if (type == DeviceType.camera) ...[
              const SizedBox(height: 12),
              const Text('Live feed not implemented in demo — placeholder only.'),
            ],

            const Spacer(),

            // Save / Apply button
            ElevatedButton(
              onPressed: () {
                _applyChanges();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              child: const Text('Save & Close'),
            )
          ],
        ),
      ),
    );
  }
}

class AddDeviceDialog extends StatefulWidget {
  final void Function(DeviceModel) onAdd;

  const AddDeviceDialog({super.key, required this.onAdd});

  @override
  State<AddDeviceDialog> createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<AddDeviceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roomController = TextEditingController();
  DeviceType? _selectedType = DeviceType.light;
  bool _isOn = false;

  @override
  void dispose() {
    _nameController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final device = DeviceModel(
      name: _nameController.text.trim(),
      type: _selectedType ?? DeviceType.light,
      room: _roomController.text.trim().isEmpty ? 'Unknown' : _roomController.text.trim(),
      isOn: _isOn,
      value: 50.0,
    );

    widget.onAdd(device);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Device'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Device Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<DeviceType>(
                value: _selectedType,
                items: DeviceType.values
                    .map((t) => DropdownMenuItem(value: t, child: Text(deviceTypeToString(t))))
                    .toList(),
                onChanged: (v) => setState(() => _selectedType = v),
                decoration: const InputDecoration(labelText: 'Device Type'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _roomController,
                decoration: const InputDecoration(labelText: 'Room Name'),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Start ON'),
                  Switch(value: _isOn, onChanged: (v) => setState(() => _isOn = v)),
                ],
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(onPressed: _submit, child: const Text('Add')),
      ],
    );
  }
}
