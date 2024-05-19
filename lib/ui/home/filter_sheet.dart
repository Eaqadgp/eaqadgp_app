import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:eaqad_app/model/filter_model.dart';
import 'package:flutter/material.dart';

class FilterSheet extends StatefulWidget {
  final Function(FilterModel) onFilter;
  const FilterSheet({super.key, required this.onFilter});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  double start = 10000.0;
  double end = 10000000.0;
  bool loading=false;
  List<DropDownValueModel> drop=[];
  List<String> selectedDistricts=[];
  List<int> rooms=[];

  @override
  void initState() {
    getAll();
    super.initState();
  }
  void getAll()async {
    setState(() {
      loading = true;
    });
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection("districts").get();
    setState(() {
      loading = false;
    });
    if (data.docChanges.isEmpty) {

    }else{
      data.docs.forEach((element) {

        drop.add(DropDownValueModel(
            name: element['name'], value: element['id'],));
      });
    }
    print(drop.isEmpty);
    print(drop.length);
  }

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: loading,
      blurEffectIntensity: 8,
      progressIndicator: const CircularProgressIndicator(),
      dismissible: false,
      opacity: 0.4,
      color: Theme.of(context).primaryColor,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                      Icons.arrow_circle_right_outlined),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "فلتر البحث",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              DropDownTextField.multiSelection(

                displayCompleteItem: true,
                textFieldDecoration: InputDecoration(
                    hintText: "اختيار الحي",
                    hintStyle:
                    TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Color.fromARGB(
                        255, 241, 241, 241),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .primaryColor,
                        )),
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 241, 241, 241),
                        ))),
                //initialValue: const ["name1", "name2", "name8", "name3"],
                dropDownList: drop.isEmpty?[
                  DropDownValueModel(name: "name", value: "value"),
                  DropDownValueModel(name: "name", value: "value"),
                  DropDownValueModel(name: "name", value: "value"),
                  DropDownValueModel(name: "name", value: "value"),
                  DropDownValueModel(name: "name", value: "value"),
                ]:drop,
                onChanged: (val) {

                 selectedDistricts.clear();
                 if((val as List).isNotEmpty){
                   (val as List<DropDownValueModel>).forEach((element) {
                     selectedDistricts.add(element.value as String);
                   });
                 }
                },
              ),
              SizedBox(
                height: 15,
              ),
              DropDownTextField.multiSelection(
                // controller: _cntMulti,
                displayCompleteItem: true,
                textFieldDecoration: InputDecoration(
                    hintText: "اختيار عدد الغرف",
                    hintStyle:
                    TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Color.fromARGB(
                        255, 241, 241, 241),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .primaryColor,
                        )),
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 241, 241, 241),
                        ))),
                //initialValue: const ["name1", "name2", "name8", "name3"],
                dropDownList: const [
                  DropDownValueModel(name: '1', value: 1),
                  DropDownValueModel(name: '2', value: 2),
                  DropDownValueModel(name: '3', value: 3),
                  DropDownValueModel(name: '4', value: 5),
                  DropDownValueModel(name: '5', value: 5),
                  DropDownValueModel(name: '6', value: 6),
                  DropDownValueModel(name: '7', value: 7),
                  DropDownValueModel(name: '8', value: 8),
                  DropDownValueModel(name: '9', value: 9),
                  DropDownValueModel(name: '10', value: 10),
                  DropDownValueModel(name: '11', value: 11),
                ],
                onChanged: (val) {
                  rooms.clear();
                  if((val as List).isNotEmpty){
                    (val as List<DropDownValueModel>).forEach((element) {
                      rooms.add(element.value as int);
                    });
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "السعر",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              RangeSlider(

                values: RangeValues(start, end),

                labels: RangeLabels(start.toString(), end.toString()),
                onChanged: (value) {
                  setState(() {
                    start = value.start;
                    end = value.end;
                  });
                },
                min: 10000.0,
                max: 10000000.0,
              ),
              SizedBox(
                height: 15,
              ),
              Text("${start.toInt()}-${end.toInt()}",style: TextStyle(fontSize: 24),),

              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  FilterModel filter=FilterModel(start, end, selectedDistricts, rooms);
                  widget.onFilter(filter);

                  Navigator.pop(context);

                },
                child: Text(
                  'بحث',
                  style: TextStyle(
                      color: Colors.white, fontSize: 22),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  Theme.of(context).primaryColor,
                  minimumSize: Size.fromHeight(50),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
