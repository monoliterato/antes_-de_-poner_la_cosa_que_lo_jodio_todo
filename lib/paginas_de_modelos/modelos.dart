import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'metodos-modelo.dart';

class Modelos extends StatelessWidget {
  const Modelos({super.key});

  static final _modeloFirestoreService = ModeloFirestoreService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _modeloFirestoreService.getModeloStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error al cargar los modelos: ${snapshot.error}'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No hay modelos disponibles.'));
        }

        final modelos = snapshot.data!.docs;
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: modelos.length + 1,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            if (index == modelos.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 16),
                child: Column(
                  children: [
                    FloatingActionButton.extended(
                      heroTag: 'modelos-modelo-unico',
                      onPressed: () => context.push('/modelos/modelo-unico'),
                      label: const Text('unico'),
                    ),
                    const SizedBox(height: 16),
                    FloatingActionButton.extended(
                      heroTag: 'modelos-anadir-modelo',
                      onPressed: () => context.push('/modelos/anadir-modelo'),
                      label: const Text('añadir modelo'),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              );
            }

            final modelo = modelos[index].data();
            final titulo = modelo['titulo']?.toString() ?? '';
            final descripcionCorta =
                modelo['descripcionCorta']?.toString() ?? '';
            final modelImageUrl = modelo['modelImageUrl']?.toString() ?? '';

            return GestureDetector(
              onTap: () {
                context.go('/modelos/modelo-unico', extra: modelos[index].id);
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (modelImageUrl.isNotEmpty)
                      Image.network(
                        modelImageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(
                              height: 200,
                              child: Center(
                                child: Icon(Icons.broken_image_outlined),
                              ),
                            ),
                      )
                    else
                      const SizedBox(
                        height: 200,
                        child: Center(child: Icon(Icons.image_not_supported)),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titulo,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            descripcionCorta,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
