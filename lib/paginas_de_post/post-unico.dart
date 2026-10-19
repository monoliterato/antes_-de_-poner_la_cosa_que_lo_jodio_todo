import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PostUnico extends StatefulWidget {
  final String titulo;
  final String descripcionCorta;
  final String? descripcionCompleta;
  final String imageUrl;

  const PostUnico({
    super.key,
    required this.titulo,
    required this.descripcionCorta,
    required this.descripcionCompleta,
    required this.imageUrl,
  });

  @override
  State<PostUnico> createState() => _PostUnicoState();
}

final layerLink = LayerLink();

class _PostUnicoState extends State<PostUnico> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        if (widget.imageUrl.isEmpty)
                          const SizedBox(
                            width: 300,
                            height: 200,
                            child: Center(
                              child: Text(
                                'No hay imagen disponible',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        else
                          CompositedTransformTarget(
                            link: layerLink,
                            child: Image.network(
                              widget.imageUrl,
                              width: MediaQuery.of(context).size.width,
                              height: 400,
                              fit: BoxFit.cover,
                              webHtmlElementStrategy:
                                  WebHtmlElementStrategy.fallback,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const SizedBox(
                                      width: 300,
                                      height: 200,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox(
                                    width: 300,
                                    height: 200,
                                    child: Center(
                                      child: Text(
                                        'No se pudo cargar la imagen',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        CompositedTransformFollower(
                          link: layerLink,
                          offset: Offset.zero,
                          targetAnchor: Alignment.bottomCenter,
                          followerAnchor: Alignment.bottomCenter,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.0),

                                    Colors.black.withOpacity(0.8),
                                    Colors.black.withOpacity(1.0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        CompositedTransformFollower(
                          link: layerLink,
                          offset: Offset(30, -20),
                          targetAnchor: Alignment.bottomLeft,
                          followerAnchor: Alignment.bottomLeft,
                          child: Text(
                            widget.titulo,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          widget.descripcionCorta,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),

                    Text(
                      widget.descripcionCorta,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: MediaQuery.sizeOf(context).width * 0.1,
                          left: MediaQuery.sizeOf(context).width*0.1,
                        ),
                        child:
                            (widget.descripcionCompleta?.trim().isNotEmpty ??
                                false)
                            ? MarkdownBody(
                                data: widget.descripcionCompleta!,
                                styleSheet: MarkdownStyleSheet(
                                  p: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                  h1: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  h2: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  h3: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  a: const TextStyle(
                                    color: Colors.lightBlueAccent,
                                  ),
                                ),
                              )
                            : const Text(
                                'No hay descripción larga disponible.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                height: 180,
                width: MediaQuery.of(context).size.width,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.0),
                          Colors.black.withOpacity(0.9),
                          Colors.black.withOpacity(1.0),
                          Colors.black.withOpacity(1.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
