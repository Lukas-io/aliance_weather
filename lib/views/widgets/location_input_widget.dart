import 'package:aliance_weather/core/colors.dart';
import 'package:flutter/material.dart';

class LocationInputWidget extends StatefulWidget {
  final Function(String) onSearch;

  const LocationInputWidget({super.key, required this.onSearch});

  @override
  State<LocationInputWidget> createState() => _LocationInputWidgetState();
}

class _LocationInputWidgetState extends State<LocationInputWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,

            decoration: const InputDecoration(
              hintText: 'Enter city name',
              prefixIcon: Icon(Icons.search, size: 24),
              fillColor: WeatherColors.card,
              contentPadding: EdgeInsetsGeometry.symmetric(vertical: 0),
              isDense: true,
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                widget.onSearch(value);
              }
            },
          ),
        ),
        const SizedBox(width: 4),
        IconButton.filled(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onSearch(_controller.text);
            }
          },
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(4),
            ),
          ),
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }
}
