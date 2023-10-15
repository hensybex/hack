import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final List<String> activeServices;
  final List<String> services = [
    'кредит',
    'карта',
    'ипотека',
    'автокредит',
    'вклад и счет',
    'платежи и переводы',
    'страхование',
    'другие услуги',
  ];
  final Function(List<String>) onApplyFilters;

  FilterDialog({required this.onApplyFilters, required this.activeServices});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  List<bool> _isServiceSelected = [];

  @override
  void initState() {
    super.initState();
    // Initialize based on the active services
    _isServiceSelected = List.generate(
      widget.services.length,
      (index) => widget.activeServices.contains(widget.services[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          children: [
            /* Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle action for the first button
                  },
                  child: const Text('Button 1'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle action for the second button
                  },
                  child: const Text('Button 2'),
                ),
              ],
            ), */
            const SizedBox(height: 16.0),
            const Text('Услуги'),
            const SizedBox(height: 16.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 16.0,
              children: widget.services.asMap().entries.map((entry) {
                int index = entry.key;
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: _isServiceSelected[index]
                        ? Colors.blue
                        : const Color(0xFF282B32),
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isServiceSelected[index] = !_isServiceSelected[index];
                      });
                    },
                    child: Text(
                      widget.services[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'VTB Group UI',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Reset all filters
                    setState(() {
                      _isServiceSelected = List.generate(
                        widget.services.length,
                        (index) => false,
                      );
                    });
                  },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Extract selected services
                    List<String> selectedServices = [];
                    for (int i = 0; i < widget.services.length; i++) {
                      if (_isServiceSelected[i]) {
                        selectedServices.add(widget.services[i]);
                      }
                    }

                    // Call the callback
                    widget.onApplyFilters(selectedServices);

                    // Close the dialog
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
