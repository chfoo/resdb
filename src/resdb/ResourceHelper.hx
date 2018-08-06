package resdb;

import haxe.io.Bytes;


/**
    Helper class that uses `haxe.Resource` as its resource mechanism.

    Note the names do not have to be a filename but they still need to
    be unique. The names are used as a prefix with the page number added
    as a suffix. For example, the name `example` will generate resources
    such as `example-0` or `example-123`.
**/
class ResourceHelper {
    #if (macro || doc_gen)
    /**
        Adds the records to the resource from a page packer.

        This is intended to be called inside an initialization macro.

        @param pagePacker A page packer containing the records.
    **/
    public static function addResource(pagePacker:PagePacker):Array<Bytes> {
        #if macro
        var dataPages = pagePacker.packPages();
        var name = pagePacker.config.name;

        addResourcePages(name, dataPages);
        return dataPages;
        #else
            throw "Not available outside macro";
        #end
    }

    /**
        Adds the pages to the resource.

        This is intended to be called inside an initialization macro.

        @param name Name prefix.
        @param dataBytes Raw pages produced by a page packer.
    **/
    public static function addResourcePages(name:String, dataPages:Array<Bytes>) {
        #if macro
        for (index in 0...dataPages.length) {
            var pageBytes = dataPages[index];
            haxe.macro.Context.addResource('$name-$index', pageBytes);
        }
        #else
            throw "Not available outside macro";
        #end
    }
    #end

    /**
        Returns the database using the given resource name.
    **/
    public static function getDatabase(config:DatabaseConfig):Database {
        var pageStore = new ResourcePageStore(config);
        return new Database(config, pageStore);
    }
}
