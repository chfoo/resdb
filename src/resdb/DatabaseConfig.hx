package resdb;


/**
    Configuration data for the database.
**/
@:structInit
class DatabaseConfig {
    public var name(default, null):String;
    public var pageSize(default, null):Int;
    public var pageCache(default, null):Int;

    /**
        @param name Unique name for the collection of records.
        @param pageSize Maximum size of each page.
        @param pageCache Maximum number of pages to be cached,
    **/
    public function new(name:String, ?pageSize:Int = 8192, ?pageCache:Int = 8) {
        this.name = name;
        this.pageSize = pageSize;
        this.pageCache = pageCache;
    }
}
