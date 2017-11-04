# ESO Theatre II

Original ESO Theatre created by Halja: http://www.esoui.com/downloads/info59-ESOTheatre.html#info
This is a new version of the addon because the original hasn't been updated since 10/22/16.

### New features

* Emotes are now loaded from the API
* Fixed ```attempt to index a nil value``` bug
* Repositioned and updated the favourite edit buttons

### Known bugs
* Favourites button is too small to display some emotes names
* Emotes list window doesn't show the list correctly after startup (Scrolling or selecting a different category fixes it)
* Some categories are empty

Original Readme from ESO Theatre
--------------------

This is a simple add-on for playing your favourite character emotes. The game at the release had over 170 emote animation commands to choose from. There was no built-in GUI to display them for game launch. They are access via slash commands .i.e. /torch, /drink, and etc. This add-on allows you to configure a few favourites. It displays them in a window which you can click a button for the emote. If you use a gamepad, ESO did create a quick wheel for emotes starting with the Orsinium DCL late 2015.  

I hope you find the add-on useful. Feedback and suggestions are welcome.  

Key Features:
 * Configure 10 emotes buttons on moveable window
 * Thirteen bind key options
  * One for toggling the favourites window
  * One for toggling a condensed list of all the available emotes to blast through to entertain yourself and friends
  * Up to ten for quick keyboard access to favourites
  * One quick keyboard access to play random emote
 * Both windows can be moved separately and the last position is saved
 * Transparency option to fade the add-on to less intrusive while displayed
 * Favorites window collapses out of the way and speed buttons appear to access your first five favourites emotes
 * Lots of command options for access emotes without the add-on windows visible
 * Filtering options on the full emote list window
 * Option to save favourites at the account level or by character


Slash Commands and optional parameters:  
    /esotheater    Displays emote window  
    /et    Alias to display emote window  
    /et -help    Prints the slash commands to the main chat window  
    /et -reload    Reloads Add-on defaults  
    /et -v    Verbose mode which sends extra messages to the chat window  
    /et -repin    Reset main window position to top left corner  
    /et ####    Plays the games emote id  
    /et <emote name>    Plays the emote based on the name.  
    /et -f##    Plays the emote based on the favorite's button number i.e. /et -f9 plays the emote you assigned to button 9.  
