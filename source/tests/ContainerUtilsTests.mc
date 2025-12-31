import Toybox.Lang;

using MonkeyUtils.ArrayUtils;
using MonkeyUtils.ContainerUtils;
using MonkeyUtils.StringUtils;


(:public)
module MonkeyUtils {

    (:public)
    module ContainerUtils {

        (:public)
        module IteratorTests {

            function countItems(iterator as ContainerUtils.Iterator) as Number {
                var count = 0;
                while (iterator.hasNext()) {
                    iterator.next();
                    count++;
                }
                return count;
            }

            (:test)
            function testIteratorPolymorphism(logger) as Boolean {

                var passed = true;
                // Case 1: Pass a Splitter (String source)
                {
                    var input = "A,B,C";
                    var delimiter = ",";
                    var expected = StringUtils.split(input, delimiter).size();
                    var splitter = new StringUtils.EagerSplitter("A,B,C", ",");
                    var actual = countItems(splitter);
                    if (expected != actual) {
                        var message = Lang.format("Splitter iterator failed: expected $1$, got $2$", [expected, actual]);
                        logger.debug(message);
                        passed = false;
                    } else {
                        var message = Lang.format("Splitter iterator passed: expected $1$, got $2$", [expected, actual]);
                        logger.debug(message);
                    }
                }

                // Case 2: Pass an ArrayIterator (Array source)
                {
                    var input = ["X", "Y", "Z"];
                    var iterator = ArrayUtils.getIterator(input);
                    var expected = input.size();
                    var actual = countItems(iterator);
                    if (expected != actual) {
                        var message = Lang.format("Array iterator failed: expected $1$, got $2$", [expected, actual]);
                        logger.debug(message);
                        passed = false;
                    } else {
                        var message = Lang.format("Array iterator passed: expected $1$, got $2$", [expected, actual]);
                        logger.debug(message);
                    }
                }
                
                return passed;
            }

        }


    }

}