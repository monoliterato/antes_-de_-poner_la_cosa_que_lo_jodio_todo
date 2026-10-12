import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Modelos extends StatelessWidget {
  const Modelos({super.key});

  static const _tarjetas = [
    (
      imagen: 'assets/images/1.jpg',
      titulo: 'Un instante especial',
      descripcion: 'Pequeños momentos que merecen quedarse para siempre.',
    ),
    (
      imagen: 'assets/images/2.jpg',
      titulo: 'Nuevos caminos',
      descripcion: 'Cada aventura comienza con el primer paso.',
    ),
    (
      imagen: 'assets/images/3.jpg',
      titulo: 'Colores de la vida',
      descripcion: 'Una mirada diferente puede cambiarlo todo.',
    ),
    (
      imagen: 'assets/images/4.jpg',
      titulo: 'Tiempo para descubrir',
      descripcion: 'Siempre hay algo nuevo esperando ser encontrado.',
    ),
    (
      imagen: 'assets/images/5.jpg',
      titulo: 'Días memorables',
      descripcion: 'Las mejores historias nacen de lo inesperado.',
    ),
    (
      imagen: 'assets/images/6.jpg',
      titulo: 'Inspiración cotidiana',
      descripcion: 'A veces, lo extraordinario está justo frente a ti.',
    ),
    (
      imagen: 'assets/images/7.jpg',
      titulo: 'Un lugar por explorar',
      descripcion: 'Déjate sorprender por cada rincón del recorrido.',
    ),
    (
      imagen: 'assets/images/8.jpg',
      titulo: 'Perspectivas distintas',
      descripcion: 'Cambiar el punto de vista abre nuevas posibilidades.',
    ),
    (
      imagen: 'assets/images/9.jpg',
      titulo: 'Recuerdos en imágenes',
      descripcion: 'Una imagen puede contar mucho más que mil palabras.',
    ),
    (
      imagen: 'assets/images/10.jpg',
      titulo: 'Momentos para compartir',
      descripcion: 'Lo bueno se disfruta aún más cuando se comparte.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _tarjetas.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final tarjeta = _tarjetas[index];

                return Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        tarjeta.imagen,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tarjeta.titulo,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              tarjeta.descripcion,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FloatingActionButton.extended(
              onPressed: () => context.push('/modelos/modelo-unico'),
              label: const Text('unico'),
            ),
          ),
        ],
      );
    
  }
}
