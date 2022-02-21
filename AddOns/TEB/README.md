# The Elder Bar Reloaded

The Elder Bar Reloaded is an addon for Elder Scrolls Online. This addon adds an information bar on the screen, chocked full of information gadgets that update in real-time. The gadgets can be placed on the bar in any order and there are lots of options to configure each one. Last but not least, the bar can also indicate when in combat.

## Features

* The Elder Bar can be unlocked, dragged, and dropped wherever you'd like it. You can assign a hotkey to lock/unlock the bar.
* Individual gadgets can be unlocked, dragged, and dropped in any order. You can assign a hotkey to lock/unlock the gadgets.
* There is a separate mode for PvE and PvP -- the bar switches automatically. You can have different gadgets on the PvP bar than you do on the PvE bar.
* Almost every gadget has options for coloration, warning thresholds, and different options for displaying the data just how you like it.
* All timers can be automatically hidden when not in use.
* Every gadget has a tooltip that can display additional information.
* The Elder Bar can hide itself automatically when you choose. Choices include talking to NPCs, visiting the bank, crafting, and more.
* The bar can be scaled from 50% to 150% of its normal size.
* An optional setting turns the bar red when you are in combat.
* Track mount training times across multiple characters. You can choose whether to track a character or not. Automatically stops tracking characters with mounts at maximum.
* Track gold and other currencies across multiple characters. You can choose whether to track a character or not.
* Icons come in two variations: 
	* monochrome
	* full color
* Gadgets can pulse to draw the player's attention to them. They have five different modes: 
	* fade in
	* fade out
	* fade in/out
	* slow blink
	* fast blink.

## Gadgets

 1. Alliance Points
 2. Bag Space
 3. Bank Space
 4. Blacksmithing Research Timer
 5. Bounty/Heat Timer
 6. Clock
 7. Clothing Research Timer
 8. Companion
 9.	Crown Gems
10. Crowns
11. Durability
12. Endeavor Seals
13. Enlightenment
14. Event Tickets
15. Experience
16. Fast Travel Timer
17. Food Buff Timer
18. Frames Per Second
19. Gold
20. Jewelry Crafting Research Timer
21. Junk
22. Kill Counter
23. Latency
24. Level / Champion Points
25. Location (Zone Name / Coordinates)
26. Lock/Unlock Bar & Gadgets
27. Memory
28. Mount Timer
29. Mundus Stone
30. Sky Shards
31. Soul Gems
32. Tel Var Stones
33. Thief's Tools
34. Transmute Crystals
35. Undaunted Keys
36. Unread Mail
37. Vampirism
38. Weapon Charge
39. Woodworking Research Timer
40. Writ Vouchers

## Change Log
Changes in version 11.4.4 (2021-11-01)
	- updated for API 101032 (Deadlands)
	- minor fixes

Changes in version 11.4.3 (2021-08-18)
	- updated for API 101031 (Waking Flame)
	- minor fixes

Changes in version 11.4.2 (2021-07-23)
	- fixed missing check in CheckThreshold

Changes in version 11.4.1 (2021-07-21)
	- added text to Lock/Unlock gadget
	- modified Endeavor Progress gadget (added selection of remaining time display format)
	- fixed colour for research timers

Changes in version 11.4.0 (2021-07-16)
	- added a gadget for endeavor progress (number of completed endeavors and remaining time)
	- added an option for all non-global currencies to have different display formats for the gadget 
	  and for the global currencies tooltip
	- added an option to hide companion rapport if maxed out
	- fixed AP gadget (I hope…)
	- changed format of SavedVariables so that Trackers are a separate subtree
	  to make it easier to copy settings between accounts
	- another internal change - gadget icons are now of CT_TEXTURE rather than CT_BUTTON type;
	  it means they can be painted any colour, so "Icons inherit color" option finally works
	  as intended (except for the Lock/Unlock gadget - can't be helped)
	- other fixes

Changes in version 11.3.4 (2021-07-01)
	- modified tooltips for all non-global currency gadgets to show the amount of currency
	  on each character and in bank (gadgets for global currencies, i.e. crowns, crown gems,
	  undaunted keys and transmute crystals work as before, except the non-global currencies are presented
	  in tooltips in the format selected for their respective gadgets)
	- research sloths should be more diligent now
	- fixed misaligned tooltip for Bounty and Heat gadget
	- fixed Transmute Crystals gadget being always white
	- possibly fixed some other bugs

Changes in version 11.3.3 (2021-06-26)
	- circumvented the ZoS bug with companion reporting 0 XP while swimming

Changes in version 11.3.2 (2021-06-25)
	- added options to show appriopriate gadgets only when research/horse training is possible
	- fixed a bug causing companion gadget's disappearance
	- added more options to companion gadget (taken from CompanionInfo addon)
	- fixed lock gadget icon not changing on unlocking
	- fixed enlightenment gadget 

Changes in version 11.3.1 (2021-06-14)
	- added option for icons inheriting (or not) status color (warning etc.) from their labels
	- added Companion gadget
	- fixed kill counter
	
Changes in version 11.3.0 (2021-06-12)
	- added gadget for locking/unlocking bar & gadgets
	- made another attempt at fixing "Avoiding anchor cycle from [X] to [Y]" warning
	- corrected checking thresholds (changed strong inequality to weak )
	- changed SavedVars structure again (now it is v10)
	- a lot of internal changes to make it less of a CPU hog

Changes in version 11.2.2 (2021-06-03)
	- fixed disappearing pulsing items
	- added gadgets for crowns and crown gems (also added these to the currencies tooltip)
	
Changes in version 11.2.1 (2021-06-02)
	- fixed event tickets & food buff gadgets not showing up
	- fixed another problem with upgrading from earlier version (thanks to shadowcep)
	
Changes in version 11.2.0 (2021-06-01)
	- fixed research timers showing only shortest timer regardless of the settings
	- fixed problem (one of…) with upgrading from the original TEB version
	- fixed champion points mismatch
	- changed SavedVars structure again (now it is v9)
	
Changes in version 11.1.4 (2021-05-31)
	- fixed problem with slotted poison (I think…)
	- fixed problem with research timers not showing
	- fixed problem with Thief's Tools (when set to "total stolen")
	
Changes in version 11.1.3 (2021-05-30)
	- removed another overlooked debugging message
	
Changes in version 11.1.2 (2021-05-30)
	- fixed coloring of Thieves Tools and Soulgems
	- fixed mail gadget pulsing
	- Undaunted keys and Endeavor Seals now have proper icons (but no monochrome version!)
	- added "Junk" gadget
	- Tamriel time and date now rely on LibClockTST (optional dependency,
	  but without it Tamriel time is not available)
	- changed colors in the Settings menu a bit
	- removed unnecessary debugging
	
Changes in version 11.1.1 (2021-05-28)
	- fixed coloring of some items (like non-gold currencies) on the bar
	- fixed uneven transparency of the bar's background
	- fixed levels of Enlightement
	- added option for bar autohide speed
	- added widget for endeavor seals (currently works on PTS only)
	- added sorting of characters in Mundus tooltip
	- restored multiple items/times in research widgets
	- scaling the bar is now in steps of 5
	
Changes in version 11.1.0 (2021-05-25)
	- Undaunted keys gadget 
	- Transmute Crystals gadget has warning/danger levels
	- Mundus stone buff is tracked like mounts and gold, unset Mundus colored as Danger
	- option to auto-hide bar while digging for antiquities
	- full customization of 14 colors via color pickers
	- restored on popular demand: bar can be moved so high/low that part of its edge is off screen
	- changed internal data structures for storing gadget order in PvE/PvP
	- changed the format of SavedVariables again (please backup your SavedVariables if you think
	  you may want to go back to previous version)

Changes in version 11.0.3 (2021-05-20)
	- fixed some of the bugs related to settings initialization
	- moved background settings to "General Settings" section
	- added some new settings ("Spacing between gadgets","Draw a border around the bar")
	- some preparations for full color customization
	
Changes in version 11.0.2 (2021-05-18)
	- added color picker for the default color of text and icons
	
Changes in version 11.0.1 (2021-05-17)
	- fixed converting settings from the old version to the new one, using LibSavedVars
	
Changes in version 11.0.0 (2021-05-16)
	- first version of The Elder Bar Reloaded;
	version numbering continues from the original The Elder Bar by Eldrni