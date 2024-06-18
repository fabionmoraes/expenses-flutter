import 'dart:math';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';

main() => runApp(const ExpensesApp());

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt', 'BR'), // arabic, no country code
        ],
        home: const MyHomePage(),
        theme: ThemeData(
          primaryColor: Colors.purple,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.amber,
          ),
          fontFamily: 'Quicksand',
          textTheme: const TextTheme(
              titleLarge: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w700,
            fontSize: 18,
          )),
          cardTheme: const CardTheme(
            color: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _transactions = [];
  bool _showCharts = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    Widget getIconButton(IconData icon, Function() fn) {
      return Platform.isIOS
          ? GestureDetector(onTap: fn, child: Icon(icon))
          : IconButton(icon: Icon(icon), onPressed: fn);
    }

    String title = 'Despesas Pessoais';

    final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.list;
    final iconChart =
        Platform.isIOS ? CupertinoIcons.refresh : Icons.show_chart;

    final actions = [
      if (isLandscape)
        getIconButton(
          _showCharts ? iconList : iconChart,
          () {
            setState(() {
              _showCharts = !_showCharts;
            });
          },
        ),
      getIconButton(
        Icons.add,
        () => _openTransactionFormModal(context),
      )
    ];

    final PreferredSizeWidget appBar = AppBar(
      title: Text(title),
      actions: actions,
    );

    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    final bodyPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // if (isLandscape)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       const Text('Exibir Gráfico'),
            //       Switch.adaptive(
            //         activeColor: Theme.of(context).primaryColor,
            //         value: _showCharts,
            //         onChanged: (value) {
            //           setState(() {
            //             _showCharts = value;
            //           });
            //         },
            //       ),
            //     ],
            //   ),
            if (_showCharts || !isLandscape)
              Container(
                height: availableHeight * (isLandscape ? 0.8 : 0.3),
                child: Chart(_recentTransactions),
              ),
            if (!_showCharts || !isLandscape)
              Container(
                height: availableHeight * (isLandscape ? 1 : 0.7),
                child: TransactionList(_transactions, _removeTransaction),
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            backgroundColor: Colors.grey[50],
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            backgroundColor: Colors.grey[50],
            body: bodyPage,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _openTransactionFormModal(context),
                    child: const Icon(Icons.add),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
