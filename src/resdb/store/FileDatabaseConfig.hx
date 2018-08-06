package resdb.store;


@:structInit
class FileDatabaseConfig extends DatabaseConfig {
    public var rootDirectory(default, null):String;

    /**
        @param rootDirectory Path to the directory containing the
        resource/asset files.
    **/
    public function new(name:String, rootDirectory:String,
            ?pageSize:Int = 8192, ?pageCache:Int = 8) {
        super(name, pageSize, pageCache);
        this.rootDirectory = rootDirectory;
    }
}
