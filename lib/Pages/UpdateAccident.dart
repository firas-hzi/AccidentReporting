import 'package:accident_archive/Model/AccidentData.dart';
import 'package:accident_archive/widgets/DateTimePicker.dart';
import 'package:accident_archive/widgets/TextFormField.dart';
import 'package:accident_archive/widgets/TextStyle.dart';
import '../External/Storage/StorageFactory.dart';
import '../External/Storage/StorageInterface.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class UpdateAccident extends StatefulWidget {
  final Accident accident;
  final List<Tire> tires;
  UpdateAccident(this.accident, this.tires);
  @override
  _UpdateAccidentState createState() => _UpdateAccidentState();
}

class _UpdateAccidentState extends State<UpdateAccident> {
  StorageInterface storageInterface;
  Accident accident = new Accident();
  List<Tire> tires;
  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    storageInterface = StorageFactory.getStorageImplementation();
    accident = widget.accident;
    tires = widget.tires;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(fontSize: 18.0, color: Colors.black87),
        ),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(
                Icons.update,
                color: Colors.white,
              ),
              label: Text(''),
              onPressed: () async {
                await storageInterface.update(accident, tires).whenComplete(() {
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
                  initialValue: accident.versOfTheOpponent,
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
                  initialValue: accident.insuranceNumber,
                  style: textStyle,
                  decoration: textInputDecoration.copyWith(
                      labelText: 'vericherungsscheinnummer'),
                  onChanged: (val) {
                    setState(() => accident.insuranceNumber = val);
                  },
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  initialValue: accident.harmNumber,
                  style: textStyle,
                  decoration:
                      textInputDecoration.copyWith(labelText: 'schadennummer'),
                  onChanged: (val) {
                    setState(() => accident.harmNumber = val);
                  },
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  initialValue: accident.policyHolder,
                  style: textStyle,
                  decoration: textInputDecoration.copyWith(
                      labelText: 'versicherungsnehmer'),
                  onChanged: (val) {
                    setState(() => accident.policyHolder = val);
                  },
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  initialValue: accident.opponentOfTheAccident,
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
                  initialValue: accident.location,
                  style: textStyle,
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Location'),
                  onChanged: (val) {
                    setState(() => accident.location = val);
                  },
                ),
                dividerStyle,
                Center(
                    child: new Text(
                  'Verletzt',
                  style: addTextStyle,
                  textAlign: TextAlign.center,
                )),
                SizedBox(height: 10.0),
                TextFormField(
                  initialValue: accident.injuredName,
                  style: textStyle,
                  decoration: textInputDecoration.copyWith(
                      labelText: 'Name', icon: Icon(Icons.person)),
                  onChanged: (val) {
                    setState(() => accident.injuredName = val);
                  },
                ),
                SizedBox(height: 5.0),
                TextFormField(
                    initialValue: accident.injuredAddress,
                    style: textStyle,
                    decoration: textInputDecoration.copyWith(
                        labelText: 'Addresse', icon: Icon(Icons.home)),
                    onChanged: (val) {
                      setState(() => accident.injuredAddress = val);
                    }),
                SizedBox(height: 5.0),
                TextFormField(
                  initialValue: accident.injuredTelephone,
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
                  child: new Text(
                    'Reifen ' + tires[0].size,
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
                        initialValue: tires[0].tire,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Reifen z.B'),
                        onChanged: (val) {
                          setState(() => tires[0].tire = val);
                        },
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        style: textStyle,
                        initialValue: tires[0].brand,
                        decoration:
                            textInputDecoration.copyWith(labelText: 'Marke'),
                        onChanged: (val) {
                          setState(() => tires[0].brand = val);
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: DropdownButton<String>(
                        value: tires[0].profile,
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
                            tires[0].profile = newValue;
                          });
                        },
                        items: <String>['1', '2', '3', '4', '5', '6', '7', '8']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Align(
                    alignment: Alignment.topLeft,
                    child: new Text(
                      'Reifen ' + tires[1].size,
                      style: addTextStyle,
                    )),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        initialValue: tires[1].tire,
                        style: textStyle,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Reifen z.B'),
                        onChanged: (val) {
                          setState(() => tires[1].tire = val);
                        },
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        initialValue: tires[1].brand,
                        style: textStyle,
                        decoration:
                            textInputDecoration.copyWith(labelText: 'Marke'),
                        onChanged: (val) {
                          setState(() => tires[1].brand = val);
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: DropdownButton<String>(
                        value: tires[1].profile,
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
                            tires[1].profile = newValue;
                          });
                        },
                        items: <String>['1', '2', '3', '4', '5', '6', '7', '8']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Align(
                    alignment: Alignment.topLeft,
                    child: new Text(
                      'Reifen ' + tires[2].size,
                      style: addTextStyle,
                    )),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        initialValue: tires[2].tire,
                        style: textStyle,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Reifen z.B'),
                        onChanged: (val) {
                          setState(() => tires[2].tire = val);
                        },
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        initialValue: tires[2].brand,
                        style: textStyle,
                        decoration:
                            textInputDecoration.copyWith(labelText: 'Marke'),
                        onChanged: (val) {
                          setState(() => tires[2].brand = val);
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: DropdownButton<String>(
                        value: tires[2].profile,
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
                            tires[2].profile = newValue;
                          });
                        },
                        items: <String>['1', '2', '3', '4', '5', '6', '7', '8']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Align(
                    alignment: Alignment.topLeft,
                    child: new Text(
                      'Reifen ' + tires[3].size,
                      style: addTextStyle,
                    )),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        initialValue: tires[3].tire,
                        style: textStyle,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Reifen z.B'),
                        onChanged: (val) {
                          setState(() => tires[3].tire = val);
                        },
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        initialValue: tires[3].brand,
                        style: textStyle,
                        decoration:
                            textInputDecoration.copyWith(labelText: 'Marke'),
                        onChanged: (val) {
                          setState(() => tires[3].brand = val);
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: DropdownButton<String>(
                        value: tires[3].profile,
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
                            tires[3].profile = newValue;
                          });
                        },
                        items: <String>['1', '2', '3', '4', '5', '6', '7', '8']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                dividerStyle,
                Align(
                    alignment: Alignment.topLeft,
                    child: new Text(
                      'Anfullhergang',
                      style: addTextStyle,
                    )),
                SizedBox(height: 10.0),
                TextFormField(
                  initialValue: accident.accident,
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
                  initialValue: accident.how,
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
                  initialValue: accident.where,
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
                  initialValue: accident.vorschadenDesc,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Description'),
                  style: textStyle,
                  onChanged: (val) {
                    setState(() => accident.vorschadenDesc = val);
                  },
                ),
                dividerStyle,
                Row(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: new Text(
                        'Altschaden',
                        style: addTextStyle,
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
                  initialValue: accident.altschadenDesc,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Description'),
                  style: textStyle,
                  onChanged: (val) {
                    setState(() => accident.altschadenDesc = val);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
