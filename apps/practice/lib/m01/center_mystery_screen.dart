import 'package:flutter/material.dart';
import 'package:practice/m01/constraint_readout.dart';

class CenterMysteryScreen extends StatefulWidget {
  const CenterMysteryScreen({super.key});

  @override
  State<CenterMysteryScreen> createState() => _CenterMysteryScreenState();
}

class _CenterMysteryScreenState extends State<CenterMysteryScreen> {
  bool _wrapInCenter = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final box = Container(
      width: 100,
      height: 100,
      color: theme.colorScheme.primary,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Center Mystery')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Bọc ô vuông trong Center'),
            subtitle: Text(
              _wrapInCenter ? 'Center(child: box)' : 'box',
              style: const TextStyle(fontFamily: 'monospace'),
            ),
            value: _wrapInCenter,
            onChanged: (value) => setState(() => _wrapInCenter = value),
          ),

          const Divider(height: 1),

          Expanded(
            child: SizedBox.expand(
              child: _wrapInCenter ? Center(child: box) : box,
            ),
          ),

          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 120,
              child: _wrapInCenter
                  ? const Center(child: _probe)
                  : const SizedBox.expand(child: _probe),
            ),
          ),
        ],
      ),
    );
  }
}

const Widget _probe = ConstraintReadout(
  label: 'Constraints mà ô vuông nhận được',
);
