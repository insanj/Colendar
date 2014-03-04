#!/bin/bash

chown root:wheel /System/Library/LaunchDaemons/com.insanj.ColendarWriter.plist
launchctl load -w /System/Library/LaunchDaemons/com.insanj.ColendarWriter.plist
/usr/libexec/ColendarWriter
