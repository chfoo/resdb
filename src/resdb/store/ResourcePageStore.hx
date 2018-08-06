package resdb.store;

import haxe.io.Bytes;
import haxe.Resource;


/**
    Page store using `haxe.Resource`.
**/
class ResourcePageStore implements PageStore {
    var config:DatabaseConfig;

    public function new(config:DatabaseConfig) {
        this.config = config;
    }

    /**
        Returns a database with the given configuration for
        a resource page store.
    **/
    public static function getDatabase(config:DatabaseConfig):Database {
        var pageStore = new ResourcePageStore(config);
        return new Database(config, pageStore);
    }

    @:access(haxe.Resource.content)
    public function getPage(pageID:Int):Bytes {
        var name = '${config.name}-$pageID';

        #if (js && !nodejs && resdb_js_optimize_page_store)
        var pageData = null;
        for (resource in Resource.content) {
            if (resource.name != name) {
                continue;
            }

            if (resource.str != null) {
                pageData = Bytes.ofString(resource.str);
            } else {
                var decoded = js.Browser.window.atob(resource.data);
                pageData = Bytes.alloc(decoded.length);

                for (index in 0...decoded.length) {
                    pageData.set(index, decoded.charCodeAt(index));
                }
            }

            break;
        }
        #else
        var pageData = Resource.getBytes(name);
        #end

        if (pageData == null) {
            throw 'Resource $name not found.';
        }

        return pageData;
    }
}
