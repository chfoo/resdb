package resdb.store;

import haxe.io.Bytes;
#if !doc_gen
import openfl.utils.Assets;
#end


/**
    Page store using OpenFL assets system.
**/
class OpenFLAssetPageStore implements PageStore {
    var config:DatabaseConfig;

    public function new(config:DatabaseConfig) {
        this.config = config;
    }

    /**
        Returns a database with the given configuration for
        a OpenFL asset page store.
    **/
    public static function getDatabase(config:DatabaseConfig):Database {
        var pageStore = new OpenFLAssetPageStore(config);
        return new Database(config, pageStore);
    }

    public function getPage(page:Int):Bytes {
        #if !doc_gen
        var pageName = '${config.name}-$page';

        return Assets.getBytes(pageName);
        #else
        throw "in doc gen";
        #end
    }
}
