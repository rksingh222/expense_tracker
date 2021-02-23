import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//import './widgets/user_tansaction.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            button: TextStyle(
              color: Colors.white,
            )),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.amber,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _usertransactions = [
    //  Transaction(id: '1', title: 'New Shoes', amount: 66, date: DateTime.now()),
    // Transaction(
    //   id: '2', title: 'Weekly Groceries', amount: 16, date: DateTime.now())
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _usertransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime txSelectedDate) {
    final tx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: txSelectedDate);

    setState(() {
      _usertransactions.add(tx);
    });
  }

  void _deleteTransaction(String txId) {
    setState(() {
      _usertransactions.removeWhere((tx) {
        return tx.id == txId;
      });
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  List<Widget> _buildLandScapeContent(MediaQueryData mediaQuery,AppBar appBar,Widget txListWidget){
    return
      [Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart' ,style: Theme.of(context).textTheme.headline6,),
          Switch.adaptive(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          )
        ],
      ),
        _showChart
            ? Container(
            height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
                0.6,
            child: Chart(_recentTransactions))
            : txListWidget,];
  }

  List<Widget> _buildPotraitContent(MediaQueryData mediaQuery,AppBar appBar,Widget txListWidget){
    return [Container(
        height: (mediaQuery.size.height -
            appBar.preferredSize.height -
            mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions)),txListWidget];

  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    print(_recentTransactions.length);
    print('size of Screen:' + '${mediaQuery.size.height}');
    final isLandscape =
        mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Flutter App'),
            trailing: Row(
              children: [
                GestureDetector(
                  onTap: () => _startAddNewTransaction(context),
                  child: Icon(CupertinoIcons.add),
                ),
              ],
            ))
        : AppBar(
            title: Text(
              'Flutter App',
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );

    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
            mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_usertransactions, _deleteTransaction));

    final body = SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandscape)
            ... _buildLandScapeContent(mediaQuery,appBar,txListWidget),
          if (!isLandscape)
            ..._buildPotraitContent(mediaQuery,appBar,txListWidget),
        ],
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: body,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: body,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            ),
          );
  }
}
