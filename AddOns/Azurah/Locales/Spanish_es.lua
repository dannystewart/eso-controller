local Azurah							= _G['Azurah'] -- grab addon table from global
local L = {}

------------------------------------------------------------------------------------------------------------------
-- Spanish
-- (Non-indented lines still require human translation and may not make sense!)
------------------------------------------------------------------------------------------------------------------

L.Azurah								= "|c67b1e9A|c4779cezurah|r"
L.Usage									= "|c67b1e9A|c4779cezurah|r - Uso:\n|cffc600  /azurah unlock|r |cffffff =  desbloquear UI para el movimiento|r\n|cffc600  /azurah save|r |cffffff =  trabar UI y guardar posiciones|r\n|cffc600  /azurah undo|r |cffffff =  deshacer todos cambios pendientes|r\n|cffc600  /azurah exit|r |cffffff =  bloqueo UI sin guardar|r"
L.ThousandsSeparator					= "," -- used to separate large numbers in overlays
L.TheftBlocked							= "|c67b1e9A|c4779cezurah|r - Se evitó el robo debido a su configuración."

-- move window names
L.Health								= "Salud del jugador"
L.HealthSiege							= "Salud de asedio"
L.Magicka								= "Jugador magico"
L.Werewolf								= "Temporizador de hombre lobo"
L.Stamina								= "Resistencia del jugador"
L.StaminaMount							= "La resistencia del monte"
L.Experience							= "Barra de experiencia"
L.EquipmentStatus						= "Estado del equipo"
L.Synergy								= "Sinergia"
L.Compass								= "Brújula"
L.ReticleOver							= "Salud objetivo"
L.ActionBar								= "Action Bar"
L.PetGroup								= "Grupo de vida de las mascotas"
L.Group									= "Barra de acciones"
L.Raid1									= "Grupo Raid 1"
L.Raid2									= "Grupo Raid 2"
L.Raid3									= "Grupo Raid 3"
L.Raid4									= "Grupo Raid 4"
L.Raid5									= "Grupo Raid 5"
L.Raid6									= "Grupo Raid 6"
L.FocusedQuest							= "Rastreador de misiones"
L.PlayerPrompt							= "Mensaje de interacción con el jugador"
L.AlertText								= "Notificaciones de texto de alerta"
L.CenterAnnounce						= "Notificaciones en pantalla"
L.InfamyMeter							= "Pantalla de recompensas"
L.TelVarMeter							= "Pantalla de Tel Var"
L.ActiveCombatTips						= "Consejos de combate activo"
L.Tutorial								= "Tutoriales"
L.CaptureMeter							= "Medidor de captura de AvA"
L.BagWatcher							= "Bolsa vigilante"
L.WerewolfTimer							= "Temporizador de hombre lobo"
L.LootHistory							= "Historia de botín"
L.RamSiege								= "Victorias de carnero"
L.Subtitles								= "Subtitulos"
L.PaperDoll								= "Muñeca de papel"
L.QuestTimer							= "Temporizador de búsqueda"
L.PlayerBuffs							= "Buffs/Debuffs del jugador"
L.TargetDebuffs							= "Debuffs objetivo"
L.Reticle								= "Retículo"
L.Interact								= "Texto interactivo"
L.BattlegroundScore						= "Puntuación de campo de batalla"
L.DialogueWindow						= "Ventana de diálogo"
L.StealthIcon							= "Icono de sigilo"
L.WykkydReticle							= "Escala de marcos reticulares gestionados por Wykkyd Full Immersion"
L.WykkydSubtitles						= "Escala de subtítulos manejada por Wykkyd Full Immersion"

-- --------------------------------------------
-- SETTINGS -----------------------------------
-- --------------------------------------------

-- dropdown menus
L.DropOverlay1							= "Sin superposición"
L.DropOverlay2							= "Mostrar todo"
L.DropOverlay3							= "Valor & maximo"
L.DropOverlay4							= "Valor & porcentaje"
L.DropOverlay5							= "Sólo valor"
L.DropOverlay6							= "Solo por ciento"
L.DropColourBy1							= "Defecto"
L.DropColourBy2							= "Por reacción"
L.DropColourBy3							= "Por nivel"
L.DropExpBarStyle1						= "Defecto"
L.DropExpBarStyle2						= "Siempre se muestra"
L.DropExpBarStyle3						= "Siempre oculto"
L.DropHAlign1							= "Automático"
L.DropHAlign2							= "Alineado a la izquierda"
L.DropHAlign3							= "Alineado a la derecha"
L.DropHAlign4							= "Centrado"

-- tabs
L.TabButton1							= "General"
L.TabButton2							= "Atributos"
L.TabButton3							= "Objetivo"
L.TabButton4							= "Barra de acciones"
L.TabButton5							= "Experiencia"
L.TabButton6							= "Bolsa vigilante"
L.TabButton7							= "Hombre-lobo"
L.TabButton8							= "Perfiles"
L.TabHeader1							= "Configuración general"
L.TabHeader2							= "Configuración atributo jugador"
L.TabHeader3							= "Configuración ventana destino"
L.TabHeader4							= "Configuración barra acción"
L.TabHeader5							= "Configuración barra experiencia"
L.TabHeader6							= "Ajustes la bolsa vigilancia"
L.TabHeader7							= "Configuración temporizador hombre lobo"
L.TabHeader8							= "Configuración de perfil"

-- unlock window
L.UnlockHeader							= "UI desbloqueado"
L.ChangesPending						= "|cffffffCambios pendientes!|r\n|cffff00Clic en 'Bloquear la UI (Guardar)' para guardar.|r\nLos cambios no guardados se perderán en la recarga."
L.UnlockGridEnable						= "Habilitar Snap to Grid"
L.UnlockGridDisable						= "Deshabilitar Snap to Grid"
L.UnlockLockFrames						= "Bloquear la UI (Guardar)"
L.UndoChanges							= "Deshacer cambios"
L.ExitNoSave							= "Salir sin guardar"
L.UnlockReset							= "Restablecer predeterminados"
L.UnlockResetConfirm					= "Confirmar reinicio"

-- settings: generic
L.SettingOverlayFormat					= "Formato de superposición"
L.SettingOverlayShield					= "Salud del escudo"
L.SettingOverlayShieldTip				= "Incluye la salud actual del escudo."
L.SettingOverlayFancy					= "Mostrar separador de miles"
L.SettingOverlayFancyTip				= "Establezca si dividir números grandes en esta superposición.\n\nPor ejemplo, 10000 se convertirán en 10'..L.ThousandsSeparator..'000."
L.SettingOverlayFont					= "Fuente de texto de superposición"
L.SettingOverlayStyle					= "Color y estilo de texto de superposición"
L.SettingOverlaySize					= "Tamaño de texto de superposición"

-- settings: general tab (1)
L.GeneralAnchorDesc						= "Desbloquee para permitir que las ventanas de la interfaz de usuario se arrastren con el mouse y el tamaño se modifique con la rueda de desplazamiento. Se mostrará una superposición para cada ventana de la IU desbloqueada y se reposicionarán las ventanas incluso si no se muestran actualmente (por ejemplo, el estado del objetivo si no tiene un objetivo).\n\nEl bloqueo guardará cualquier cambio. Al hacer clic en 'Deshacer cambios' se restablecerán todos los cambios desde que se desbloquearon las ventanas. Al hacer clic con el botón derecho en una sola ventana, se restablecerán los cambios pendientes solo en esa ventana."
L.GeneralAnchorUnlock					= "Desbloquear UI Vindovs"
L.GeneralCompassPins					= "Pasadores de compás"
L.GeneralPinScale						= "Tamaño del Pin Brújula"
L.GeneralPinScaleTip					= "Establezca el tamaño de los pines de la brújula. Este tamaño es independiente del tamaño de la brújula, que se puede cambiar cuando se desbloquea la interfaz de usuario.\n\nUna configuración de 100 es 100% del tamaño predeterminado (sin cambios)."
L.GeneralPinLabel						= "Ocultar texto de brújula"
L.GeneralPinLabelTip					= "Establezca si ocultar el texto que identifica su objetivo de 'pin' actual (por ejemplo, el nombre del marcador de misión que está viendo actualmente).\n\nLa configuración de la interfaz de usuario predeterminada está desactivada."
L.General_TheftHeader					= "Robo"
L.General_TheftPrevent					= "Prevenir el robo accidental de artículos del mundo"
L.General_TheftPreventTip				= "Establece si se debe evitar el saqueo de los artículos de propiedad en exhibición en el mundo. Esto incluye todas esas piezas de armadura, armas, comida, etc. que darían una recompensa si se capturaran tomando.\n\nTenga en cuenta que esto no proporciona protección contra los contenedores de saqueo."
L.General_TheftSafer					= "Robo más seguro de artículos del mundo"
L.General_TheftSaferTip					= "Establezca si volver a habilitar el robo de elementos de propiedad cuando está completamente oculto.\n\nTenga en cuenta que esto todavía no proporciona protección contra los contenedores de saqueo."
L.General_CTheftSafer					= "Robo más seguro de los contenedores"
L.General_CTheftSaferTip				= "Establecer si se debe evitar la apertura de contenedores propios a menos que esté completamente oculto."
L.General_PTheftSafer					= "Pickpocket más seguro"
L.General_PTheftSaferTip				= "Establezca si hacer que el carterismo sea más seguro al evitar el saqueo a menos que esté completamente oculto."
L.General_TheftSaferWarn				= "Esto es técnicamente engaño!"
L.General_TheftAnnounceBlock			= "Anunciar cuando se previene un robo"
L.General_TheftAnnounceBlockTip			= "Configure si desea anunciar cuándo un intento de robo está bloqueado por su configuración de robo.\n\nLa alerta llegará a la ventana de chat actual."
L.General_ModeChange					= "Cambio de modo de teclado/gamepad Volver a cargar"
L.General_ModeChangeTip					= "Recarga la interfaz de usuario al cambiar entre los modos de teclado y gamepad. Normalmente, si cambia de modo, los cambios de posición realizados en Azurah para ese modo se restablecerán continuamente hasta que se vuelva a cargar manualmente la interfaz de usuario."
L.GeneralNotification					= "Texto de notificación"
L.General_Notification					= "Configurar la alineación"
L.General_NotificationTip				= "Seleccione la alineación horizontal para el Texto de Notificación. De forma predeterminada, la opción 'Automática' establece la alineación hacia la izquierda o hacia la derecha según la posición del marco del texto de notificación."
L.General_NotificationWarn				= "Los cambios en esta configuración requieren desbloquear Y mover el marco de Texto de Notificación, o volver a cargar la IU para que tenga efecto."
L.General_MiscHeader					= "Misceláneo"
L.General_ATrackerDisable				= "Desactivar rastreador de actividad"
L.General_ATrackerDisableTip			= "Desactiva la visualización de estado para actividades como Dungeon Finder y Battlegrounds."

-- settings: attributes tab (2)
L.AttributesFadeMin						= "Visibilidad: cuando está lleno"
L.AttributesFadeMinTip					= "Establezca cuán opacas deberían ser las barras de atributos cuando el atributo está lleno. Al 100%, las barras serán completamente visibles y al 0%, serán invisibles.\n\nLa configuración de la interfaz de usuario predeterminada es 0%."
L.AttributesFadeMax						= "Visibilidad: cuando no está lleno"
L.AttributesFadeMaxTip					= "Establezca qué tan opacas deberían ser las barras de atributos cuando el atributo no está lleno (por ejemplo, resistencia al correr). Al 100%, las barras serán completamente visibles y al 0%, serán invisibles.\n\nLa configuración de la interfaz de usuario predeterminada es 100%."
L.AttributesLockSize					= "Tamaño del atributo de bloqueo"
L.AttributesLockSizeTip					= "Establece si el tamaño de los atributos está bloqueado para que no cambien cuando ganas vida o potencia extra.\n\nLa configuración de la interfaz de usuario predeterminada está desactivada."
L.AttributesCombatBars					= "Visibilidad: En Combate."
L.AttributesCombatBarsTip				= "Siempre use la visibilidad 'Cuando no esté lleno' en combate."
L.AttributesOverlayHealth				= "Texto superpuesto: Salud"
L.AttributesOverlayMagicka				= "Texto superpuesto: Magia"
L.AttributesOverlayStamina				= "Texto superpuesto: aguante"
L.AttributesOverlayFormatTip			= "Defina cómo mostrar el texto de superposición para esta barra de atributos.\n\nLa configuración de la interfaz de usuario predeterminada es Sin superposición."

-- settings: target tab (3)
L.TargetLockSize						= "Tamaño objetivo de bloqueo"
L.TargetLockSizeTip						= "Establezca si el tamaño de la barra de destino está bloqueado para que no cambie cuando se dirige a alguien con salud adicional.\n\nLa configuración de la interfaz de usuario predeterminada es Desactivado."
L.TargetRPName							= "Ocultar el @Accountname de Target"
L.TargetRPNameTip						= "No muestre la etiqueta @accountname en el marco de destino. NOTA: Si eliges 'Preferir ID de usuario' en la configuración de Nombre de pantalla de las opciones de Interfaz del juego, esto ocultará el nombre del personaje normal."
L.TargetRPTitle							= "Ocultar título de destino"
L.TargetRPTitleTip						= "Ocultar el título del jugador objetivo."
L.TargetRPTitleWarn						= "Requiere una recarga de la interfaz de usuario."
L.TargetRPInteract						= "Ocultar Interacción @Accountname"
L.TargetRPInteractTip					= "No muestres la etiqueta @accountname en el cuadro de interacción del jugador."
L.TargetColourByBar						= "Barra de salud de Color Target"
L.TargetColourByBarTip					= "Establece si la barra de salud del objetivo está coloreada por disposición (reacción) o dificultad (nivel)."
L.TargetColourByName					= "Nombre del objetivo de color"
L.TargetColourByNameTip					= "Establece si la placa de identificación del objetivo está coloreada por disposición (reacción) o dificultad (nivel)."
L.TargetColourByLevel					= "Nivel de objetivo de color por dificultad"
L.TargetColourByLevelTip				= "Establece si el nivel del objetivo está coloreado por su dificultad (nivel)."
L.TargetIconClassShow					= "Mostrar icono de clase para jugadores"
L.TargetIconClassShowTip				= "Establecer si mostrar el ícono de clase del jugador objetivo."
L.TargetIconClassByName					= "Mostrar icono de clase por placa de identificación"
L.TargetIconClassByNameTip				= "Establezca si el icono de la clase (si se muestra) se muestra a la izquierda de la placa de identificación del objetivo en lugar de a la izquierda de la barra de salud del objetivo."
L.TargetIconAllianceShow				= "Mostrar icono de alianza para jugadores"
L.TargetIconAllianceShowTip				= "Establecer si mostrar el ícono de alianza del jugador objetivo."
L.TargetIconAllianceByName				= "Mostrar icono de alianza por placa de identificación"
L.TargetIconAllianceByNameTip			= "Establezca si el icono de alianza (si se muestra) se muestra a la derecha de la placa de identificación del objetivo en lugar de a la derecha de la barra de salud del objetivo."
L.TargetOverlayFormatTip				= "Configure cómo mostrar el texto de superposición para la barra de destino.\n\nLa configuración de la interfaz de usuario predeterminada es Sin superposición."
L.BossbarHeader							= "Configuración de Bossbar"
L.BossbarOverlayFormatTip				= "Establecer cómo mostrar el texto de superposición para la barra de jefe. La barra de jefe muestra la suma de los valores de salud para todos los jefes activos.\n\nLa configuración de la interfaz de usuario predeterminada es Sin superposición."

-- settings: action bar tab (4)
L.ActionBarHideBindBG					= "Ocultar fondo de encuadernación"
L.ActionBarHideBindBGTip				= "Establecer si el fondo oscuro detrás de los enlaces de teclas de la barra de acción es visible."
L.ActionBarHideBindText					= "Ocultar texto de encuadernación"
L.ActionBarHideBindTextTip				= "Establece si el texto de enlace de teclado debajo de las barras de acción es visible."
L.ActionBarHideWeaponSwap				= "Ocultar icono de intercambio de armas"
L.ActionBarHideWeaponSwapTip			= "Establecer si el icono de intercambio de armas entre las teclas de acceso rápido y la ranura rápida es visible."
L.ActionBarOverlayShow					= "Mostrar superposición"
L.ActionBarOverlayUltValue				= "Texto superpuesto: último (valor)"
L.ActionBarOverlayUltValueShowTip		= "Establezca si desea mostrar una superposición encima del último botón que muestra su nivel máximo actual."
L.ActionBarOverlayUltValueShowCost		= "Mostrar Costo de Habilidad"
L.ActionBarOverlayUltValueShowCostTip	= "Establezca si la superposición muestra solo su nivel final actual o el costo final de nivel / capacidad."
L.ActionBarOverlayUltPercent			= "Texto superpuesto: Ultimate (Porcentaje)"
L.ActionBarOverlayUltPercentShowTip		= "Establezca si desea mostrar una superposición sobre el último botón que muestra su nivel final como un porcentaje."
L.ActionBarOverlayUltPercentRelative	= "Mostrar porcentaje relativo"
L.ActionBarOverlayUltPercentRelativeTip	= "Establezca si el porcentaje que se muestra en la superposición es relativo al costo de su habilidad final ranurada en lugar de un porcentaje de su grupo final máximo de 500 puntos."

-- settings: experience bar tab (5)
L.ExperienceDisplayStyle				= "Estilo de visualización"
L.ExperienceDisplayStyleTip				= "Defina cómo mostrar la barra de experiencia.\n\nNota: Incluso cuando Siempre se muestra, la barra se ocultará mientras se elabora y cuando el Mapa del mundo está abierto para no superponerse a otras ventanas."
L.ExperienceOverlayFormatTip			= "Configure cómo mostrar el texto de superposición para la barra de experiencia.\n\nLa configuración de la interfaz de usuario predeterminada es Sin superposición."

-- settings: bag watcher tab (6)
L.Bag_Desc								= "El observador de bolsas crea una barra (similar a la barra de experiencia en apariencia) que muestra qué tan llena está su mochila. Se mostrará brevemente cada vez que cambie el contenido de su bolsa y, opcionalmente, se puede configurar para que siempre muestre si su bolsa está casi llena."
L.Bag_Enable							= "Habilitar observador de bolsa"
L.Bag_ReverseAlignment					= "Alineación de barra inversa"
L.Bag_ReverseAlignmentTip				= "Establece si se invierte la dirección de la barra haciéndola aumentar hacia la derecha. Esto también colocará el icono en el lado opuesto de la barra."
L.Bag_LowSpaceLock						= "Mostrar siempre cuando hay poco espacio"
L.Bag_LowSpaceLockTip					= "Establezca si se debe mostrar siempre el observador de la bolsa cuando su mochila esté casi llena."
L.Bag_LowSpaceTrigger					= "Bajo nivel de disparo en el espacio"
L.Bag_LowSpaceTriggerTip				= "Establece cuántas ranuras deben permanecer libres antes de considerar que tu mochila tiene poco espacio."

-- settings: werewolf tab (7)
L.Werewolf_Desc							= "El temporizador de hombre lobo es una ventana (móvil) separada que muestra el tiempo restante de transformación del hombre lobo en segundos para una manera más fácil de hacer un seguimiento de cuánto tiempo tienes para cazar. Inicialmente se coloca justo a la derecha del botón final."
L.Werewolf_Enable						= "Habilitar temporizador de hombre lobo"
L.Werewolf_Flash						= "Extensión de Flash On Time"
L.Werewolf_FlashTip						= "Establece si el icono del temporizador debe parpadear brevemente cuando aumente el tiempo restante en tu transformación."
L.Werewolf_IconOnRight					= "Mostrar icono a la derecha"
L.Werewolf_IconOnRightTip				= "Establezca si desea que el icono se muestre a la derecha del temporizador en lugar de a la izquierda."

-- settings: profiles tab (8)
L.Profile_Desc							= "La configuración de los perfiles se puede administrar aquí, incluida la opción de habilitar un perfil de cuenta amplia que aplicará la misma configuración a TODOS los caracteres en esta cuenta. Debido a la permanencia de estas opciones, la administración debe habilitarse primero mediante la casilla de verificación en la parte inferior del panel."
L.Profile_UseGlobal						= "Usar cuenta de perfil ancho"
L.Profile_UseGlobalWarn					= "El cambio entre los perfiles locales y globales volverá a cargar la interfaz."
L.Profile_Copy							= "Seleccione un perfil para copiar"
L.Profile_CopyTip						= "Seleccione un perfil para copiar sus configuraciones al perfil actual activo. El perfil activo será para el carácter de inicio de sesión o el perfil de la cuenta si está habilitado. La configuración de perfil existente se sobrescribirá permanentemente.\n\nEsto no se puede deshacer."
L.Profile_CopyButton					= "Copiar perfil"
L.Profile_CopyButtonWarn				= "Copiar un perfil volverá a cargar la interfaz."
L.Profile_Delete						= "Seleccione un perfil para eliminar"
L.Profile_DeleteTip						= "Seleccione un perfil para eliminar su configuración de la base de datos. Si ese carácter se registra más tarde y no está utilizando el perfil de toda la cuenta, se crearán nuevas configuraciones predeterminadas.\n\n¡Eliminar un perfil es permanente!"
L.Profile_DeleteButton					= "Borrar perfil"
L.Profile_Guard							= "Habilitar la gestión de perfiles"

------------------------------------------------------------------------------------------------------------------

if (GetCVar('language.2') == 'es') then -- overwrite GetLanguage for new language
	for k, v in pairs(Azurah:GetLocale()) do
		if (not L[k]) then -- no translation for this string, use default
			L[k] = v
		end
	end
	function Azurah:GetLocale() -- set new language return
		return L
	end
end
