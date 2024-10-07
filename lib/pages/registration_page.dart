// registration_page.dart
import 'package:flutter/material.dart';
import '../widgets/custom_stepper.dart';
import '../widgets/regist/PhoneRegist.dart'; // Import your step widgets


class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    List<StepData> steps = [
      StepData(
        content: PhoneRegist(
          onPhoneNumberEntered: (phoneNumber) {
            setState(() {
              phoneNumber;
            });
          },
        ),
      ),
      StepData(content: PhoneRegist(
          onPhoneNumberEntered: (phoneNumber) {
            setState(() {
              phoneNumber;
            });
          },
        ),)
    ];

    return Scaffold(
      body: SafeArea(
          child: Center(
            child: CustomStepper(
                currentStep: _currentStep,
                steps: steps,
                onStepContinue: () {
                  if (_currentStep < steps.length - 1) {
                    setState(() {
                      _currentStep += 1;
                    });
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() {
                      _currentStep -= 1;
                    });
                  }
                },
                activeColor: Colors.blue,
                inactiveColor: Colors.grey,
              ),
            ),
      )
    );
  }
}
