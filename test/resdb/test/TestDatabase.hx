package resdb.test;

import haxe.io.Bytes;
import utest.Assert;
import resdb.store.ResourceHelper;


class TestDatabase {
    public function new() {
    }

    public function testGet() {
        var database = ResourceHelper.getDatabase({name: "resource1"});

        switch database.get(Bytes.ofString("key0")) {
            case Some(value):
                Assert.equals("Hello world! 0", value.toString().substr(0, 14));
            case None:
                Assert.fail();
        }
    }

    public function testGetNone() {
        var database = ResourceHelper.getDatabase({name: "resource1"});

        switch database.get(Bytes.ofString("no-exist")) {
            case Some(value):
                Assert.fail();
            case None:
                Assert.pass();
        }
    }

    public function testCount() {
        var database = ResourceHelper.getDatabase({name: "resource1"});
        Assert.equals(100, database.count());
    }
}
