import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:requests/requests.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'productCard.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:data_table_2/data_table_2.dart';

class MyMobileBody extends StatefulWidget {
  const MyMobileBody({Key? key}) : super(key: key);

  @override
  State<MyMobileBody> createState() => _MyMobileBodyState();
}

final fieldText = TextEditingController();

void clearText() {
  fieldText.clear();
}
class _MyMobileBodyState extends State<MyMobileBody> {
  late AudioPlayer audioPlayer;
  late AudioCache audioCache;

  String _scanBarcode = '';
  String ipAdress = '';
  List productDetails = [];
  List<CountryCard> cards = [];
  List dataColumns = ['Lütfen Ürün Aratın Veya Barkod Okutun'];
  var dataRows = [];
  String response = '';
  var queryResponse  = { 'default' : 'Hoşgeldin' };
  TextEditingController _controller = TextEditingController();
  TextEditingController _barcodeController = TextEditingController();
  TextEditingController _scanController = TextEditingController();
  @override

  void initState() {

    super.initState();
    _controller.text = '89.252.188.10:61500';
    _barcodeController.text = '8682921261146';

    audioPlayer = AudioPlayer();
    audioCache = AudioCache();
      if(_myBox.get(2) != null){
        ipAdress = readData();
      }else {
        writeData("setuped");
        ipAdress = _myBox.get(1);
      }
  }

  void playSound() async {
     await audioCache.play('beep.mp3');

  }

  MaterialColor maviRenk = MaterialColor(
    0xFF6EC3EF,
    <int, Color>{
      50: Color(0xFF6EC3EF),
      100: Color(0xFF6EC3EF),
      200: Color(0xFF6EC3EF),
      300: Color(0xFF6EC3EF),
      400: Color(0xFF6EC3EF),
      500: Color(0xFF6EC3EF),
      600: Color(0xFF6EC3EF),
      700: Color(0xFF6EC3EF),
      800: Color(0xFF6EC3EF),
      900: Color(0xFF6EC3EF),
    },
  );

  final _myBox = Hive.box('mybox');
  Future<void> writeData(String _data) async {
    _myBox.put(1,_data);
    _myBox.put(2,"setuped");
  }

  String readData() {
    return _myBox.get(1);
  }

  void deleteData() {
    _myBox.delete(1);
  }

  List<CountryCard> getCards() {
    List<CountryCard> cards = [];
    for(int i = 0; i < productDetails.length; i++){
      cards.add(CountryCard(
        column: productDetails[i]['Açıklama'],
        row: productDetails[i]['Sonuç'],
      ));

    }
    return cards;
  }

  Future<void> getProductData(String _scanBarcode) async {

    //ipAdress = getIPAddress().toString();

    var r = await Requests.post(
        'http://$ipAdress/home/getChart',
        body: {
          'val': _scanBarcode,
        },
        bodyEncoding: RequestBodyEncoding.FormURLEncoded);
    r.raiseForStatus();
    List decodedJson = jsonDecode(r.body);
    setState(() {
      productDetails = decodedJson[1]['Data'];
      dataRows = decodedJson[0]['Data'];
      dataRows.forEach((element) {
        dataColumns = element.keys.toList();


      });
      getCards();


      dataRows = dataRows.map((product) {
        product.forEach((key, value) {
          if (value == "0") {
            product[key] = "";
          }

        });
        return product;
      }).toList();

    });
  }

  void setIpAdress() {
    setState(() {

      ipAdress = _controller.text.toString();
      writeData(ipAdress);


    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ffffff', 'İptal', false, ScanMode.BARCODE);

    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

      setState(() {

      _scanBarcode = barcodeScanRes;
      getProductData(_scanBarcode);
      if(_scanBarcode != '-1'){
          playSound();
      }
    });
  }

  Widget build(BuildContext context) {
    

    return Scaffold(

      backgroundColor: Color(0xfff5f8fa),
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(8),
          child:Image.asset('images/limonTechnology.png'),
        ),

        shape: Border(
            bottom: BorderSide(
              color: Color(0xff4DB0DD),
              width: 1,
            )
        ),
        centerTitle: true,

        title: const  Text('Limon Teknoloji | Ürün Sorgula',style: TextStyle(fontSize: 16),),
        actions: <Widget>[
          IconButton(
            color: Color(0xff4DB0DD),
            icon: Icon(Icons.settings),
            onPressed: () async {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: SizedBox(
                      height: 200,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 15,
                              child: Container(

                                height: 100,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20,right: 10,top: 20,),
                                  child:TextField(
                                    controller: _controller,
                                    decoration: const InputDecoration(
                                      labelText: "Adres",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        borderSide: BorderSide(color: Color(0xff4DB0DD), width: 1.0),
                                      ),

                                      hintText: 'Sunucu Adresini Portu İle Beraber Yazınız.',
                                      prefixIcon: Icon(Icons.computer_rounded),
                                    ),


                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Container(

                                height: 100,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10,top: 20,bottom: 20,),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1,color: Color(0xff4DB0DD)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: IconButton(


                                      icon: Icon(Icons.save),
                                      color: Color(0xff4DB0DD),
                                      onPressed: () {
                                        setIpAdress();
                                        final snackBar = SnackBar(
                                          content: const Text('Başarılı Bir Şekilde İp Adresini Kaydettiniz.'),

                                        );


                                        // Find the ScaffoldMessenger in the widget tree
                                        // and use it to show a SnackBar.
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        Navigator.pop(context);

                                      },

                                      iconSize: 30,
                                    ),
                                  ),

                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );

            },
          ),
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
                  height: 100,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 9,
                          child: Container(
                            height: 100,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20,right: 10,top: 20,),
                              child:TextField(
                                controller: _controller,
                                decoration: const InputDecoration(
                                  labelText: "Barkod",
                                  labelStyle: TextStyle(
                                    color: Color(0xff4DB0DD),
                                  ),

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(color: Color(0xff4DB0DD), width: 1.0),
                                  ),


                                  hintText: 'Ürün Barkodu Giriniz',
                                ),

                                onSubmitted: (String _scanBarcode) async {
                                  setState(() {
                                    getProductData(_scanBarcode);
                                    clearText();
                                  });

                                },

                                controller: fieldText,


                              ),
                            ),
                          ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 100,
                          alignment: Alignment.center,
                          child: Container(

                            child: IconButton(
                              icon: const Icon(Icons.send),
                              color: Color(0xff4DB0DD),
                              onPressed: () => {
                                setState(() {
                                 getProductData(fieldText.text.toString());
                                  clearText();
                                }),

                              },
                              iconSize: 35,
                            ),
                          ),

                        ),
                      ),

                      Expanded(
                        flex: 3,
                          child: Container(
                                height: 100,
                                alignment: Alignment.center,
                                child: Container(
                                  child: IconButton(
                                    icon: const Icon(Icons.camera_alt),
                                    color: Color(0xff4DB0DD),
                                    onPressed: ()=>scanQR(),
                                    iconSize: 40,
                                  ),
                                ),

                          ),
                      ),
                    ],
                  ),
                ),




            Flexible(
              flex: 5,
                child: ListView.builder(
                  itemCount: productDetails.length,
                  itemBuilder: (context, index) {
                    final jsonVeri = productDetails[index];
                    final column = jsonVeri["Açıklama"];
                    final row = jsonVeri['Sonuç'];

                    return Padding(
                      padding: const EdgeInsets.all(2.0),

                      child: Container(
                        color: Colors.white,
                        height: 55,
                        alignment: Alignment.center,
                        child:   ListTile(
                          title: Text(
                            column.toString(),
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                            row.toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ),

            Expanded(
              flex: 7,
                child: DataTable2(
                  headingRowColor: MaterialStateProperty.resolveWith(
                          (states) => 2 > 0 ? Colors.blue[200] : Colors.transparent),
                    columnSpacing: 12,
                    dataRowHeight: 40,
                    headingRowHeight: 40,
                    horizontalMargin: 12,
                    minWidth: 600,
                    columns: dataColumns.map((column) => DataColumn2(
                      label: Container(

                      alignment: Alignment.center,
                      child: Text(column, textAlign: TextAlign.center),
                    ),
                      size: ColumnSize.L,

                    )).toList(),

                    rows:List<DataRow>.generate(
                  dataRows.length,
                      (index) => DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                          }
                          if (index.isEven) {
                            return Colors.grey.withOpacity(0.3);
                          }
                          return null;
                        }),
                    cells: dataColumns
                        .map((column) => DataCell(
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            dataRows[index][column].toString(),
                            textAlign: TextAlign.center,
                          ),
                        )
                    )).toList(),
                  ),
                ),
                ),
                /*child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Builder(
                      builder: (context) => DataTable(
                        headingRowColor:
                        MaterialStateColor.resolveWith((states) => Color(0xff4DB0DD)),


                        columnSpacing: (MediaQuery.of(context).size.width / 10) * 0.5,
                        dataRowHeight: 35,

                        columns: dataColumns.map((column) => DataColumn(label: Text(column))).toList(),
                        rows: List<DataRow>.generate(
                          dataRows.length,
                              (index) => DataRow(
                                color: MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.selected)) {
                                        return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                                      }
                                      if (index.isEven) {
                                        return Colors.grey.withOpacity(0.3);
                                      }
                                      return null;
                                    }),
                            cells: dataColumns
                                .map((column) => DataCell(Text(dataRows[index][column].toString())))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),*/
            ),





          ],
        ),
      ),
      /*floatingActionButton: SafeArea(
        child: Builder(
          builder: (context) => FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: SizedBox(
                      height: 200,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 15,
                              child: Container(

                                height: 100,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20,right: 10,top: 20,),
                                  child:TextField(
                                    controller: _controller,
                                    decoration: const InputDecoration(
                                      labelText: "Adres",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        borderSide: BorderSide(color: Color(0xff4DB0DD), width: 1.0),
                                      ),

                                      hintText: 'Sunucu Adresini Portu İle Beraber Yazınız.',
                                      prefixIcon: Icon(Icons.computer_rounded),
                                    ),


                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Container(

                                height: 100,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10,top: 20,bottom: 20,),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1,color: Color(0xff4DB0DD)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: IconButton(


                                      icon: Icon(Icons.save),
                                      color: Color(0xff4DB0DD),
                                      onPressed: () {
                                        setIpAdress();
                                        final snackBar = SnackBar(
                                          content: const Text('Başarılı Bir Şekilde İp Adresini Kaydettiniz.'),

                                        );


                                        // Find the ScaffoldMessenger in the widget tree
                                        // and use it to show a SnackBar.
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        Navigator.pop(context);

                                      },

                                      iconSize: 30,
                                    ),
                                  ),

                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );

            },
            child: const Icon(Icons.settings,color: Color(0xff4DB0DD),),
          ),
        ),
      ),*/
    );
  }

}