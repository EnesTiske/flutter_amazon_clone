import 'package:amazon_clone_tutorial/common/widgets/custom_textfield.dart';
import 'package:amazon_clone_tutorial/constants/global_variables.dart';
import 'package:amazon_clone_tutorial/constants/utils.dart';
import 'package:amazon_clone_tutorial/features/address/services/address_services.dart';
import 'package:amazon_clone_tutorial/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();

  String addressToBeUsed = '';
  List<PaymentItem> paymentItems = [];
  final AddressServices addressServices = AddressServices();

  @override
  void initState() {
    super.initState();
    paymentItems.add(
      PaymentItem(
        amount: widget.totalAmount,
        label: 'Total Amount',
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  final Future<PaymentConfiguration> applePayConfigFuture =
      PaymentConfiguration.fromAsset('applepay.json');

  final Future<PaymentConfiguration> googlePayConfigFuture =
      PaymentConfiguration.fromAsset('gpay.json');

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
  }

  void onApplePayResult(res) {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServices.saveUserAddress(
        context: context,
        address: addressToBeUsed,
      );
    }
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalAmount: double.parse(widget.totalAmount),
    );
  }

  void onGooglePayResult(res) {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServices.saveUserAddress(
        context: context,
        address: addressToBeUsed,
      );
    }
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalAmount: double.parse(widget.totalAmount),
    );
  }

  void payPressed(String addressFormProvider) {
    addressToBeUsed = '';
    bool isForm = flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pincodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;

    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed = '${flatBuildingController.text}, '
            '${areaController.text}, '
            '${pincodeController.text}, '
            '${cityController.text}';
      } else {
        throw Exception('Please fill the form');
      }
    } else {
      if (addressFormProvider.isNotEmpty) {
        addressToBeUsed = addressFormProvider;
      } else {
        showSnackBar(context, 'Enter Address');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // var address = 'amazon clone address';
    var address = context.watch<UserProvider>().user.address;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          address,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: flatBuildingController,
                      hintText: 'Flat, House No., Building, Company, Apartment',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: areaController,
                      hintText: 'Area, Colony, Street, Sector, Village',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: pincodeController,
                      hintText: 'Pincode',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: cityController,
                      hintText: 'Town/City',
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              FutureBuilder<PaymentConfiguration>(
                future: applePayConfigFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return ApplePayButton(
                        onPressed: () {
                          payPressed(address);
                        },
                        width: double.infinity,
                        style: ApplePayButtonStyle.whiteOutline,
                        type: ApplePayButtonType.buy,
                        paymentConfiguration: snapshot.data!,
                        paymentItems: paymentItems,
                        onPaymentResult: onApplePayResult,
                        margin: const EdgeInsets.only(top: 15),
                        height: 50,
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder<PaymentConfiguration>(
                future: googlePayConfigFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return GooglePayButton(
                        onPressed: () {
                          payPressed(address);
                        },
                        width: double.infinity,
                        paymentConfiguration: snapshot.data!,
                        paymentItems: paymentItems,
                        onPaymentResult: onGooglePayResult,
                        margin: const EdgeInsets.only(top: 15),
                        height: 50,
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
