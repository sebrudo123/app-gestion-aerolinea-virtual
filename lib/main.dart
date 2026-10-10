import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const VertexApp());
}

class V {
  static const Color bg = Color(0xFF090E17);
  static const Color bg2 = Color(0xFF0B132B);
  static const Color surface = Color(0xFF1C2541);
  static const Color surface2 = Color(0xFF141B2E);
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFFFC077);
  static const Color bronze = Color(0xFF8C6D2F);
  static const Color text = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFF9AA3B2);
  static const Color green = Color(0xFF3DDC84);
  static const Color danger = Color(0xFFE05A5A);
  static const Color borderGold = Color(0x33D4AF37);
}

class VertexApp extends StatelessWidget {
  const VertexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vertex Airlines',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: V.bg,
        colorScheme: ColorScheme.dark(
          primary: V.gold,
          secondary: V.goldLight,
          surface: V.surface,
          background: V.bg,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: V.text,
              displayColor: V.text,
            ),
      ),
      home: const SplashScreen(),
    );
  }
}


class GoldGradientText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final double spacing;
  const GoldGradientText(this.text, {super.key, this.size=22, this.weight=FontWeight.w800, this.spacing=1.5});
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => const LinearGradient(colors: [V.goldLight, V.gold, V.bronze]).createShader(rect),
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: size, fontWeight: weight, letterSpacing: spacing)),
    );
  }
}

class GradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  const GradientCard({required this.child, super.key, this.padding=const EdgeInsets.all(18), this.radius=22});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [V.surface, V.surface2]),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: V.borderGold),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 18, offset: Offset(0,8))],
      ),
      child: child,
    );
  }
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  Timer? _msgTimer;
  int _msg=0;
  final _msgs = const ['Conectando con el servidor...', 'Verificando sesión...', 'Cargando perfil de piloto...'];
  final _jokes = const ['Listo para despegar...', 'Revisando meteorología...', 'Chequeando checklist...'];
  int _joke=0;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds:3))..forward();
    _msgTimer = Timer.periodic(const Duration(seconds:1), (_){ if(!mounted)return; setState((){
      if(_msg<_msgs.length-1)_msg++; _joke=(_joke+1)%_jokes.length;
    }); });
    Timer(const Duration(seconds:3), (){
      if(!mounted)return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>const LoginScreen()));
    });
  }
  @override
  void dispose(){ _msgTimer?.cancel(); _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[V.bg2,V.bg])),
        child: SafeArea(
          child: Padding(padding: const EdgeInsets.all(32), child: Column(children:[
            const Spacer(flex:2),
            FadeTransition(opacity: CurvedAnimation(parent:_ctrl,curve:Interval(0,0.3)), child: Column(children:[
              Container(height:110,width:110,decoration: BoxDecoration(shape:BoxShape.circle,gradient:LinearGradient(colors:[V.goldLight,V.gold,V.bronze]),boxShadow:[BoxShadow(color:V.gold.withOpacity(0.35),blurRadius:30)]),child:Icon(Icons.flight_takeoff_rounded,size:56,color:V.bg)),
              const SizedBox(height:20),
              const GoldGradientText('VERTEX AIRLINES', size:24),
              const SizedBox(height:8),
              const Text('Aerolínea Virtual', style:TextStyle(color:V.muted,fontSize:12)),
            ])),
            const Spacer(flex:2),
            FadeTransition(opacity: CurvedAnimation(parent:_ctrl,curve:Interval(0,0.5)), child: Column(children:[
              AnimatedBuilder(animation:_ctrl, builder:(_,__)=>ClipRRect(borderRadius:BorderRadius.circular(20), child: LinearProgressIndicator(value:_ctrl.value,minHeight:6,backgroundColor:V.surface,valueColor:AlwaysStoppedAnimation(V.gold)))),
              const SizedBox(height:16),
              AnimatedSwitcher(duration:Duration(milliseconds:400), child: Text(_msgs[_msg], key:ValueKey(_msg), style:TextStyle(color:V.goldLight,fontSize:13,fontWeight:FontWeight.w600))),
            ])),
            const Spacer(flex:1),
            AnimatedSwitcher(duration:Duration(milliseconds:400), child: Text(_jokes[_joke], key:ValueKey(_joke), style:TextStyle(color:V.muted,fontSize:11))),
            const SizedBox(height:16),
          ])),
        ),
      ),
    );
  }
}


class Auth {
  static const String user='vertexairlanes@gmail.com';
  static const String pass='vertexadmin123';
  static bool remember=false;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState()=>_LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _email=TextEditingController();
  final _pass=TextEditingController();
  bool _ob=true; bool _err=false; bool _rem=false;
  @override
  void dispose(){_email.dispose();_pass.dispose();super.dispose();}
  void _login(){
    if(_email.text.trim()==Auth.user && _pass.text==Auth.pass){
      setState(()=>_err=false);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(_)=>const MainShell()));
    }else{
      setState(()=>_err=true);
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[V.bg2,V.bg])),
        child: SafeArea(child: ListView(padding: const EdgeInsets.all(24), children:[
          const SizedBox(height:40),
          const GoldGradientText('VERTEX AIRLINES',size:24),
          const SizedBox(height:8),
          const Center(child: Text('Acceso a la plataforma', style:TextStyle(color:V.muted,fontSize:12))),
          const SizedBox(height:40),
          GradientCard(padding: const EdgeInsets.all(22), child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
            const Text('INICIAR SESIÓN', style:TextStyle(fontWeight:FontWeight.w800,letterSpacing:1.2)),
            const SizedBox(height:20),
            const Text('Correo electrónico', style:TextStyle(color:V.muted,fontSize:12)),
            const SizedBox(height:8),
            _Field(controller:_email,hint:'correo@dominio.com',icon:Icons.mail_outline),
            const SizedBox(height:16),
            const Text('Contraseña', style:TextStyle(color:V.muted,fontSize:12)),
            const SizedBox(height:8),
            _Field(controller:_pass,hint:'••••••••',icon:Icons.lock_outline,obscure:_ob, suffix:IconButton(icon:Icon(_ob?Icons.visibility_off:Icons.visibility,color:V.muted),onPressed:()=>setState(()=>_ob=!_ob))),
            const SizedBox(height:12),
            Row(children:[
              Checkbox(activeColor:V.gold,checkColor:V.bg,value:_rem,onChanged:(v){setState(()=>_rem=v??false); Auth.remember=_rem;}),
              const Text('Recordar sesión', style:TextStyle(color:V.muted,fontSize:12)),
            ]),
            if(_err)...[const SizedBox(height:8), const Text('Credenciales incorrectas', style:TextStyle(color:V.danger,fontSize:12,fontWeight:FontWeight.w600))],
            const SizedBox(height:18),
            GestureDetector(onTap:_login, child: Container(padding:const EdgeInsets.symmetric(vertical:16), decoration: BoxDecoration(gradient:LinearGradient(colors:[V.goldLight,V.gold,V.bronze]),borderRadius:BorderRadius.circular(16)), child:const Center(child: Text('INGRESAR', style:TextStyle(color:V.bg,fontWeight:FontWeight.w900,letterSpacing:1.4))))),
          ])),
        ])),
      ),
    );
  }
}
class _Field extends StatelessWidget {
  final TextEditingController controller; final String hint; final IconData icon; final bool obscure; final Widget? suffix;
  const _Field({required this.controller,required this.hint,required this.icon,this.obscure=false,this.suffix});
  @override
  Widget build(BuildContext context){
    return TextField(controller:controller,obscureText:obscure,style:TextStyle(color:V.text),cursorColor:V.gold,decoration:InputDecoration(
      hintText:hint,hintStyle:TextStyle(color:V.muted),prefixIcon:Icon(icon,color:V.goldLight),suffixIcon:suffix,
      filled:true,fillColor:V.surface2,
      enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(14),borderSide:BorderSide(color:V.borderGold)),
      focusedBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(14),borderSide:BorderSide(color:V.gold,width:1.4)),
    ));
  }
}
