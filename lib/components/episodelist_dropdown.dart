import 'package:flutter/material.dart';

class EpisodeDropdown extends StatefulWidget {
  final List<dynamic> episodesData;
  final String? selectedRange;
  final Function(String) onRangeSelected;

  const EpisodeDropdown({
    super.key,
    required this.episodesData,
    this.selectedRange,
    required this.onRangeSelected,
  });

  @override
  _EpisodeDropdownState createState() => _EpisodeDropdownState();
}

class _EpisodeDropdownState extends State<EpisodeDropdown> {
  late List<String> episodeRanges;
  String? selectedRange;
  @override
  void initState() {
    super.initState();
    _initializeEpisodeRanges();
  }

  void _initializeEpisodeRanges() {
    int totalEpisodes = widget.episodesData.length;
    int rangeSize = 50;
    episodeRanges = [];

    for (int i = 0; i < totalEpisodes; i += rangeSize) {
      int start = i + 1;
      int end = (i + rangeSize > totalEpisodes) ? totalEpisodes : i + rangeSize;
      episodeRanges.add('$start-$end');
    }
    selectedRange = episodeRanges.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        menuMaxHeight: 400,
        value: selectedRange,
        icon: const Icon(Icons.arrow_drop_down, size: 16),
        isExpanded: true,
        style: const TextStyle(fontSize: 12),
        items: episodeRanges.map((String range) {
          return DropdownMenuItem<String>(
            value: range,
            child: Center(
              child: Text(
                range,
                style:  TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.inverseSurface),
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            widget.onRangeSelected(newValue);
          }
        },
      ),
    );
  }
}
