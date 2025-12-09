import 'package:flutter/material.dart';

import '../services/audio_service.dart';

class AudioToggleButton extends StatefulWidget {
  const AudioToggleButton({super.key});

  @override
  State<AudioToggleButton> createState() => _AudioToggleButtonState();
}

class _AudioToggleButtonState extends State<AudioToggleButton> {
  bool _muted = false;

  @override
  void initState() {
    super.initState();
    _muted = AudioService.instance.isMuted;
  }

  @override
  Widget build(BuildContext context) {
    final IconData iconData = _muted ? Icons.volume_off : Icons.volume_up;
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _muted = !_muted;
                AudioService.instance.setMuted(_muted);
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(
                iconData,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
