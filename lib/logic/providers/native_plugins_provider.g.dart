// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'native_plugins_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(documentScannerService)
final documentScannerServiceProvider = DocumentScannerServiceProvider._();

final class DocumentScannerServiceProvider
    extends
        $FunctionalProvider<
          DocumentScannerService,
          DocumentScannerService,
          DocumentScannerService
        >
    with $Provider<DocumentScannerService> {
  DocumentScannerServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentScannerServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentScannerServiceHash();

  @$internal
  @override
  $ProviderElement<DocumentScannerService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DocumentScannerService create(Ref ref) {
    return documentScannerService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentScannerService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentScannerService>(value),
    );
  }
}

String _$documentScannerServiceHash() =>
    r'ddd0cac7e961ca2215da43036c0af65b22cabf2b';

@ProviderFor(imageProcessorService)
final imageProcessorServiceProvider = ImageProcessorServiceProvider._();

final class ImageProcessorServiceProvider
    extends
        $FunctionalProvider<
          ImageProcessorService,
          ImageProcessorService,
          ImageProcessorService
        >
    with $Provider<ImageProcessorService> {
  ImageProcessorServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageProcessorServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageProcessorServiceHash();

  @$internal
  @override
  $ProviderElement<ImageProcessorService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ImageProcessorService create(Ref ref) {
    return imageProcessorService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageProcessorService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageProcessorService>(value),
    );
  }
}

String _$imageProcessorServiceHash() =>
    r'3bd0ac1db3fbd52b52460fb957c15ac2a83eae1a';
