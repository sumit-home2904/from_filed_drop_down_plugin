import 'dart:convert';
import 'package:form_filed_drop_down/form_filed_drop_down.dart';
import 'Model/CityModel.dart';
import 'Model/StatesModel.dart';
import 'Model/CountryModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FormFiled DropDown Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.deepPurple,
        ),
        appBarTheme:const AppBarTheme(
          color:  Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const DropDownClass(),
    );
  }
}

class DropDownClass extends StatefulWidget {
  const DropDownClass({super.key});

  @override
  State<DropDownClass> createState() => _DropDownClassState();
}

class _DropDownClassState extends State<DropDownClass> {

  final countryController = OverlayPortalController();
  final stateController = OverlayPortalController();
  final cityController = OverlayPortalController();
  final itemController = OverlayPortalController();

  final countryTextController = TextEditingController();
  final stateTextController = TextEditingController();
  final cityTextController = TextEditingController();
  final itemTextController = TextEditingController();

  CountryModel? selectedCountry;
  StatesModel? selectedState;
  CityModel? selectedCity;

  List<StatesModel> tempStatesList = [];
  List<CountryModel> countryList = [];
  List<StatesModel> statesList = [];
  List<CityModel> tempCityList = [];
  List<CityModel> cityList = [];


  FocusNode focusNode = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();

  Future<void> loadCity() async {
    cityList = [];

    var data = await rootBundle.loadString("assets/JsonFiles/City.json");
    var cityData = json.decode(data);
    List list = cityData['city'].cast<Map<String, dynamic>>();
    cityList.addAll(list.map((e) => CityModel.fromJson(e)).toList());
    setState(() {});

  }

  Future<void> loadState() async {
    statesList = [];
    var data = await rootBundle.loadString("assets/JsonFiles/State.json");
    var stateData = json.decode(data);
    List list = stateData['states'].cast<Map<String, dynamic>>();
    statesList.addAll(list.map((e) => StatesModel.fromJson(e)).toList());
    setState(() {});
  }

  Future<void> loadCountry() async {
    countryList = [];
    var data = await rootBundle.loadString("assets/JsonFiles/Country.json");
    var countryData = json.decode(data);
    List list = countryData['countries'].cast<Map<String, dynamic>>();
    countryList.addAll(list.map((e) => CountryModel.fromJson(e)).toList());
    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    loadCity();
    loadState();
    loadCountry();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "FormFiled DropDown Example",
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: CallbackShortcuts(
        bindings: {
          LogicalKeySet(LogicalKeyboardKey.tab):() async {
            if(focusNode.hasFocus){
              focusNode2.requestFocus();
              stateController.show();
              countryController.hide();
              cityController.hide();
            }else if(focusNode2.hasFocus){
              focusNode3.requestFocus();
              stateController.hide();
              countryController.hide();
              cityController.show();
            }else if(focusNode3.hasFocus){
              focusNode.requestFocus();
              stateController.hide();
              cityController.hide();
              countryController.show();
            }
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // SizedBox(height: MediaQuery.sizeOf(context).height * 0.9),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: FormFiledDropDown<CountryModel>(
                          focusNode: focusNode,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: countryController,
                          textController: countryTextController,
                          initialItem: selectedCountry,
                          item : countryList,
                          textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400
                          ),
                          menuDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: Colors.blueAccent
                              )
                          ),
                          filedDecoration: InputDecoration(
                              suffixIcon: IntrinsicWidth(
                                child: Row(
                                  children: [
                                    if(countryTextController.text.isNotEmpty)
                                      InkWell(
                                        onTap:() {
                                          setState(() {
                                            tempCityList = [];
                                            tempStatesList = [];
                                            // print(tempStatesList.length);
                                            selectedCity = null;
                                            selectedState = null;
                                            selectedCountry = null;
                                            countryTextController.clear();
                                            loadCountry();
                                          });
                                        },
                                        child: const Icon(
                                          Icons.clear,
                                          size: 20,
                                        ),
                                      ),

                                    if(countryTextController.text.isNotEmpty)
                                      const SizedBox(width: 5),
                                    const Icon(
                                      Icons.arrow_drop_down_sharp,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),

                                  ],
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(10),
                              errorStyle:const TextStyle(fontSize: 12,color: Colors.red,),
                              fillColor: Colors.white,
                              hintStyle: TextStyle(color: Colors.grey.shade800),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide:  const BorderSide(
                                      color: Colors.blueAccent
                                  )
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent
                                  )
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                      color: Colors.red
                                  )
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                      color: Colors.red
                                  )
                              )
                          ),
                          onChanged: (CountryModel? value) {
                            setState(() {
                              selectedCountry = value;
                              selectedCity = null;
                              selectedState = null;
                              tempStatesList = [];
                              tempCityList = [];
                              tempStatesList = statesList.where((element) {
                                return "${element.countryId}" == "${selectedCountry?.id}";
                              }).toList();
                            });
                          },
                          onSearch: (value) async {
                            return countryList.where((element) {
                              return element.name.toLowerCase().contains(value.toLowerCase());
                            }).toList();
                          },
                          listItemBuilder: (context, item, isSelected) {
                            int index = countryList.indexOf(item);
                            return Container(
                              padding:const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              margin: EdgeInsets.fromLTRB(5, index == 0 ? 7:2,5,1),
                              decoration: BoxDecoration(
                                  color: isSelected ? Colors.green : Colors.transparent,
                                  borderRadius: BorderRadius.circular(2)
                              ),
                              child: Text(
                                item.name,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            );
                          },
                          selectedItemBuilder: (context,item) {
                            return Text(
                              item.name,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400
                              ),
                            );
                          },
                        )
                    ),
                    const SizedBox(width: 15),

                    Expanded(
                        child: FormFiledDropDown<StatesModel>(
                          focusNode: focusNode2,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: stateController,
                          textController: stateTextController,
                          initialItem: selectedState,
                          item : tempStatesList,
                          textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400
                          ),
                          menuDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: Colors.blueAccent
                              )
                          ),
                          filedDecoration: InputDecoration(
                              suffixIcon: IntrinsicWidth(
                                child: Row(
                                  children: [
                                    if(stateTextController.text.isNotEmpty)
                                      InkWell(
                                        onTap:() {
                                          setState(() {
                                            selectedState = null;
                                            stateTextController.clear();
                                            if(selectedCountry == null) tempStatesList.clear();
                                          });
                                        },
                                        child: const Icon(
                                          Icons.clear,
                                          size: 20,
                                        ),
                                      ),

                                    if(stateTextController.text.isNotEmpty)
                                      const SizedBox(width: 5),
                                    const Icon(
                                      Icons.arrow_drop_down_sharp,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),

                                  ],
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(10),
                              errorStyle:const TextStyle(fontSize: 12,color: Colors.red,),
                              fillColor: Colors.white,
                              hintStyle: TextStyle(color: Colors.grey.shade800),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide:  const BorderSide(
                                      color: Colors.blueAccent
                                  )
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent
                                  )
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                      color: Colors.red
                                  )
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                      color: Colors.red
                                  )
                              )
                          ),
                          onChanged: (StatesModel? value) {
                            setState(() {
                              tempCityList = [];
                              selectedCity = null;
                              selectedState = value;

                              tempCityList = cityList.where((element) {
                                return "${element.stateId}" == "${selectedState?.id}";
                              }).toList();

                            });
                          },

                          onSearch: (value) async {
                            return statesList.where((element) {
                              return element.name.toLowerCase().contains(value.toLowerCase());
                            }).toList();
                          },
                          listItemBuilder: (context, item, isSelected) {
                            int index = statesList.indexOf(item);
                            return Container(
                              padding:const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              margin: EdgeInsets.fromLTRB(5, index == 0 ? 7:2,5,1),
                              decoration: BoxDecoration(
                                  color: isSelected ? Colors.green : Colors.transparent,
                                  borderRadius: BorderRadius.circular(2)
                              ),
                              child: Text(
                                item.name,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            );
                          },
                          selectedItemBuilder: (context, item) {
                            return Text(
                              item.name,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400
                              ),
                            );
                          },
                        )
                    ),
                    const SizedBox(width: 15),

                    Expanded(
                        child: FormFiledDropDown<CityModel>(
                          focusNode: focusNode3,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: cityController,
                          textController: cityTextController,
                          readOnly: tempCityList.isEmpty,
                          initialItem: selectedCity,
                          item : tempCityList,
                          textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400
                          ),
                          menuDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: Colors.blueAccent
                              )
                          ),
                          filedDecoration: InputDecoration(
                              suffixIcon: IntrinsicWidth(
                                child: Row(
                                  children: [
                                    if(cityTextController.text.isNotEmpty)
                                      InkWell(
                                        onTap:() {
                                          setState(() {
                                            selectedCity = null;
                                            cityTextController.clear();
                                            if(selectedState == null) tempCityList.clear();

                                          });
                                        },
                                        child: const Icon(
                                          Icons.clear,
                                          size: 20,
                                        ),
                                      ),

                                    if(cityTextController.text.isNotEmpty)
                                      const SizedBox(width: 5),
                                    const Icon(
                                      Icons.arrow_drop_down_sharp,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),

                                  ],
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(10),
                              errorStyle:const TextStyle(fontSize: 12,color: Colors.red,),
                              fillColor: Colors.white,
                              hintStyle: TextStyle(color: Colors.grey.shade800),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide:  const BorderSide(
                                      color: Colors.blueAccent
                                  )
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent
                                  )
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                      color: Colors.red
                                  )
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                      color: Colors.red
                                  )
                              )
                          ),
                          onChanged: (CityModel? value) {
                            setState(() {
                              selectedCity = value;
                            });
                          },
                          onSearch: (value) async {
                            return tempCityList.where((element) {
                              return element.name.toLowerCase().contains(value.toLowerCase());
                            }).toList();
                          },
                          listItemBuilder: (context, item, isSelected) {
                            int index = cityList.indexOf(item);
                            return Container(
                              padding:const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              margin: EdgeInsets.fromLTRB(5, index == 0 ? 7:2,5,1),
                              decoration: BoxDecoration(
                                  color: isSelected ? Colors.green : Colors.transparent,
                                  borderRadius: BorderRadius.circular(2)
                              ),
                              child: Text(
                                item.name,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            );
                          },
                          selectedItemBuilder: (context, item) {
                            return Text(
                              item.name,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400
                              ),
                            );
                          },
                        )
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

