package resdb.test;

import utest.Assert;

using resdb.adapter.IntAdapter;


class TestIntAdapter {
    public function new() {
    }

    public function testAdapterGet() {
        var database = ResourceHelper.getDatabase({name: "resource2"});

        switch database.intGet(100) {
            case Some(value):
                Assert.equals("Hello world 1", value.toString());
            case None:
                Assert.fail();
        }
    }

    public function testAdapterCursor() {
        var database = ResourceHelper.getDatabase({name: "resource2"});
        var cursor = database.intCursor();

        var previousKey = -1;

        while (true) {
            switch cursor.next() {
                case Some(key):
                    Assert.isTrue(key > previousKey);
                    previousKey = key;
                case None:
                    break;
            }
        }
    }
}
