// Read the data
~data = CSVFileReader.read("/Users/mikewinters/news-sonification/data/all_tweets.csv", true, true);

// Make a dictionary for retrieving the index of the match
(
y = Dictionary.new();
d = ["youtube", "rt", "21stcenturywire", "clarityofsignal", "zerohedge", "sputniknews", "cbsnews", "mintpressnews", "theguardian", "globalresearch", "facebook", "trib", "theduran", "alternet", "davidicke"];
d.do({ |i, j| y.put(i,(j + 1));})
)

// Initialize MIDI
m = MIDIClient.init;
m = MIDIOut(0);

// Places to start in the "White Helmet" dataset:
//  5606      06/05/2017  "Omran"
//  26419    06/17/2017  "Grefnell"
//  95000    08/11/2017  "Murder"
//  139049  09/04/2017  "Peace"
//  154310  09/15/2017  "Russian Airstrikes"
//  214676  11/18/2017  "Ghouta Airstrikes"
//  227986  11/27/2017  "Swiss Press"

(
fork{
	inf.do({ | idx |
		var startIdx = 154310;
		var i = idx + startIdx + 1;
		var speedFactor = 1000;
		var domain = if ( ~data[i][7] != "None", {~data[i][7].splitext[0]}, {""});
		var retweetID = if( ~data[i][2] != "None", {~data[i][2][12..14]},{nil});
		var date1 = ~getDateFromString.(~data[i][5]);
		var date2 = ~getDateFromString.(~data[i+1][5]);
		var waitTime = ~getSecsBetweenDates.(date2, date1) / speedFactor;
		if (i.mod(100) == 0, {("\n" ++ date1.format("%b %m %Y %H:%M") ++ "\n").postln;});
		if (retweetID != nil, {
			var midiPort = if (y.at(domain) != nil, {y.at(domain)}, {0});
			if (midiPort != 0, {
				var pitch = retweetID.asInt.mod(36) + 60;
				[domain, retweetID].postln;
				m.noteOn(midiPort, pitch);
			});
		});
		waitTime.wait;
	});
}
)


(
~retrieveIdxOfNearestDate = {arg dateAsSortableString;
	var curDate = ~getDateFromString.(~data[1][5]).asSortableString;
	var idx = 1;
	while ( { dateAsSortableString.asFloat > curDate.asFloat }, {
		curDate = ~getDateFromString.(~data[idx][5]).asSortableString;
		idx = idx + 1;
	});
	idx
}.("20170605000000")
)

(
~getDateFromString = { arg string;
	var slashes = string.findAll("/");
	var space = string.find(" ");
	var colons = string.findAll(":");
	var month = string[0..(slashes[0]-1)].asFloat;
	var day = string[(slashes[0]+1)..(slashes[1]-1)].asFloat;
	var year = ("20" ++ string[(slashes[1]+1)..(slashes[1]+2)]).asFloat;
	var hour = string[(space+1)..(colons[0]-1)].asFloat;
	var minute = string[(colons[0]+1)..(colons[1]-1)].asFloat;
	var second = string[(colons[1]+1)..].asFloat;
	var date = Date.new(year, month, day, hour, minute, second, 0);
	date
};

~getSecsBetweenDates = { arg date2, date1;
	var secsToSecs = (date2.second - date1.second );
	var minsToSecs = (date2.minute - date1.minute ) * 60;
	var hoursToSecs = (date2.hour - date1.hour) * 3600;
	var daysToSecs = (date2.day - date1.day) * 86400;
	var totSecs = secsToSecs + minsToSecs + hoursToSecs + daysToSecs;
	totSecs
}
)



/*	var minsToSecs = (stamp2.asString[10..11] - stamp1.asString[10..11]) * 60;
	var hoursToSecs  = (stamp2.asString[8..9] - stamp1.asString[8..9]) * 3600;
	var daysToSecs = (stamp2.asString[6..7] - stamp1.asString[6..7]) * 86400;
	var totSecs = secsToSecs + minsToSecs + hoursToSecs + daysToSecs;
	totSecs*/