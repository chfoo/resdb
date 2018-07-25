package resdb.test;

import haxe.io.Bytes;
import utest.Assert;


class TestCursor {
    public function new() {
    }

    public function testFirstLast() {
        var database = ResourceHelper.getDatabase({name: "resource1"});
        var cursor = database.cursor();

        Assert.equals("key0", cursor.first().toString());
        Assert.equals("key950", cursor.last().toString());

    }

    public function testTraverse() {
        var database = ResourceHelper.getDatabase({name: "resource1"});
        var cursor = database.cursor();
        var count = 0;

        while (true) {
            cursor.value();
            count += 1;

            switch cursor.next() {
                case Some(key):
                case None:
                    break;
            }
        }
        Assert.equals(100, count);

        while (true) {
            cursor.value();
            count += 1;

            switch cursor.previous() {
                case Some(key):
                case None:
                    break;
            }
        }
        Assert.equals(200, count);
    }

    public function testFind() {
        var database = ResourceHelper.getDatabase({name: "resource1"});
        var cursor = database.cursor();

        switch cursor.find(Bytes.ofString("key101")) {
            case Some(key):
                // key100, key1000, key101, key1050
                Assert.equals("key1000", key.toString());
            case None:
                Assert.fail();
        }
    }
}
