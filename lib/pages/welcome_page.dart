import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:veto_renew_application/pages/login_register_page.dart';
import 'package:veto_renew_application/pages/registration_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Upper part: Picture
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/basemap.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Lower part: Information text and Sign-In button
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _title(),
                  const SizedBox(height: 20.0),
                  _description(),
                  const SizedBox(height: 30.0),
                  Center(
                    // Center the Sign In button
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 24, 111, 183), // Change button color to blue
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15.0),
                      ),
                      onPressed: () async{
                        // final provider = OAuthProvider('microsoft.com');
                        // provider.setCustomParameters(
                        //   {"tenant": "6f4432dc-20d2-441d-b1db-ac3380ba633d"}
                        // );

                        // await FirebaseAuth.instance.signInWithPopup(provider);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegistrationPage()),
                        );
                      },
                      child: const Wrap(
                        spacing: 10.0,  // Space between text and image
                        crossAxisAlignment: WrapCrossAlignment.center,  // Align items in the center vertically
                        children: [
                          Text('Sign Up with', style: TextStyle(color: Colors.white)),
                          SizedBox(width: 10.0),
                          Image(
                            image: AssetImage('assets/images/microsoftSignin.png'),
                            width: 24,  // Reasonable size for the image
                            height: 24, 
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),

                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 65, 65, 65),
                            ), // Grey text for the non-clickable part
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Sign In',
                            style: const TextStyle(
                              color: Colors.blue, // Blue clickable text
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return const Text(
      "More than just a ride, it's a vibe!",
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _description() {
    return const Text(
      "Veto is a ride-sharing app that aims to connect drivers and passengers by allowing them to find suitable matches, and meet new people in the community.",
      style: TextStyle(
        fontSize: 16.0,
      ),
      textAlign: TextAlign.justify,
    );
  }
}