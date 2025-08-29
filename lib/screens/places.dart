import 'package:favoriteplaces/providers/user_places.dart';
import 'package:favoriteplaces/widgets/places_list.dart';
import 'package:favoriteplaces/screens/add_place.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() {
    return _PlacesScreenState();
  }
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const AddPlaceScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // FutureBuilder — позволяет строить интерфейс в зависимости от состояния асинхронной 
        // операции (Future).
        child: FutureBuilder(
          future: _placesFuture, //  Асинхронная операция (Future)
          builder: (ctx, snapshot) => // Функция, которая строит UI в зависимости от состояния Future
              snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : PlacesList(places: userPlaces),
        ),
      ),
    );
  }
}

/*
FutureBuilder - 
Через snapshot.connectionState можно проверить:
ConnectionState.none — Future ещё не запущен
ConnectionState.waiting — Future выполняется (мы ждём результат)
ConnectionState.done — Future завершился
*/