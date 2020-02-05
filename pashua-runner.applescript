use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

property log_path : "~/Library/Logs/com.catsdeep/"
property log_file : "Pashua.log"

global pashua_binary
global escaped_log_fullpath

on open pashua_file_list
	set pashua_posix_path to _get_pashua_path()
	repeat with pashua_file in pashua_file_list
		-- Run with "nohup" and "&" to dis-attach Pashua Runner, so it can quit
		set pashua_posix_file to POSIX path of pashua_file
		set pashua_cmd to "echo \"$(date): Pashua Runner started; Pashua's output on next line:\"  >> " & escaped_log_fullpath & ¬
			"; " & quoted form of pashua_posix_path & space & quoted form of pashua_posix_file & " >> " & escaped_log_fullpath
		try
			do shell script pashua_cmd
		on error err_msg number err_nr
			display dialog "Pashua exitted with the error number " & err_nr & " and the following text:" default answer err_msg with title "Pashua-dialog error"
		end try
	end repeat
end open

on run
	global pashua_binary
	set pashua_binary to ""
	-- Just initialize, when opening. We're not going to use this value
	set pashua_path to _get_pashua_path()
	-- Display info & settings alert
	set msg to "This app will enable you to open `*.pashua` files with Pashua.app by double-clicking on a file with this extension. " & return & return & ¬
		"The resulting text of Pashua.app will be written to the log-file `" & log_file & "` in the folder `" & log_path & "`. You can inspect these log files with Console.app." & return & return
	display alert "Pashua Runner information" message msg as informational buttons {"Close and open Console.app", "Just close"} default button 2
	if button returned of result is "Close and open Console.app" then
		do shell script "open " & escaped_log_fullpath
	end if
end run

on _get_pashua_path()
	global pashua_binary, escaped_log_fullpath
	-- Make sure the log-folder exists
	try
		-- Make an escaped form of the quoted form. This way, we have expansion (~/ can be used as well as variables)
		set escaped_log_fullpath to do shell script "printf \"%q\" " & quoted form of (log_path & log_file)
		do shell script "mkdir -p $(dirname " & escaped_log_fullpath & "); echo \"$(date): Initializing Pashua Runner.\" >> " & escaped_log_fullpath
	on error err_msg number err_nr
		display alert "Can't create log path" message err_msg & " (number " & err_nr & ")" as critical buttons {"Close"} default button 1
	end try
	-- Try to find the Pashua binary
	try
		tell application "Finder"
			-- Find (persisted path of) Pashua binary
			if POSIX file pashua_binary exists then
				return pashua_binary
			end if
			error "Can't find Pashua binary" number -2753
		end tell
	on error number -2753 --The variable <pashua_binary> is not defined/Can't find Pashua binary
		-- look for a reference to the Pashua binary
		repeat with pashua_location in [path to applications folder from user domain, path to applications folder from local domain]
			set app_location to (pashua_location as text) & "Pashua.app:"
			tell application "Finder"
				if alias app_location exists then
					set pashua_binary to (my POSIX path of alias app_location) & "Contents/MacOS/Pashua"
					return pashua_binary
				end if
			end tell
		end repeat
		-- No app installed
		set msg to "To use this app, you need to have Pashua.app installed in your Applications folder."
		try
			display alert "Can't find Pashua.app" message msg as critical buttons {"Go to Pashua website", "Download Pashua", "Just close "} cancel button 3
			if button returned of result is "Go to Pashua website" then
				set link to "https://www.bluem.net/en/mac/pashua/"
			else
				set link to "https://www.bluem.net/files/Pashua.dmg"
			end if
			do shell script "open " & quoted form of link
		on error number -128
			-- do nothing, just end with a Pashua not installed error
		end try
		error "Pashua.app is not installed"
	end try
end _get_pashua_path
