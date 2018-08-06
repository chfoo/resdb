package resdb.store;

import haxe.io.Bytes;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;


/**
    Page store using the filesystem.
**/
class FilePageStore implements PageStore {
    var config:FileDatabaseConfig;

    public function new(config:FileDatabaseConfig) {
        this.config = config;
    }

    /**
        Saves the data pages to the filesystem.

        @param rootDirectory Path to the directory containing the
            resource/asset files.
        @param name Filename prefix of the database (that will be located
            in the `rootDirectory`).
    **/
    public static function saveDataPages(rootDirectory:String, name:String,
            dataPages:Array<Bytes>) {

        var pageDir = Path.directory(Path.join([rootDirectory, name]));
        FileSystem.createDirectory(pageDir);

        for (index in 0...dataPages.length) {
            var pageName = Path.join([rootDirectory, '$name-$index']);
            File.saveBytes(pageName, dataPages[index]);
        }
    }

    /**
        Returns a database with the given configuration for
        a filesystem page store.
    **/
    public static function getDatabase(config:FileDatabaseConfig):Database {
        var pageStore = new FilePageStore(config);
        return new Database(config, pageStore);
    }

    public function getPage(page:Int):Bytes {
        var name = config.name;
        var pageName = Path.join([config.rootDirectory, '$name-$page']);

        return File.getBytes(pageName);
    }
}
