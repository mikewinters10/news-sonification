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
~tweetJSON = (~dir +/+ "demo.json").parseYAMLFile;

// How many tweets are there?
~tweetJSON.size;

// What is the first tweet's dictionary?
~tweetJSON[0];

// What does the tweet say?
~tweetJSON[0].at("text")

// Are there any celebrities?
~tweetJSON[0].at("MSR").at("CompVis").at("Analyze").at("categories")[0].at("detail").at("celebrities").size > 0

// What are their names?
(
var celebrities = ~tweetJSON[0].at("MSR").at("CompVis").at("Analyze").at("categories")[0].at("detail").at("celebrities");
celebrities.size.do ( { |idx|
	celebrities[idx].at("name").postln;
});
)

