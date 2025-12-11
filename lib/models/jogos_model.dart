class Jogos {
  final String id;
  final String nJogo;
  final String nEmpresa;
  final String anoJogo;
  final String nPlataforma;
  final String notaJogo;
  bool isFavorite;

  Jogos({
    required this.id,
    required this.nJogo,
    required this.nEmpresa,
    required this.anoJogo,
    required this.nPlataforma,
    required this.notaJogo,
    this.isFavorite = false,
  });
}
