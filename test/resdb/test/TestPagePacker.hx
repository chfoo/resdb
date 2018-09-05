package resdb.test;

import utest.Assert;


class TestPagePacker {
    public function new() {
    }

    public function testEmpty() {
        var pagePacker = new PagePacker({ name: "test" });
        Assert.raises(pagePacker.packPages, String);
    }
}
