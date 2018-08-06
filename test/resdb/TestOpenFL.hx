package resdb;

import openfl.display.Sprite;
import resdb.store.OpenFLAssetPageStore;


class TestOpenFL extends Sprite {
    public function new() {
        super();

        var database = OpenFLAssetPageStore.getDatabase({ name: "assets/test1" });
        var cursor = database.cursor();

        if (cursor.value().toString() == "Hello world!") {
            trace("ok");
            Sys.exit(0);
        } else {
            trace("fail");
            Sys.exit(1);
        }
    }
}
