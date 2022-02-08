import 'package:delphi_prog/models/data.dart';
import 'package:delphi_prog/models/data_set.dart';
import 'package:delphi_prog/models/input.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _data = Data();
  int _selectedIndex = 0;
  List<Input> _inputs = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _inputs = [
        Input(
            title: 'Интенсивность потока отказов, ω, базовый',
            setValue: (value) => {_data.omegaBase = value},
            getValue: () => _data.omegaBase),
        Input(
          title: 'Интенсивность потока отказов, ω новый',
          setValue: (value) => {_data.omegaNew = value},
          getValue: () => _data.omegaNew,
        ),
        Input(
          title: 'Потери добычи нефти на одно отключение в сети 35 кВ, ΔQ',
          setValue: (value) => {_data.deltaQ = value},
          getValue: () => _data.deltaQ,
        ),
        Input(
          title: 'Темп падения добычи нефти в год',
          setValue: (value) => {_data.oilProductionDecline = value},
          getValue: () => _data.oilProductionDecline,
        ),
        Input(
          title: 'Кол-во выключателей',
          setValue: (value) => {_data.switchQuantity = value},
          getValue: () => _data.switchQuantity,
        ),
        Input(
          title: 'Выключатель',
          setValue: (value) => {_data.switchPrice = value},
          getValue: () => _data.switchPrice,
        ),
        Input(
          title: 'СМР',
          setValue: (value) => {_data.switchMountPrice = value},
          getValue: () => _data.switchMountPrice,
        ),
        Input(
          title: 'Длина ВЛ',
          setValue: (value) => {_data.etLength = value},
          getValue: () => _data.etLength,
        ),
        Input(
          title: 'Базовая стоимость ВЛ',
          setValue: (value) => {_data.etPrice = value},
          getValue: () => _data.etPrice,
        ),
        Input(
          title: 'Цена нефти ',
          setValue: (value) => {_data.oilPrice = value},
          getValue: () => _data.oilPrice,
        ),
        Input(
          title: 'В 1 т.нефти баррелей',
          setValue: (value) => {_data.oilBarrel = value},
          getValue: () => _data.oilBarrel,
        ),
        Input(
          title: 'Курс доллара',
          setValue: (value) => {_data.dollarRate = value},
          getValue: () => _data.dollarRate,
        ),
        Input(
          title: 'цена нефти на внутр.рынке',
          setValue: (value) => {_data.oilPriceInside = value},
          getValue: () => _data.oilPriceInside,
        ),
        Input(
          title: 'экпорт нефти ',
          setValue: (value) => {_data.oilExport = value},
          getValue: () => _data.oilExport,
        ),
        Input(
          title: 'срок службы оборудования',
          setValue: (value) => {_data.equipmentServiceLife = value},
          getValue: () => _data.equipmentServiceLife,
        ),
        Input(
          title: 'условно-переменные затраты',
          setValue: (value) => {_data.conditionalVarCost = value},
          getValue: () => _data.conditionalVarCost,
        ),
        Input(
          title: 'Налог наимущество',
          setValue: (value) => {_data.propertyTax = value},
          getValue: () => _data.propertyTax,
        ),
        Input(
          title: 'Налог на прибыль',
          setValue: (value) => {_data.profitTax = value},
          getValue: () => _data.profitTax,
        ),
        Input(
          title: 'Ставка дисконтирования',
          setValue: (value) => {_data.discountRate = value},
          getValue: () => _data.discountRate,
        ),
        Input(
          title: 'Ндпи',
          setValue: (value) => {_data.miningTax = value},
          getValue: () => _data.miningTax,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: ListView(
              children: _inputs.map((input) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: input.controller,
                    onChanged: (text) {
                      setState(
                        () {
                          final newValue = num.tryParse(text);
                          if (newValue == null) {
                            if (input.controller.text.isNotEmpty) {
                              input.controller.text =
                                  input.getValue().toString();
                              input.controller.selection =
                                  TextSelection.collapsed(
                                      offset: input.controller.text.length);
                            }
                          } else {
                            if (input.controller
                                    .text[input.controller.text.length - 1] !=
                                '.') {
                              input.setValue(newValue);
                            }
                          }
                        },
                      );
                    },
                    decoration: InputDecoration(
                      labelText: input.title,
                      // border: const OutlineInputBorder(),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Flexible(
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: [buildTable(), buildLinePlot()][_selectedIndex],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  elevation: 0,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.table_chart),
                      label: "Table",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.show_chart),
                      label: "Chart",
                    )
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.amber[800],
                  onTap: _onItemTapped,
                ),
              ),
              flex: 10),
        ],
      ),
    );
  }

  Widget buildTable() {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: List.filled(
                _data.indexes.length + 2, const DataColumn(label: Text(''))),
            rows: rows
                .map((row) => DataRow(
                    cells: ([row.title] +
                            List.filled(
                                _data.indexes.length - row.data.length, '') +
                            row.data
                                .map((e) =>
                                    e.toStringAsFixed(row.fractionDigits))
                                .toList() +
                            [
                              row.sum?.toStringAsFixed(row.fractionDigits) ?? ''
                            ])
                        .map((e) => DataCell(Text(e)))
                        .toList()))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget buildLinePlot() {
    return LineChart(
      LineChartData(
        lineBarsData: rows
            .map(
              (row) => LineChartBarData(
                spots: row.data
                    .asMap()
                    .entries
                    .map((e) => FlSpot(
                        (e.key + _data.indexes.length - row.data.length)
                            .toDouble(),
                        e.value.toDouble()))
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }

  List<DataSet> get rows => [
        DataSet(
          data: _data.indexes,
          fractionDigits: 0,
        ),
        DataSet(
          title: 'Прирост добычи нефти, т.',
          data: _data.oilProductionIncrease,
          sum: _data.oilProductionIncreaseSum,
        ),
        DataSet(
          title:
              'Дополнительный прирост выручки в результате сокращения потока отказов, тыс. руб',
          data: _data.additionProfitGrowth,
          sum: _data.oilProductionIncreaseSum,
        ),
        DataSet(
          title:
              'Прирост производств.себестоимости (условно-переменные+амортизация+НДПИ), тыс.руб',
          data: _data.productionCostIncrease,
          sum: _data.productionCostIncreaseSum,
        ),
        DataSet(
          title: '\t-условно-переменные, тыс.руб',
          data: _data.conditionVariables,
          sum: _data.conditionVariablesSum,
        ),
        DataSet(
            title:
                '\t-амортизация  (методом по сумме лет использования) , тыс.руб.',
            data: _data.deprication,
            sum: _data.depricationSum),
        DataSet(
          title: 'норма амортизации, доли ед.',
          data: _data.normDeprication,
        ),
        DataSet(
            title: 'года',
            data: _data.years,
            sum: _data.yearsSum,
            fractionDigits: 0),
        DataSet(
            title: '\t-НДПИ, тыс. руб',
            data: _data.miningTaxes,
            sum: _data.miningTaxesSum),
        DataSet(
            title: 'Балансовая прибыль, тыс.руб.',
            data: _data.balanceIncome,
            sum: _data.balanceIncomeSum),
        DataSet(
            title: 'Налог на имущество, тыс. руб',
            data: _data.propertyTaxes,
            sum: _data.propertyTaxesSum),
        DataSet(
          title: 'остаточная стоимость, тыс. руб',
          data: _data.residualCost,
        ),
        DataSet(
          title: 'база для нагога на имущество, тыс. руб',
          data: _data.propertyTaxBase,
        ),
        DataSet(
            title: 'Прибыль для налогообл, тыс.руб.',
            data: _data.taxationProfit,
            sum: _data.taxationProfitSum),
        DataSet(
            title: 'Налог на прибыль',
            data: _data.profitTaxes,
            sum: _data.propertyTaxesSum),
        DataSet(
            title: 'Чистая прибыль, тыс.руб',
            data: _data.clearProfit,
            sum: _data.clearProfitSum),
        DataSet(
            title: 'Сальдо денежного потока, тыс.руб',
            data: _data.moneyFlow,
            sum: _data.moneyFlowSum),
        DataSet(
          title: 'Дисконтированный денежный поток, тыс.руб',
          data: _data.discountedMoneyFlow,
          sum: _data.discountedMoneyFlowSum,
        ),
        DataSet(
          title: 'Дисконтированный денежный поток нарастающим итогом,тыс. руб',
          data: _data.cumulativeDiscountMoneyFlow,
        ),
      ];
}
