import 'package:aplicacion/paginas_de_modelos/datos-modelo.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/*
class ModeloUnico extends StatefulWidget {
  const ModeloUnico({super.key});

  @override
  State<ModeloUnico> createState() => _ModeloUnicoState();
}

class _ModeloUnicoState extends State<ModeloUnico> {
  double rotarx = 90.0 * math.pi / 180.0;
  double rotary = 1.0 * math.pi / 180.0;
  vm.Quaternion rotationx = vm.Quaternion.axisAngle(
    vm.Vector3(0, 1, 0),
    90.0 * math.pi / 180.0,
  );
  vm.Quaternion rotationy = vm.Quaternion.axisAngle(
    vm.Vector3(1, 0, 0),
    1.0 * math.pi / 180.0,
  );
  vm.Vector3 escala = vm.Vector3.all(8.0);
  bool _isMoving = true;
  double _animatedSeconds = 0.0;
  Duration _lastElapsed = Duration.zero;
  //vm.Quaternion rotex = vm.Quaternion.axisAngle(vm.Vector3(1,0,0), 0);
  //vm.Quaternion rotey = vm.Quaternion.axisAngle(vm.Vector3(0,1,0), 0);
  void detener()async{
    _isMoving=false;
 await Future.delayed(const Duration(seconds: 3));
 _isMoving=true;
 
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {

          
            rotary = (rotary + details.delta.dy * 0.01)
              .clamp(-1.3,1.3);//angulo pero con restricciones clamp lo restringe
          rotationy = vm.Quaternion.axisAngle(vm.Vector3(1, 0, 0), rotary);
       
        
         
          rotarx += details.delta.dx * 0.01;
          rotationx = vm.Quaternion.axisAngle(vm.Vector3(0, -1, 0), rotarx);
          detener();
          
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
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SceneView.declarative(
          cameraBuilder: (elapsed) {
            final delta = (elapsed - _lastElapsed).inMilliseconds / 1000.0;
            _lastElapsed = elapsed;


            if(_isMoving){


              _animatedSeconds+= delta;
            }
          
            final double radio = 20;
            
            final double camx = math.sin(_animatedSeconds) * radio;
            final double camz = math.cos(_animatedSeconds) * radio;
            return PerspectiveCamera(
              position: vm.Vector3(camx, 2, camz),
              target: vm.Vector3(0, 4, 0),
              fovRadiansY: 35 * pi / 180,
            );
          },
          children: [
            SceneNode(
              rotation: rotationx * rotationy,
              scale: escala,
              children: [SceneModel('assets/3d/modelo.glb')],
            ),
          ],
        ),
      ),
    );
  }
}

*/

class ModeloUnico extends StatefulWidget {
  const ModeloUnico({super.key});

  @override
  State<ModeloUnico> createState() => _ModeloUnicoState();
}

class _ModeloUnicoState extends State<ModeloUnico> {
  Future<void> _openData() async {
    await Navigator.push<void>(
      context,
      PageRouteBuilder<void>(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return const DatosModelo();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 1,
          height: MediaQuery.sizeOf(context).height * 0.9,
          child: const ModelViewer(
            src: 'assets/3d/modelo.glb',
            alt: 'Modelo 3D',
            autoRotate: true,
            cameraControls: true,
            ar: true,
            shadowIntensity: 1.0,
          ),
        ),
        Positioned(
          bottom: 120,
          left: MediaQuery.of(context).size.width * 0.32,
          right: MediaQuery.of(context).size.width * 0.32,
          child: FloatingActionButton.extended(
            heroTag: 'models-profile',
            shape: const StadiumBorder(),
            onPressed: _openData,
            icon: const Icon(Icons.assessment_sharp),
            label: const Text('DESCRIPCION'),
          ),
        ),
      ],
    );
  }
}
