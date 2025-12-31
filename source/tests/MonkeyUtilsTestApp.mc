import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;


module MonkeyUtils {

    // This class is required to satisfy the "entry point" requirement
    // of the manifest when running unit tests.
    (:test)
    class MonkeyUtilsTestApp extends Application.AppBase {

        function initialize() {
            AppBase.initialize();
        }

        function getInitialView() as [Views] or [Views, InputDelegates] {
            // We just need to return a dummy view to satisfy the signature
            return [ new WatchUi.View() ];
        }
        
    }

}