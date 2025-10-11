import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/features/Profile/application/location_cubit/location_cubit.dart';
import 'package:flutter_social_media/src/features/Profile/application/location_cubit/location_state.dart';
import 'package:flutter_social_media/src/features/Profile/domain/models/location_model.dart';

class LocationPickerField extends StatefulWidget {
  final String label;
  final Function(Location) onSelected;

  const LocationPickerField({Key? key, required this.label, required this.onSelected}) : super(key: key);

  @override
  State<LocationPickerField> createState() => _LocationPickerFieldState();
}

class _LocationPickerFieldState extends State<LocationPickerField> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<LocationCubit>().search(value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              onChanged: _onChanged,
              decoration: const InputDecoration(hintText: "Search location"),
            ),
            SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<LocationCubit, LocationState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.results.isEmpty) {
                    return const Center(child: Text("No results"));
                  }
                  return ListView.builder(
                    itemCount: state.results.length,
                    itemBuilder: (context, index) {
                      final location = state.results[index];
                      return ListTile(
                        title: Text(location.name),
                        subtitle: Text(location.address),
                        onTap: () {
                          widget.onSelected(location);
                          context.read<LocationCubit>().select(location);
                          Navigator.of(context).pop(location);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            if (context.read<LocationCubit>().state.selected != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Selected: ${context.read<LocationCubit>().state.selected!.name}, "
                  "${context.read<LocationCubit>().state.selected!.address}",
                ),
              ),
          ],
        ),
      ),
    );
  }
}
