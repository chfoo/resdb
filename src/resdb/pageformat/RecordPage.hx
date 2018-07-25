package resdb.pageformat;

import haxe.io.Eof;
import haxe.io.BytesOutput;
import haxe.io.BytesInput;


class RecordPage extends Page {
    public var records(default, null):Array<Record>;

    public function new() {
        super();

        records = [];
    }

    override public function load(input:BytesInput) {
        super.load(input);

        while (true) {
            var record = new Record();

            try {
                record.load(input);
            } catch (exception:Eof) {
                break;
            }

            records.push(record);
        }
    }

    override public function save(output:BytesOutput) {
        super.save(output);

        for (record in records) {
            record.save(output);
        }
    }

    public function totalLength():Int {
        var sum = 0;

        for (record in records) {
            sum += record.totalLength();
        }

        return sum;
    }
}
