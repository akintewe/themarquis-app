// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ludo_session.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ludoSessionHash() => r'9a01b1c18ab23704321178b39877792d2f283a65';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$LudoSession extends BuildlessNotifier<LudoSessionData?> {
  late final String id;

  LudoSessionData? build(
    String id,
  );
}

/// See also [LudoSession].
@ProviderFor(LudoSession)
const ludoSessionProvider = LudoSessionFamily();

/// See also [LudoSession].
class LudoSessionFamily extends Family<LudoSessionData?> {
  /// See also [LudoSession].
  const LudoSessionFamily();

  /// See also [LudoSession].
  LudoSessionProvider call(
    String id,
  ) {
    return LudoSessionProvider(
      id,
    );
  }

  @override
  LudoSessionProvider getProviderOverride(
    covariant LudoSessionProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'ludoSessionProvider';
}

/// See also [LudoSession].
class LudoSessionProvider
    extends NotifierProviderImpl<LudoSession, LudoSessionData?> {
  /// See also [LudoSession].
  LudoSessionProvider(
    String id,
  ) : this._internal(
          () => LudoSession()..id = id,
          from: ludoSessionProvider,
          name: r'ludoSessionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ludoSessionHash,
          dependencies: LudoSessionFamily._dependencies,
          allTransitiveDependencies:
              LudoSessionFamily._allTransitiveDependencies,
          id: id,
        );

  LudoSessionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  LudoSessionData? runNotifierBuild(
    covariant LudoSession notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @override
  Override overrideWith(LudoSession Function() create) {
    return ProviderOverride(
      origin: this,
      override: LudoSessionProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  NotifierProviderElement<LudoSession, LudoSessionData?> createElement() {
    return _LudoSessionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LudoSessionProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LudoSessionRef on NotifierProviderRef<LudoSessionData?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _LudoSessionProviderElement
    extends NotifierProviderElement<LudoSession, LudoSessionData?>
    with LudoSessionRef {
  _LudoSessionProviderElement(super.provider);

  @override
  String get id => (origin as LudoSessionProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
