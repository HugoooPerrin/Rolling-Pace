import Toybox.Activity;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Application;


// MAIN DATA FIELD CLASS
class RollingSView extends WatchUi.SimpleDataField {

    // General settings
    const ignore_first = 10;
    var lag = 0;

    // Application settings
    var rolling_duration;
    var lap_reset;

    // Set the label of the data field here.
    function initialize() {
        SimpleDataField.initialize();

        // Collect user settings
        rolling_duration = Application.getApp().getProperty("WINDOW").toNumber()+1;
        lap_reset = Application.getApp().getProperty("LAP_RESET");

        // Set label name based on chosen datafield
        label = "PACE";
    }

    // Reset metric queue & lag when starting or restarting activity
    // (to prevent from decreasing value while effort is increasing since resuming activity)
    function reset_queues() {
        speed = new Queue(rolling_duration);
        lag = 0;
    }

    function onTimerStart() {
        reset_queues();
    }

    function onTimerResume() {
        reset_queues();
    }

    // Reset metric queue when starting a new workout step
    // to be directly accurate related to targeted effort
    function onWorkoutStepComplete() {
        reset_queues();
    }

    function onTimerLap() {
        if (lap_reset) {
            reset_queues();
        }
    }

    // Computing variable
    var speed;
    var rolling_spd;
    var val;
    var pace;

    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Numeric or Duration or String or Null {

        // Update rolling queues & compute value
        if (lag >= ignore_first) {

            // Add new value to rolling queue (oldest member is automatically removed)
            speed.update((info.currentSpeed != null) ? info.currentSpeed : 0);

            // Compute rolling mean 
            rolling_spd = speed.mean();

            // Display value
            pace = to_pace(rolling_spd);
            val = Lang.format("$1$:$2$", [pace[0].format("%d"), pace[1].format("%02d")]);

        } else if (info.timerState == 3) {
            // Increase lag counter
            lag++;
            val = "--";

        } else {
            val = "--";
        }
        
        return val;
    }
}