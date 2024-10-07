import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veto_renew_application/provider/auth_provider.dart';

class PhoneRegist extends StatefulWidget {
  final ValueChanged<String> onPhoneNumberEntered; // Callback to send phone number

  const PhoneRegist({super.key, required this.onPhoneNumberEntered});

  @override
  _PhoneRegistState createState() => _PhoneRegistState();
}

class _PhoneRegistState extends State<PhoneRegist> {
  bool _isVisible = true;
  final TextEditingController phoneController = TextEditingController();

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
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 30, right: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns elements at the start
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

  void sendOTP(){
      final ap = Provider.of<AuthProvider>(context, listen: false);
      String phoneNumber = phoneController.text.trim();
      ap.signInWithPhone(context, "+${selectedCountry.phoneCode}$phoneNumber");
    }

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: phoneController.text.length),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: const Text(
                  "Registration",
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
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.start, // Aligns text to the start (left)
                children: [
                  Text(
                    "Enter your phone number",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              TextFormField(
                cursorColor: Theme.of(context).primaryColor,
                controller: phoneController,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  // Call the callback to send the updated phone number
                  widget.onPhoneNumberEntered(value);
                },
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'xxx-xxx-xxxx',
                  hintStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          onSelect: (value) {
                            setState(() {
                              selectedCountry = value;
                            });
                          },
                          countryListTheme: const CountryListThemeData(
                            flagSize: 30,
                            bottomSheetHeight: 550,
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  suffixIcon: phoneController.text.length > 9
                      ? Container(
                          height: 20,
                          width: 20,
                          margin: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: const Icon(Icons.done, color: Colors.white, size: 15),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Here you can add your validation and action to send OTP
            String phoneNumber = phoneController.text.trim();
            if (phoneNumber.length > 9) {
              sendOTP();
            } else {
              // Show an error message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please enter a valid phone number.")),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          ),
          child: const Text('Send OTP',
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ),
      ],
    );
  }

  
}
