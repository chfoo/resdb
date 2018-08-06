package resdb.ds;

import commonbox.adt.NodeSequence;
import commonbox.ds.AutoMap;
import commonbox.ds.List;
import haxe.ds.Option;
import haxe.ds.Vector;

/**
    Cache data structure using LRU replacement policy.
**/
class Cache<K,V> {
    var items:AutoMap<K,V>;
    var recentList:List<K>;
    var recentListNodeMap:AutoMap<K,NodeSequenceRef<K>>;
    var maxSize:Int;

    public function new(maxSize:Int) {
        if (maxSize < 0) {
            throw "maxSize must be non-negative";
        }

        items = new AutoMap();
        recentList = new List();
        recentListNodeMap = new AutoMap();
        this.maxSize = maxSize;
    }

    /**
        Puts an item in the cache.
    **/
    public function put(key:K, value:V) {
        if (maxSize == 0) {
            return;
        }

        if (items.length >= maxSize) {
            evict();
        }

        items.set(key, value);
        recentList.unshift(key);
        recentListNodeMap.set(key, recentList.getNodeAt(0));
    }

    /**
        Returns an item from the cache or None.
    **/
    public function get(key:K):Option<V> {
        moveToFront(key);

        return items.get(key);
    }

    function evict() {
        var lastKey = recentList.last();
        switch recentListNodeMap.get(lastKey) {
            case Some(node):
                node.remove();
            case None:
                // pass
        }
        recentListNodeMap.remove(lastKey);
        items.remove(lastKey);
    }

    function moveToFront(key:K) {
        switch recentListNodeMap.get(key) {
            case Some(node):
                node.remove();
                recentList.unshift(key);
                recentListNodeMap.set(key, recentList.getNodeAt(0));
            case None:
                // pass
        }
    }
}
