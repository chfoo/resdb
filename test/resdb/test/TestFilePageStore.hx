package resdb.test;

import haxe.io.Bytes;
import resdb.store.FileDatabaseConfig;
import resdb.store.FilePageStore;
import utest.Assert;


class TestFilePageStore {
    public function new() {
    }

    public function test() {
        var dbName = "test1";
        var rootDir = "out/tmp/";
        var config:FileDatabaseConfig = { name: dbName, rootDirectory: rootDir };

        var pagePacker = new PagePacker(config);
        pagePacker.addRecord(Bytes.ofString("key"), Bytes.ofString("Hello world!"));
        FilePageStore.saveDataPages(rootDir, "test1", pagePacker.packPages());

        var database = FilePageStore.getDatabase(config);
        var cursor = database.cursor();

        Assert.equals("key", cursor.key().toString());
        Assert.equals("Hello world!", cursor.value().toString());
    }
}
