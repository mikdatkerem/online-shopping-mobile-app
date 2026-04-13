import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';
  static const List<_TechPreset> _techPresets = [
    _TechPreset(
      title: 'Nova X Pro Kulaklik',
      category: 'ses sistemleri',
      description:
          'Aktif gurultu engelleme, uzun pil omru ve net cagri performansi sunan premium kablosuz kulaklik.',
      image: 'https://fakestoreapi.com/img/61U7T1koQqL._AC_SX679_.jpg',
    ),
    _TechPreset(
      title: 'OrionBook 14 Laptop',
      category: 'bilgisayar',
      description:
          'Gunluk isler, ders ve mobil uretkenlik icin hafif govdeli, hizli acilan ince dizustu bilgisayar.',
      image: 'https://fakestoreapi.com/img/81Zt42ioCgL._AC_SX679_.jpg',
    ),
    _TechPreset(
      title: 'PixelView 27 Monitor',
      category: 'ekran',
      description:
          'Genis gorus acisi, canli renkler ve masaustu kurulumuna uygun ince cerceveli monitor deneyimi sunar.',
      image: 'https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg',
    ),
    _TechPreset(
      title: 'AeroPods Kablosuz Kulaklik',
      category: 'mobil aksesuar',
      description:
          'Cepte tasinabilen sarj kutusu ve dusuk gecikmeli baglanti ile gun boyu kesintisiz muzik keyfi saglar.',
      image: 'https://fakestoreapi.com/img/61U7T1koQqL._AC_SX679_.jpg',
    ),
    _TechPreset(
      title: 'Vertex S24 Akilli Telefon',
      category: 'telefon',
      description:
          'Yuksek yenileme hizli ekran, coklu kamera sistemi ve hizli sarj destegiyle modern akilli telefon deneyimi.',
      image: 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
    ),
    _TechPreset(
      title: 'ZenPad 11 Tablet',
      category: 'tablet',
      description:
          'Dizi izleme, cizim ve not alma icin optimize edilmis buyuk ekranli ve hafif tablet modeli.',
      image: 'https://fakestoreapi.com/img/81QpkIctqPL._AC_SX679_.jpg',
    ),
    _TechPreset(
      title: 'CoreBeam Mekanik Klavye',
      category: 'oyuncu ekipmani',
      description:
          'RGB aydinlatma, sessiz mekanik anahtarlar ve dayanikli govde ile masaustu kurulumunu guclendirir.',
      image: 'https://fakestoreapi.com/img/71HblAHs5xL._AC_UY879_-2.jpg',
    ),
    _TechPreset(
      title: 'Pulse Mini Bluetooth Hoparlor',
      category: 'ses sistemleri',
      description:
          'Kompakt tasarimi, guclu bas performansi ve su sicrama direnciyle her ortama uyum saglar.',
      image: 'https://fakestoreapi.com/img/61U7T1koQqL._AC_SX679_.jpg',
    ),
    _TechPreset(
      title: 'SkyCam 4K Aksiyon Kamera',
      category: 'kamera',
      description:
          'Sarsinti azaltma, 4K cekim ve genis aci lens ile hareketli anlari net bicimde kaydeder.',
      image: 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
    ),
    _TechPreset(
      title: 'VoltCharge 3-in-1 Sarj Istasyonu',
      category: 'sarj cozumleri',
      description:
          'Telefon, saat ve kulakligi tek noktada hizli ve duzenli bicimde sarj etmek icin tasarlandi.',
      image: 'https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_.jpg',
    ),
    _TechPreset(
      title: 'HyperMouse Pro',
      category: 'bilgisayar aksesuari',
      description:
          'Ergonomik tutus, hassas sensor ve sessiz tiklama ile uzun sureli kullanimda konfor sunar.',
      image: 'https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_.jpg',
    ),
    _TechPreset(
      title: 'VisionHub Akilli Saat',
      category: 'giyilebilir teknoloji',
      description:
          'Saglik takibi, bildirim kontrolu ve spor modlariyla gunluk rutini bilekte toplar.',
      image: 'https://fakestoreapi.com/img/71HblAHs5xL._AC_UY879_-2.jpg',
    ),
    _TechPreset(
      title: 'StreamMic USB Mikrofon',
      category: 'icerik uretimi',
      description:
          'Yayin, podcast ve online toplantilar icin temiz ses yakalayan kolay kurulumlu mikrofon.',
      image: 'https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg',
    ),
    _TechPreset(
      title: 'DriveBox 1TB SSD',
      category: 'depolama',
      description:
          'Hizli veri aktarimi, dayanikli yapi ve tasinabilir boyutlariyla modern depolama ihtiyacina cevap verir.',
      image: 'https://fakestoreapi.com/img/81Zt42ioCgL._AC_SX679_.jpg',
    ),
    _TechPreset(
      title: 'GameSphere El Konsolu',
      category: 'oyun',
      description:
          'Tasinarak oyun oynamayi kolaylastiran parlak ekranli ve uzun pil omurlu kompakt oyun cihazi.',
      image: 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
    ),
    _TechPreset(
      title: 'LinkPro Wi-Fi Router',
      category: 'ag cihazi',
      description:
          'Evin her odasina daha guclu kapsama alani ve stabil baglanti sunan cift bant router.',
      image: 'https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_.jpg',
    ),
    _TechPreset(
      title: 'ColorForge Grafik Tablet',
      category: 'tasarim ekipmani',
      description:
          'Cizim, tasarim ve foto duzenleme sureclerini hizlandiran hassas kalem destekli tablet.',
      image: 'https://fakestoreapi.com/img/81QpkIctqPL._AC_SX679_.jpg',
    ),
    _TechPreset(
      title: 'SoundDock Masaustu Hoparlor',
      category: 'ses sistemleri',
      description:
          'Film, muzik ve oyunlarda dolgun ses karakteri sunan kompakt masaustu hoparlor seti.',
      image: 'https://fakestoreapi.com/img/61U7T1koQqL._AC_SX679_.jpg',
    ),
    _TechPreset(
      title: 'FocusBeam Projeksiyon Cihazi',
      category: 'goruntu sistemleri',
      description:
          'Evde sinema keyfi icin parlak goruntu, kablosuz aktarim ve kolay kurulum saglayan projektor.',
      image: 'https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg',
    ),
    _TechPreset(
      title: 'DockStation Type-C Hub',
      category: 'baglanti cozumleri',
      description:
          'Laptop icin ekstra HDMI, USB ve kart okuyucu girislerini tek govdede toplayan pratik hub.',
      image: 'https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_.jpg',
    ),
  ];

  Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'));

    if (response.statusCode != 200) {
      throw Exception('Urunler alinamadi.');
    }

    final List<dynamic> decoded = jsonDecode(response.body) as List<dynamic>;

    return decoded.asMap().entries.map((entry) {
      final product = ProductModel.fromJson(
        entry.value as Map<String, dynamic>,
      );
      final preset = _techPresets[entry.key % _techPresets.length];

      return product.copyWith(
        title: preset.title,
        category: preset.category,
        description: preset.description,
        image: product.image,
      );
    }).toList();
  }
}

class _TechPreset {
  const _TechPreset({
    required this.title,
    required this.category,
    required this.description,
    required this.image,
  });

  final String title;
  final String category;
  final String description;
  final String image;
}
