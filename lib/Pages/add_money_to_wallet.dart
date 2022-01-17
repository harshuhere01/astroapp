import 'package:astro/Widgets/custom_gridview.dart';
import 'package:flutter/material.dart';

class AddMoneyPage extends StatefulWidget {
  AddMoneyPage({Key? key, this.balance = "90"}) : super(key: key);

  String? balance;

  @override
  _AddMoneyPageState createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {
  final _balancefieldcontroller = TextEditingController();
  List<int> itemlist = [
    25,
    50,
    100,
    200,
    300,
    500,
    1000,
    2000,
    3000,
    4000,
    8000,
    15000,
    20000,
    50000,
    100000
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add money to wallet"),
        backgroundColor: Colors.yellow[600],
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(25),
            child: Text(
              "Available Balance: ₹ ${widget.balance}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.1,
            child: TextFormField(
              controller: _balancefieldcontroller,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
              validator: (valuee) {
                if (valuee == null || valuee.isEmpty) {
                  return "*Enter money";
                }
              },
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text("data")));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width / 4.5,
                      decoration: const BoxDecoration(
                          color: Color(0xFFFdd835), //  Colors.yellow[600]
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: const Center(
                        child: Text(
                          'Proceed',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  hintText: 'Enter money'),
            ),
          ),
          Expanded(
            child: GridView.builder(
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCountAndCentralizedLastElement(
                  itemCount: itemlist.length,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 5),
                ),
                padding: const EdgeInsets.all(40),
                itemCount: itemlist.length,
                itemBuilder: (BuildContext context, int index) {
                  return ClipRect(
                    child: Banner(
                      location: BannerLocation.topStart,
                      message: '10% Extra',
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "You've selected ₹ ${itemlist[index]}.")),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: const Color(0xFFfeecd4),
                            border: Border.all(color: Colors.black87, width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Center(
                            child: Text(
                              " ₹ ${itemlist[index].toString()}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
