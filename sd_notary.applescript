use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

property NSData : a reference to current application's NSData
property NSJSONSerialization : a reference to current application's NSJSONSerialization

on read_json(file_posix_path)
	local jsonData, readDict
	set jsonData to NSData's dataWithContentsOfFile:file_posix_path
	set readDict to NSJSONSerialization's JSONObjectWithData:jsonData options:0 |error|:(missing value)
end read_json

set the_app to choose file with prompt "Please select an .app to notarize" of type {"com.apple.application"}
set the_settings to {|active identity|:"D Zanstra (6FMXG4C59Y)", |Apple ID|:¬
	"doeke@zanstra.net"} ¬
	
return POSIX path of (path to me)
tell application "SD Notary"
	set the_settings2 to make new document with properties the_settings
	--set resultFile to submit app the_settings at the_app
end tell
