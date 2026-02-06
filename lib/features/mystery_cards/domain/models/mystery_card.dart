import '../enums/card_result.dart';

class MysteryCard {
  final int id;
  final CardResult result;
  final bool isRevealed;
  final bool isSelected;

  const MysteryCard({
    required this.id,
    required this.result,
    this.isRevealed = false,
    this.isSelected = false,
  });

  MysteryCard copyWith({
    int? id,
    CardResult? result,
    bool? isRevealed,
    bool? isSelected,
  }) {
    return MysteryCard(
      id: id ?? this.id,
      result: result ?? this.result,
      isRevealed: isRevealed ?? this.isRevealed,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MysteryCard &&
        other.id == id &&
        other.result == result &&
        other.isRevealed == isRevealed &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        result.hashCode ^
        isRevealed.hashCode ^
        isSelected.hashCode;
  }
}