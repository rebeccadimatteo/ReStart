/// Interfaccia per l'adattatore di Lavoro Adatto.
///
/// Definisce un metodo per determinare il lavoro più adatto in base ai dati forniti.
abstract class LavoroAdattoAdapter {
  /// Determina il lavoro più adatto per un utente basandosi sui dati forniti.
  ///
  /// Accetta un [Map<String, dynamic>] contenente i dati necessari per valutare il lavoro adatto.
  /// Potrebbero includere, ad esempio, competenze, esperienze lavorative, preferenze personali, ecc.
  ///
  /// Restituisce una [Future<String>] che rappresenta il lavoro più adatto calcolato in base ai dati forniti.
  Future<String> lavoroAdatto(Map<String, dynamic> data);
}
