local Azurah							= _G['Azurah'] -- grab addon table from global
local L = {}

------------------------------------------------------------------------------------------------------------------
-- German (Thanks to ESOUI.com users Baertram and Scootworks for the translations.)
-- (Non-indented lines still require human translation and may not make sense!)
------------------------------------------------------------------------------------------------------------------

	L.Azurah								= "|c67b1e9A|c4779cezurah|r"
	L.Usage									= "|c67b1e9A|c4779cezurah|r - Gebrauch:\n|cffc600  /azurah unlock|r |cffffff =  Entsperren UI für Bewegung|r\n|cffc600  /azurah save|r |cffffff =  UI sperren und Positionen speichern|r\n|cffc600  /azurah undo|r |cffffff =  mache alle Änderungen rückgängig|r\n|cffc600  /azurah exit|r |cffffff =  sperre UI ohne zu speichern|r"
	L.ThousandsSeparator					= "," -- used to separate large numbers in overlays
	L.TheftBlocked							= "|c67b1e9A|c4779cezurah|r - Diebstahl wurde aufgrund Euren Einstellungen verhindert."

-- move window names
	L.Health								= "Spieler Gesundheit"
	L.HealthSiege							= "Belagerung Gesundheit"
	L.Magicka								= "Spieler Magie"
	L.Werewolf								= "Werwolf-Timer"
	L.Stamina								= "Spieler Ausdauer"
	L.StaminaMount							= "Reittier Ausdauer"
	L.Experience							= "Erfahrungsleiste"
	L.EquipmentStatus						= "Ausrüstungsstatus"
	L.Synergy								= "Synergie"
	L.Compass								= "Kompass"
	L.ReticleOver							= "Ziel Gesundheit"
	L.ActionBar								= "Aktionsleiste"
	L.PetGroup								= "Begleiter"
	L.Group									= "Gruppenmitglieder"
	L.Raid1									= "Raid Gruppe 1"
	L.Raid2									= "Raid Gruppe 2"
	L.Raid3									= "Raid Gruppe 3"
	L.Raid4									= "Raid Gruppe 4"
	L.Raid5									= "Raid Gruppe 5"
	L.Raid6									= "Raid Gruppe 6"
	L.FocusedQuest							= "Verfolgte Quest"
	L.PlayerPrompt							= "Spieler-Interaktion"
	L.AlertText								= "Warnungstext"
	L.CenterAnnounce						= "Bildschirm-Benachrichtigung"
	L.InfamyMeter							= "Kopfgeld-Anzeige"
	L.TelVarMeter							= "Tel Var Anzeige"
	L.ActiveCombatTips						= "Aktive Kampftipps"
	L.Tutorial								= "Tutorial"
	L.CaptureMeter							= "AvA-Erfassungsmeter"
	L.BagWatcher							= "Taschenwächter"
	L.WerewolfTimer							= "Werwolf-Timer"
	L.LootHistory							= "Loot Historie"
	L.RamSiege								= "Rammbock Belagerung"
	L.Subtitles								= "Untertitel"
	L.PaperDoll								= "Charakter Puppe"
	L.QuestTimer							= "Quest Timer"
	L.PlayerBuffs							= "Spieler Buffs/Debuffs"
	L.TargetDebuffs							= "Ziel-Debuffs"
	L.Reticle								= "Fadenkreutz"
	L.Interact								= "Interagieren Text"
	L.BattlegroundScore						= "Schlachtfeld-Ergebnis"
L.DialogueWindow						= "Dialogfenster"
	L.StealthIcon							= "Schleichen-Symbol"
	L.WykkydReticle							= "Fadenkreutz Rahmen skaliert von Wykkyd Full Immersion"
	L.WykkydSubtitles						= "Untertitel-Skala verwaltet von Wykkyd Full Immersion"

-- --------------------------------------------
-- SETTINGS -----------------------------------
-- --------------------------------------------

-- dropdown menus
	L.DropOverlay1							= "Keine Überlagerung"
	L.DropOverlay2							= "Zeige alles"
	L.DropOverlay3							= "Wert & Maximal"
	L.DropOverlay4							= "Wert & Prozent"
	L.DropOverlay5							= "Nur Wert"
	L.DropOverlay6							= "Nur in Prozent"
	L.DropColourBy1							= "Standard"
	L.DropColourBy2							= "Durch Reaktion"
	L.DropColourBy3							= "Nach Stufe"
	L.DropExpBarStyle1						= "Standard"
	L.DropExpBarStyle2						= "Immer gezeigt"
	L.DropExpBarStyle3						= "Immer versteckt"
	L.DropHAlign1							= "Automatisch"
	L.DropHAlign2							= "Linksbündig"
	L.DropHAlign3							= "Rechtsbündig"
	L.DropHAlign4							= "Zentriert"

-- tabs
	L.TabButton1							= "Allgemeines"
	L.TabButton2							= "Attribute"
	L.TabButton3							= "Zielfenster"
	L.TabButton4							= "Aktionsleiste"
	L.TabButton5							= "Erfahrung"
	L.TabButton6							= "Taschenwächter"
	L.TabButton7							= "Werwolf"
	L.TabButton8							= "Profile"
	L.TabHeader1							= "Allgemeine Einstellungen"
	L.TabHeader2							= "Spieler-Attribut Einstellungen"
	L.TabHeader3							= "Zielfenster Einstellungen"
	L.TabHeader4							= "Aktionsleiste Einstellungen"
	L.TabHeader5							= "Erlebnis Bar Einstellungen"
	L.TabHeader6							= "Taschenwächter Einstellungen"
	L.TabHeader7							= "Werwolf-Timer Einstellungen"
	L.TabHeader8							= "Profil Einstellungen"

-- unlock window
	L.UnlockHeader							= "UI entsperrt"
	L.ChangesPending						= "|cffffffÄnderungen ausstehend!|r\n|cffff00Klicken 'Benutzeroberfläche sperren (Speichern)' um speichern.|r\nNicht gespeicherte Änderungen gehen beim neu laden."
	L.UnlockGridEnable						= "\"Am Raster ausrichten\" aktivieren"
	L.UnlockGridDisable						= "\"Am Raster ausrichten\" deaktivieren"
	L.UnlockLockFrames						= "Benutzeroberfläche sperren (Speichern)"
	L.UndoChanges							= "Veränderungen rückgängig machen"
	L.ExitNoSave							= "Beenden ohne Speichern"
	L.UnlockReset							= "Auf Standardeinstellung zurücksetzen"
	L.UnlockResetConfirm					= "Bestätigen Sie das Zurücksetzen"

-- settings: generic
	L.SettingOverlayFormat					= "Überlagerungsformat"
	L.SettingOverlayShield					= "Schildstärke"
	L.SettingOverlayShieldTip				= "Enthält die aktuelle Stärke/Gesundheit des Schildes."
	L.SettingOverlayFancy					= "Tausendertrennzeichen anzeigen"
	L.SettingOverlayFancyTip				= "Legen Sie fest, ob in diesem Overlay große Zahlen aufgeteilt werden sollen. \n\nBeispiel wird 10000 zu 10'..L.ThousandsSeparator..'000."
	L.SettingOverlayFont					= "Überlagerung  Schriftart"
	L.SettingOverlayStyle					= "Textfarbe/-stil überlagern"
	L.SettingOverlaySize					= "Textgrösse überlagern"

-- settings: general tab (1)
	L.GeneralAnchorDesc						= "Entsperren, damit die UI-Fenster mit der Maus verschoben und die Größe mit dem Scrollrad skaliert werden kann. Ein Overlay wird für jedes freigeschaltete UI-Fenster angezeigt und positioniert die Fenster neu, auch wenn sie momentan nicht angezeigt werden (z. B. die Zielgesundheit, wenn Sie kein Ziel haben).\n\nSperren speichert alle Änderungen. Durch Klicken auf 'Veränderungen rückgängig machen' werden alle Änderungen zurückgesetzt, seit die Fenster entsperrt wurden. Wenn Sie mit der rechten Maustaste auf ein einzelnes Fenster klicken, werden ausstehende Änderungen an diesem Fenster zurückgesetzt."
	L.GeneralAnchorUnlock					= "UI freischalten"
	L.GeneralCompassPins					= "Kompass-Pins"
	L.GeneralPinScale						= "Kompass Pingröse"
	L.GeneralPinScaleTip					= "Legen Sie fest, wie groß die Kompass-Pins sein sollen. Diese Größe ist unabhängig von der Größe des Kompasses selbst und kann bei entsperrter Benutzeroberfläche geändert werden.\n\nEine Einstellung von 100 entspricht 100% der Standardgröße (keine Änderung)."
	L.GeneralPinLabel						= "Kompass-Pin-Text ausblenden"
	L.GeneralPinLabelTip					= "Legen Sie fest, ob der Text, der Ihr aktuelles Ziel angibt, ausgeblendet wird (z. B. der Name des Questmarkers, den Sie gerade ansehen).\n\nDie Standardbenutzeroberfläche ist Aus."
	L.General_TheftHeader					= "Diebstahl"
	L.General_TheftPrevent					= "Versehentlichen Diebstahl verhindern"
	L.General_TheftPreventTip				= "Legen Sie fest, ob der Diebstahl/das Plündern von Objekten in der Welt verhindert werden soll, wenn Sie nicht vollständig schleichen. Dies beinhaltet all die Rüstungsteile, Waffen, Nahrung usw., die bei Beutezug ein Kopfgeld geben würden.\n\nBitte beachten Sie, dass dies keinen Schutz gegen das Plündern von Containern bietet."
	L.General_TheftSafer					= "Sicherer Diebstahl von Gegenständen der Welt"
	L.General_TheftSaferTip					= "Legen Sie fest, ob der Diebstahl von Gegenständen in der Welt wieder aktiviert werden soll, wenn sie vollständig schleichen.\n\nBitte beachten Sie, dass dies keinen Schutz gegen das Plündern von Containern bietet."
	L.General_CTheftSafer					= "Sichererer Diebstahl aus Containern"
	L.General_CTheftSaferTip				= "Legen Sie fest, ob das Öffnen von Containern verhindert werden soll, sofern sie nicht vollständig schleichen."
	L.General_PTheftSafer					= "Safer Taschendiebstahl"
	L.General_PTheftSaferTip				= "Legen Sie fest, ob Taschendiebstahl sicherer gemacht werden soll, indem Sie das Plündern verhindern, es sei denn, es ist vollständig versteckt."
	L.General_TheftSaferWarn				= "Dies ist technisch gesehen ein Betrug!"
	L.General_TheftAnnounceBlock			= "Info, wenn Diebstahl verhindert wird"
	L.General_TheftAnnounceBlockTip			= "Legen Sie fest, ob ein Diebstahlversuch durch Ihre Diebstahleinstellungen blockiert werden soll.\n\nDie Warnung wird im aktuellen Chat-Fenster ausgegeben."
	L.General_ModeChange					= "Tastatur/Gamepad-Modus ändern Neu laden"
	L.General_ModeChangeTip					= "Lädt die Benutzeroberfläche neu, wenn zwischen den Modi 'Tastatur' und 'Gamepad' gewechselt wird. Normalerweise werden Positionsänderungen, die in Azurah für diesen Modus vorgenommen werden, kontinuierlich zurückgesetzt, bis Sie die UI manuell neu laden."
	L.GeneralNotification					= "Benachrichtigungstext"
	L.General_Notification					= "Benachrichtigungstext..."
	L.General_NotificationTip				= "Wählen Sie die horizontale Ausrichtung für den Benachrichtigungstext. Standardmäßig stellt die Option 'Automatisch' die Ausrichtung basierend auf der Position des Benachrichtigungstextrahmens entweder nach links, oder nach rechts ein."
	L.General_NotificationWarn				= "Änderungen an dieser Einstellung erfordern das Entsperren UND Verschieben des Benachrichtigungstextrahmens oder das Neuladen der Benutzeroberfläche, um wirksam zu werden."
	L.General_MiscHeader					= "Verschiedenes"
	L.General_ATrackerDisable				= "Aktivitäts-Tracker deaktivieren"
	L.General_ATrackerDisableTip			= "Deaktiviert die Statusanzeige für Aktivitäten wie den Dungeon Finder und die Schlachtfelder."

-- settings: attributes tab (2)
	L.AttributesFadeMin						= "Sichtbarkeit: Wenn voll"
	L.AttributesFadeMinTip					= "Legen Sie fest, wie undurchsichtig die Attributleisten sein sollen, wenn das Attribut voll ist. Bei 100% sind die Balken vollständig sichtbar und bei 0% sind sie unsichtbar.\n\nDie Standard-UI-Einstellung ist 0%."
	L.AttributesFadeMax						= "Sichtbarkeit: Wenn nicht voll"
	L.AttributesFadeMaxTip					= "Legen Sie fest, wie undurchsichtig die Attributleisten sein sollen, wenn das Attribut nicht voll ist (z. B. Ausdauer beim Sprinten). Bei 100% sind die Balken vollständig sichtbar und bei 0% sind sie unsichtbar.\n\nDie Standard-UI-Einstellung ist 100%."
	L.AttributesLockSize					= "Attributgröße sperren"
	L.AttributesLockSizeTip					= "Legen Sie fest, ob die Größe der Attribute gesperrt ist, damit sie sich nicht ändern, wenn Sie mehr Gesundheit oder mehr Energie erhalten.\n\nDie Standardeinstellungen der Benutzeroberfläche sind Aus."
	L.AttributesCombatBars					= "Sichtbarkeit: Im Kampf"
	L.AttributesCombatBarsTip				= "Verwenden Sie im Kampf immer die Sichtbarkeit 'Wenn nicht voll'."
	L.AttributesOverlayHealth				= "Überlagerungstext: Gesundheit"
	L.AttributesOverlayMagicka				= "Überlagerungstext: Magie"
	L.AttributesOverlayStamina				= "Overlay-Text: Ausdauer"
	L.AttributesOverlayFormatTip			= "Legen Sie fest, wie der Überlagerungstext für diese Attributleiste angezeigt wird.\n\nDie Standard Benutzeroberflächeneinstellung ist 'Keine Überlagerung'."

-- settings: target tab (3)
	L.TargetLockSize						= "Zielleiste Größe sperren"
	L.TargetLockSizeTip						= "Legen Sie fest, ob die Größe der Zielleiste gesperrt ist, damit sie sich nicht ändert, wenn Sie auf eine Person mit Bonus-Gesundheit schauen.\n\nDie Standardeinstellung für die Benutzeroberfläche ist 'Aus'."
	L.TargetRPName							= "Verstecke den @Accountname des Ziels"
	L.TargetRPNameTip						= "Zeigen Sie nicht das @Accountname - Tag im Zielrahmen. HINWEIS: Wenn Sie unter der Einstellung 'Display Name des Spiels' die Option 'Bevorzuge UserID' auswählen, wird der normale Charaktername ausgeblendet."
	L.TargetRPTitle							= "Zieltitel ausblenden"
	L.TargetRPTitleTip						= "Verstecke den Titel des Zielspielers."
	L.TargetRPTitleWarn						= "Erfordert ein Nachladen der UI."
	L.TargetRPInteract						= "Ausblenden Interaktion @Accountname"
	L.TargetRPInteractTip					= "Zeige den @Accountname nicht im Interaktionsrahmen des Spielers."
	L.TargetColourByBar						= "Farbbalken für den Zielzustand"
	L.TargetColourByBarTip					= "Legen Sie fest, ob die Statusleiste des Ziels entweder durch Disposition (Reaktion) oder Schwierigkeitsgrad (Ebene) gekennzeichnet ist."
	L.TargetColourByName					= "Name des Farbziels"
	L.TargetColourByNameTip					= "Legen Sie fest, ob das Namensschild des Ziels durch Disposition (Reaktion) oder Schwierigkeitsgrad (Level) gefärbt wird."
	L.TargetColourByLevel					= "Ziel des Farbziels nach Schwierigkeitsgrad"
	L.TargetColourByLevelTip				= "Stellen Sie ein, ob das Level des Ziels durch seinen Schwierigkeitsgrad (Level) gefärbt ist."
	L.TargetIconClassShow					= "Zeigen Sie Klassensymbol für Spieler"
	L.TargetIconClassShowTip				= "Legen Sie fest, ob das Klassensymbol des Zielspielers angezeigt werden soll."
	L.TargetIconClassByName					= "Klassensymbol nach Typenschild anzeigen"
	L.TargetIconClassByNameTip				= "Legen Sie fest, ob das Klassensymbol (falls angezeigt) links vom Namensschild des Ziels angezeigt wird und nicht links vom Statusbalken des Ziels."
	L.TargetIconAllianceShow				= "Zeige Allianz Icon für Spieler"
	L.TargetIconAllianceShowTip				= "Legen Sie fest, ob das Allianzsymbol des Zielspielers angezeigt werden soll."
	L.TargetIconAllianceByName				= "Allianzsymbol durch Typenschild anzeigen"
	L.TargetIconAllianceByNameTip			= "Legen Sie fest, ob das Allianzsymbol (falls angezeigt) rechts neben dem Namensschild des Ziels angezeigt wird und nicht rechts vom Statusbalken des Ziels."
	L.TargetOverlayFormatTip				= "Legen Sie fest, wie der Überlagerungstext für die Zielleiste angezeigt wird.\n\nDie Standardbenutzeroberflächeneinstellung ist Keine Überlagerung."
	L.BossbarHeader							= "Bossanzeige Einstellungen"
	L.BossbarOverlayFormatTip				= "Legen Sie fest, wie der Überlagerungstext für die Boss-Leiste angezeigt werden soll. Die Boss-Leiste zeigt die Summe der Gesundheitswerte für alle aktiven Bosse an.\n\nDie Standardeinstellung für die Benutzeroberfläche lautet 'Kein Overlay'."

-- settings: action bar tab (4)
	L.ActionBarHideBindBG					= "Hintergrund der Tastaturbelegung ausblenden"
	L.ActionBarHideBindBGTip				= "Legen Sie fest, ob der dunkle Hintergrund hinter den Tastaturbelegungen der Aktionsleiste angezeigt werden soll."
	L.ActionBarHideBindText					= "Tastaturkürzel ausblenden"
	L.ActionBarHideBindTextTip				= "Stellen Sie ein, ob der Tastenkombinationen-Text unterhalb der Aktionsleisten sichtbar ist."
	L.ActionBarHideWeaponSwap				= "Waffenwechsel Symbol ausblenden"
	L.ActionBarHideWeaponSwapTip			= "Legen Sie fest, ob das Waffenaustauschsymbol zwischen der Aktionsleiste und dem Quickslot sichtbar ist."
	L.ActionBarOverlayShow					= "Überlagerung anzeigen"
	L.ActionBarOverlayUltValue				= "Überlagerung: Ultimative Kraft (Wert)"
	L.ActionBarOverlayUltValueShowTip		= "Legen Sie fest, ob ein Overlay über der ultimativen Schaltfläche angezeigt werden soll, die Ihr aktuelles Endniveau anzeigt."
	L.ActionBarOverlayUltValueShowCost		= "Zeige Fähigkeitskosten"
	L.ActionBarOverlayUltValueShowCostTip	= "Legen Sie fest, ob das Overlay nur Ihre aktuellen Ultimate Level oder Ultimate Level/Fähigkeits-Kosten anzeigt."
	L.ActionBarOverlayUltPercent			= "Überlagerung: Ultimative Kraft (Prozentsatz)"
	L.ActionBarOverlayUltPercentShowTip		= "Legen Sie fest, ob eine Überlagerung über die ultimative Schaltfläche angezeigt werden soll, die Ihr endgültiges Level als Prozentsatz anzeigt."
	L.ActionBarOverlayUltPercentRelative	= "Zeige relative Prozent"
	L.ActionBarOverlayUltPercentRelativeTip	= "Legen Sie fest, ob der auf dem Overlay angezeigte Prozentsatz relativ zu den Kosten Ihrer ultimativen Ausgerüsteten-Fähigkeit ist, anstatt eines Prozentsatzes zu Ihrem maximalen/endgültigen Wert von 500 Punkten."

-- settings: experience bar tab (5)
	L.ExperienceDisplayStyle				= "Anzeigestil"
	L.ExperienceDisplayStyleTip				= "Legen Sie fest, wie die Erfahrungsleiste angezeigt wird.\n\nHinweis: Auch wenn 'Immer angezeigt' angezeigt wird, wird die Leiste beim Erstellen und bei geöffneter Weltkarte ausgeblendet, um andere Fenster nicht zu überlappen."
	L.ExperienceOverlayFormatTip			= "Legen Sie fest, wie der Überlagerungstext für die Erfahrungsleiste angezeigt wird.\n\nDie Standard Benutzeroberflächeneinstellung ist 'Kein Overlay'."

-- settings: bag watcher tab (6)
	L.Bag_Desc								= "Der Taschenwächter erstellt eine Leiste (ähnlich der Erfahrungsleiste im Aussehen), die zeigt, wie voll ihr Rucksack ist. Es wird kurz angezeigt, wenn sich der Inhalt Ihres Beutels ändert, und kann optional so eingestellt werden, dass diese immer dann angezeigt wird, wenn Ihre Tasche fast voll ist."
	L.Bag_Enable							= "Aktiviere Taschenwächter"
	L.Bag_ReverseAlignment					= "Umgekehrte Balkenausrichtung"
	L.Bag_ReverseAlignmentTip				= "Legen Sie fest, ob die Richtung des Balkens umgekehrt werden soll, indem Sie ihn nach rechts erhöhen. Dadurch wird auch das Symbol auf der gegenüberliegenden Seite der Leiste platziert."
	L.Bag_LowSpaceLock						= "Immer anzeigen, wenn zu wenig Platz ist"
	L.Bag_LowSpaceLockTip					= "Legen Sie fest, ob der Taschenwächter immer angezeigt werden soll, wenn der Rucksack fast voll ist."
	L.Bag_LowSpaceTrigger					= "Schwellenwert \"Wenig Platz\""
	L.Bag_LowSpaceTriggerTip				= "Legen Sie fest, wie viele Inventarplätze frei bleiben sollen, bevor Sie Ihren Rucksack als \"Rucksack mit wenig Platz\" betrachten."

-- settings: werewolf tab (7)
	L.Werewolf_Desc							= "Der Werwolf-Timer ist ein separates (bewegliches) Fenster, das die verbleibende Werwolf-Umwandlungszeit in Sekunden anzeigt, damit Sie leichter verfolgen können, wie viel Zeit Sie noch in der Werewolfgestalt jagen können. Es ist zunächst nur auf der rechten Seite der ultimativen Fähigkeit platziert."
	L.Werewolf_Enable						= "Aktiviere Werwolf-Timer"
	L.Werewolf_Flash						= "Blinken bei Zeitverlängerung"
	L.Werewolf_FlashTip						= "Legen Sie fest, ob das Timer-Symbol kurz aufleuchten soll, wenn die für Ihre Umwandlung verbleibende Zeit ansteigt."
	L.Werewolf_IconOnRight					= "Zeige Icon auf der rechten Seite"
	L.Werewolf_IconOnRightTip				= "Legen Sie fest, ob das Symbol rechts neben dem Timer,anstelle von links daneben, angezeigt werden soll."

-- settings: profiles tab (8)
	L.Profile_Desc							= "Einstellungsprofile können hier verwaltet werden, einschließlich der Option, ein Kontoweites Profil zu aktivieren, das die gleichen Einstellungen für ALLE Charaktere in diesem Konto anwendet.\nAufgrund der dauerhaften Auswirkung dieser Optionen muss die Verwaltung zunächst über das Kontrollkästchen im unteren Bereich des Bedienfelds aktiviert werden."
	L.Profile_UseGlobal						= "Verwenden Kontoweite Profile"
	L.Profile_UseGlobalWarn					= "Durch das Wechseln zwischen lokalen und Kontoweiten Profilen wird die Benutzeroberfläche neu geladen."
	L.Profile_Copy							= "Wählen Sie zu kopierendes Profil aus"
	L.Profile_CopyTip						= "Wählen Sie ein Profil aus, um seine Einstellungen in das aktuell aktive Profil zu kopieren. Das aktive Profil wird entweder für den angemeldeten Charakter oder für das Kontoweite Profil verwendet, sofern dieses aktiviert ist. Die bestehenden Profileinstellungen werden dauerhaft überschrieben.\n\nDies kann nicht rückgängig gemacht werden!"
	L.Profile_CopyButton					= "Profil kopieren"
	L.Profile_CopyButtonWarn				= "Durch das Kopieren eines Profils wird die Benutzeroberfläche neu geladen."
	L.Profile_Delete						= "Wählen Sie zu löschendes Profil"
	L.Profile_DeleteTip						= "Wählen Sie ein Profil aus, um seine Einstellungen aus der Datenbank zu löschen. Wenn diese Charakter später angemeldet wird und Sie das Kontoweite Profil nicht verwenden, werden neue Standardeinstellungen erstellt.\n\nDas Löschen eines Profils ist permanent und kann nicht rückgängig gemacht werden!"
	L.Profile_DeleteButton					= "Profil löschen"
	L.Profile_Guard							= "Aktivieren der Profilverwaltung"

------------------------------------------------------------------------------------------------------------------

if (GetCVar('language.2') == 'de') then -- overwrite GetLanguage for new language
	for k, v in pairs(Azurah:GetLocale()) do
		if (not L[k]) then -- no translation for this string, use default
			L[k] = v
		end
	end
	function Azurah:GetLocale() -- set new language return
		return L
	end
end
