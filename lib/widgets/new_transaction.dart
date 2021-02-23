import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import "../widgets/adaptive_flatbutton.dart";

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();
  DateTime selectedDate;

  void submitData() {
    if(amountController.text.isEmpty){
      return;
    }
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);



    if (enteredTitle.isEmpty || enteredAmount <= 0 || selectedDate == null) {
      return;
    }

    widget.addTx(enteredTitle, enteredAmount,selectedDate);
    Navigator.of(context).pop();
  }

  void presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then((pickedDate) {
          if(pickedDate == null){
            return;
          }
          setState(() {
            selectedDate = pickedDate;
          });

    });
  }

  @override
  Widget build(BuildContext context) {
    print('height of the viewInsets ' + '${MediaQuery.of(context).viewInsets.bottom}');
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            left:10,
            top:10,
            right:10,
            bottom:MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleController,
                onSubmitted: (_) => submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(child: Text(selectedDate == null ? 'No Date Choosen': 'Picked Date : ${DateFormat.yMd().format(selectedDate)}')),
                    AdaptiveFlatButton('Choose Date', presentDatePicker),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: submitData,
                child: Text('Add Transaction'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
