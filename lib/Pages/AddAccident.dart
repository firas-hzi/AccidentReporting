import 'package:accident_archive/Model/AccidentData.dart';
import 'package:accident_archive/widgets/DateTimePicker.dart';
import 'package:accident_archive/widgets/DropDownButtomFile.dart';
import 'package:accident_archive/widgets/TextFormField.dart';
import 'package:accident_archive/widgets/TextStyle.dart';
import '../External/Storage/StorageFactory.dart';
import '../External/Storage/StorageInterface.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class AddAccident extends StatefulWidget {
  @override
  _AddAccidentState createState() => _AddAccidentState();
}

class _AddAccidentState extends State<AddAccident> {
  StorageInterface storageInterface;
  Accident accident;
  Tire tireVL;
  Tire tireVR;
  Tire tireHL;
  Tire tireHR;
  List<Tire> tires;

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    storageInterface = StorageFactory.getStorageImplementation();
    accident = new Accident();
    tires = new List<Tire>();
    initTire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(
                Icons.save,
                color: Colors.white,
              ),
              label: Text(''),
              onPressed: () async {
                tires.add(tireVL);
                tires.add(tireVR);
                tires.add(tireHL);
                tires.add(tireHR);
                await storageInterface.insert(accident, tires).whenComplete(() {
                  Navigator.of(context)
                      .pop(MaterialPageRoute(builder: (context) => Home()));
                });
              }),
        
        ],
      ),
      backgroundColor: Colors.blue[100],
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
              
                SizedBox(height: 10.0),
                Center(
                    child: new Text(
                  'Basic',
                  style: addTextStyle,
                  textAlign: TextAlign.center,
                )),
                SizedBox(height: 10.0),
                TextFormField(
                  style: textStyle,
                  // autofocus: true,
                  decoration: textInputDecoration.copyWith(
                      labelText: 'vers des unfallgegners'),
                  onChanged: (val) {
                    setState(() => accident.versOfTheOpponent = val);
                  },
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  style: textStyle,
                  decoration: textInputDecoration.copyWith(
                      labelText: 'vericherungsscheinnummer'),
                  onChanged: (val) {
                    setState(() => accident.insuranceNumber = val);
                  },
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  style: textStyle,
                  decoration:
                      textInputDecoration.copyWith(labelText: 'schadennummer'),
                  onChanged: (val) {
                    setState(() => accident.harmNumber = val);
                  },
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  style: textStyle,
                  decoration: textInputDecoration.copyWith(
                      labelText: 'versicherungsnehmer'),
                  onChanged: (val) {
                    setState(() => accident.policyHolder = val);
                  },
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  style: textStyle,
                  decoration: textInputDecoration.copyWith(
                      labelText: 'kenz. des unfallgegners'),
                  onChanged: (val) {
                    setState(() => accident.opponentOfTheAccident = val);
                  },
                ),
                SizedBox(height: 5.0),
                DateTimePickerClass(accident, 'C'),
                SizedBox(height: 5.0),
                TextFormField(
                  style: textStyle,
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Location'),
                  onChanged: (val) {
                    setState(() => accident.location = val);
                  },
                ),
                dividerStyle,
                Text(
                  'Verletzt',
                  style: addTextStyle,
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  style: textStyle,
                  decoration: textInputDecoration.copyWith(
                      labelText: 'Name', icon: Icon(Icons.person)),
                  onChanged: (val) {
                    setState(() => accident.injuredName = val);
                  },
                ),
                SizedBox(height: 5.0),
                TextFormField(
                    style: textStyle,
                    decoration: textInputDecoration.copyWith(
                        labelText: 'Addresse', icon: Icon(Icons.home)),
                    onChanged: (val) {
                      setState(() => accident.injuredAddress = val);
                    }),
                SizedBox(height: 5.0),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  style: textStyle,
                  decoration: textInputDecoration.copyWith(
                      labelText: 'Telephone', icon: Icon(Icons.phone_iphone)),
                  onChanged: (val) {
                    setState(() => accident.injuredTelephone = val);
                  },
                ),
                dividerStyle,
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Reifen VL,',
                    style: addTextStyle,
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        style: textStyle,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Reifen z.B'),
                        onChanged: (val) {
                          setState(() => tireVL.tire = val);
                        },
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        style: textStyle,
                        decoration:
                            textInputDecoration.copyWith(labelText: 'Marke'),
                        onChanged: (val) {
                          setState(() => tireVL.brand = val);
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: DropDownButtonTire(tireVL),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Align(
                    alignment: Alignment.topLeft,
                    child: new Text(
                      'Reifen VR,',
                      style: addTextStyle,
                    )),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        style: textStyle,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Reifen z.B'),
                        onChanged: (val) {
                          setState(() => tireVR.tire = val);
                        },
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        style: textStyle,
                        decoration:
                            textInputDecoration.copyWith(labelText: 'Marke'),
                        onChanged: (val) {
                          setState(() => tireVR.brand = val);
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: DropDownButtonTire(tireVR),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Align(
                    alignment: Alignment.topLeft,
                    child: new Text(
                      'Reifen HR,',
                      style: addTextStyle,
                      textAlign: TextAlign.center,
                    )),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        style: textStyle,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Reifen z.B'),
                        onChanged: (val) {
                          setState(() => tireHR.tire = val);
                        },
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        style: textStyle,
                        decoration:
                            textInputDecoration.copyWith(labelText: 'Marke'),
                        onChanged: (val) {
                          setState(() => tireHR.brand = val);
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: DropDownButtonTire(tireHR),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Align(
                    alignment: Alignment.topLeft,
                    child: new Text(
                      'Reifen HL,',
                      style: addTextStyle,
                      textAlign: TextAlign.center,
                    )),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        style: textStyle,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Reifen z.B'),
                        onChanged: (val) {
                          setState(() => tireHL.tire = val);
                        },
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        style: textStyle,
                        decoration:
                            textInputDecoration.copyWith(labelText: 'Marke'),
                        onChanged: (val) {
                          setState(() => tireHL.brand = val);
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: DropDownButtonTire(tireHL),
                    ),
                  ],
                ),
                dividerStyle,
                Align(
                    alignment: Alignment.topLeft,
                    child: new Text(
                      'Anfullhergang',
                      style: addTextStyle,
                      textAlign: TextAlign.center,
                    )),
                SizedBox(height: 10.0),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  style: textStyle,
                  decoration:
                      textInputDecoration.copyWith(labelText: 'anfullhergang'),
                  onChanged: (val) {
                    setState(() => accident.accident = val);
                  },
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  style: textStyle,
                  decoration: textInputDecoration.copyWith(labelText: 'Wie'),
                  onChanged: (val) {
                    setState(() => accident.how = val);
                  },
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  style: textStyle,
                  decoration: textInputDecoration.copyWith(labelText: 'Wo'),
                  onChanged: (val) {
                    setState(() => accident.where = val);
                  },
                ),
                SizedBox(height: 5.0),
                DateTimePickerClass(accident, 'W'),
                dividerStyle,
                Row(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: new Text(
                        'Vorschaden',
                        style: addTextStyle,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    DropdownButton<String>(
                      value: accident.vorschadenTimes,
                      icon: Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                      ),
                      iconSize: 18,
                      elevation: 16,
                      style: TextStyle(color: Colors.lightBlue, fontSize: 24),
                      underline: Container(
                        height: 2,
                        color: Colors.white,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          accident.vorschadenTimes = newValue;
                        });
                      },
                      items: <String>[
                        '0',
                        '1',
                        '2',
                        '3',
                        '4',
                        '5',
                        '6',
                        '7',
                        '8'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Description'),
                  style: textStyle,
                ),
                dividerStyle,
                Row(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: new Text(
                        'Altschaden',
                        style: addTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 30),
                    DropdownButton<String>(
                      value: accident.altschadenTimes,
                      icon: Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                      ),
                      iconSize: 18,
                      elevation: 16,
                      style: TextStyle(color: Colors.lightBlue, fontSize: 24),
                      underline: Container(
                        height: 2,
                        color: Colors.white,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          accident.altschadenTimes = newValue;
                        });
                      },
                      items: <String>[
                        '0',
                        '1',
                        '2',
                        '3',
                        '4',
                        '5',
                        '6',
                        '7',
                        '8'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Description'),
                  style: textStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> initTire() async {
    tireVL = new Tire();
    tireVL.size = 'VL';
    tireVR = new Tire();
    tireVR.size = 'VR';
    tireHL = new Tire();
    tireHL.size = 'HL';
    tireHR = new Tire();
    tireHR.size = 'HR';
  }
}
