import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/authentication/model/usermodel.dart';
import 'package:flutterproject/features/authentication/presentation/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutterproject/features/authentication/presentation/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:flutterproject/features/authentication/presentation/UI/pages/login_page.dart';
import 'package:flutterproject/features/authentication/presentation/UI/widgets/formcontainer.dart';

class SignUppage extends StatefulWidget {
  const SignUppage({Key? key}) : super(key: key);
  @override
  State<SignUppage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUppage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNoController = TextEditingController();

  late SignUpBloc signUpBloc;
  @override
  void initState() {
    signUpBloc = BlocProvider.of<SignUpBloc>(context);
    signUpBloc.add(SignUpInitialEvent());

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      bloc: signUpBloc,
      listenWhen: (previous, current) => current is SignUpActionState,
      buildWhen: (previous, current) => current is! SignUpActionState,
      builder: (context, state) {
        if (state is SignUpInitialState) {
          return Scaffold(
            body: Stack(
              children: [
                const Image(
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  image: AssetImage('images/aaa.jpg'),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(200, 51, 76, 56),
                        Colors.black.withOpacity(0.15)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('HA',
                                  style: TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                  )), // Text before the icon
                              Image.asset(
                                'images/logo.png', // Replace 'custom_icon.png' with the name of your icon file
                                width:
                                    60, // Adjust the width of the icon as needed
                                height:
                                    60, // Adjust the height of the icon as needed
                              ),
                              Text('O',
                                  style: TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                  )), // Text after the icon
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            child: Text(
                              'Please Sign Up To Your Account',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: Formcontainerwidget(
                              controller: _nameController,
                              hinttext: "Name",
                              isPasswordField: false,
                              borderRadius: 10.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: Formcontainerwidget(
                              controller: _phoneNoController,
                              hinttext: "Phone Number",
                              isPasswordField: false,
                              borderRadius: 10.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: Formcontainerwidget(
                              controller: _emailController,
                              hinttext: "Email Address",
                              isPasswordField: false,
                              borderRadius: 10.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                            child: Formcontainerwidget(
                              controller: _passwordController,
                              hinttext: "Password",
                              isPasswordField: true,
                              borderRadius: 10.0,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              signUpBloc.add(
                                SignUpButtonPressedEvent(
                                  context: context,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  user: UserModel(
                                    email: _emailController.text,
                                    name: _nameController.text,
                                    role: 'buyer',
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  signUpBloc.add(
                                    SignUpButtonPressedEvent(
                                      context: context,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      user: UserModel(
                                        email: _emailController.text,
                                        name: _nameController.text,
                                        role: 'buyer',
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      const Color.fromARGB(255, 156, 199, 107),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5),
                              GestureDetector(
                                onTap: () {
                                  signUpBloc.add(LoginButtonPressedEvent());
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 156, 199, 107),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is SignUpErrorState) {
          return const Scaffold();
        } else {
          return const Scaffold();
        }
      },
      listener: (context, state) {
        if (state is LoginPressedNavigateToLoginActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => SignInBloc(),
                child: LoginPage(),
              ),
            ),
          );
        } else if (state is EmailVerifiedState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => SignInBloc(),
                child: LoginPage(),
              ),
            ),
          );
        } else if (state is VerificationEmailSentState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyEmailScreen(email: state.email)));
        }
      },
    );
  }
}

class VerifyEmailScreen extends StatelessWidget {
  final String email;

  const VerifyEmailScreen({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('A verification email has been sent to $email.'),
            ElevatedButton(onPressed: () {}, child: Text('Verified'))
          ],
        ),
      ),
    );
  }
}
