package resdb;

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

    public function getPage(pageID:Int):Bytes {
        var name = '${config.name}-$pageID';
                }

        var pageData = Resource.getBytes(name);

        if (pageData == null) {
            throw 'Resource $name not found.';
        }

        return pageData;
    }
}
