local Azurah							= _G['Azurah'] -- grab addon table from global
local L = {}

------------------------------------------------------------------------------------------------------------------
-- Italian - Partial interpretive machine translation by Phinix.
-- Still needs review by a native speaker!
------------------------------------------------------------------------------------------------------------------

L.Azurah								= "|c67b1e9A|c4779cezurah|r"
L.Usage									= "|c67b1e9A|c4779cezurah|r - Uso:\n|cffc600  /azurah unlock|r |cffffff =  sblocca UI per movimento|r\n|cffc600  /azurah save|r |cffffff =  bloccare UI e salvare le posizioni|r\n|cffc600  /azurah undo|r |cffffff =  disfare tutte modifiche in sospeso|r\n|cffc600  /azurah exit|r |cffffff =  bloccare UI senza salvare|r"
L.ThousandsSeparator					= "," -- used to separate large numbers in overlays
L.TheftBlocked							= "|c67b1e9A|c4779cezurah|r - Furto è stato impedito a causa delle tue impostazioni."

-- move window names
L.Health								= "Salute del Giocatore"
L.HealthSiege							= "Salute d'assedio"
L.Magicka								= "Giocatore Magicko"
L.Werewolf								= "Timer Mannaro"
L.Stamina								= "Resistenza al Giocatore"
L.StaminaMount							= "Montare la Resistenza"
L.Experience							= "Barra di Esperienza"
L.EquipmentStatus						= "Stato dell'apparecchiatura"
L.Synergy								= "Synergy"
L.Compass								= "Bussola"
L.ReticleOver							= "Obiettivo del Reticolo"
L.ActionBar								= "Barra dell'azione"
L.PetGroup								= "Gruppo di vita di animali domestici"
L.Group									= "Membri del Gruppo"
L.Raid1									= "Incursione Gruppo 1"
L.Raid2									= "Incursione Gruppo 2"
L.Raid3									= "Incursione Gruppo 3"
L.Raid4									= "Incursione Gruppo 4"
L.Raid5									= "Incursione Gruppo 5"
L.Raid6									= "Incursione Gruppo 6"
L.FocusedQuest							= "Tracciatore di Missioni"
L.PlayerPrompt							= "Prompt di Interazione del Giocatore"
L.AlertText								= "Notifiche di Avviso"
L.CenterAnnounce						= "Notifiche su Schermo"
L.InfamyMeter							= "Metro di Taglie"
L.TelVarMeter							= "Metro Tel Var"
L.ActiveCombatTips						= "Suggerimenti Combattimento"
L.Tutorial								= "Esercitazioni"
L.CaptureMeter							= "Misuratore di Cattura AvA"
L.BagWatcher							= "Osservatore di Borse"
L.WerewolfTimer							= "Timer Mannaro"
L.LootHistory							= "Storia del Bottino"
L.RamSiege								= "Assedio di Ram"
L.Subtitles								= "Sottotitoli"
L.PaperDoll								= "Bambola di Carta"
L.QuestTimer							= "Timer di Ricerca"
L.PlayerBuffs							= "Buff/Debuff del Giocatore"
L.TargetDebuffs							= "Bersaglio Debuffs"
L.Reticle								= "Reticolo"
L.Interact								= "Testo di Interazione"
L.BattlegroundScore						= "Punto Battaglia"
L.DialogueWindow						= "Finestra di dialogo"
L.StealthIcon							= "Icona di Furtività"
L.WykkydReticle							= "Scala dei fotogrammi reticolata gestita da Wykkyd Full Immersion"
L.WykkydSubtitles						= "Scala dei sottotitoli gestita da Wykkyd Full Immersion"

-- --------------------------------------------
-- SETTINGS -----------------------------------
-- --------------------------------------------

-- dropdown menus
L.DropOverlay1							= "Nessuna Sovrapposizione"
L.DropOverlay2							= "Mostra Tutto"
L.DropOverlay3							= "Valore e Max"
L.DropOverlay4							= "Valore e Percentuale"
L.DropOverlay5							= "Solo Valore"
L.DropOverlay6							= "Solo per Cento"
L.DropColourBy1							= "Predefinito"
L.DropColourBy2							= "Per Reazione"
L.DropColourBy3							= "Per Livello"
L.DropExpBarStyle1						= "Predefinito"
L.DropExpBarStyle2						= "Sempre Mostrato"
L.DropExpBarStyle3						= "Sempre Nascosto"
L.DropHAlign1							= "Automatico"
L.DropHAlign2							= "Sinistra Allineata"
L.DropHAlign3							= "Giusto Allineato"
L.DropHAlign4							= "Centrato"

-- tabs
L.TabButton1							= "Generale"
L.TabButton2							= "Attributi"
L.TabButton3							= "Bersaglio"
L.TabButton4							= "Barra dell'azione"
L.TabButton5							= "Esperienza"
L.TabButton6							= "Osservatore di borse"
L.TabButton7							= "Mannaro"
L.TabButton8							= "Profili"
L.TabHeader1							= "Impostazioni Generali"
L.TabHeader2							= "Opzioni Statistiche Giocatore"
L.TabHeader3							= "Opzioni Unità Bersaglio"
L.TabHeader4							= "Action Bar Settings"
L.TabHeader5							= "Experience Bar Settings"
L.TabHeader6							= "Opzioni Orologio da Borsa"
L.TabHeader7							= "Opzioni del Metro Mannaro"
L.TabHeader8							= "Impostazioni del Profilo"

-- unlock window
L.UnlockHeader							= "UI Sbloccato"
L.ChangesPending						= "|cffffffModifiche in sospeso!|r\n|cffff00Clic 'Serratura UI (Salva)' per salvare.|r\nLe modifiche non salvate andranno perse dopo il ricaricamento."
L.UnlockGridEnable						= "Abilita lo snap alla griglia"
L.UnlockGridDisable						= "Disattiva Snap alla griglia"
L.UnlockLockFrames						= "Serratura UI (Salva)"
L.UndoChanges							= "Cancella cambiamenti"
L.ExitNoSave							= "Uscire senza salvare"
L.UnlockReset							= "Ripristino Predefinito"
L.UnlockResetConfirm					= "Conferma Ripristino"

-- settings: generic
L.SettingOverlayFormat					= "Formato Sovrapposizione"
L.SettingOverlayShield					= "Scudo di Salute"
L.SettingOverlayShieldTip				= "Include lo stato attuale dello scudo."
L.SettingOverlayFancy					= "Mostra Separatore di Migliaia"
L.SettingOverlayFancyTip				= "Impostare se suddividere i numeri grandi in questo overlay.\n\nAd esempio, 10000 diventerà 10'..L.ThousandsSeparator..'000."
L.SettingOverlayFont					= "Carattere Testo Sovrapposizione"
L.SettingOverlayStyle					= "Colore & stile del Testo Sovrapposizione"
L.SettingOverlaySize					= "Dimensione del Testo Sovrapposizione"

-- settings: general tab (1)
L.GeneralAnchorDesc						= "Sblocca per consentire il trascinamento delle finestre dell'interfaccia utente utilizzando il mouse e le dimensioni ridimensionate utilizzando la rotellina. Verrà mostrata una sovrapposizione per ciascuna finestra dell'interfaccia utente sbloccata e riposizionerà le finestre anche se non sono visualizzate al momento (ad esempio, la salute del bersaglio se non si dispone di un obiettivo).\n\nIl blocco salverà qualsiasi modifica. Facendo clic su 'Cancella cambiamenti' verranno ripristinate tutte le modifiche da quando le finestre sono state sbloccate. Facendo clic con il tasto destro su una singola finestra si resetteranno le modifiche in sospeso solo a quella finestra."
L.GeneralAnchorUnlock					= "Sblocca le finestre dell'interfaccia utente"
L.GeneralCompassPins					= "Perni della bussola"
L.GeneralPinScale						= "Dimensione Perno Bussola"
L.GeneralPinScaleTip					= "Imposta quanto devono essere grandi i perni della bussola. Questa dimensione è indipendente dalla dimensione della bussola stessa che può essere cambiata quando l'interfaccia utente è sbloccata.\n\nL'impostazione di 100 corrisponde al 100% della dimensione predefinita (nessuna modifica)."
L.GeneralPinLabel						= "Nascondi Testo Perno Bussola"
L.GeneralPinLabelTip					= "Imposta se nascondere il testo che identifica il tuo attuale bersaglio 'perno' (ad esempio, il nome del marcatore della missione che stai guardando attualmente).\n\nL'impostazione dell'interfaccia utente predefinita è Spento."
L.General_TheftHeader					= "Furto"
L.General_TheftPrevent					= "Prevenire il furto accidentale di oggetti del mondo"
L.General_TheftPreventTip				= "Stabilire se impedire il saccheggio di oggetti di proprietà in esposizione nel mondo. Questo include tutti quei pezzi di armature, armi, cibo ecc. Che darebbero una taglia se catturati.\n\nSi prega di notare che questo non fornisce alcuna protezione contro i saccheggi."
L.General_TheftSafer					= "Furto più sicuro di oggetti del mondo"
L.General_TheftSaferTip					= "Imposta se riattivare il furto di oggetti di proprietà quando sono completamente nascosti.\n\nSi noti che questo non offre ancora protezione contro i saccheggi."
L.General_CTheftSafer					= "Furto più sicuro dai contenitori"
L.General_CTheftSaferTip				= "Imposta se impedire l'apertura di contenitori di proprietà a meno che non siano completamente nascosti."
L.General_PTheftSafer					= "Pickpocketing più sicuro"
L.General_PTheftSaferTip				= "Stabilire se rendere più sicuro il borseggio impedendo il saccheggio se non completamente nascosto."
L.General_TheftSaferWarn				= "Questo è tecnicamente imbroglione!"
L.General_TheftAnnounceBlock			= "Annuncia quando viene impedito un furto"
L.General_TheftAnnounceBlockTip			= "Imposta se annunciare quando un tentativo di furto è bloccato dalle tue impostazioni di furto.\n\nL'avviso arriverà alla finestra di chat corrente."
L.General_ModeChange					= "Ricarica della modalità Keyboard/Gamepad Change"
L.General_ModeChangeTip					= "Ricarica l'interfaccia utente quando si passa dalla modalità tastiera a quella da gamepad. Normalmente se si cambiano le modalità, le modifiche di posizione apportate in Azurah per quella modalità verranno continuamente ripristinate fino a ricaricare manualmente l'interfaccia utente."
L.GeneralNotification					= "Testo di Notifica"
L.General_Notification					= "Configura Allineamento"
L.General_NotificationTip				= "Seleziona l'allineamento orizzontale per il testo di notifica. Per impostazione predefinita, l'opzione 'Automatico' imposta l'allineamento a sinistra o a destra in base alla posizione della cornice del testo di notifica."
L.General_NotificationWarn				= "Le modifiche a questa impostazione richiedono lo sblocco E lo spostamento della cornice del testo di notifica o il ripristino dell'interfaccia utente per avere effetto."
L.General_MiscHeader					= "Varie"
L.General_ATrackerDisable				= "Disattiva il tracker delle attività"
L.General_ATrackerDisableTip			= "Disabilita la visualizzazione dello stato per attività come Dungeon Finder e Battlegrounds."

-- settings: attributes tab (2)
L.AttributesFadeMin						= "Visibilità: Quando Pieno"
L.AttributesFadeMinTip					= "Imposta l'opacità delle barre degli attributi quando l'attributo è pieno. Al 100% le barre saranno completamente visibili e allo 0% saranno invisibili.\n\nL'impostazione dell'interfaccia utente predefinita è 0%."
L.AttributesFadeMax						= "Visibilità: quando non è pieno"
L.AttributesFadeMaxTip					= "Imposta l'opacità delle barre degli attributi quando l'attributo non è pieno (ad esempio, resistenza durante lo sprint). Al 100% le barre saranno completamente visibili e allo 0% saranno invisibili.\n\nL'impostazione dell'interfaccia utente predefinita è 100%."
L.AttributesLockSize					= "Blocca le Dimensioni Degli Attributi"
L.AttributesLockSizeTip					= "Imposta se le dimensioni degli attributi sono bloccate in modo che non cambino quando ottieni salute o energia del bonus.\n\nL'impostazione dell'interfaccia utente predefinita è Spento."
L.AttributesCombatBars					= "Visibilità: in Combattimento"
L.AttributesCombatBarsTip				= "Usa sempre la visibilità 'Quando non è pieno' in combattimento."
L.AttributesOverlayHealth				= "Sovrapposizione Testo: Salute"
L.AttributesOverlayMagicka				= "Sovrapposizione Testo: Magicka"
L.AttributesOverlayStamina				= "Sovrapposizione Testo: Resistenza"
L.AttributesOverlayFormatTip			= "Imposta come visualizzare il testo di sovrapposizione per questa barra degli attributi.\n\nL'impostazione dell'interfaccia utente predefinita è Nessuna sovrapposizione."

-- settings: target tab (3)
L.TargetLockSize						= "Blocco Dimensioni Barra di Bersaglio"
L.TargetLockSizeTip						= "Imposta se la dimensione della barra di bersaglio è bloccata, in modo che non cambi quando si rivolge a qualcuno con un bonus di salute.\n\nL'impostazione dell'interfaccia utente predefinita è Disattivata."
L.TargetRPName							= "Nascondi Bersaglio @Accountname"
L.TargetRPNameTip						= "Non mostrare il tag @accountname nel frame di bersaglio. NOTA: Se si seleziona 'Prefer UserID' sotto l'opzione Display Name di Interface Interface del gioco, questo in realtà nasconde il nome normale del personaggio."
L.TargetRPTitle							= "Nascondi il Titolo Bersaglio"
L.TargetRPTitleTip						= "Nascondi il titolo del giocatore bersaglio."
L.TargetRPTitleWarn						= "Richiede un ricaricare dell'UI."
L.TargetRPInteract						= "Nascondi Interazione @Accountname"
L.TargetRPInteractTip					= "Non mostrare il tag @accountname nel frame di interazione del giocatore."
L.TargetColourByBar						= "Colore della barra salute del bersaglio"
L.TargetColourByBarTip					= "Stabilisci se la barra della salute del bersaglio è colorata dalla disposizione (reazione) o dalla difficoltà (livello)."
L.TargetColourByName					= "Colore del nome dell'bersaglio"
L.TargetColourByNameTip					= "Imposta se la targa identificativa del bersaglio è colorata dalla disposizione (reazione) o dalla difficoltà (livello)."
L.TargetColourByLevel					= "Colora il livello del bersaglio per difficoltà"
L.TargetColourByLevelTip				= "Imposta se il livello del bersaglio è colorato dalla sua difficoltà (livello)."
L.TargetIconClassShow					= "Mostra icona della classe per giocatori"
L.TargetIconClassShowTip				= "Imposta se mostrare l'icona della classe del giocatore bersaglio."
L.TargetIconClassByName					= "Mostra icona della classe sulla targhetta"
L.TargetIconClassByNameTip				= "Imposta se l'icona della classe (se mostrata) viene visualizzata a sinistra della targa del bersaglio anziché a sinistra della barra della salute del bersaglio."
L.TargetIconAllianceShow				= "Mostra l'icona dell'alleanza per i giocatori"
L.TargetIconAllianceShowTip				= "Imposta se mostrare l'icona dell'alleanza del giocatore bersaglio."
L.TargetIconAllianceByName				= "Mostra l'icona di Alleanza di Nameplate"
L.TargetIconAllianceByNameTip			= "Imposta se l'icona dell'alleanza (se mostrata) viene visualizzata a destra della targa del bersaglio anziché a destra della barra della salute del bersaglio."
L.TargetOverlayFormatTip				= "Imposta come visualizzare il testo di sovrapposizione per la barra di bersaglio.\n\nL'impostazione dell'interfaccia utente predefinita è Nessuna sovrapposizione."
L.BossbarHeader							= "Impostazioni Bossbar"
L.BossbarOverlayFormatTip				= "Imposta come visualizzare il testo di sovrapposizione per la barra del boss. La barra Boss mostra la somma dei valori di salute per tutti i boss attivi.\n\nL'impostazione dell'interfaccia utente predefinita è Nessuna sovrapposizione."

-- settings: action bar tab (4)
L.ActionBarHideBindBG					= "Nascondi Sfondo di Keybind"
L.ActionBarHideBindBGTip				= "Imposta se lo sfondo scuro dietro i collegamenti dei tasti della barra delle azioni è visibile."
L.ActionBarHideBindText					= "Nascondi il Testo di Keybind"
L.ActionBarHideBindTextTip				= "Imposta se il testo di keybind sotto le barre di azione è visibile."
L.ActionBarHideWeaponSwap				= "Nascondi l'icona di scambio di armi"
L.ActionBarHideWeaponSwapTip			= "Imposta se l'icona di scambio arma tra i tasti di scelta rapida e il quickslot è visibile."
L.ActionBarOverlayShow					= "Mostra Sovrapposizione"
L.ActionBarOverlayUltValue				= "Sovrapposizione Testo: Ultimo (Valore)"
L.ActionBarOverlayUltValueShowTip		= "Imposta se mostrare una sovrapposizione sopra il pulsante finale che mostra il tuo ultimo livello attuale."
L.ActionBarOverlayUltValueShowCost		= "Mostra cCosto di Abilità"
L.ActionBarOverlayUltValueShowCostTip	= "Imposta se la sovrapposizione mostra solo il tuo ultimo livello attuale o il costo ultimo livello / abilità."
L.ActionBarOverlayUltPercent			= "Testo di Sovrapposizione: Ultimo (Percentuale)"
L.ActionBarOverlayUltPercentShowTip		= "Imposta se mostrare un overlay sul pulsante definitivo visualizzando il livello finale in percentuale."
L.ActionBarOverlayUltPercentRelative	= "Mostra percentuale relativa"
L.ActionBarOverlayUltPercentRelativeTip	= "Stabilisci se la percentuale mostrata sull'overlay è relativa al costo dell'abilità finale con fessura invece di una percentuale del tuo massimo pool di 500 punti."

-- settings: experience bar tab (5)
L.ExperienceDisplayStyle				= "Mostra Stile"
L.ExperienceDisplayStyleTip				= "Imposta come visualizzare la barra dell'esperienza.\n\nNota: anche quando Mostra sempre, la barra verrà nascosta durante la creazione e quando la Mappa del mondo è aperta in modo da non sovrapporsi ad altre finestre."
L.ExperienceOverlayFormatTip			= "Imposta come visualizzare il testo di sovrapposizione per la barra dell'esperienza.\n\nL'impostazione dell'interfaccia utente predefinita è Nessuna sovrapposizione."

-- settings: bag watcher tab (6)
L.Bag_Desc								= "L'osservatore della borsa crea una barra (simile alla barra dell'esperienza in apparenza) che mostra quanto è pieno il tuo zaino. Si visualizzerà brevemente ogni volta che il contenuto della borsa cambia, e può essere impostato in modo da mostrare sempre se la borsa è quasi piena."
L.Bag_Enable							= "Abilita Osservatore di Borse"
L.Bag_ReverseAlignment					= "Allineamento Barra Inversa"
L.Bag_ReverseAlignmentTip				= "Impostare se invertire la direzione della barra aumentandola verso destra. Questo posizionerà anche l'icona sul lato opposto della barra."
L.Bag_LowSpaceLock						= "Mostra sempre quando c'è poco spazio"
L.Bag_LowSpaceLockTip					= "Imposta se l'osservatore della borsa deve sempre essere mostrato quando lo zaino è quasi pieno."
L.Bag_LowSpaceTrigger					= "Livello di avviso di spazio ridotto"
L.Bag_LowSpaceTriggerTip				= "Imposta quante slot dovrebbero rimanere libere prima di considerare lo zaino basso nello spazio."

-- settings: werewolf tab (7)
L.Werewolf_Desc							= "Il timer del licantropo è una finestra separata (mobile) che mostra il tempo di trasformazione del lupo mannaro rimanente in secondi per un modo più semplice per tenere traccia di quanto tempo devi cacciare. Inizialmente viene posizionato proprio a destra del pulsante finale."
L.Werewolf_Enable						= "Abilita timer lupo mannaro"
L.Werewolf_Flash						= "Lampeggiare sull'estensione temporale"
L.Werewolf_FlashTip						= "Imposta se l'icona del timer dovrebbe lampeggiare brevemente quando aumenta il tempo rimanente sulla tua trasformazione."
L.Werewolf_IconOnRight					= "Show icon on the right"
L.Werewolf_IconOnRightTip				= "Impostare se avere l'icona visualizzata a destra del timer anziché a sinistra."

-- settings: profiles tab (8)
L.Profile_Desc							= "Qui è possibile gestire i profili di impostazione, inclusa l'opzione per abilitare un profilo a livello di account che applicherà le stesse impostazioni a TUTTI i personaggi su questo account. A causa della permanenza di queste opzioni, la gestione deve prima essere abilitata utilizzando la casella di controllo nella parte inferiore del pannello."
L.Profile_UseGlobal						= "Usa profilo a livello di account"
L.Profile_UseGlobalWarn					= "Il passaggio tra i profili locali e globali ricaricherà l'interfaccia."
L.Profile_Copy							= "Seleziona un profilo da copiare"
L.Profile_CopyTip						= "Seleziona un profilo per copiare le sue impostazioni sul profilo corrente. Se attivo, il profilo attivo sarà per il personaggio registrato o per il profilo completo dell'account. Le impostazioni del profilo esistenti verranno sovrascritte in modo permanente.\n\nQuesto non può essere annullato!"
L.Profile_CopyButton					= "Copia profilo"
L.Profile_CopyButtonWarn				= "La copia di un profilo ricaricherà l'interfaccia."
L.Profile_Delete						= "Seleziona un profilo da eliminare"
L.Profile_DeleteTip						= "Seleziona un profilo per eliminare le sue impostazioni dal database. Se quel personaggio ha effettuato l'accesso in un secondo momento e non stai utilizzando il profilo completo dell'account, verranno create nuove impostazioni predefinite.\n\nDeleting di un profilo è permanente!"
L.Profile_DeleteButton					= "Elimina profilo"
L.Profile_Guard							= "Abilita gestione profili"

------------------------------------------------------------------------------------------------------------------

if (GetCVar('language.2') == 'it') then -- overwrite GetLanguage for new language
	for k, v in pairs(Azurah:GetLocale()) do
		if (not L[k]) then -- no translation for this string, use default
			L[k] = v
		end
	end
	function Azurah:GetLocale() -- set new language return
		return L
	end
end
