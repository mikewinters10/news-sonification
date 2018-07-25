// Example SuperCollider Code to parse JSON format.
// Written using SuperCollider 3.8.0
// By R. Michael Winters, June 25, 2018
//
// Search Help: Shift + Cmd + D
// Evaluate a line: Shift + Enter
// Evaluate multiple lines: Command + Enter within parenthesis

// Load in a SuperCollider Compatible JSON object
// This file contains two tweets, plus data from microsoft cognitive services

// Set the current directory
~dir = Document.current.dir;

// This is a local file that includes a special "seconds" field, which has the tweets ordered in time.
~tweetJSON = ("/Users/mikewinters/Downloads/y10.json").parseYAMLFile;

// Initalize the MIDI Client (In our case Ableton Live)
MIDIClient.init;
m = MIDIOut(0)

// A task that plays through all of the tweets in temporal order
(
var timeInc = 1;
fork {
~tweetJSON.size.do({ |i|
		var idx = i;
		var tweet = ~tweetJSON[idx];
		var seconds = tweet.at("seconds").asFloat.round(1);
		var waitTime = (~tweetJSON[idx+1].at("seconds").asFloat.round(1) - seconds);
		// Check if there is a true retweet
		if ( tweet.keys.includes("retweeted_status") && (tweet.at("retweeted_status") != "NaN"), {
			var id = tweet.at("retweeted_status").at("id")[15..].asFloat;
			var followersCount = ~tweetJSON[i].at("user").at("followers_count").asFloat;
			var note = id.mod(36);
			var velocity = followersCount.log10 * 14;
			~tweetJSON[i].at("retweeted_status").at("text").postln;
			m.noteOn(0, 60 + note, velocity);
		});
		//0.2.wait;
		(waitTime / 50).wait;
	});
};
// A ticker for timing information
fork{ inf.do( { m.noteOn(1, 60); (timeInc/2).wait;} )}
)