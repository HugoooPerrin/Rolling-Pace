import Toybox.Math;

// ROLLING QUEUE CLASS
class Queue {

    // Init
    var length;
    var queue;
    var counter;
    var sum;

    // Initialize instance
    function initialize(len) {
        length = len;
        queue = new [len];
    }

    // Add a member to queue
    function update(member) {
        for (var i = self.length-1; i > 0; i--) {
            self.queue[i] = self.queue[i-1];
        }
        self.queue[0] = member;
    }

    // Compute mean (taking null into account)
    function mean() {
        counter = 0;
        sum = 0.0;

        // Compute rolling sum for metric
        for (var i = 0; i < self.length; i++) {

            // Ignore null
            if (self.queue[i] == null) {
                continue;
            }

            sum += self.queue[i];
            counter++;
        }

        // Return average
        return (counter != 0) ? sum / counter : 0.0;
    }

    // Get current
    function current(n) {
        return Math.mean(self.queue.slice(0, n));
    }

    // Get last (not null)
    function last(n) {
        for (var i = self.length-1; i >= n-1; i--) {
            if (self.queue[i] != null) {
                return Math.mean(self.queue.slice(i+1-n, i+1));
            } else {
                continue;
            }
        }
        return null;
    }

    // Get non-null count
    function count_not_null() {
        counter = self.length;
        for (var i = self.length-1; i >= 0; i--) {
            if (self.queue[i] != null) {
                return counter;
            } else {
                counter--;
                continue;
            }
        }
        return 0;
    }
}