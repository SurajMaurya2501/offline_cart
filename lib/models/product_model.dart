import 'package:equatable/equatable.dart';
import 'package:offline_cart/core/extensions/safe_parsing.dart';

class ProductsResponseModel extends Equatable {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  const ProductsResponseModel({
    this.products = const [],
    this.total = 0,
    this.skip = 0,
    this.limit = 0,
  });

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductsResponseModel(
      products: json.parseList('products', (item) => ProductModel.fromJson(item)),
      total: json.parseInt('total'),
      skip: json.parseInt('skip'),
      limit: json.parseInt('limit'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products.map((e) => e.toJson()).toList(),
      'total': total,
      'skip': skip,
      'limit': limit,
    };
  }

  ProductsResponseModel copyWith({
    List<ProductModel>? products,
    int? total,
    int? skip,
    int? limit,
  }) {
    return ProductsResponseModel(
      products: products ?? this.products,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
    );
  }

  @override
  List<Object?> get props => [products, total, skip, limit];
}

class ProductModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String sku;
  final int weight;
  final DimensionsModel dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<ReviewModel> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final MetaModel meta;
  final List<String> images;
  final String thumbnail;

  const ProductModel({
    this.id = 0,
    this.title = '',
    this.description = '',
    this.category = '',
    this.price = 0.0,
    this.discountPercentage = 0.0,
    this.rating = 0.0,
    this.stock = 0,
    this.tags = const [],
    this.brand = '',
    this.sku = '',
    this.weight = 0,
    this.dimensions = const DimensionsModel(),
    this.warrantyInformation = '',
    this.shippingInformation = '',
    this.availabilityStatus = '',
    this.reviews = const [],
    this.returnPolicy = '',
    this.minimumOrderQuantity = 0,
    this.meta = const MetaModel(),
    this.images = const [],
    this.thumbnail = '',
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json.parseInt('id'),
      title: json.parseString('title'),
      description: json.parseString('description'),
      category: json.parseString('category'),
      price: json.parseDouble('price'),
      discountPercentage: json.parseDouble('discountPercentage'),
      rating: json.parseDouble('rating'),
      stock: json.parseInt('stock'),
      tags: json.parseStringList('tags'),
      brand: json.parseString('brand'),
      sku: json.parseString('sku'),
      weight: json.parseInt('weight'),
      dimensions: DimensionsModel.fromJson(json.parseMap('dimensions')),
      warrantyInformation: json.parseString('warrantyInformation'),
      shippingInformation: json.parseString('shippingInformation'),
      availabilityStatus: json.parseString('availabilityStatus'),
      reviews: json.parseList('reviews', (item) => ReviewModel.fromJson(item)),
      returnPolicy: json.parseString('returnPolicy'),
      minimumOrderQuantity: json.parseInt('minimumOrderQuantity'),
      meta: MetaModel.fromJson(json.parseMap('meta')),
      images: json.parseStringList('images'),
      thumbnail: json.parseString('thumbnail'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'tags': tags,
      'brand': brand,
      'sku': sku,
      'weight': weight,
      'dimensions': dimensions.toJson(),
      'warrantyInformation': warrantyInformation,
      'shippingInformation': shippingInformation,
      'availabilityStatus': availabilityStatus,
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'returnPolicy': returnPolicy,
      'minimumOrderQuantity': minimumOrderQuantity,
      'meta': meta.toJson(),
      'images': images,
      'thumbnail': thumbnail,
    };
  }

  ProductModel copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    double? price,
    double? discountPercentage,
    double? rating,
    int? stock,
    List<String>? tags,
    String? brand,
    String? sku,
    int? weight,
    DimensionsModel? dimensions,
    String? warrantyInformation,
    String? shippingInformation,
    String? availabilityStatus,
    List<ReviewModel>? reviews,
    String? returnPolicy,
    int? minimumOrderQuantity,
    MetaModel? meta,
    List<String>? images,
    String? thumbnail,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      rating: rating ?? this.rating,
      stock: stock ?? this.stock,
      tags: tags ?? this.tags,
      brand: brand ?? this.brand,
      sku: sku ?? this.sku,
      weight: weight ?? this.weight,
      dimensions: dimensions ?? this.dimensions,
      warrantyInformation: warrantyInformation ?? this.warrantyInformation,
      shippingInformation: shippingInformation ?? this.shippingInformation,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      reviews: reviews ?? this.reviews,
      returnPolicy: returnPolicy ?? this.returnPolicy,
      minimumOrderQuantity: minimumOrderQuantity ?? this.minimumOrderQuantity,
      meta: meta ?? this.meta,
      images: images ?? this.images,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        price,
        discountPercentage,
        rating,
        stock,
        tags,
        brand,
        sku,
        weight,
        dimensions,
        warrantyInformation,
        shippingInformation,
        availabilityStatus,
        reviews,
        returnPolicy,
        minimumOrderQuantity,
        meta,
        images,
        thumbnail,
      ];
}

class DimensionsModel extends Equatable {
  final double width;
  final double height;
  final double depth;

  const DimensionsModel({
    this.width = 0.0,
    this.height = 0.0,
    this.depth = 0.0,
  });

  factory DimensionsModel.fromJson(Map<String, dynamic> json) {
    return DimensionsModel(
      width: json.parseDouble('width'),
      height: json.parseDouble('height'),
      depth: json.parseDouble('depth'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'depth': depth,
    };
  }

  DimensionsModel copyWith({
    double? width,
    double? height,
    double? depth,
  }) {
    return DimensionsModel(
      width: width ?? this.width,
      height: height ?? this.height,
      depth: depth ?? this.depth,
    );
  }

  @override
  List<Object?> get props => [width, height, depth];
}

class ReviewModel extends Equatable {
  final int rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String reviewerEmail;

  const ReviewModel({
    this.rating = 0,
    this.comment = '',
    this.date = '',
    this.reviewerName = '',
    this.reviewerEmail = '',
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      rating: json.parseInt('rating'),
      comment: json.parseString('comment'),
      date: json.parseString('date'),
      reviewerName: json.parseString('reviewerName'),
      reviewerEmail: json.parseString('reviewerEmail'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'date': date,
      'reviewerName': reviewerName,
      'reviewerEmail': reviewerEmail,
    };
  }

  ReviewModel copyWith({
    int? rating,
    String? comment,
    String? date,
    String? reviewerName,
    String? reviewerEmail,
  }) {
    return ReviewModel(
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      date: date ?? this.date,
      reviewerName: reviewerName ?? this.reviewerName,
      reviewerEmail: reviewerEmail ?? this.reviewerEmail,
    );
  }

  @override
  List<Object?> get props => [
        rating,
        comment,
        date,
        reviewerName,
        reviewerEmail,
      ];
}

class MetaModel extends Equatable {
  final String createdAt;
  final String updatedAt;
  final String barcode;
  final String qrCode;

  const MetaModel({
    this.createdAt = '',
    this.updatedAt = '',
    this.barcode = '',
    this.qrCode = '',
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      createdAt: json.parseString('createdAt'),
      updatedAt: json.parseString('updatedAt'),
      barcode: json.parseString('barcode'),
      qrCode: json.parseString('qrCode'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'barcode': barcode,
      'qrCode': qrCode,
    };
  }

  MetaModel copyWith({
    String? createdAt,
    String? updatedAt,
    String? barcode,
    String? qrCode,
  }) {
    return MetaModel(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      barcode: barcode ?? this.barcode,
      qrCode: qrCode ?? this.qrCode,
    );
  }

  @override
  List<Object?> get props => [
        createdAt,
        updatedAt,
        barcode,
        qrCode,
      ];
}

