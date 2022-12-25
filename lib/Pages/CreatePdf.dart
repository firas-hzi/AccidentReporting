import 'dart:io';
import 'package:accident_archive/Model/AccidentData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' as flutterWidget;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

class CreatePdf {
  var pdfTextStyle = TextStyle(
    fontSize: 18,
    color: PdfColors.blue900,
  );

  var headerTextStyle = TextStyle(
      fontSize: 20, color: PdfColors.blue, fontWeight: FontWeight.bold);

  Future<File> createPdfFile(
      Accident accident, List<Tire> tires, List<DocumentSnapshot> urls) async {
    final Document pdf = Document();

   
    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        crossAxisAlignment: CrossAxisAlignment.start,
        header: (Context context) {
          if (context.pageNumber == 1) {
            return null;
          }
          return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const BoxDecoration(
                  border: BoxBorder(
                      bottom: true, width: 0.5, color: PdfColors.grey)),
              child: Text('CCbyExpert',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (Context context) => <Widget>[
              Header(
                  level: 0,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'CCbyExpert',
                          style: headerTextStyle.copyWith(fontSize: 22),
                          textScaleFactor: 1,
                        ),
                        PdfLogo()
                      ])),

              Header(
                  level: 1,
                  text: 'Abtretungserklarung des Kfz-Sachverständigen',
                  textStyle: headerTextStyle),

              Paragraph(
                text: 'vers. des Unfallgegners:  ' + accident.versOfTheOpponent,
                style: pdfTextStyle,
              ),

              Paragraph(
                text: 'Versicherungsscheinnummer:  ' + accident.insuranceNumber,
                style: pdfTextStyle,
              ),

              Paragraph(
                text: 'Schadennummer:  ' + accident.harmNumber,
                style: pdfTextStyle,
              ),

              Paragraph(
                text: 'Versicherungsnehmer:  ' + accident.policyHolder,
                style: pdfTextStyle,
              ),

              Paragraph(
                text: 'Kennz. des Unfallgegners:  ' +
                    accident.opponentOfTheAccident,
                style: pdfTextStyle,
              ),

              Paragraph(
                text: 'Schadentag:  ' +
                    DateFormat('dd-MMM-yy HH:mm a')
                        .format(accident.claimDay)
                        .toString(),
                style: pdfTextStyle,
              ),

              Paragraph(
                text: 'Schadenort:  ' + accident.location,
                style: pdfTextStyle,
              ),

              Header(
                  level: 1, text: 'Geschadigten', textStyle: headerTextStyle),

              Paragraph(
                text: 'Name:  ' + accident.injuredName,
                style: pdfTextStyle,
              ),

              Paragraph(
                text: 'Addresse:  ' + accident.injuredAddress,
                style: pdfTextStyle,
              ),

              Paragraph(
                text: 'Telephone:  ' + accident.injuredTelephone,
                style: pdfTextStyle,
              ),

              Header(level: 1, text: 'Reifen', textStyle: headerTextStyle),

              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder(width: 1.0, color: PdfColors.blueAccent200),
                tableWidth: TableWidth.max,
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 50,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text('Reifen z.B', style: pdfTextStyle)),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 50,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text('Marke', style: pdfTextStyle)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 50,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text('Grosse', style: pdfTextStyle)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 50,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text('Profile', style: pdfTextStyle)),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Container(
                        height: 35,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(tires[0].tire ?? '', style: pdfTextStyle),
                        ),
                      ),
                      Container(
                        height: 35,
                        child: Align(
                          alignment: Alignment.center,
                          child:
                              Text(tires[0].brand ?? '', style: pdfTextStyle),
                        ),
                      ),
                      Container(
                        height: 35,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(tires[0].size ?? '', style: pdfTextStyle),
                        ),
                      ),
                      Container(
                        height: 35,
                        child: Align(
                          alignment: Alignment.center,
                          child:
                              Text(tires[0].profile ?? '', style: pdfTextStyle),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Container(
                        height: 35,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(tires[1].tire ?? '', style: pdfTextStyle),
                        ),
                      ),
                      Container(
                        height: 35,
                        child: Align(
                          alignment: Alignment.center,
                          child:
                              Text(tires[1].brand ?? '', style: pdfTextStyle),
                        ),
                      ),
                      Container(
                        height: 35,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(tires[1].size ?? '', style: pdfTextStyle),
                        ),
                      ),
                      Container(
                        height: 35,
                        child: Align(
                          alignment: Alignment.center,
                          child:
                              Text(tires[1].profile ?? '', style: pdfTextStyle),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Container(
                        height: 35,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(tires[2].tire ?? '', style: pdfTextStyle),
                        ),
                      ),
                      Container(
                        height: 35,
                        child: Align(
                          alignment: Alignment.center,
                          child:
                              Text(tires[2].brand ?? '', style: pdfTextStyle),
                        ),
                      ),
                      Container(
                        height: 35,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(tires[2].size ?? '', style: pdfTextStyle),
                        ),
                      ),
                      Container(
                        height: 35,
                        child: Align(
                          alignment: Alignment.center,
                          child:
                              Text(tires[2].profile ?? '', style: pdfTextStyle),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Container(
                        height: 35,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(tires[3].tire ?? '', style: pdfTextStyle),
                        ),
                      ),
                      Container(
                        height: 35,
                        child: Align(
                          alignment: Alignment.center,
                          child:
                              Text(tires[3].brand ?? '', style: pdfTextStyle),
                        ),
                      ),
                      Container(
                        height: 35,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(tires[3].size ?? '', style: pdfTextStyle),
                        ),
                      ),
                      Container(
                        height: 35,
                        child: Align(
                          alignment: Alignment.center,
                          child:
                              Text(tires[3].profile ?? '', style: pdfTextStyle),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 15),
              Header(level: 1, text: 'Unfallen', textStyle: headerTextStyle),

              Paragraph(
                text: 'Unfallhergung:  ' + accident.accident,
                style: pdfTextStyle,
              ),

              Paragraph(
                text: 'Wie:  ' + accident.how,
                style: pdfTextStyle,
              ),

              Paragraph(
                text: 'Wo:  ' + accident.where,
                style: pdfTextStyle,
              ),

              Paragraph(
                text: 'Wann:  ' +
                    DateFormat('dd-MMM-yy HH:mm a')
                        .format(accident.when)
                        .toString(),
                style: pdfTextStyle,
              ),

              Header(
                  level: 1,
                  text: 'Vorschaden ' + accident.vorschadenTimes + ' time/s: ',
                  textStyle: headerTextStyle),

              Paragraph(style: pdfTextStyle, text: accident.vorschadenDesc),

              //  Padding(padding: const EdgeInsets.all(10)),
              Header(
                  level: 1,
                  text: 'Altschaden ' + accident.altschadenTimes + ' time/s: ',
                  textStyle: headerTextStyle),

              Paragraph(style: pdfTextStyle, text: accident.altschadenDesc),

              Header(level: 1, text: 'Images ', textStyle: headerTextStyle)

     
          
            ]));
             for (var url in urls) {
               
      
        flutterWidget.FileImage imageProvider;
          imageProvider = flutterWidget.FileImage(File(url.data['url']), scale: 0.5,);
    final PdfImage image = await pdfImageFromImageProvider(
        pdf: pdf.document, image: imageProvider);
        if(image!=null)
        {
                pdf.addPage(Page(
                 
          build: (context) => (
         
               Center(
        child: Image(image,
        
        ),
        
      )
        
          )));  
        }
      }

    //getApplicationDocumentsDirectory()
    final String dir = (await getTemporaryDirectory()).path;
    final String path = '$dir/unfallen.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdf.save());
    return file;
  }
}
