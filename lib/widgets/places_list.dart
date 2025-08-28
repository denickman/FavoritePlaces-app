import 'package:flutter/material.dart';
import 'package:favoriteplaces/models/place.dart';

class PlacesList extends StatelessWidget {
  // ===== Init =====

  const PlacesList({super.key, required this.places});

  // ===== Properties =====

  final List<Place> places;

  // ===== Lifecycle =====

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No places added yet',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (ctx, index) => ListTile(
        title: Text(
          places[index].title,
          style: Theme.of(ctx).textTheme.titleMedium!.copyWith(
            color: Theme.of(ctx).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
