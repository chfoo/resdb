package resdb;

import haxe.io.Bytes;

using resdb.adapter.IntAdapter;


class TestEmbedResource {
    #if macro
    public static function embed() {
        embed1();
        embed2();
    }

    static function embed1() {
        var packer = new PagePacker({name: "resource1"});
        var buf = new StringBuf();

        for (index in 0...1000) {
            buf.addChar("a".code);
        }

        var filler = buf.toString();

        for (index in 0...100) {

            packer.addRecord(
                Bytes.ofString('key${index * 50}'),
                Bytes.ofString('Hello world! $index $filler')
            );
        }

        var pagesBytes = ResourceHelper.addResource(packer);
        trace('Added ${pagesBytes.length} pages');
    }

    static function embed2() {
        var packer = new PagePacker({name: "resource2"});

        for (index in 0...100) {
            packer.intAddRecord(
                index * 100,
                Bytes.ofString('Hello world $index')
            );
        }

        var pagesBytes = ResourceHelper.addResource(packer);
        trace('Added ${pagesBytes.length} pages');
    }
    #end
}
