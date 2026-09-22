import 'dart:math';
import 'dart:math' as math;

import 'package:flutter/material.dart';

//import 'package:flutter_scene/build_hooks.dart';
//import 'package:hooks/hooks.dart';

/*

class Modelos extends StatelessWidget {
  const Modelos({super.key});




  @override
  Widget build(BuildContext context) {





    return Container();




  }
}*/

/*


import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;

void main() => runApp(const Modelos());

class Modelos extends StatelessWidget {
  const Modelos({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: FirstScene()),
    );
  }
}

class FirstScene extends StatelessWidget {
  const FirstScene({super.key});

  @override
  Widget build(BuildContext context) {
    return SceneView.declarative(
      // The camera orbits the origin once per second.
      cameraBuilder: (elapsed) {
        final t = elapsed.inMicroseconds / 1e6;
        return PerspectiveCamera(
          position: vm.Vector3(sin(t) * 5, 2, cos(t) * 5),
          target: vm.Vector3(0, 0, 0),
        );
      },
      children: [
        SceneNode(
          components: [SpinComponent(1.5)],
          children: [
            SceneMesh(
              geometry: CuboidGeometry(vm.Vector3(1, 1, 1), debugColors: true),
              material: UnlitMaterial(),
            ),
          ],
        ),
      ],
    );
  }
}

class SpinComponent extends Component {
  SpinComponent(this.radiansPerSecond);

  final double radiansPerSecond;

  // Runs once when the node joins a live scene, before the first update.
  @override
  void onMount() {
    debugPrint('SpinComponent attached and driving its node');
  }

  // Runs every frame while mounted. deltaSeconds is the time since the
  // previous tick, so motion stays framerate independent.
  @override
  void update(double deltaSeconds) {
    node.localTransform.rotateY(radiansPerSecond * deltaSeconds);
    node.markTransformDirty();
  }

  // Runs when the node leaves the scene. Release any resources here.
  @override
  void onUnmount() {
    debugPrint('SpinComponent removed from the scene');
  }
}


*/

import 'package:flutter/material.dart';
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;

class Modelos extends StatefulWidget {
  const Modelos({super.key});

  @override
  State<Modelos> createState() => _ModelosState();
}

class _ModelosState extends State<Modelos> {
  double rotarx = 45.0 * math.pi / 180.0;
  double rotary = 45.0 * math.pi / 180.0;
  vm.Quaternion rotationx = vm.Quaternion.axisAngle(
    vm.Vector3(0, 1, 0),
    90.0 * math.pi / 180.0,
  );
  vm.Quaternion rotationy = vm.Quaternion.axisAngle(
    vm.Vector3(1, 0, 0),
    45.0 * math.pi / 180.0,
  );
  vm.Vector3 escala = vm.Vector3.all(8.0);
  //vm.Quaternion rotex = vm.Quaternion.axisAngle(vm.Vector3(1,0,0), 0);
  //vm.Quaternion rotey = vm.Quaternion.axisAngle(vm.Vector3(0,1,0), 0);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          rotary += details.delta.dy * 0.01;
          rotationy = vm.Quaternion.axisAngle(vm.Vector3(1, 0, 0), rotary);
          rotarx += details.delta.dx * 0.01;
          rotationx = vm.Quaternion.axisAngle(vm.Vector3(0, 1, 0), rotarx);
          //escala += vm.Vector3.all(details.delta.dx);
          //print(details.delta.dx,);
          // rotex += vm.Quaternion.axisAngle(vm.Vector3(1,0,0), details.delta.dx*0.0001);
          //rotey += vm.Quaternion.axisAngle(vm.Vector3(0,1,0), details.delta.dy*0.0001);
          //print(rotex);
          //print(rotey);
        });
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SceneView.declarative(
          cameraBuilder: (elapsed) {
            final double radio = 20;
            final double t = elapsed.inMicroseconds / 2110000.0;
            final double camx = math.sin(t) * radio;
            final double camz = math.cos(t) * radio;
            return PerspectiveCamera(
              position: vm.Vector3(camx, 2, camz),
              target: vm.Vector3(0, 4, 0),
              fovRadiansY: 35 * pi / 180,
            );
          },
          children: [
            SceneNode(
              rotation: rotationx*rotationy,
                   scale: escala,
              children: [
                SceneModel(
                  'assets/3d/modelo.glb',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*

import 'package:flutter/material.dart';
import 'package:flutter_scene/scene.dart'; // Asegúrate de importar flutter_scene
import 'package:vector_math/vector_math.dart' as vm;

class Modelos extends StatefulWidget {
  const Modelos({super.key});

  @override
  State<Modelos> createState() => _ModelosState();
}

class _ModelosState extends State<Modelos> {
  // 1. Definimos las variables de estado que controlarán la transformación local
  
  vm.Vector3 _scale = vm.Vector3(1, 1, 1);
  vm.Quaternion _rotation = vm.Quaternion.identity();

  void _moveAndRotateObject() {
    setState(() {
      // Modificamos los valores; Flutter reconstruirá el árbol de SceneNodes
      
      _scale=_scale+vm.Vector3(0.5, 0.5, 0.5);
      _rotation = vm.Quaternion.axisAngle(vm.Vector3(0, 1, 0), 0.785); // 45 grados en Y
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 2. Usamos SceneView.declarative para renderizar la escena entera
          SceneView.declarative(
            children: [
              // 3. El nodo de tu objeto mapea las variables de estado directamente
              SceneNode(
               // Reemplaza el uso manual de localTransform
                rotation: _rotation,  // El motor calcula el Matrix4 por debajo
                scale: _scale,
                children: [
                  SceneModel('assets/3d/pixellabs-glb-3347.glb'),
                ],
              ),
            ],
          ),
          
          // Botón flotante para interactuar y cambiar la transformación
          Positioned(
            bottom: 500,
            right: 30,
            child: FloatingActionButton(
              onPressed: _moveAndRotateObject,
              child: const Icon(Icons.play_arrow),
            ),
          ),
        ],
      ),
    );
  }
}





*/
