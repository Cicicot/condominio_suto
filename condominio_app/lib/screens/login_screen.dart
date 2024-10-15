import 'package:condominio_app/screens/screens.dart';
import 'package:condominio_app/sqlite/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  //We need two TextEditingController
  //TextEditingController to control id and password
  final username = TextEditingController();
  final password = TextEditingController();

  //una variable booleana para ocultar/mostrar la contraseña
  bool isVisible = false;

  //Here is out bool variable
  bool isLoginTrue = false;

  final db = DatabaseHelper();

  login() async {
    // Llama al método login y guarda la respuesta
    var response = await db.login(username.text, password.text);

    // Verifica si el login fue exitoso
    if (response['success'] == true) {
      // Si el login es correcto, navega a la pantalla correspondiente
      if (!mounted) return;

      String usuario = response['usuario'];

      if (usuario == 'ADMINISTRADOR') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InicioAdministrador()),
        );
      } else if (usuario == 'GUARDIA DE SEGURIDAD') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InicioGuardia()),
        );
      } else if (usuario == 'residente') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InicioResidente()),
        );
      }
    } else {
      // Si no es correcto, muestra un mensaje de error
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  //Debemos crear una llave global para nuestro formulario
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            //We put all TextEditingControllers in a form, to control and not allowed empty values
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  //Before to show the image, after we copy the image we need to define the location
                  //in pubspec.yaml
                  SvgPicture.asset(
                    'lib/assets/login1.svg',
                    height: 250,
                  ),
                  const SizedBox( height: 20 ),
                  //Username field
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueAccent.withOpacity(.3)
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: username,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Campo usuario obligatorio';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon( Icons.person ),
                        border: InputBorder.none,
                        hintText: 'Username'
                      ),
                    ),
                  ),
                  //Password field
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueAccent.withOpacity(.3)
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: password,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Campo contraseña obligatorio';
                        }
                        return null;
                      },
                      obscureText: !isVisible,
                      decoration: InputDecoration(
                        icon: const Icon( Icons.lock ),
                        border: InputBorder.none,
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          //Aquí vamos a crear un método para mostrar/ocultar la contraseña en un toggle button
                          onPressed: () {
                            setState(() {
                              //toggle button
                              isVisible = !isVisible;
                            });
                          }, 
                          icon: Icon( isVisible ? Icons.visibility : Icons.visibility_off )
                        )
                      ),
                    ),
                  ),
                  const SizedBox( height: 10 ),
                  //Botón de login
                  Container(
                    height: 65,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration( 
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueAccent  
                    ),
                    child: TextButton(
                      onPressed: (){
                        if ( formKey.currentState!.validate() ) {
                          //El método LOGIN estará aquí
                          login();

                          //Now we have a response from our sqlite method
                          //We are going to create a user

                        }
                      }, 
                      child: const Text( 
                        'LOGIN', //'INICIAR SESIÓN' 
                        style: TextStyle( 
                          color: Colors.white, 
                          fontSize: 16 
                        ) 
                      )
                    ),
                  ),
                  //botón contacte al administrador
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿No tiene una cuenta?'),
                      TextButton(onPressed: (){
                        //Navega a registro
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => const UsuarioScreen(),
                          )
                        );
                      }, child: const Text('CONTACTE AL ADMINISTRADOR'))
                    ],
                  ),
                  //We will disable this message in default, when user and password is incorrect
                  //we will trigger this message
                  isLoginTrue
                  ? const Text( 
                    'Usuario u contraseña es incorrecto', 
                    style: TextStyle(
                      color: Colors.red
                    )
                  )
                  : const SizedBox()
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}