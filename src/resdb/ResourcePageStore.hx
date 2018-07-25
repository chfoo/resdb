package resdb;

import haxe.ds.Option;
import haxe.io.Bytes;
import haxe.Resource;


private typedef CacheItem = { pageID:Int, pageData:Bytes };


/**
    Page store using `haxe.Resource`.
**/
class ResourcePageStore implements PageStore {
    var config:DatabaseConfig;
    var pageCache:Option<CacheItem> = None;

    public function new(config:DatabaseConfig) {
        this.config = config;
    }

    public function getPage(pageID:Int):Bytes {
        switch pageCache {
            case Some(cacheItem):
                if (cacheItem.pageID == pageID) {
                    return cacheItem.pageData;
                }
            case None:
                // pass
        }

        var pageData = Resource.getBytes('${config.name}-$pageID');
        pageCache = Some({ pageID: pageID, pageData: pageData });

        if (pageData == null) {
            throw 'Resource ${config.name}-$pageID not found.';
        }

        return pageData;
    }
}
