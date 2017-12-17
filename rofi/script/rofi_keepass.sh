#!/usr/bin/expect

#########################################################
### CONFIGURATION #######################################
#########################################################

# paste | type
set pass_main_action "paste"

set notifications true
set notify_icon_wrong_pass "keepassxc-locked"
set notify_icon_pass_copied "keepassxc-dark"

set user [ exec whoami ]

#########################################################
### History functions ###################################
#########################################################

proc open_recent {} {
	global user

	set apath [ exec xfconf-query -c $user -p /keeprofi-recent ]
	if { [ file exists $apath ] } {
		open_kdb $apath
	} else {
		throw 1 "File not found"
	}
}

proc save_recent { kdb } {
	global user

	set apath [ file normalize $kdb ]
	exec xfconf-query -c $user -p /keeprofi-recent -n -t string -s "$apath"
}

#########################################################
### Additional functions ################################
#########################################################

proc _exit {} {
	send "exit\n"
	sleep 0.1
	exit
}

#########################################################
### PASS functions ######################################
#########################################################

proc get_pass { item } {
	send "show $item -f\n"
	expect -re "kpcli:/.*"

	return [ exec echo "$expect_out(buffer)" | perl -ne "/.*Pass: (.*)$/ and print \"\$1\"" ]
}

proc pass_type { item } {
	exec xdotool type "[ get_pass $item ]"
}

proc pass_copy { item is_target} {
	exec printf "%s" [ get_pass $item ] | xclip -sel c > /dev/null

	global notifications notify_icon_pass_copied
	if {$is_target && $notifications} {exec notify-send --icon=$notify_icon_pass_copied "Password copied" "$item"}
}

proc pass_paste { item } {
	# store current clipboard content
	set clip [ exec xclip -o -sel c ]

	# write pass to clipboard
	pass_copy $item false

	# paste pass
	exec xdotool getactivewindow windowfocus
	exec xdotool key "ctrl+v"

	# restore clipboard content
	exec printf "%s" "$clip" | xclip -sel c > /dev/null
}

#########################################################
### KDB navigation ######################################
#########################################################

proc is_group { selection } {
	return [ regexp {(\.\.|\w*/\n?)} $selection ]
}

proc node_select { node mode } {
	# if is group - open it
	if { [ is_group $node ] } {
		send "cd $node\n"
		expect -re "kpcli:/.*"

		node_show
	# else - copy/paste password
	} else {
		if { $mode == 10} {
			pass_copy $node true
		} else {
			global pass_main_action
			pass_$pass_main_action $node
		}
	}
}

proc node_show {} {
	send "ls\n"
	expect -re "kpcli:/.*"

	# remove all unnecessary lines and symbols from out buffer
	set items [ exec echo "$expect_out(buffer)" | perl -00 -pe "s/(^.*|===.*|.*:\\/.*|\\d+\\. )\n?//g" ]

	# if only 1 group available(first main category) - open it
	if { [ llength $items ] == 1 && [ is_group $items ] } {
		node_select $items 0
	} else {
		# add ".." as first item
		set items [ linsert $items 0 ".." ]

		# get selection and exit status of rofi(10 - Ctrl+Enter)
		try {
			set selection [ exec printf "%s" [ join $items "\n" ] | rofi -dmenu -p "kdb: " -no-custom -kb-accept-custom "" -kb-custom-1 Control+Return ]
			set status 0
		} trap CHILDSTATUS {selection options} {
			set selection [ lindex $selection 0 ]
			set status [lindex [dict get $options -errorcode] 2]
			if { $status != 10 } {
				_exit
			}
		}

		node_select $selection $status
	}
}

#########################################################
### FS navigation #######################################
#########################################################

proc is_dir { selection } {
	return [ is_group $selection ]
}

proc fs_select { node } {
	# if is dir - open it
	if { [ is_dir $node ] } {
		cd $node

		fs_show
	# else - open kdb file
	} else {
		open_kdb $node
	}
}

proc fs_show {} {
	# show only dirs, *.kdbx files and ".."
	set fs [ exec ls -1 --group-directories-first -p ]
	set fs [ lsearch -all -inline -regexp $fs ".*(/|kdbx)$" ]
	set fs [ linsert $fs 0 ".." ]

	try {
		set selection [ exec printf "%s" [ join $fs "\n" ] | rofi -dmenu -p "file: " -no-custom ]
	# exit if ESC pressed in rofi
	} trap CHILDSTATUS {} {
		exit
	}

	fs_select $selection
}

#########################################################
### Main func & entry point #############################
#########################################################

proc open_kdb { kdb } {
	global spawn_id
	spawn kpcli --kdb $kdb --readonly
	expect {
		"Please provide the master password:" {
			try {
				set pass [exec echo ".." | rofi -dmenu -p "pass: " -password]

				# if ".." was choosen - return to FS navigate
				if { $pass == ".." } {
					close
					fs_show
				} else {
					send "$pass\n"
					expect {
						# if wrong password - show notify
						"The database key appears invalid or else the database is corrupt." {

							global notifications notify_icon_wrong_pass
							if {$notifications} {exec notify-send --icon=$notify_icon_wrong_pass "Wrong password" "$kdb"}
						}
						# else - save kdb file as recent and start navigation over pass groups
						"kpcli:/>" {
							save_recent $kdb
							node_show
							_exit
						}
					}
				}
			# exit if ESC pressed in rofi
			} trap CHILDSTATUS {} {
				_exit
			}
		}
	}
}


try {
	# open_recent
	fs_show
} trap {} {} {
	fs_show
}


