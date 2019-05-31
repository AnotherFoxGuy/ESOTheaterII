Version 2.0.1 -- 31/05/2019
  Updated to API release 100027
  Fixed emotes list window doesn't show the list correctly after startup

Version 1.0
  Updated to API release 100021

Version 0.4.8 -- 10/22/2016
	Updated to API release 100017 (Patch 2.6.4)
	/letterlookup and /bdcake were removed
	/bow2 and /colder moved up one position in the list
	there is a duplicate emote of pray at 215
	the enumeration list has RNDtest at 125 but it not usable as slash command
	New emote call /crownstore. Your character kneels in front a treasure chest as it opens.

Version 0.4.7 -- 08/07/2016
	Updated to new API release 100016 (Patch 2.5.5)

Version 0.4.6 -- 05/08/2016
	Updated to new API release 100015 (Patch 2.4.5)

Version 0.4.51 -- 03/20/2016
	French localization had the German list :(

Version 0.4.5 -- 03/08/2016
	Updated to new API release 100014 (Patch 2.3.5)
	Three new emotes
		bow2
		colder
		bdcake	(Animation is provisioning at the moment)

Version 0.4.4 -- 11/13/2015
	Updated to new API release 100013 (Patch 2.2.5)
	Two new emotes (animation broken on some models)
		letter
		letterlook

Version 0.4.3 -- 08/31/2015
	Updated to new API release 100012 (Patch 2.1.4)
	Four new emotes
		pie
		soupbowl
		smallbread
		meal
	All languages have the same number of emotes again

Version 0.4.2 -- 03/31/2015
	Added a key bind to play a random emote

Version 0.4.1 -- 03/09/2015
	French and German clients have one more emote than English version (/prov)

Version 0.4.0 -- 03/01/2015
	Updated to new API release 100011 (Patch 1.6.x)
	Added key bind options for 10 favorites buttons
	Added Category filters on the full emote window

Version 0.3.9 -- 12/04/2014
	Fix for transparency control mouse enter error

Version 0.3.8 -- 11/11/2014
	Updated to new API release 100010 (Patch 1.5.3)

Version 0.3.7 -- 09/17/2014
	Updated to new API release 100009 (Patch 1.4.4)

Version 0.3.6 -- 08/04/2014
	Updated to new API release 100008 (Patch 1.3.3)

	Version 0.3.5 -- 06/24/2014
	Updated to new API release (Patch 1.2.3)

Version 0.3.4 -- 05/27/2014
	Adjustments of add-on to lower the Global profile.
	Updated to new API for Craglorn release (Patch 1.1.2)
	Emotes match between languages again.
	/Torch and /kick are back in the English client!
	New emotes are /spit and /idle (an animation to animate doing nothing*)

Version 0.3.3 -- 04/23/2014
	Refactor of localization only load one language instead all on launch
	Code separation of the full emote list panel
	Full emote list window size reduced
	Full emote list window can be key bind
	Full emote list window takes up the least HUD space when using a key bind.
	Small button bar appears when favorites window is collapsed

Version 0.3.2 -- 04/13/2014
	More command line options for when you don't want the GUI visible:
		/et #### Plays the games emote id
		/et -f## Plays the emote based on the favorite's button number e.g. /et -f9 plays the emote you assigned to button 9.
		/et <emote name> Plays the emote based on the name. This is useful when playing in French, German, and/or you customized the ESOTheatreII emote names
			/et c�ur bris�	While playing in French does the emote heartbroken
			/et H�nde reiben	While playing in German does the emote rubhands
	The transparency level of the main widow is user configurable in ESOTheatreIISettings.lua
	Fixed code error uncover when Skyshard 0.5.2 was also running

Version 0.3.1 -- 04/12/2014
		The favorite windows now can collapse to just the header bar to be even less obtrusive without closing it.
		Key binding option for toggling main window added
		Translation adjustments for German localization.
		French language localization!

Version 0.3.0 -- 04/06/2014
	UI clean-up to make it a little smaller. The close button is not on the bottom right any more. It's the X on the top right now.
	The configuration/playground window only displays the button name you are changing if in verbose mode.
	The duplicate Kiss and Eatbread are removed from configuration window list.
	No longer loading the EmoteTable to SavedVariables. Reading from localizations files.
	Support having Add-on to save either account wide or by character. ********** MANUAL ********** Edit the variable "EmotesAccountWide" in ESOTheatreIISettings.lua from 1 to 0 from character level saves.
	First stab at localization for German players and to resolve that they have two more emotes than English players. Big thanks to Valerius for the translations.
	174 emotes ZeniMax takes one down. A 173 emotes... :( /torch was removed by ZeniMax in English language version.

Version 0.2.2 -- 03/30/2014
	--- HACK! ---
	The Early Release version the emote ids start index shifted by one. This occurs in version eso.live.1.0.0.956792.
	As it stands /torch is not available. It was one but zero. The API for playing emote ignores zero. I placed a math hack for now in the hopes they fix it.

Version 0.2.1 -- 03/26/2014
	Works with the games Release Candidate
	Fixed reload issues that were introduced when I switched to virtual XML control definitions

Version 0.2.0 -- 03/23/2014
	"Emote like it's 1999!"
	You can now configure your favorite emote with-in the add-on. Hand editing not required unless you like it that way. The configuration window has the active emotes listed. You not only click the name to pick but it plays it like a preview before you commit to the button on save.

Version 0.1.8 -- 03/20/2014
	Had to adjust the emotes tables. The emotes ID numbers changed in the PTS patch this time.
	Removed the Drama Queen title line. It was cute at first but it was just in the way.
	Made the window smaller to take up less space.
	As requested a transparency option for the window. It is to the upper left of the ESOTheatreII windows. Click the ON text, the window becomes also translucent and text changes to OFF. Click OFF and it toggles back.

	Version 0.1.6 -- 03/16/2014
	Add-on now saves the screen location of the ESOTheatreII between sessions!
	Add-on auto-hides itself when the main game window is open, inventory, map, and etc..
	Known issue is it does not auto-hide the you re position ESOTheatreII windows the first time but it starts to auto-hide on subsequent menu toggles, sorry.
	New slash command option "/et -repin" just in case the ESOTheatreII window wonders off your screen and can not be dragged back.

Version 0.1.3 -- 03/14/2014
	Initial release to public
