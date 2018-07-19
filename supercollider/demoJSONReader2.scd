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

// Read an example JSON file (emojis have been previously removed)
~tweetJSON = ("/Users/mikewinters/Dropbox_rwinters7/Dropbox (GaTech)/Consulting Projects/2018-Windstorm/Data/lyincomey/dataNoEmojis.json").parseYAMLFile;

// How many tweets are there?
~tweetJSON.size;

// What is the first tweet's dictionary?
~tweetJSON[0];

// What does the tweet say?
~tweetJSON[0].at("text");

MIDIClient.init
m = MIDIOut(0)


// A task to play through all the tweets
(
fork {
~tweetJSON.size.do({ |i|
		~tweetJSON[i].at("user").at("name").postln;
		if ( ~tweetJSON[i].at("retweeted_status") != nil, {
			var id = ~tweetJSON[i].at("retweeted_status").at("id")[13..].asFloat;
			var followersCount = ~tweetJSON[i].at("user").at("followers_count").asFloat;
			var note = id.mod(36);
			var velocity = followersCount.log10 * 16;
			//~tweetJSON[i].at("retweeted_status").at("text").postln;
			m.noteOn(0, 60 + note, velocity);
		});
	0.2.wait;
	});
};
)
// A task to play through all the tweets
(
fork {
	~tweetJSON.size.do({ |i|
		var followersCount = ~tweetJSON[i].at("user").at("followers_count").asFloat.postln;
		var note = 72 - (12 * (followersCount.log10/2));
		var velocity = 128/8 * followersCount;
		m.noteOn(1, note, velocity);
	});
};
)

// A task to play through all the tweets
(
fork {
~tweetJSON.size.do({ |i|
		//~tweetJSON[i].at("user").at("name").postln;
		//~tweetJSON[i].at("user").at("followers_count").postln;
		if ( ~tweetJSON[i].at("retweeted_status") != nil, {
			var id = ~tweetJSON[i].at("retweeted_status").at("id")[13..].asFloat;
			var note = id.mod(36);
			note.postln;
			m.noteOn(0,60 + note);
		});
	0.05.wait;
	});
};
)