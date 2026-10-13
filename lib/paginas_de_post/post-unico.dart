import 'package:flutter/material.dart';

class PostUnico extends StatefulWidget {
  final String titulo;
  final String descripcionCorta;
  final String imageUrl;

  const PostUnico({
    super.key,
    required this.titulo,
    required this.descripcionCorta,
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
                          child: Positioned(
                            top: 1000,
                            child: Text(
                              widget.titulo,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
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
                    Stack(
                      children: [
                        Text(
                          'Elit proident cillum aliqua pariatur cillum reprehenderit deserunt in. Ex veniam minim ad in nisi ea eu enim ex id est voluptate proident excepteur. Anim ut ut cupidatat commodo nostrud sunt eu velit mollit cupidatat et. Laborum in sit eu nulla exercitation culpa duis quis aute proident. sunt sunt cupidatat laboris est aliqua. Nostrud consequat ullamco excepteur laborum.Sit eiusmod occaecat aute quis. Ea eu ex adipisicing nulla exercitation magna est sunt ut mollit et officia. Tempor magna ex incididunt non aute.Sint sint ad culpa tempor cupidatat aliquip nostrud laborum laborum sint deserunt. Non id consequat officia cupidatat eiusmod quis laboris nostrud veniam irure nostrud duis fugiat eu. Enim sunt officia nostrud eiusmod sint nulla minim eu irure proident adipisicing pariatur non. Qui est velit irure mollit in cupidatat veniam enim do.Enim amet aute deserunt incididunt cillum commodo duis in magna consectetur. Sit nostrud voluptate do excepteur do nisi consectetur quis. Tempor aliquip ex proident et non. Ut mollit eu eu consequat Lorem occaecat mollit ea laborum. Reprehenderit elit do est aliquip anim. Sint excepteur magna consectetur cupidatat non id id nulla. Nulla officia ullamco occaecat reprehenderit ipsum exercitation ea occaecat occaecat in dolor aliquip.',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
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
