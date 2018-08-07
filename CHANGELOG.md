Change log
==========

0.2.0 (2018-08-07)
------------------

* Changed `ResourceHelper.addResource` to return array of bytes pages.
* Changed `Database` constructor to accept `DatabaseConfig` parameter.
* Changed `ResourceHelper` and `ResourcePageStore` to the `store` package.
* Changed: Moved `ResourceHelper.getDatabase()` to `ResourcePageStore`.
* Added `ResourceHelper.addResourcePages`.
* Added caching with `pageCache` parameter to `DatabaseConfig`.
* Added `resdb-js-optimize-page-store` compiler flag.
* Added `FilePageStore` and `OpenFLAssetPageStore`.


0.1.0 (2018-07-29)
------------------

* First release.
