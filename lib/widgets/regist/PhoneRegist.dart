import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class PhoneRegist extends StatefulWidget {
  final ValueChanged<String>
      onPhoneNumberEntered; // Callback to send phone number

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

  // Moved _alertCard method inside the state class
  Widget _alertCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isVisible = false;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: phoneController.text.length),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Registration",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "Fill in the registration data. It will take a couple of minutes. All you need is a phone number and e-mail.",
          style: TextStyle(fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        if (_isVisible) _alertCard(),
        const SizedBox(height: 20),
        TextFormField(
          cursorColor: Theme.of(context).primaryColor,
          controller: phoneController,
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            setState(() {
              phoneController.text = value;
            });
          },
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: 'Enter your phone number',
            hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.grey.shade600),
            prefixIcon: Container(
                padding: const EdgeInsets.all(15.0),
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
                  child: Text(
                      "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                )),
            suffixIcon: phoneController.text.length > 9
                ? Container(
                    height: 20,
                    width: 20,
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child:
                        const Icon(Icons.done, color: Colors.white, size: 15),
                  )
                : null,
          ),
        ),

        const SizedBox(height: 20),
        
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          ),
          child: const Text('Send OTP', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
