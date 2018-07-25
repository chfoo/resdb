package resdb;


/**
    Configuration data for the database.
**/
@:structInit
class DatabaseConfig {
    public var name(default, null):String;
    public var pageSize(default, null):Int;

    /**
        @param name Unique name for the collection of records.
        @param pageSize Maximum size of each page.
    **/
    public function new(name:String, ?pageSize:Int = 8192) {
        this.name = name;
        this.pageSize = pageSize;
    }
}
