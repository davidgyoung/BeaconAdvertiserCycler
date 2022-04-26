# BeaconAdvertiserCycler

Simple iOS test program for transmitting iBeacon and altering the advertisement with time.

## How it works

This program will emit an iBeacon advertisement with UUID: 00e69745-943a-45de-bf29-f80586c46c99, major: 1 and minor: 1 with measuredPower: -59.
Every 60 seconds it will stop the advertisement, change the minor value and then restart the advertisement.  By default the minor will increment
by 1 each time it changes.  This logic may be customized in code.

Because iOS apps can only advertise in the foreground, you must configure your iPhone so that the sceeen will never time out, and run this program
visible on the screen while connected to a charger.  If the screen goes dark, or another app comes to the foreground, advertising will stop.

## Compiling and Running

1. Use a git client to clone this repo onto a MacOS machine
2. Using XCode 13.3+ open the project file
3. In the project pane, adjust the team name and app bundle id in as needed to allow making a debug build with your Apple account
4. Attach an iOS device to your computer and choose it as our target in XCode
5. From the XCode menu choose Product -> Run
6. Once the program is running you can disconnect the USB cable from your computer.


