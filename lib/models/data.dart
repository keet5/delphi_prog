import 'dart:math';
import 'package:quiver/iterables.dart';

class Data {
  /// 5
  num omegaBase;

  /// 5
  num omegaNew;

  /// 7
  num deltaQ;

  /// 9
  num oilProductionDecline;

  /// 11
  num switchQuantity;

  /// 12
  num switchPrice;

  /// 13
  num switchMountPrice;

  /// 15
  num etLength;

  /// 16
  num etPrice;

  /// 17
  num oilPrice;

  /// 18
  num oilBarrel;

  /// 19
  num dollarRate;

  /// 20
  num oilPriceInside;

  /// 21
  num oilExport;

  /// 23
  num equipmentServiceLife;

  /// 24
  num conditionalVarCost;

  /// 25
  num propertyTax;

  /// 26
  num profitTax;

  /// 27
  num discountRate;

  /// 28
  num miningTax;

  Data({
    this.equipmentServiceLife = 40,
    this.omegaBase = 5.63,
    this.omegaNew = 1.487,
    this.deltaQ = 50,
    this.oilProductionDecline = 0.08,
    this.switchQuantity = 2,
    this.switchPrice = 850,
    this.switchMountPrice = 350,
    this.etLength = 1,
    this.etPrice = 6700,
    this.oilPrice = 81,
    this.oilBarrel = 7.59,
    this.dollarRate = 72,
    this.oilPriceInside = 35,
    this.oilExport = 0.537,
    this.conditionalVarCost = 2.6,
    this.propertyTax = 0.02,
    this.profitTax = 0.2,
    this.discountRate = 0.12,
    this.miningTax = 9.088,
  });

  get deltaOmega => omegaBase - omegaNew; //G5
  get oilInsideSell => 1 - oilExport; // E22
  get losesOilProduction =>
      oilInsideSell * oilPriceInside +
      oilExport * oilBarrel * oilPrice * dollarRate / 1000; //D6E6
  get yearQ => deltaOmega * deltaQ;

  // Graph
  /// 32
  List<num> get indexes =>
      List<num>.generate(equipmentServiceLife.toInt() + 1, (index) => index);

  /// 33
  List<num> get oilProductionIncrease => List<num>.generate(
      equipmentServiceLife.toInt(),
      (index) => yearQ * pow(1 - oilProductionDecline, index));

  /// 33 sum
  num get oilProductionIncreaseSum => oilProductionIncrease.reduce(sum);

  /// 34
  num get capitalInvestments =>
      switchQuantity * switchPrice +
      switchMountPrice * switchQuantity +
      etLength * etPrice; // C34

  /// 35
  List<num> get additionProfitGrowth => oilProductionIncrease
      .map((oilIncrease) => oilIncrease * losesOilProduction)
      .toList(); //C35:AQ35
  num get additionProfitGrowthSum => additionProfitGrowth.reduce(sum);

  /// 36
  List<num> get productionCostIncrease =>
      zip([conditionVariables, deprication, miningTaxes])
          .map((e) => e.reduce(sum))
          .toList();

  /// 36 sum
  num get productionCostIncreaseSum => productionCostIncrease.reduce(sum);

  /// 37
  List<num> get conditionVariables => oilProductionIncrease
      .map((oilIncrease) => conditionalVarCost * oilIncrease)
      .toList();

  /// 37 sum
  num get conditionVariablesSum => conditionVariables.reduce(sum);

  /// 38
  List<num> get deprication =>
      normDeprication.map((nd) => nd * capitalInvestments).toList();

  /// 38 sum
  num get depricationSum => deprication.reduce(sum);

  /// 39
  List<num> get normDeprication =>
      years.map((year) => year / yearsSum).toList();

  /// 40
  List<num> get years =>
      List.generate(equipmentServiceLife.toInt(), (index) => index + 1)
          .cast<num>()
          .reversed
          .toList();

  /// 40 sum
  num get yearsSum => years.reduce(sum);

  /// 41
  List<num> get miningTaxes =>
      oilProductionIncrease.map((opi) => miningTax * opi).toList();

  /// 41 sum
  num get miningTaxesSum => miningTaxes.reduce(sum);

  /// 42
  List<num> get balanceIncome =>
      zip([additionProfitGrowth, productionCostIncrease])
          .map((e) => e[0] - e[1])
          .toList();

  /// 42 sum
  num get balanceIncomeSum => balanceIncome.reduce(sum);

  /// 43
  List<num> get propertyTaxes =>
      propertyTaxBase.map((e) => e * propertyTax).toList();

  /// 43 sum
  num get propertyTaxesSum => propertyTaxes.reduce(sum);

  /// 44
  List<num> get residualCost =>
      deprication.fold([capitalInvestments], (resultList, element) {
        final newValue = resultList.last - element;
        resultList.add(newValue);
        return resultList;
      });

  /// 45
  List<num> get propertyTaxBase => residualCost
      .asMap()
      .entries
      .toList()
      .sublist(1)
      // .map((e) => (residualCost[e.key - 1] + e.value) / 2)
      .map((e) => 1)
      .toList();

  /// 46
  List<num> get taxationProfit =>
      zip([balanceIncome, propertyTaxes]).map((e) => e[0] - e[1]).toList();

  /// 46 sum
  num get taxationProfitSum => taxationProfit.reduce(sum);

  /// 47
  List<num> get profitTaxes =>
      taxationProfit.map((e) => e > 0 ? e * profitTax : 0).toList();

  /// 47 sum
  num get profitTaxesSum => profitTaxes.reduce(sum);

  /// 48
  List<num> get clearProfit =>
      zip([taxationProfit, profitTaxes]).map((e) => e[0] - e[1]).toList();

  /// 48 sum
  num get clearProfitSum => clearProfit.reduce(sum);

  /// 49
  List<num> get moneyFlow =>
      [-capitalInvestments] +
      zip([clearProfit, deprication]).map((e) => e[0] + e[1]).toList();

  /// 49 sum
  num get moneyFlowSum => moneyFlow.reduce(sum);

  /// 50
  List<num> get discountedMoneyFlow => moneyFlow
      .asMap()
      .entries
      .map((e) => e.value / pow((1 + discountRate), e.key))
      .cast<num>()
      .toList();

  /// 50 sum
  num get discountedMoneyFlowSum => discountedMoneyFlow.reduce(sum);

  /// 51
  List<num> get cumulativeDiscountMoneyFlow => discountedMoneyFlow
          .sublist(1)
          .fold(discountedMoneyFlow.sublist(0, 1), (resultList, element) {
        final newValue = resultList.last + element;
        resultList.add(newValue);
        return resultList;
      });

  /// 52
  /// 53
}

num sum(num a, num b) => a + b;

void main() {
  final d = Data();

  print(d.discountedMoneyFlowSum);
}
