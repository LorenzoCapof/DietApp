// lib/core/repositories/product_repository.dart

import '../models/product.dart';

/// Repository astratto per la gestione dei prodotti
/// Questa interfaccia definisce i contratti che l'implementazione reale (API) dovrà rispettare
/// 
/// TODO BACKEND:
/// - Implementare ProductApiRepository che estende questa classe
/// - Connettere a endpoint REST/GraphQL
/// - Gestire caching e offline-first strategy
/// - Implementare paginazione per liste lunghe
abstract class ProductRepository {
  /// Cerca prodotti per nome o barcode
  /// 
  /// [query] - Testo di ricerca (nome, brand, etc.)
  /// [limit] - Numero massimo di risultati (default: 20)
  /// 
  /// TODO BACKEND: Implementare ricerca full-text con ranking
  Future<List<Product>> searchProducts(String query, {int limit = 20});

  /// Ottiene un prodotto tramite barcode
  /// 
  /// [barcode] - Codice a barre del prodotto
  /// 
  /// TODO BACKEND: Integrare con database prodotti (es. OpenFoodFacts)
  Future<Product?> getProductByBarcode(String barcode);

  /// Ottiene un prodotto tramite ID
  /// 
  /// [productId] - ID univoco del prodotto
  Future<Product?> getProductById(String productId);

  /// Ottiene prodotti per categoria
  /// 
  /// [category] - Categoria filtro
  /// [limit] - Numero massimo di risultati
  /// 
  /// TODO BACKEND: Implementare filtri multipli (categoria, brand, etc.)
  Future<List<Product>> getProductsByCategory(
    ProductCategory category, {
    int limit = 20,
  });

  /// Ottiene i prodotti recentemente aggiunti dall'utente
  /// 
  /// TODO BACKEND: Tracciare storia degli ultimi prodotti usati per suggerimenti
  Future<List<Product>> getRecentProducts({int limit = 10});

  /// Ottiene i prodotti preferiti dell'utente
  /// 
  /// TODO BACKEND: Sincronizzare preferiti con account utente
  Future<List<Product>> getFavoriteProducts();

  /// Analizza una foto per riconoscere il prodotto
  /// 
  /// [imagePath] - Path dell'immagine da analizzare
  /// 
  /// TODO BACKEND: 
  /// - Integrare con servizio di image recognition (Google Vision, AWS Rekognition)
  /// - OCR per leggere etichette nutrizionali
  /// - Matching con database prodotti
  Future<List<Product>> searchProductsByImage(String imagePath);

  /// Aggiunge un prodotto ai preferiti
  /// 
  /// TODO BACKEND: Persistere su server + sync
  Future<void> addToFavorites(String productId);

  /// Rimuove un prodotto dai preferiti
  /// 
  /// TODO BACKEND: Persistere su server + sync
  Future<void> removeFromFavorites(String productId);
}
