local Azurah                            = _G['Azurah'] -- grab addon table from global
local L = {}
 
------------------------------------------------------------------------------------------------------------------
-- French (Thanks to ESOUI.com users Ayantir, Ykses and lexo1000 for the translations.)
-- (Non-indented lines still require human translation and may not make sense!)
------------------------------------------------------------------------------------------------------------------
 
	L.Azurah                                = "|c67b1e9A|c4779cezurah|r"
	L.Usage									= "|c67b1e9A|c4779cezurah|r - Usage:\n|cffc600  /azurah unlock|r |cffffff =  déverrouiller UI pour le mouvement|r\n|cffc600  /azurah save|r |cffffff =  verrouiller UI et enregistrer positions|r\n|cffc600  /azurah undo|r |cffffff =  annuler modifications en attente|r\n|cffc600  /azurah exit|r |cffffff =  verrouiller UI sans sauvegarder|r"
	L.ThousandsSeparator                  	= "," -- used to separate large numbers in overlays
	L.TheftBlocked							= "|c67b1e9A|c4779cezurah|r - Le vol a été empêché en raison de vos paramètres."

-- move window names
	L.Health                                = "Santé du personnage"
	L.HealthSiege                           = "Arme de siège"
	L.Magicka                               = "Magie du personnage"
	L.Werewolf                              = "Minuterie du loup-Garou"
	L.Stamina                               = "Vigueur du personnage"
	L.StaminaMount                          = "Vigueur de la monture"
	L.Experience                            = "Barre d'expérience"
	L.EquipmentStatus                       = "Statut de l'équipement"
	L.Synergy                               = "Synergie"
	L.Compass                               = "Boussole"
	L.ReticleOver                           = "Santé de la cible"
	L.ActionBar                             = "Barre de compétence"
	L.PetGroup								= "Group de vie des familiers"
	L.Group                                 = "Membres du groupe"
	L.Raid1                                 = "Groupe de raid 1"
	L.Raid2                                 = "Groupe de raid 2"
	L.Raid3                                 = "Groupe de raid 3"
	L.Raid4                                 = "Groupe de raid 4"
	L.Raid5                                 = "Groupe de raid 5"
	L.Raid6                                 = "Groupe de raid 6"
	L.FocusedQuest                          = "Suivi des quêtes"
	L.PlayerPrompt                          = "Messages d'interaction"
	L.AlertText                             = "Alertes"
	L.CenterAnnounce                        = "Notifications"
	L.InfamyMeter                           = "Affichage des primes"
	L.TelVarMeter                           = "Affichage des Tel Var"
	L.ActiveCombatTips                      = "Aides au combat"
	L.Tutorial                              = "Didacticiels"
	L.CaptureMeter                          = "Compteur de capture AvA"
	L.BagWatcher                            = "Barre d'encombrement"
	L.WerewolfTimer                         = "Loup-garou"
	L.LootHistory                           = "Historique de butin"
	L.RamSiege                              = "Bélier de siege"
	L.Subtitles                             = "Sous-titres"
	L.PaperDoll                             = "Poupée de papier"
	L.QuestTimer                            = "Minuterie de quêtes"
	L.PlayerBuffs                           = "Bonus/malus du joueur"
	L.TargetDebuffs							= "Debuffs Cible"
	L.Reticle                               = "Réticule"
	L.Interact                              = "Texte d'interaction"
	L.BattlegroundScore                     = "Score des Champs de bataille"
	L.DialogueWindow						= "Fenêtre de dialogue"
	L.StealthIcon                           = "Icône de furtivité"
	L.WykkydReticle							= "Cadres de réticule échelle gérée par Wykkyd Full Immersion"
	L.WykkydSubtitles						= "Balance de sous-titres gérée par Wykkyd Full Immersion"

-- --------------------------------------------
-- SETTINGS -----------------------------------
-- --------------------------------------------
 
-- dropdown menus
	L.DropOverlay1                          = "Ne rien afficher"
	L.DropOverlay2                          = "Tout afficher"
	L.DropOverlay3                          = "Valeur/Valeur max"
	L.DropOverlay4                          = "Valeur/Pourcentage"
	L.DropOverlay5                          = "Valeur"
	L.DropOverlay6                          = "Pourcentage"
	L.DropColourBy1                         = "Par défaut"
	L.DropColourBy2                         = "Selon le danger"
	L.DropColourBy3                         = "Selon le niveau"
	L.DropExpBarStyle1                      = "Par défaut"
	L.DropExpBarStyle2                      = "Toujours affichée"
	L.DropExpBarStyle3                      = "Toujours masquée"
	L.DropHAlign1                           = "Automatique"
	L.DropHAlign2                           = "Aligné à gauche"
	L.DropHAlign3                           = "Aligné à droite"
	L.DropHAlign4                           = "Centré"
 
-- tabs
	L.TabButton1                            = "Général"
	L.TabButton2                            = "Caractéristiques"
	L.TabButton3                            = "Cibles"
	L.TabButton4                            = "Compétences"
	L.TabButton5                            = "Expérience"
	L.TabButton6                            = "Encombrement"
	L.TabButton7                            = "Loup-garou"
	L.TabButton8                            = "Profils"
	L.TabHeader1                            = "Déverrouillage de l'interface"
	L.TabHeader2                            = "Visibilité des barres de caractéristique"
	L.TabHeader3                            = "Affichage des cibles"
	L.TabHeader4                            = "Affichage de la barre de compétence"
	L.TabHeader5                            = "Affichage de la barre d'expérience"
	L.TabHeader6                            = "Affichage de la barre d'encombrement"
	L.TabHeader7                            = "Minuterie de loup-garou"
	L.TabHeader8                            = "Gestionnaire de profils"
 
-- unlock window
	L.UnlockHeader                          = "Déverrouillage"
	L.ChangesPending						= "|cffffffModifications en attente!|r\n|cffff00Cliquer sur 'Sauvegarder' pour enregistrer.|r\nLes modifications non enregistrées seront perdues lors du rechargement."
	L.UnlockGridEnable                      = "Activer l'alignement"
	L.UnlockGridDisable                     = "Désactiver l'alignement"
	L.UnlockLockFrames                      = "Sauvegarder"
	L.UndoChanges							= "Annuler les changements"
	L.ExitNoSave							= "Quitter sans sauvegarder"
	L.UnlockReset                           = "Positions par défaut"
	L.UnlockResetConfirm                    = "Confirmer la réinitialisation"

-- settings: generic
	L.SettingOverlayFormat                  = "Type de données"
	L.SettingOverlayShield                  = "Durabilité du bouclier"
	L.SettingOverlayShieldTip               = "Affiche le niveau de durabilité du bouclier."
	L.SettingOverlayFancy                   = "Distinguer les milliers"
	L.SettingOverlayFancyTip                = "Ajoute une virgule entre les milliers. Par exemple \"10000\" deviendra \"10,000\"."
	L.SettingOverlayFont                    = "Police du texte"
	L.SettingOverlayStyle                   = "Couleur & style du texte"
	L.SettingOverlaySize                    = "Taille du texte"
 
-- settings: general tab (1)
	L.GeneralAnchorDesc                     = "Déverrouiller l'interface permet de déplacer librement les fenêtres et les redimensionner avec la molette de la souris.\nFaire un clic droit sur une fenêtre pour annuler les modifications apportées à celle-ci. Une fois terminé, cliquer sur 'Sauvegarder' pour enregistrer les modifications ou sur 'Annuler les changements' pour réinitialiser toutes les modifications effectuées depuis le déverrouillage de l'interface."
	L.GeneralAnchorUnlock                   = "Déverrouiller l'IU"
	L.GeneralCompassPins                    = "Boussole"
	L.GeneralPinScale                       = "Taille des icônes"
	L.GeneralPinScaleTip                    = "Détermine la taille des icônes affichées dans la boussole. Ce réglage est indépendant de la taille de la boussole (qui peut être modifiée en déverouillant l'interface)."
	L.GeneralPinLabel                       = "Masquer le texte"
	L.GeneralPinLabelTip                    = "Retire le texte des icônes qui apparaît au-dessus de la boussole comme l'objectif de la quête actuellement suivie."
	L.General_TheftHeader                   = "Protections contre le vol"
	L.General_TheftPrevent                  = "Empêcher le vol accidentel"
	L.General_TheftPreventTip				= "Empêche le vol des objets à moins que le personnage ne soit en mode furtif.\nNoter que cela n\'offre aucune protection contre le vol des conteneurs."
	L.General_TheftSafer                    = "Protection contre le vol des objets"
	L.General_TheftSaferTip					= "Active une protection supplémentaire en empêchant le vol à moins que le personnage ne soit caché.\nNoter que cela n\'offre aucune protection contre le vol des conteneurs."
	L.General_CTheftSafer                   = "Protection contre le vol des conteneurs"
	L.General_CTheftSaferTip				= "Active une protection supplémentaire en empêchant le vol des conteneurs à moins que le personnage ne soit caché."
	L.General_PTheftSafer                   = "Protection contre le vol à la tire"
	L.General_PTheftSaferTip				= "Empêche le vol à la tir à moins que le personnage ne soit caché."
	L.General_TheftSaferWarn                = "Ceci peut être considéré comme une forme de triche !"
	L.General_TheftAnnounceBlock			= "Afficher l'alerte de vol bloqué"
	L.General_TheftAnnounceBlockTip			= "Permet d'afficher un message indiquant qu'un vol a été bloqué par les paramètres de protection contre le vol.\nL'alerte s'affiche dans la fenêtre de discussion en cours."
	L.General_ModeChange                    = "Recharger lors du basculement clavier/manette"
	L.General_ModeChangeTip                 = "Force le rechargement de l'interface utilisateur lors du passage entre les modes d'affichage clavier et manette.\nPar défaut, lors du changement de mode d'affichage, la modification de la position des éléments de l'interface ne sont pris en compte qu'en rechargeant manuellement l'interface utilisateur."
	L.GeneralNotification                   = "Fenêtre de notification"
	L.General_Notification                  = "Disposition du texte"
	L.General_NotificationTip               = "Détermine l'alignemment horizontal des textes de notification. Par défaut, l'option 'Automatique' affiche le texte à gauche ou à droite en fonction de la position de la fenêtre."
	L.General_NotificationWarn              = "Pour être prise en compte, la modification de ce paramètre nécessite de débloquer et déplacer le cadre du texte de notification ou de recharger l'interface utilisateur."
	L.General_MiscHeader					= "Suivi des activités"
	L.General_ATrackerDisable				= "Désactiver le suivi des activités"
	L.General_ATrackerDisableTip			= "Désactive l'affichage du statut des activités comme la recherche de donjons ou les champs de bataille."

-- settings: attributes tab (2)
	L.AttributesFadeMin                     = "Visibilité à 100%"
	L.AttributesFadeMinTip                  = "Détermine le niveau d'opacité des barres de caractéristique du personnage lorsque leur valeur est égale à 100%."
	L.AttributesFadeMax                     = "Visibilité à moins de 100%"
	L.AttributesFadeMaxTip                  = "Détermine le niveau d'opacité des barres de caractéristique du personnage lorsque leur valeur est inférieure à 100%."
	L.AttributesLockSize                    = "Verrouiller la taille"
	L.AttributesLockSizeTip                 = "Empêche le redimensionnement des barres de caractéristique du personnage lorsqu'un bonus qui augmente la santé, la magie ou la vigueur est actif."
	L.AttributesCombatBars                  = "Toujours afficher en combat"
	L.AttributesCombatBarsTip               = "Force l'utilisation du réglage 'Niveau d'opacité à moins de 100%' lorsque le personnage est engagé en combat."
	L.AttributesOverlayHealth               = "Barre de Santé"
	L.AttributesOverlayMagicka              = "Barre de Magie"
	L.AttributesOverlayStamina              = "Barre de Vigueur"
	L.AttributesOverlayFormatTip            = "Détermine les informations affichées sur la barre de compétence."
 
-- settings: target tab (3)
	L.TargetLockSize                        = "Verrouiller la taille de la barre de santé"
	L.TargetLockSizeTip                     = "Empêche le redimensionnement de la barre de santé de la cible lorsqu'un bonus qui augmente sa santé est actif."
	L.TargetRPName                          = "Masquer @nomducompte"
	L.TargetRPNameTip                       = "Retire la mention @nomducompte de l'encadré de la cible."
	L.TargetRPTitle                         = "Masquer le titre"
	L.TargetRPTitleTip                      = "Retire le titre du personnage de l'encadré de la cible."
	L.TargetRPTitleWarn                     = "Nécessite un rechargement de l'interface utilisateur."
	L.TargetRPInteract                      = "Masquer @Nomducompte de la fenêtre d'interaction"
	L.TargetRPInteractTip                   = "Retire la mention @nomducompte de l'encadré d'interaction de la cible."
	L.TargetColourByBar                     = "Couleur de la barre de santé"
	L.TargetColourByBarTip                  = "Détermine si la barre de santé de la cible est colorée selon le danger qu'elle représente pour le personnage (hostile, neutre ou amicale) ou selon son niveau."
	L.TargetColourByName                    = "Couleur du nom de la cible"
	L.TargetColourByNameTip                 = "Détermine si le nom de la cible est coloré selon le danger qu'elle représente pour le personnage (hostile, neutre ou amicale) ou selon son niveau."
	L.TargetColourByLevel                   = "Colorer le niveau de la cible"
	L.TargetColourByLevelTip                = "Détermine si le niveau de la cible est coloré en fonction de sa difficulté (différence de niveau avec le joueur)."
	L.TargetIconClassShow                   = "Afficher l'icône de classe"
	L.TargetIconClassShowTip                = "Affiche une icône correspondant à la classe du joueur ciblé."
	L.TargetIconClassByName                 = "Positionner l'icône de classe à côté du nom"
	L.TargetIconClassByNameTip              = "Affiche l'icône de classe à côté du nom de la cible au lieu de l'afficher à côté de la barre de santé."
	L.TargetIconAllianceShow                = "Afficher l'icône d'Alliance"
	L.TargetIconAllianceShowTip             = "Affiche une icône correspondant à l\'Alliance à laquelle le joueur ciblé appartient."
	L.TargetIconAllianceByName              = "Positionner l'icône d'Alliance à côté du nom"
	L.TargetIconAllianceByNameTip           = "Affiche l'icône d'Alliance à côté du nom de la cible plutôt qu'à côté de la barre de santé."
	L.TargetOverlayFormatTip                = "Détermine les informations affichées sur la barre de santé de la cible."
	L.BossbarHeader                         = "Affichage des Boss"
	L.BossbarOverlayFormatTip               = "Détermine les informations affichées sur la barre de santé des Boss (boussole). Cette dernière affiche un résumé de la santé de tous les Boss actifs."
 
-- settings: action bar tab (4)
	L.ActionBarHideBindBG                   = "Masquer l'arrière-plan"
	L.ActionBarHideBindBGTip                = "Retire l'arrière-plan sombre affiché derrière la barre de compétence."
	L.ActionBarHideBindText                 = "Masquer les raccourcis clavier"
	L.ActionBarHideBindTextTip              = "Retire les raccourcis claviers affichés sous la barre de compétence."
	L.ActionBarHideWeaponSwap               = "Masquer l'icône de changement d'arme"
	L.ActionBarHideWeaponSwapTip            = "Retire l'icône de changement d'arme affichée à gauche de la barre de compétence."
	L.ActionBarOverlayShow                  = "Afficher le texte"
	L.ActionBarOverlayUltValue              = "Affichage de l'Ultime"
	L.ActionBarOverlayUltValueShowTip       = "Affiche la valeur de la compétence Ultime au-dessus du bouton de compétence Ultime."
	L.ActionBarOverlayUltValueShowCost      = "Afficher la valeur détaillée"
	L.ActionBarOverlayUltValueShowCostTip   = "Affiche la quantité d'Ultime disponible ainsi que le coût de l'Ultime."
	L.ActionBarOverlayUltPercent            = "Affichage de l'Ultime en pourcentage"
	L.ActionBarOverlayUltPercentShowTip     = "Affiche le pourcentage de la compétence Ultime sur le bouton de la compétence Ultime."
	L.ActionBarOverlayUltPercentRelative    = "Afficher en pourcentage relatif"
	L.ActionBarOverlayUltPercentRelativeTip = "Affiche le pourcentage relativement à la compétence actuelle plutôt que relativement au maximum de charge possible (1000 points)."
 
-- settings: experience bar tab (5)
	L.ExperienceDisplayStyle                = "Style d'affichage"
	L.ExperienceDisplayStyleTip             = "Détermine l'affichage de la barre d'expérience.\n\nNote : Même avec l'option \"Toujours affichée\", la barre sera masquée pendant l'artisanat ou quand la carte du monde est ouverte afin qu'elle ne se superpose pas avec l'affichage d'autres informations."
	L.ExperienceOverlayFormatTip            = "Détermine les informations affichées sur la barre."
 
-- settings: bag watcher tab (6)
	L.Bag_Desc                              = "La barre d'encombrement indique le taux de remplissage de l'inventaire du personnage."
	L.Bag_Enable                            = "Activer la barre d'encombrement"
	L.Bag_ReverseAlignment                  = "Inverser l'alignement de la barre"
	L.Bag_ReverseAlignmentTip               = "Inverse la direction de remplissage de la barre d'encombrement en la faisant progresser de gauche à droite. L'icône de sac sera également positionnée sur le côté opposé."
	L.Bag_LowSpaceLock                      = "Toujours afficher quand l'espace est faible"
	L.Bag_LowSpaceLockTip                   = "Force l'affichage de la barre d'encombrement lorsque le niveau d'encombrement atteint la valeur indiquée dans l'option ci-dessous."
	L.Bag_LowSpaceTrigger                   = "Niveau de déclenchement d'espace faible"
	L.Bag_LowSpaceTriggerTip                = "Détermine le nombre minimum d'emplacements libres restants pour que la barre d'encombrement s'affiche en permanence."
 
-- settings: werewolf tab (7)
	L.Werewolf_Desc                         = "La minuterie de loup-garou est une fenêtre mobile qui affiche le temps de transformation restant au loup-garou en secondes."
	L.Werewolf_Enable                       = "Activer la minuterie"
	L.Werewolf_Flash                        = "Clignotement de la minuterie"
	L.Werewolf_FlashTip                     = "Détermine si l'icône de la minuterie clignote lorsque le temps de transformation restant est faible."
	L.Werewolf_IconOnRight                  = "Afficher l'icône à droite"
	L.Werewolf_IconOnRightTip               = "Affiche l'icône de la minuterie à droite plutôt qu'à gauche."
 
-- settings: profiles tab (8)
	L.Profile_Desc                          = "Le gestionnaire de profil permet d'appliquer les mêmes paramètres pour tous les personnages du compte. En raison du caractère permanent de ce paramètre, l'option 'Activer le gestionnaire de profil' en bas de cette fenêtre doit d'abord être activée."
	L.Profile_UseGlobal                     = "Appliquer les réglages au niveau du compte"
	L.Profile_UseGlobalWarn                 = "Passer entre les profils locaux et globaux recharge automatiquement l'interface."
	L.Profile_Copy                          = "Appliquer les réglages du profil"
	L.Profile_CopyTip                       = "Applique les paramètres du profil sélectionné sur le profil actuellement actif. Le profil actif s'appliquera au personnage enregistré ou à tous les profils du compte s'il est activé. Les paramètres de profil existants sont écrasés en permanence.\n\nCeci ne peut pas être annulé!"
	L.Profile_CopyButton                    = "Copier le profil"
	L.Profile_CopyButtonWarn                = "Copier le profil recharge l'interface automatiquement."
	L.Profile_Delete                        = "Supprimer le profil"
	L.Profile_DeleteTip                     = "Supprime les paramètres du profil selectionné de la base de données. Si ce personnage se connecte a posteriori et que vous n'utilisez pas le profil appliqué au compte, de nouveaux paramètres par défaut lui seront appliqués. Supprimer un profil est irréversible"
	L.Profile_DeleteButton                  = "Supprimer le profil"
	L.Profile_Guard                         = "Activer le gestionnaire de profil"


if (GetCVar('language.2') == 'fr') then -- overwrite GetLanguage for new language
    for k, v in pairs(Azurah:GetLocale()) do
        if (not L[k]) then -- no translation for this string, use default
            L[k] = v
        end
    end
    function Azurah:GetLocale() -- set new language return
        return L
    end
end
