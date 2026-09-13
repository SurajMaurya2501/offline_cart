// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserTableTable extends UserTable
    with TableInfo<$UserTableTable, UserTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileImageMeta =
      const VerificationMeta('profileImage');
  @override
  late final GeneratedColumn<String> profileImage = GeneratedColumn<String>(
      'profile_image', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, email, name, profileImage];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_table';
  @override
  VerificationContext validateIntegrity(Insertable<UserTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('profile_image')) {
      context.handle(
          _profileImageMeta,
          profileImage.isAcceptableOrUnknown(
              data['profile_image']!, _profileImageMeta));
    } else if (isInserting) {
      context.missing(_profileImageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      profileImage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_image'])!,
    );
  }

  @override
  $UserTableTable createAlias(String alias) {
    return $UserTableTable(attachedDatabase, alias);
  }
}

class UserTableData extends DataClass implements Insertable<UserTableData> {
  final String id;
  final String email;
  final String name;
  final String profileImage;
  const UserTableData(
      {required this.id,
      required this.email,
      required this.name,
      required this.profileImage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['name'] = Variable<String>(name);
    map['profile_image'] = Variable<String>(profileImage);
    return map;
  }

  UserTableCompanion toCompanion(bool nullToAbsent) {
    return UserTableCompanion(
      id: Value(id),
      email: Value(email),
      name: Value(name),
      profileImage: Value(profileImage),
    );
  }

  factory UserTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserTableData(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      name: serializer.fromJson<String>(json['name']),
      profileImage: serializer.fromJson<String>(json['profileImage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'name': serializer.toJson<String>(name),
      'profileImage': serializer.toJson<String>(profileImage),
    };
  }

  UserTableData copyWith(
          {String? id, String? email, String? name, String? profileImage}) =>
      UserTableData(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
        profileImage: profileImage ?? this.profileImage,
      );
  UserTableData copyWithCompanion(UserTableCompanion data) {
    return UserTableData(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      name: data.name.present ? data.name.value : this.name,
      profileImage: data.profileImage.present
          ? data.profileImage.value
          : this.profileImage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserTableData(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('name: $name, ')
          ..write('profileImage: $profileImage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, email, name, profileImage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserTableData &&
          other.id == this.id &&
          other.email == this.email &&
          other.name == this.name &&
          other.profileImage == this.profileImage);
}

class UserTableCompanion extends UpdateCompanion<UserTableData> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> name;
  final Value<String> profileImage;
  final Value<int> rowid;
  const UserTableCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.name = const Value.absent(),
    this.profileImage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserTableCompanion.insert({
    required String id,
    required String email,
    required String name,
    required String profileImage,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        email = Value(email),
        name = Value(name),
        profileImage = Value(profileImage);
  static Insertable<UserTableData> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? name,
    Expression<String>? profileImage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (name != null) 'name': name,
      if (profileImage != null) 'profile_image': profileImage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? email,
      Value<String>? name,
      Value<String>? profileImage,
      Value<int>? rowid}) {
    return UserTableCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (profileImage.present) {
      map['profile_image'] = Variable<String>(profileImage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserTableCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('name: $name, ')
          ..write('profileImage: $profileImage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTableTable extends ProductsTable
    with TableInfo<$ProductsTableTable, ProductsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _discountPercentageMeta =
      const VerificationMeta('discountPercentage');
  @override
  late final GeneratedColumn<double> discountPercentage =
      GeneratedColumn<double>('discount_percentage', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
      'rating', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<int> stock = GeneratedColumn<int>(
      'stock', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _thumbnailMeta =
      const VerificationMeta('thumbnail');
  @override
  late final GeneratedColumn<String> thumbnail = GeneratedColumn<String>(
      'thumbnail', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imagesMeta = const VerificationMeta('images');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> images =
      GeneratedColumn<String>('images', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('[]'))
          .withConverter<List<String>>($ProductsTableTable.$converterimages);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        category,
        price,
        discountPercentage,
        rating,
        stock,
        brand,
        thumbnail,
        images
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products_table';
  @override
  VerificationContext validateIntegrity(Insertable<ProductsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('discount_percentage')) {
      context.handle(
          _discountPercentageMeta,
          discountPercentage.isAcceptableOrUnknown(
              data['discount_percentage']!, _discountPercentageMeta));
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta,
          rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    }
    if (data.containsKey('stock')) {
      context.handle(
          _stockMeta, stock.isAcceptableOrUnknown(data['stock']!, _stockMeta));
    } else if (isInserting) {
      context.missing(_stockMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    }
    if (data.containsKey('thumbnail')) {
      context.handle(_thumbnailMeta,
          thumbnail.isAcceptableOrUnknown(data['thumbnail']!, _thumbnailMeta));
    } else if (isInserting) {
      context.missing(_thumbnailMeta);
    }
    context.handle(_imagesMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      discountPercentage: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}discount_percentage']),
      rating: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rating']),
      stock: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock'])!,
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand']),
      thumbnail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thumbnail'])!,
      images: $ProductsTableTable.$converterimages.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}images'])!),
    );
  }

  @override
  $ProductsTableTable createAlias(String alias) {
    return $ProductsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterimages =
      const StringListConverter();
}

class ProductsTableData extends DataClass
    implements Insertable<ProductsTableData> {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double? discountPercentage;
  final double? rating;
  final int stock;
  final String? brand;
  final String thumbnail;
  final List<String> images;
  const ProductsTableData(
      {required this.id,
      required this.title,
      required this.description,
      required this.category,
      required this.price,
      this.discountPercentage,
      this.rating,
      required this.stock,
      this.brand,
      required this.thumbnail,
      required this.images});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['category'] = Variable<String>(category);
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || discountPercentage != null) {
      map['discount_percentage'] = Variable<double>(discountPercentage);
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<double>(rating);
    }
    map['stock'] = Variable<int>(stock);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    map['thumbnail'] = Variable<String>(thumbnail);
    {
      map['images'] =
          Variable<String>($ProductsTableTable.$converterimages.toSql(images));
    }
    return map;
  }

  ProductsTableCompanion toCompanion(bool nullToAbsent) {
    return ProductsTableCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      category: Value(category),
      price: Value(price),
      discountPercentage: discountPercentage == null && nullToAbsent
          ? const Value.absent()
          : Value(discountPercentage),
      rating:
          rating == null && nullToAbsent ? const Value.absent() : Value(rating),
      stock: Value(stock),
      brand:
          brand == null && nullToAbsent ? const Value.absent() : Value(brand),
      thumbnail: Value(thumbnail),
      images: Value(images),
    );
  }

  factory ProductsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductsTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      price: serializer.fromJson<double>(json['price']),
      discountPercentage:
          serializer.fromJson<double?>(json['discountPercentage']),
      rating: serializer.fromJson<double?>(json['rating']),
      stock: serializer.fromJson<int>(json['stock']),
      brand: serializer.fromJson<String?>(json['brand']),
      thumbnail: serializer.fromJson<String>(json['thumbnail']),
      images: serializer.fromJson<List<String>>(json['images']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(category),
      'price': serializer.toJson<double>(price),
      'discountPercentage': serializer.toJson<double?>(discountPercentage),
      'rating': serializer.toJson<double?>(rating),
      'stock': serializer.toJson<int>(stock),
      'brand': serializer.toJson<String?>(brand),
      'thumbnail': serializer.toJson<String>(thumbnail),
      'images': serializer.toJson<List<String>>(images),
    };
  }

  ProductsTableData copyWith(
          {int? id,
          String? title,
          String? description,
          String? category,
          double? price,
          Value<double?> discountPercentage = const Value.absent(),
          Value<double?> rating = const Value.absent(),
          int? stock,
          Value<String?> brand = const Value.absent(),
          String? thumbnail,
          List<String>? images}) =>
      ProductsTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        category: category ?? this.category,
        price: price ?? this.price,
        discountPercentage: discountPercentage.present
            ? discountPercentage.value
            : this.discountPercentage,
        rating: rating.present ? rating.value : this.rating,
        stock: stock ?? this.stock,
        brand: brand.present ? brand.value : this.brand,
        thumbnail: thumbnail ?? this.thumbnail,
        images: images ?? this.images,
      );
  ProductsTableData copyWithCompanion(ProductsTableCompanion data) {
    return ProductsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      category: data.category.present ? data.category.value : this.category,
      price: data.price.present ? data.price.value : this.price,
      discountPercentage: data.discountPercentage.present
          ? data.discountPercentage.value
          : this.discountPercentage,
      rating: data.rating.present ? data.rating.value : this.rating,
      stock: data.stock.present ? data.stock.value : this.stock,
      brand: data.brand.present ? data.brand.value : this.brand,
      thumbnail: data.thumbnail.present ? data.thumbnail.value : this.thumbnail,
      images: data.images.present ? data.images.value : this.images,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('discountPercentage: $discountPercentage, ')
          ..write('rating: $rating, ')
          ..write('stock: $stock, ')
          ..write('brand: $brand, ')
          ..write('thumbnail: $thumbnail, ')
          ..write('images: $images')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, description, category, price,
      discountPercentage, rating, stock, brand, thumbnail, images);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.price == this.price &&
          other.discountPercentage == this.discountPercentage &&
          other.rating == this.rating &&
          other.stock == this.stock &&
          other.brand == this.brand &&
          other.thumbnail == this.thumbnail &&
          other.images == this.images);
}

class ProductsTableCompanion extends UpdateCompanion<ProductsTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> category;
  final Value<double> price;
  final Value<double?> discountPercentage;
  final Value<double?> rating;
  final Value<int> stock;
  final Value<String?> brand;
  final Value<String> thumbnail;
  final Value<List<String>> images;
  const ProductsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.price = const Value.absent(),
    this.discountPercentage = const Value.absent(),
    this.rating = const Value.absent(),
    this.stock = const Value.absent(),
    this.brand = const Value.absent(),
    this.thumbnail = const Value.absent(),
    this.images = const Value.absent(),
  });
  ProductsTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String description,
    required String category,
    required double price,
    this.discountPercentage = const Value.absent(),
    this.rating = const Value.absent(),
    required int stock,
    this.brand = const Value.absent(),
    required String thumbnail,
    this.images = const Value.absent(),
  })  : title = Value(title),
        description = Value(description),
        category = Value(category),
        price = Value(price),
        stock = Value(stock),
        thumbnail = Value(thumbnail);
  static Insertable<ProductsTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? category,
    Expression<double>? price,
    Expression<double>? discountPercentage,
    Expression<double>? rating,
    Expression<int>? stock,
    Expression<String>? brand,
    Expression<String>? thumbnail,
    Expression<String>? images,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (price != null) 'price': price,
      if (discountPercentage != null) 'discount_percentage': discountPercentage,
      if (rating != null) 'rating': rating,
      if (stock != null) 'stock': stock,
      if (brand != null) 'brand': brand,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (images != null) 'images': images,
    });
  }

  ProductsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? description,
      Value<String>? category,
      Value<double>? price,
      Value<double?>? discountPercentage,
      Value<double?>? rating,
      Value<int>? stock,
      Value<String?>? brand,
      Value<String>? thumbnail,
      Value<List<String>>? images}) {
    return ProductsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      rating: rating ?? this.rating,
      stock: stock ?? this.stock,
      brand: brand ?? this.brand,
      thumbnail: thumbnail ?? this.thumbnail,
      images: images ?? this.images,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (discountPercentage.present) {
      map['discount_percentage'] = Variable<double>(discountPercentage.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (stock.present) {
      map['stock'] = Variable<int>(stock.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (thumbnail.present) {
      map['thumbnail'] = Variable<String>(thumbnail.value);
    }
    if (images.present) {
      map['images'] = Variable<String>(
          $ProductsTableTable.$converterimages.toSql(images.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('discountPercentage: $discountPercentage, ')
          ..write('rating: $rating, ')
          ..write('stock: $stock, ')
          ..write('brand: $brand, ')
          ..write('thumbnail: $thumbnail, ')
          ..write('images: $images')
          ..write(')'))
        .toString();
  }
}

class $CartTableTable extends CartTable
    with TableInfo<$CartTableTable, CartTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CartTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [productId, quantity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cart_table';
  @override
  VerificationContext validateIntegrity(Insertable<CartTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productId};
  @override
  CartTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CartTableData(
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
    );
  }

  @override
  $CartTableTable createAlias(String alias) {
    return $CartTableTable(attachedDatabase, alias);
  }
}

class CartTableData extends DataClass implements Insertable<CartTableData> {
  final int productId;
  final int quantity;
  const CartTableData({required this.productId, required this.quantity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_id'] = Variable<int>(productId);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  CartTableCompanion toCompanion(bool nullToAbsent) {
    return CartTableCompanion(
      productId: Value(productId),
      quantity: Value(quantity),
    );
  }

  factory CartTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CartTableData(
      productId: serializer.fromJson<int>(json['productId']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productId': serializer.toJson<int>(productId),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  CartTableData copyWith({int? productId, int? quantity}) => CartTableData(
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
      );
  CartTableData copyWithCompanion(CartTableCompanion data) {
    return CartTableData(
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CartTableData(')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(productId, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartTableData &&
          other.productId == this.productId &&
          other.quantity == this.quantity);
}

class CartTableCompanion extends UpdateCompanion<CartTableData> {
  final Value<int> productId;
  final Value<int> quantity;
  const CartTableCompanion({
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  CartTableCompanion.insert({
    this.productId = const Value.absent(),
    required int quantity,
  }) : quantity = Value(quantity);
  static Insertable<CartTableData> custom({
    Expression<int>? productId,
    Expression<int>? quantity,
  }) {
    return RawValuesInsertable({
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
    });
  }

  CartTableCompanion copyWith({Value<int>? productId, Value<int>? quantity}) {
    return CartTableCompanion(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartTableCompanion(')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

class $FavouritesTableTable extends FavouritesTable
    with TableInfo<$FavouritesTableTable, FavouritesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavouritesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [productId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favourites_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<FavouritesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productId};
  @override
  FavouritesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavouritesTableData(
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
    );
  }

  @override
  $FavouritesTableTable createAlias(String alias) {
    return $FavouritesTableTable(attachedDatabase, alias);
  }
}

class FavouritesTableData extends DataClass
    implements Insertable<FavouritesTableData> {
  final int productId;
  const FavouritesTableData({required this.productId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_id'] = Variable<int>(productId);
    return map;
  }

  FavouritesTableCompanion toCompanion(bool nullToAbsent) {
    return FavouritesTableCompanion(
      productId: Value(productId),
    );
  }

  factory FavouritesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavouritesTableData(
      productId: serializer.fromJson<int>(json['productId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productId': serializer.toJson<int>(productId),
    };
  }

  FavouritesTableData copyWith({int? productId}) => FavouritesTableData(
        productId: productId ?? this.productId,
      );
  FavouritesTableData copyWithCompanion(FavouritesTableCompanion data) {
    return FavouritesTableData(
      productId: data.productId.present ? data.productId.value : this.productId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavouritesTableData(')
          ..write('productId: $productId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => productId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavouritesTableData && other.productId == this.productId);
}

class FavouritesTableCompanion extends UpdateCompanion<FavouritesTableData> {
  final Value<int> productId;
  const FavouritesTableCompanion({
    this.productId = const Value.absent(),
  });
  FavouritesTableCompanion.insert({
    this.productId = const Value.absent(),
  });
  static Insertable<FavouritesTableData> custom({
    Expression<int>? productId,
  }) {
    return RawValuesInsertable({
      if (productId != null) 'product_id': productId,
    });
  }

  FavouritesTableCompanion copyWith({Value<int>? productId}) {
    return FavouritesTableCompanion(
      productId: productId ?? this.productId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavouritesTableCompanion(')
          ..write('productId: $productId')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [slug, name, url];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CategoriesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('slug')) {
      context.handle(
          _slugMeta, slug.isAcceptableOrUnknown(data['slug']!, _slugMeta));
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {slug};
  @override
  CategoriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesTableData(
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url']),
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoriesTableData extends DataClass
    implements Insertable<CategoriesTableData> {
  final String slug;
  final String name;
  final String? url;
  const CategoriesTableData({required this.slug, required this.name, this.url});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['slug'] = Variable<String>(slug);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      slug: Value(slug),
      name: Value(name),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
    );
  }

  factory CategoriesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesTableData(
      slug: serializer.fromJson<String>(json['slug']),
      name: serializer.fromJson<String>(json['name']),
      url: serializer.fromJson<String?>(json['url']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'slug': serializer.toJson<String>(slug),
      'name': serializer.toJson<String>(name),
      'url': serializer.toJson<String?>(url),
    };
  }

  CategoriesTableData copyWith(
          {String? slug,
          String? name,
          Value<String?> url = const Value.absent()}) =>
      CategoriesTableData(
        slug: slug ?? this.slug,
        name: name ?? this.name,
        url: url.present ? url.value : this.url,
      );
  CategoriesTableData copyWithCompanion(CategoriesTableCompanion data) {
    return CategoriesTableData(
      slug: data.slug.present ? data.slug.value : this.slug,
      name: data.name.present ? data.name.value : this.name,
      url: data.url.present ? data.url.value : this.url,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableData(')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('url: $url')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(slug, name, url);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesTableData &&
          other.slug == this.slug &&
          other.name == this.name &&
          other.url == this.url);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoriesTableData> {
  final Value<String> slug;
  final Value<String> name;
  final Value<String?> url;
  final Value<int> rowid;
  const CategoriesTableCompanion({
    this.slug = const Value.absent(),
    this.name = const Value.absent(),
    this.url = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    required String slug,
    required String name,
    this.url = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : slug = Value(slug),
        name = Value(name);
  static Insertable<CategoriesTableData> custom({
    Expression<String>? slug,
    Expression<String>? name,
    Expression<String>? url,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (slug != null) 'slug': slug,
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesTableCompanion copyWith(
      {Value<String>? slug,
      Value<String>? name,
      Value<String?>? url,
      Value<int>? rowid}) {
    return CategoriesTableCompanion(
      slug: slug ?? this.slug,
      name: name ?? this.name,
      url: url ?? this.url,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingRequestsTableTable extends PendingRequestsTable
    with TableInfo<$PendingRequestsTableTable, PendingRequestsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingRequestsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _headersMeta =
      const VerificationMeta('headers');
  @override
  late final GeneratedColumn<String> headers = GeneratedColumn<String>(
      'headers', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _queryParamsMeta =
      const VerificationMeta('queryParams');
  @override
  late final GeneratedColumn<String> queryParams = GeneratedColumn<String>(
      'query_params', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Network Request'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        url,
        method,
        headers,
        body,
        queryParams,
        description,
        createdAt,
        retryCount,
        status
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_requests_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<PendingRequestsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('headers')) {
      context.handle(_headersMeta,
          headers.isAcceptableOrUnknown(data['headers']!, _headersMeta));
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    }
    if (data.containsKey('query_params')) {
      context.handle(
          _queryParamsMeta,
          queryParams.isAcceptableOrUnknown(
              data['query_params']!, _queryParamsMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingRequestsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingRequestsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      headers: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}headers']),
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body']),
      queryParams: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}query_params']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $PendingRequestsTableTable createAlias(String alias) {
    return $PendingRequestsTableTable(attachedDatabase, alias);
  }
}

class PendingRequestsTableData extends DataClass
    implements Insertable<PendingRequestsTableData> {
  final int id;
  final String url;
  final String method;
  final String? headers;
  final String? body;
  final String? queryParams;
  final String description;
  final DateTime createdAt;
  final int retryCount;
  final String status;
  const PendingRequestsTableData(
      {required this.id,
      required this.url,
      required this.method,
      this.headers,
      this.body,
      this.queryParams,
      required this.description,
      required this.createdAt,
      required this.retryCount,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['url'] = Variable<String>(url);
    map['method'] = Variable<String>(method);
    if (!nullToAbsent || headers != null) {
      map['headers'] = Variable<String>(headers);
    }
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    if (!nullToAbsent || queryParams != null) {
      map['query_params'] = Variable<String>(queryParams);
    }
    map['description'] = Variable<String>(description);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['retry_count'] = Variable<int>(retryCount);
    map['status'] = Variable<String>(status);
    return map;
  }

  PendingRequestsTableCompanion toCompanion(bool nullToAbsent) {
    return PendingRequestsTableCompanion(
      id: Value(id),
      url: Value(url),
      method: Value(method),
      headers: headers == null && nullToAbsent
          ? const Value.absent()
          : Value(headers),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      queryParams: queryParams == null && nullToAbsent
          ? const Value.absent()
          : Value(queryParams),
      description: Value(description),
      createdAt: Value(createdAt),
      retryCount: Value(retryCount),
      status: Value(status),
    );
  }

  factory PendingRequestsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingRequestsTableData(
      id: serializer.fromJson<int>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      method: serializer.fromJson<String>(json['method']),
      headers: serializer.fromJson<String?>(json['headers']),
      body: serializer.fromJson<String?>(json['body']),
      queryParams: serializer.fromJson<String?>(json['queryParams']),
      description: serializer.fromJson<String>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'url': serializer.toJson<String>(url),
      'method': serializer.toJson<String>(method),
      'headers': serializer.toJson<String?>(headers),
      'body': serializer.toJson<String?>(body),
      'queryParams': serializer.toJson<String?>(queryParams),
      'description': serializer.toJson<String>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'status': serializer.toJson<String>(status),
    };
  }

  PendingRequestsTableData copyWith(
          {int? id,
          String? url,
          String? method,
          Value<String?> headers = const Value.absent(),
          Value<String?> body = const Value.absent(),
          Value<String?> queryParams = const Value.absent(),
          String? description,
          DateTime? createdAt,
          int? retryCount,
          String? status}) =>
      PendingRequestsTableData(
        id: id ?? this.id,
        url: url ?? this.url,
        method: method ?? this.method,
        headers: headers.present ? headers.value : this.headers,
        body: body.present ? body.value : this.body,
        queryParams: queryParams.present ? queryParams.value : this.queryParams,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        retryCount: retryCount ?? this.retryCount,
        status: status ?? this.status,
      );
  PendingRequestsTableData copyWithCompanion(
      PendingRequestsTableCompanion data) {
    return PendingRequestsTableData(
      id: data.id.present ? data.id.value : this.id,
      url: data.url.present ? data.url.value : this.url,
      method: data.method.present ? data.method.value : this.method,
      headers: data.headers.present ? data.headers.value : this.headers,
      body: data.body.present ? data.body.value : this.body,
      queryParams:
          data.queryParams.present ? data.queryParams.value : this.queryParams,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingRequestsTableData(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('method: $method, ')
          ..write('headers: $headers, ')
          ..write('body: $body, ')
          ..write('queryParams: $queryParams, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, url, method, headers, body, queryParams,
      description, createdAt, retryCount, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingRequestsTableData &&
          other.id == this.id &&
          other.url == this.url &&
          other.method == this.method &&
          other.headers == this.headers &&
          other.body == this.body &&
          other.queryParams == this.queryParams &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.retryCount == this.retryCount &&
          other.status == this.status);
}

class PendingRequestsTableCompanion
    extends UpdateCompanion<PendingRequestsTableData> {
  final Value<int> id;
  final Value<String> url;
  final Value<String> method;
  final Value<String?> headers;
  final Value<String?> body;
  final Value<String?> queryParams;
  final Value<String> description;
  final Value<DateTime> createdAt;
  final Value<int> retryCount;
  final Value<String> status;
  const PendingRequestsTableCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.method = const Value.absent(),
    this.headers = const Value.absent(),
    this.body = const Value.absent(),
    this.queryParams = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.status = const Value.absent(),
  });
  PendingRequestsTableCompanion.insert({
    this.id = const Value.absent(),
    required String url,
    required String method,
    this.headers = const Value.absent(),
    this.body = const Value.absent(),
    this.queryParams = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.status = const Value.absent(),
  })  : url = Value(url),
        method = Value(method);
  static Insertable<PendingRequestsTableData> custom({
    Expression<int>? id,
    Expression<String>? url,
    Expression<String>? method,
    Expression<String>? headers,
    Expression<String>? body,
    Expression<String>? queryParams,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<int>? retryCount,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (method != null) 'method': method,
      if (headers != null) 'headers': headers,
      if (body != null) 'body': body,
      if (queryParams != null) 'query_params': queryParams,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (status != null) 'status': status,
    });
  }

  PendingRequestsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? url,
      Value<String>? method,
      Value<String?>? headers,
      Value<String?>? body,
      Value<String?>? queryParams,
      Value<String>? description,
      Value<DateTime>? createdAt,
      Value<int>? retryCount,
      Value<String>? status}) {
    return PendingRequestsTableCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      method: method ?? this.method,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      queryParams: queryParams ?? this.queryParams,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (headers.present) {
      map['headers'] = Variable<String>(headers.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (queryParams.present) {
      map['query_params'] = Variable<String>(queryParams.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingRequestsTableCompanion(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('method: $method, ')
          ..write('headers: $headers, ')
          ..write('body: $body, ')
          ..write('queryParams: $queryParams, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserTableTable userTable = $UserTableTable(this);
  late final $ProductsTableTable productsTable = $ProductsTableTable(this);
  late final $CartTableTable cartTable = $CartTableTable(this);
  late final $FavouritesTableTable favouritesTable =
      $FavouritesTableTable(this);
  late final $CategoriesTableTable categoriesTable =
      $CategoriesTableTable(this);
  late final $PendingRequestsTableTable pendingRequestsTable =
      $PendingRequestsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        userTable,
        productsTable,
        cartTable,
        favouritesTable,
        categoriesTable,
        pendingRequestsTable
      ];
}

typedef $$UserTableTableCreateCompanionBuilder = UserTableCompanion Function({
  required String id,
  required String email,
  required String name,
  required String profileImage,
  Value<int> rowid,
});
typedef $$UserTableTableUpdateCompanionBuilder = UserTableCompanion Function({
  Value<String> id,
  Value<String> email,
  Value<String> name,
  Value<String> profileImage,
  Value<int> rowid,
});

class $$UserTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $UserTableTable> {
  $$UserTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get profileImage => $state.composableBuilder(
      column: $state.table.profileImage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$UserTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $UserTableTable> {
  $$UserTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get profileImage => $state.composableBuilder(
      column: $state.table.profileImage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$UserTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserTableTable,
    UserTableData,
    $$UserTableTableFilterComposer,
    $$UserTableTableOrderingComposer,
    $$UserTableTableCreateCompanionBuilder,
    $$UserTableTableUpdateCompanionBuilder,
    (
      UserTableData,
      BaseReferences<_$AppDatabase, $UserTableTable, UserTableData>
    ),
    UserTableData,
    PrefetchHooks Function()> {
  $$UserTableTableTableManager(_$AppDatabase db, $UserTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$UserTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$UserTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> profileImage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserTableCompanion(
            id: id,
            email: email,
            name: name,
            profileImage: profileImage,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String email,
            required String name,
            required String profileImage,
            Value<int> rowid = const Value.absent(),
          }) =>
              UserTableCompanion.insert(
            id: id,
            email: email,
            name: name,
            profileImage: profileImage,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserTableTable,
    UserTableData,
    $$UserTableTableFilterComposer,
    $$UserTableTableOrderingComposer,
    $$UserTableTableCreateCompanionBuilder,
    $$UserTableTableUpdateCompanionBuilder,
    (
      UserTableData,
      BaseReferences<_$AppDatabase, $UserTableTable, UserTableData>
    ),
    UserTableData,
    PrefetchHooks Function()>;
typedef $$ProductsTableTableCreateCompanionBuilder = ProductsTableCompanion
    Function({
  Value<int> id,
  required String title,
  required String description,
  required String category,
  required double price,
  Value<double?> discountPercentage,
  Value<double?> rating,
  required int stock,
  Value<String?> brand,
  required String thumbnail,
  Value<List<String>> images,
});
typedef $$ProductsTableTableUpdateCompanionBuilder = ProductsTableCompanion
    Function({
  Value<int> id,
  Value<String> title,
  Value<String> description,
  Value<String> category,
  Value<double> price,
  Value<double?> discountPercentage,
  Value<double?> rating,
  Value<int> stock,
  Value<String?> brand,
  Value<String> thumbnail,
  Value<List<String>> images,
});

class $$ProductsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get category => $state.composableBuilder(
      column: $state.table.category,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get price => $state.composableBuilder(
      column: $state.table.price,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get discountPercentage => $state.composableBuilder(
      column: $state.table.discountPercentage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get rating => $state.composableBuilder(
      column: $state.table.rating,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get stock => $state.composableBuilder(
      column: $state.table.stock,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get brand => $state.composableBuilder(
      column: $state.table.brand,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get thumbnail => $state.composableBuilder(
      column: $state.table.thumbnail,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get images => $state.composableBuilder(
          column: $state.table.images,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));
}

class $$ProductsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get category => $state.composableBuilder(
      column: $state.table.category,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get price => $state.composableBuilder(
      column: $state.table.price,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get discountPercentage => $state.composableBuilder(
      column: $state.table.discountPercentage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get rating => $state.composableBuilder(
      column: $state.table.rating,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get stock => $state.composableBuilder(
      column: $state.table.stock,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get brand => $state.composableBuilder(
      column: $state.table.brand,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get thumbnail => $state.composableBuilder(
      column: $state.table.thumbnail,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get images => $state.composableBuilder(
      column: $state.table.images,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$ProductsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTableTable,
    ProductsTableData,
    $$ProductsTableTableFilterComposer,
    $$ProductsTableTableOrderingComposer,
    $$ProductsTableTableCreateCompanionBuilder,
    $$ProductsTableTableUpdateCompanionBuilder,
    (
      ProductsTableData,
      BaseReferences<_$AppDatabase, $ProductsTableTable, ProductsTableData>
    ),
    ProductsTableData,
    PrefetchHooks Function()> {
  $$ProductsTableTableTableManager(_$AppDatabase db, $ProductsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ProductsTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ProductsTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double?> discountPercentage = const Value.absent(),
            Value<double?> rating = const Value.absent(),
            Value<int> stock = const Value.absent(),
            Value<String?> brand = const Value.absent(),
            Value<String> thumbnail = const Value.absent(),
            Value<List<String>> images = const Value.absent(),
          }) =>
              ProductsTableCompanion(
            id: id,
            title: title,
            description: description,
            category: category,
            price: price,
            discountPercentage: discountPercentage,
            rating: rating,
            stock: stock,
            brand: brand,
            thumbnail: thumbnail,
            images: images,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String description,
            required String category,
            required double price,
            Value<double?> discountPercentage = const Value.absent(),
            Value<double?> rating = const Value.absent(),
            required int stock,
            Value<String?> brand = const Value.absent(),
            required String thumbnail,
            Value<List<String>> images = const Value.absent(),
          }) =>
              ProductsTableCompanion.insert(
            id: id,
            title: title,
            description: description,
            category: category,
            price: price,
            discountPercentage: discountPercentage,
            rating: rating,
            stock: stock,
            brand: brand,
            thumbnail: thumbnail,
            images: images,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductsTableTable,
    ProductsTableData,
    $$ProductsTableTableFilterComposer,
    $$ProductsTableTableOrderingComposer,
    $$ProductsTableTableCreateCompanionBuilder,
    $$ProductsTableTableUpdateCompanionBuilder,
    (
      ProductsTableData,
      BaseReferences<_$AppDatabase, $ProductsTableTable, ProductsTableData>
    ),
    ProductsTableData,
    PrefetchHooks Function()>;
typedef $$CartTableTableCreateCompanionBuilder = CartTableCompanion Function({
  Value<int> productId,
  required int quantity,
});
typedef $$CartTableTableUpdateCompanionBuilder = CartTableCompanion Function({
  Value<int> productId,
  Value<int> quantity,
});

class $$CartTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CartTableTable> {
  $$CartTableTableFilterComposer(super.$state);
  ColumnFilters<int> get productId => $state.composableBuilder(
      column: $state.table.productId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$CartTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CartTableTable> {
  $$CartTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get productId => $state.composableBuilder(
      column: $state.table.productId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$CartTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CartTableTable,
    CartTableData,
    $$CartTableTableFilterComposer,
    $$CartTableTableOrderingComposer,
    $$CartTableTableCreateCompanionBuilder,
    $$CartTableTableUpdateCompanionBuilder,
    (
      CartTableData,
      BaseReferences<_$AppDatabase, $CartTableTable, CartTableData>
    ),
    CartTableData,
    PrefetchHooks Function()> {
  $$CartTableTableTableManager(_$AppDatabase db, $CartTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CartTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CartTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> productId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
          }) =>
              CartTableCompanion(
            productId: productId,
            quantity: quantity,
          ),
          createCompanionCallback: ({
            Value<int> productId = const Value.absent(),
            required int quantity,
          }) =>
              CartTableCompanion.insert(
            productId: productId,
            quantity: quantity,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CartTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CartTableTable,
    CartTableData,
    $$CartTableTableFilterComposer,
    $$CartTableTableOrderingComposer,
    $$CartTableTableCreateCompanionBuilder,
    $$CartTableTableUpdateCompanionBuilder,
    (
      CartTableData,
      BaseReferences<_$AppDatabase, $CartTableTable, CartTableData>
    ),
    CartTableData,
    PrefetchHooks Function()>;
typedef $$FavouritesTableTableCreateCompanionBuilder = FavouritesTableCompanion
    Function({
  Value<int> productId,
});
typedef $$FavouritesTableTableUpdateCompanionBuilder = FavouritesTableCompanion
    Function({
  Value<int> productId,
});

class $$FavouritesTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $FavouritesTableTable> {
  $$FavouritesTableTableFilterComposer(super.$state);
  ColumnFilters<int> get productId => $state.composableBuilder(
      column: $state.table.productId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$FavouritesTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $FavouritesTableTable> {
  $$FavouritesTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get productId => $state.composableBuilder(
      column: $state.table.productId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$FavouritesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FavouritesTableTable,
    FavouritesTableData,
    $$FavouritesTableTableFilterComposer,
    $$FavouritesTableTableOrderingComposer,
    $$FavouritesTableTableCreateCompanionBuilder,
    $$FavouritesTableTableUpdateCompanionBuilder,
    (
      FavouritesTableData,
      BaseReferences<_$AppDatabase, $FavouritesTableTable, FavouritesTableData>
    ),
    FavouritesTableData,
    PrefetchHooks Function()> {
  $$FavouritesTableTableTableManager(
      _$AppDatabase db, $FavouritesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$FavouritesTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$FavouritesTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> productId = const Value.absent(),
          }) =>
              FavouritesTableCompanion(
            productId: productId,
          ),
          createCompanionCallback: ({
            Value<int> productId = const Value.absent(),
          }) =>
              FavouritesTableCompanion.insert(
            productId: productId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FavouritesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FavouritesTableTable,
    FavouritesTableData,
    $$FavouritesTableTableFilterComposer,
    $$FavouritesTableTableOrderingComposer,
    $$FavouritesTableTableCreateCompanionBuilder,
    $$FavouritesTableTableUpdateCompanionBuilder,
    (
      FavouritesTableData,
      BaseReferences<_$AppDatabase, $FavouritesTableTable, FavouritesTableData>
    ),
    FavouritesTableData,
    PrefetchHooks Function()>;
typedef $$CategoriesTableTableCreateCompanionBuilder = CategoriesTableCompanion
    Function({
  required String slug,
  required String name,
  Value<String?> url,
  Value<int> rowid,
});
typedef $$CategoriesTableTableUpdateCompanionBuilder = CategoriesTableCompanion
    Function({
  Value<String> slug,
  Value<String> name,
  Value<String?> url,
  Value<int> rowid,
});

class $$CategoriesTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer(super.$state);
  ColumnFilters<String> get slug => $state.composableBuilder(
      column: $state.table.slug,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get url => $state.composableBuilder(
      column: $state.table.url,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$CategoriesTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get slug => $state.composableBuilder(
      column: $state.table.slug,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get url => $state.composableBuilder(
      column: $state.table.url,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$CategoriesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTableTable,
    CategoriesTableData,
    $$CategoriesTableTableFilterComposer,
    $$CategoriesTableTableOrderingComposer,
    $$CategoriesTableTableCreateCompanionBuilder,
    $$CategoriesTableTableUpdateCompanionBuilder,
    (
      CategoriesTableData,
      BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoriesTableData>
    ),
    CategoriesTableData,
    PrefetchHooks Function()> {
  $$CategoriesTableTableTableManager(
      _$AppDatabase db, $CategoriesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CategoriesTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CategoriesTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> slug = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> url = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesTableCompanion(
            slug: slug,
            name: name,
            url: url,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String slug,
            required String name,
            Value<String?> url = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesTableCompanion.insert(
            slug: slug,
            name: name,
            url: url,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CategoriesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTableTable,
    CategoriesTableData,
    $$CategoriesTableTableFilterComposer,
    $$CategoriesTableTableOrderingComposer,
    $$CategoriesTableTableCreateCompanionBuilder,
    $$CategoriesTableTableUpdateCompanionBuilder,
    (
      CategoriesTableData,
      BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoriesTableData>
    ),
    CategoriesTableData,
    PrefetchHooks Function()>;
typedef $$PendingRequestsTableTableCreateCompanionBuilder
    = PendingRequestsTableCompanion Function({
  Value<int> id,
  required String url,
  required String method,
  Value<String?> headers,
  Value<String?> body,
  Value<String?> queryParams,
  Value<String> description,
  Value<DateTime> createdAt,
  Value<int> retryCount,
  Value<String> status,
});
typedef $$PendingRequestsTableTableUpdateCompanionBuilder
    = PendingRequestsTableCompanion Function({
  Value<int> id,
  Value<String> url,
  Value<String> method,
  Value<String?> headers,
  Value<String?> body,
  Value<String?> queryParams,
  Value<String> description,
  Value<DateTime> createdAt,
  Value<int> retryCount,
  Value<String> status,
});

class $$PendingRequestsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PendingRequestsTableTable> {
  $$PendingRequestsTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get url => $state.composableBuilder(
      column: $state.table.url,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get method => $state.composableBuilder(
      column: $state.table.method,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get headers => $state.composableBuilder(
      column: $state.table.headers,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get body => $state.composableBuilder(
      column: $state.table.body,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get queryParams => $state.composableBuilder(
      column: $state.table.queryParams,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get retryCount => $state.composableBuilder(
      column: $state.table.retryCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PendingRequestsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PendingRequestsTableTable> {
  $$PendingRequestsTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get url => $state.composableBuilder(
      column: $state.table.url,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get method => $state.composableBuilder(
      column: $state.table.method,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get headers => $state.composableBuilder(
      column: $state.table.headers,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get body => $state.composableBuilder(
      column: $state.table.body,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get queryParams => $state.composableBuilder(
      column: $state.table.queryParams,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get retryCount => $state.composableBuilder(
      column: $state.table.retryCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$PendingRequestsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PendingRequestsTableTable,
    PendingRequestsTableData,
    $$PendingRequestsTableTableFilterComposer,
    $$PendingRequestsTableTableOrderingComposer,
    $$PendingRequestsTableTableCreateCompanionBuilder,
    $$PendingRequestsTableTableUpdateCompanionBuilder,
    (
      PendingRequestsTableData,
      BaseReferences<_$AppDatabase, $PendingRequestsTableTable,
          PendingRequestsTableData>
    ),
    PendingRequestsTableData,
    PrefetchHooks Function()> {
  $$PendingRequestsTableTableTableManager(
      _$AppDatabase db, $PendingRequestsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$PendingRequestsTableTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$PendingRequestsTableTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<String?> headers = const Value.absent(),
            Value<String?> body = const Value.absent(),
            Value<String?> queryParams = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              PendingRequestsTableCompanion(
            id: id,
            url: url,
            method: method,
            headers: headers,
            body: body,
            queryParams: queryParams,
            description: description,
            createdAt: createdAt,
            retryCount: retryCount,
            status: status,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String url,
            required String method,
            Value<String?> headers = const Value.absent(),
            Value<String?> body = const Value.absent(),
            Value<String?> queryParams = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              PendingRequestsTableCompanion.insert(
            id: id,
            url: url,
            method: method,
            headers: headers,
            body: body,
            queryParams: queryParams,
            description: description,
            createdAt: createdAt,
            retryCount: retryCount,
            status: status,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PendingRequestsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $PendingRequestsTableTable,
        PendingRequestsTableData,
        $$PendingRequestsTableTableFilterComposer,
        $$PendingRequestsTableTableOrderingComposer,
        $$PendingRequestsTableTableCreateCompanionBuilder,
        $$PendingRequestsTableTableUpdateCompanionBuilder,
        (
          PendingRequestsTableData,
          BaseReferences<_$AppDatabase, $PendingRequestsTableTable,
              PendingRequestsTableData>
        ),
        PendingRequestsTableData,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db, _db.userTable);
  $$ProductsTableTableTableManager get productsTable =>
      $$ProductsTableTableTableManager(_db, _db.productsTable);
  $$CartTableTableTableManager get cartTable =>
      $$CartTableTableTableManager(_db, _db.cartTable);
  $$FavouritesTableTableTableManager get favouritesTable =>
      $$FavouritesTableTableTableManager(_db, _db.favouritesTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$PendingRequestsTableTableTableManager get pendingRequestsTable =>
      $$PendingRequestsTableTableTableManager(_db, _db.pendingRequestsTable);
}
