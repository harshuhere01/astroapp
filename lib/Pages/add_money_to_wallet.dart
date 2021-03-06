import 'package:astro/Pages/payment_info.dart';
import 'package:astro/Widgets/custom_gridview.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddMoneyPage extends StatefulWidget {
  AddMoneyPage({Key? key, this.balance }) : super(key: key);

  String? balance;

  @override
  _AddMoneyPageState createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {
  final _balancefieldcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? amount;
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
  void dispose() {
    // if(!mounted) {
      _balancefieldcontroller.dispose();
    // }
    super.dispose();
  }

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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("asset/placeholder.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(25),
              child: Text(
                "Available Balance: ₹ ${widget.balance}",
                style:  TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: widget.balance != null? Colors.black : Colors.white),
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                width: MediaQuery.of(context).size.width / 1.1,
                child: TextFormField(
                  onChanged: (value){
                    amount=_balancefieldcontroller.text;
                  },
                  controller: _balancefieldcontroller,
                  keyboardType: TextInputType.number,
                  style:
                      const TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                  validator: (valuee) {
                    if (valuee == null || valuee.isEmpty) {
                      return "*Enter money";
                    }
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(10),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          if (_formKey.currentState?.validate() == true) {
                            int val = int.parse(_balancefieldcontroller.text);
                            if(val > 25 ){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) =>  PaymentInfo(selectedAmount: amount,)));
                            }
                            else{
                              Fluttertoast.showToast(msg: "Minimum recharge value is ₹25");
                            }
                          }
    },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          width: MediaQuery.of(context).size.width / 4.5,
                          decoration: const BoxDecoration(
                              color: Color(0xFFFdd835), //  Colors.yellow[600]
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
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
                      child: itemlist[index] > 200
                          ? Banner(
                              location: BannerLocation.topStart,
                              message: itemlist[index] <= 500
                                  ? '5% Extra'
                                  : itemlist[index] <= 4000
                                      ? '10% Extra'
                                      : '15% Extra',
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _balancefieldcontroller.text = itemlist[index].toString();
                                    amount=_balancefieldcontroller.text;
                                  });
                                  // var convertedamount = int.parse(_balancefieldcontroller.text) * 100;
                                  print("!!!!!!!!!!!!!!!!!$amount");

                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: const Color(0xFFfeecd4),
                                    border: Border.all(
                                        color: Colors.black87, width: 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
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
                            )
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  _balancefieldcontroller.text = itemlist[index].toString();
                                  amount=_balancefieldcontroller.text;
                                });
                                print(amount);
                                // ScaffoldMessenger.of(context).clearSnackBars();
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(
                                //       content: Text(
                                //           "You've selected ₹ ${itemlist[index]}.")),
                                // );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: const Color(0xFFfeecd4),
                                  border: Border.all(
                                      color: Colors.black87, width: 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
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
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
