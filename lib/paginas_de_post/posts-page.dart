import 'package:aplicacion/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import 'metodos_posts.dart';

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
                        String docID = document.id;

                        String titulo = document['titulo'] ?? '';
                        String descripcionCorta =
                            document['descripcionCorta'] ?? '';
                        String imagenUrl = document['imagenUrl'] ?? '';

                        return ImageCard(
                          imageUrl: imagenUrl,
                          titulo: titulo,
                          descripcionCorta: descripcionCorta,
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
    required this.imageUrl,
    required this.titulo,
    required this.descripcionCorta,
  });

  final String imageUrl;
  final String titulo;
  final String descripcionCorta;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  bool _isImageLoaded = false;
  bool _hasError = false;
  late NetworkImage _networkImage;
  late ImageStream _imageStream;
  late ImageStreamListener _streamListener;

  @override
  void initState() {
    super.initState();
    _initImageLoading();
  }

  void _initImageLoading() {
    // 1. Inicializamos el proveedor de la imagen por red
    _networkImage = NetworkImage(widget.imageUrl);

    // 2. Obtenemos el flujo de datos (Stream) de la imagen directamente del motor
    _imageStream = _networkImage.resolve(ImageConfiguration.empty);

    // 3. Creamos el listener para saber exactamente cuándo termina (con o sin caché)
    _streamListener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        if (mounted) {
          setState(() {
            _isImageLoaded = true; // ¡La imagen está lista para pintarse!
          });
        }
      },
      onError: (Object exception, StackTrace? stackTrace) {
        if (mounted) {
          setState(() {
            _hasError = true;
            _isImageLoaded = true;
          });
        }
      },
    );

    // 4. Empezamos a escuchar la descarga
    _imageStream.addListener(_streamListener);
  }

  @override
  void dispose() {
    // Es indispensable limpiar el listener para evitar fugas de memoria (Memory Leaks)
    _imageStream.removeListener(_streamListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(
          '/post-page/post-unico',
          extra: {
            'titulo': widget.titulo,
            'descripcionCorta': widget.descripcionCorta,
            'imagenUrl': widget.imageUrl,
          },
        );
      },
      child: AnimatedOpacity(
        opacity: _isImageLoaded ? 1 : 0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        child: SizedBox(
          height: _isImageLoaded ? null : 300,
          child: _hasError
              ? const Center(child: Icon(Icons.broken_image))
              : Stack(
                  alignment: AlignmentGeometry.bottomStart,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image(image: _networkImage, fit: BoxFit.cover),
                    ),
                    Container(
                      height: 100,
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(150, 30, 30, 30),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.titulo,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          widget.descripcionCorta,
                          style: TextStyle(color: Colors.red, fontSize: 25),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
