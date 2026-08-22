class InventoryFormulaSelection {
  const InventoryFormulaSelection({
    required this.formulaId,
    required this.coefficientValuesBySymbol,
    this.formulaName,
  });

  final String formulaId;
  final Map<String, double?> coefficientValuesBySymbol;
  final String? formulaName;
}

class InventoryFormulaCoefficientValue {
  const InventoryFormulaCoefficientValue({
    required this.symbol,
    required this.label,
    required this.value,
  });

  final String symbol;
  final String label;
  final double? value;
}
