

import 'package:aplicacion/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import 'metodos-posts.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

/*
class ImageData {
  final String id;
  final String imageUrl;

  const ImageData({required this.id, required this.imageUrl});
}

const imageList = [
  ImageData(id: 'id-001', imageUrl: 'assets/images/1.jpg'),
  ImageData(id: 'id-002', imageUrl: 'assets/images/2.jpg'),
  ImageData(id: 'id-003', imageUrl: 'assets/images/3.jpg'),
  ImageData(id: 'id-004', imageUrl: 'assets/images/4.jpg'),
  ImageData(id: 'id-005', imageUrl: 'assets/images/5.jpg'),
  ImageData(id: 'id-006', imageUrl: 'assets/images/6.jpg'),
  ImageData(id: 'id-007', imageUrl: 'assets/images/7.jpg'),
  ImageData(id: 'id-008', imageUrl: 'assets/images/2.jpg'),
  ImageData(id: 'id-009', imageUrl: 'assets/images/3.jpg'),
  ImageData(id: 'id-010', imageUrl: 'assets/images/4.jpg'),
  ImageData(id: 'id-011', imageUrl: 'assets/images/5.jpg'),
  ImageData(id: 'id-012', imageUrl: 'assets/images/6.jpg'),
  ImageData(id: 'id-013', imageUrl: 'assets/images/7.jpg'),
  ImageData(id: 'id-014', imageUrl: 'assets/images/8.jpg'),
  ImageData(id: 'id-015', imageUrl: 'assets/images/9.jpg'),
  ImageData(id: 'id-016', imageUrl: 'assets/images/10.jpg'),
  ImageData(id: 'id-017', imageUrl: 'assets/images/3.jpg'),
  ImageData(id: 'id-018', imageUrl: 'assets/images/6.jpg'),
  ImageData(id: 'id-019', imageUrl: 'assets/images/7.jpg'),
];
*/
class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  firestoreService _firestoreService = firestoreService();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80, bottom: 20),
                  child: Text(
                    'PUBLICACIONES',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),

              StreamBuilder<QuerySnapshot>(
                stream: _firestoreService.getPostsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    List postsList = snapshot.data!.docs;
                    return SliverMasonryGrid.count(
                      crossAxisCount: 2,
                      childCount: postsList.length,
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 10.0,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = postsList[index];

                        String titulo = document['titulo'] ?? '';
                        String descripcionCorta =
                            document['descripcionCorta'] ?? '';
                        String descripcionCompleta =
                            document['descripcionCompleta'] ?? '';
                        String imagenUrl = document['imagenUrl'] ?? '';

                        return ImageCard(
                          key: ValueKey(document.id),
                          postId: document.id,
                          imageUrl: imagenUrl,
                          titulo: titulo,
                          descripcionCorta: descripcionCorta,
                          descripcionCompleta: descripcionCompleta,
                        );
                      },
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Text(
                        'No posts available',
                        style: TextStyle(color: Colors.white, fontSize: 30.0),
                      ),
                    );
                  } else {
                    return const SliverToBoxAdapter(
                      child: Text('No data available'),
                    );
                  }
                },
              ),

              SliverToBoxAdapter(
                child: Container(
                  //padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
                  margin: const EdgeInsets.only(top: 20.0, bottom: 130),
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/post-page/anadir-post');
                    },
                    child: Text(
                      'AÑADIR PUBLICACION',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 190,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.degradadoClaro.withOpacity(0.0),
                    AppColors.degradadoClaro.withOpacity(0.8),
                    AppColors.degradadoClaro.withOpacity(1.0),
                    AppColors.degradadoClaro.withOpacity(1.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//el diseño de una tarjeta

class ImageCard extends StatefulWidget {
  const ImageCard({
    super.key,
    required this.postId,
    required this.imageUrl,
    required this.titulo,
    required this.descripcionCorta,
    required this.descripcionCompleta,
  });

  final String postId;
  final String imageUrl;
  final String titulo;
  final String descripcionCorta;
  final String descripcionCompleta;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard>
    with AutomaticKeepAliveClientMixin<ImageCard> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            context.go(
              '/post-page/post-unico',
              extra: {
                'titulo': widget.titulo,
                'descripcionCorta': widget.descripcionCorta,
                'descripcionCompleta':widget.descripcionCompleta,
                'imagenUrl': widget.imageUrl,
              },
            );
          },
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              

              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  widget.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded || frame != null)
                          return child;
                        return const SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                    height: 300,
                    child: Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(150, 30, 30, 30),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.titulo,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    widget.descripcionCorta,
                    style: const TextStyle(color: Colors.red, fontSize: 25),
                  ),
                ],
              ),
            ],
          ),
        ),
      
      FloatingActionButton.extended(
                heroTag: 'editar-post-${widget.postId}',
                shape: const StadiumBorder(),
                onPressed: () => context.go(
                  '/post-page/editar-post',
                  extra: {
                    'oldIdentificador': widget.postId,
                    'oldTitulo': widget.titulo,
                    'oldDescripcionCorta': widget.descripcionCorta,
                    'oldDescripcionCompleta': widget.descripcionCompleta,
                    'oldImageUrl': widget.imageUrl,
                  },
                ),
                icon: const Icon(Icons.person),
                label: const Text('EDITAR'),
              ),
      
      
      
      ],
    );
  }
}
