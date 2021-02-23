import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      var totalAmount = 0.0;
      final weekDay = DateTime.now().subtract(Duration(days: index));

      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalAmount += recentTransactions[i].amount;
        }
      }
      print(DateFormat.E().format(weekDay));
      print(totalAmount);
      return {
        'Day': DateFormat.E().format(weekDay).substring(0, 1),
        'Amount': totalAmount
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['Amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);

    return Card(
      elevation: 6,
      //color: Colors.blue,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ...groupedTransactionValues.map((Data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    Data['Day'],
                    Data['Amount'],
                    totalSpending == 0.0
                        ? 0.0
                        : (Data['Amount'] as double) / totalSpending),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
