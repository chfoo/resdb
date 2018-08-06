package resdb.test;

import haxe.ds.Option;
import utest.Assert;
import resdb.ds.Cache;


class TestCache {
    public function new() {
    }

    public function testZeroMaxSize() {
        var cache = new Cache<Int,String>(0);

        Assert.equals(None, cache.get(123));
        cache.put(123, "abc");
        Assert.equals(None, cache.get(123));
    }

    public function testOneMaxSize() {
        var cache = new Cache<Int,String>(1);

        Assert.equals(None, cache.get(123));
        cache.put(123, "abc");

        Assert.same(Some("abc"), cache.get(123));

        cache.put(456, "def");
        Assert.equals(None, cache.get(123));
    }

    public function testRecent() {
        var cache = new Cache<Int,String>(3);

        cache.put(1, "a");
        cache.put(2, "b");
        cache.put(3, "c");

        cache.get(2);
        cache.get(3);
        cache.get(1);

        cache.put(4, "d");

        Assert.same(Some("a"), cache.get(1));
        Assert.same(None, cache.get(2));
        Assert.same(Some("c"), cache.get(3));
        Assert.same(Some("d"), cache.get(4));
    }
}
