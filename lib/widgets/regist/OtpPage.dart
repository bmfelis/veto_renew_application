import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:veto_renew_application/provider/auth_provider.dart';
import 'package:veto_renew_application/utils/utils.dart';
import 'package:veto_renew_application/widgets/regist/UserInfo.dart';

class OtpPage extends StatefulWidget {
  // final ValueChanged<String> onPhoneNumberEntered; // Callback to send phone number
  final String verificationId;
  const OtpPage({super.key, required this.verificationId});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  bool _isVisible = true;
  String? otpCode;

  Country selectedCountry = Country(
    phoneCode: '66',
    countryCode: 'TH',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Thailand',
    example: 'Thailand',
    displayName: 'Thailand',
    displayNameNoCountryCode: 'TH',
    e164Key: '',
  );

  Widget _alertCard() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: const Border(), // Removes rounded corners
        child: Padding(
          padding: const EdgeInsets.only(
              top: 20.0, bottom: 20.0, left: 30, right: 30),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligns elements at the start
            children: [
              const Icon(Icons.lock, color: Colors.grey),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    "We take privacy issues seriously. You can be sure that your personal data is securely protected.",
                    style: TextStyle(fontSize: 15.0),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isVisible = false;
                    });
                  },
                  child: const Icon(Icons.close, size: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void verifyOtp(BuildContext context, String userOtp) async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOtp(
        context: context,
        verificationId: widget.verificationId,
        userOtp: userOtp,
        onSuccess: () {
          ap.checkExistingUser().then((value) async {
            if (value == true) {
              Navigator.pushNamed(context, '/home');
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserInfoPage(),
                  ),
                  (route) => false);
            }
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;

    return Scaffold(
        body: SafeArea(
            child: isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.blue,
                  ))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Icon(Icons.arrow_back),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: const Text(
                                "Verification",
                                style: TextStyle(
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Container(
                              alignment: Alignment.center,
                              child: const Text(
                                "Fill in the registration data. It will take a couple of minutes. All you need is a phone number and e-mail.",
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_isVisible) _alertCard(),
                      const SizedBox(height: 20),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .start, // Aligns text to the start (left)
                                children: [
                                  const Text(
                                    "Confirmation code",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Pinput(
                                    length: 6,
                                    showCursor: true,
                                    keyboardType: TextInputType.number,
                                    defaultPinTheme: PinTheme(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.blue,
                                          width: 1,
                                        ),
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    onCompleted: (otp) {
                                      otpCode = otp;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    "Confirm phone number with code from sms message",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      if (otpCode != null) {
                                        verifyOtp(context, otpCode!);
                                      } else {
                                        showSnackBar(
                                            context, "Enter 4 digit OTP code");
                                      }
                                    },
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: Icon(Icons.refresh,
                                                color: Colors.blue, size: 18)),
                                        SizedBox(width: 8),
                                        Text(
                                          "Send again",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (otpCode != null) {
                            verifyOtp(context, otpCode!);
                          } else {
                            showSnackBar(context, "Enter the 4-digit OTP code");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                        ),
                        child: const Text('Confirm',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ],
                  )));
  }
}
