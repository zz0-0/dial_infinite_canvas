enum ResizeDirection {
  left("LEFT"),
  bottom("BOTTOM"),
  right("RIGHT"),
  bottomRight("BOTTOMRIGHT");

  const ResizeDirection(this.label);
  final String label;
}

enum ResizeType {
  card("CARD"),
  group("GROUP");

  const ResizeType(this.label);
  final String label;
}
