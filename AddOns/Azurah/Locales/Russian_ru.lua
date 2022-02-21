local Azurah							= _G['Azurah'] -- grab addon table from global
local L = {}

------------------------------------------------------------------------------------------------------------------
-- Russian (Thanks to ESOUI.com user GJSmoker for the translations.)
-- (Non-indented lines may still require human translation.)
------------------------------------------------------------------------------------------------------------------

L.Azurah = "|c67b1e9A|c4779cezurah|r"
L.Usage = "|c67b1e9A|c4779cezurah|r - Употребление:\n|cffc600 /azurah unlock|r |cffffff = разблокировать UI для движения|r\n|cffc600 /azurah save|r |cffffff = зажим UI и сохранить позиции|r\n|cffc600 /azurah undo|r |cffffff = отменить все ожидающие изменения|r\n|cffc600 /azurah exit|r |cffffff = блокировка UI без сохранения|r"
L.ThousandsSeparator = "," -- used to separate large numbers in overlays
L.TheftBlocked = "|c67b1e9A|c4779cezurah|r - Предотвращение кражи 'Azurah'."

-- move window names
L.Health = "Здоровье"
L.HealthSiege = "Прочность"
L.Magicka = "Магия"
L.Werewolf = "Таймер оборотня"
L.Stamina = "Запас сил"
L.StaminaMount = "Выносливость"
L.Experience = "Панель опыта"
L.EquipmentStatus = "Прочность экипировки"
L.Synergy = "Синергия"
L.Compass = "Компас"
L.ReticleOver = "Здоровье цели"
L.ActionBar = "Панель способностей"
L.PetGroup = "Здоровье призваных питомцев"
L.Group = "Участники группы"
L.Raid1 = "Рейд группа 1"
L.Raid2 = "Рейд группа 2"
L.Raid3 = "Рейд группа 3"
L.Raid4 = "Рейд группа 4"
L.Raid5 = "Рейд группа 5"
L.Raid6 = "Рейд группа 6"
L.FocusedQuest = "Квест-трекер"
L.PlayerPrompt = "Взаимодействие с другим игроком"
L.AlertText = "Предупреждения"
L.CenterAnnounce = "Системные уведомления"
L.InfamyMeter = "Дисплей очков альянса"
L.TelVarMeter = "Дисплей камней тель-вар"
L.ActiveCombatTips = "Боевые советы"
L.Tutorial = "Руководство"
L.CaptureMeter = "Состояние захвата территории"
L.BagWatcher = "Контроль инвентаря"
L.WerewolfTimer = "Таймер оборотня"
L.LootHistory = "История подбора"
L.RamSiege = "Победы Рама"
L.Subtitles = "Субтитры"
L.PaperDoll = "Бумажная кукла"
L.QuestTimer = "Квест-таймер"
L.PlayerBuffs = "Баффы игроков/Дебаффы"
L.TargetDebuffs = "Дебафы цели"
L.Reticle = "Прицел"
L.Interact = "Взаимодействие"
L.BattlegroundScore = "Счет батлграунда"
L.DialogueWindow = "Диалоговое окно"
L.StealthIcon = "Скрытность"
L.WykkydReticle = "Шкала растровых рамок, управляемая Wykkyd Full Immersion"
L.WykkydSubtitles = "Масштаб субтитров, управляемый Wykkyd Full Immersion"

-- --------------------------------------------
-- SETTINGS -----------------------------------
-- --------------------------------------------

-- dropdown menus
L.DropOverlay1 = "Не показывать"
L.DropOverlay2 = "Показать все"
L.DropOverlay3 = "Значение и макс."
L.DropOverlay4 = "Значение и процент"
L.DropOverlay5 = "Только значение"
L.DropOverlay6 = "Только процент"
L.DropColourBy1 = "По умолчанию"
L.DropColourBy2 = "По атрибутам"
L.DropColourBy3 = "По уровню"
L.DropExpBarStyle1 = "По умолчанию"
L.DropExpBarStyle2 = "Всегда отображается"
L.DropExpBarStyle3 = "Всегда скрыто"
L.DropHAlign1 = "Автоматическое"
L.DropHAlign2 = "Слева"
L.DropHAlign3 = "Справа"
L.DropHAlign4 = "По центру"

-- tabs
L.TabButton1 = "Общие"
L.TabButton2 = "Игрок"
L.TabButton3 = "Цель"
L.TabButton4 = "Навыки"
L.TabButton5 = "Опыт"
L.TabButton6 = "Инвентарь"
L.TabButton7 = "Оборотень"
L.TabButton8 = "Профили"
L.TabHeader1 = "Общие настройки"
L.TabHeader2 = "Настройки панели игрока"
L.TabHeader3 = "Настройки панели цели"
L.TabHeader4 = "Настройки панели навыков"
L.TabHeader5 = "Настройки панели опыта"
L.TabHeader6 = "Настройки контроля инвентаря"
L.TabHeader7 = "Настройки таймера оборотня"
L.TabHeader8 = "Настройки профиля"

-- unlock window
L.UnlockHeader = "UI разблокирован"
L.ChangesPending = "|cffffffИзменения в ожидании!|r\n|cffff00Нажмите 'Сохранить' для сохранения.|r\nНесбалансированные изменения будут потеряны при перезагрузке."
L.UnlockGridEnable = "Сетка вкл."
L.UnlockGridDisable = "Сетка выкл."
L.UnlockLockFrames = "Сохранить"
L.UndoChanges = "Отменить"
L.ExitNoSave = "Выход"
L.UnlockReset = "По умолчанию"
L.UnlockResetConfirm = "Подтвердить сброс"

-- settings: generic
L.SettingOverlayFormat = "Формат текста"
L.SettingOverlayShield = "Мощность щита"
L.SettingOverlayShieldTip = "Включает отображение состояние мощности щита."
L.SettingOverlayFancy = "Десятичный разделитель"
L.SettingOverlayFancyTip = "Включает отображение десятичных на больших числах.\n\nНапример: 10000 станет 10,000."
L.SettingOverlayFont = "Шрифт"
L.SettingOverlayStyle = "Цвет и стиль"
L.SettingOverlaySize = "Размер"

-- settings: general tab (1)
L.GeneralAnchorDesc = "Используйте 'UI windows' для перемещения окон дисплея с помощью мыши, размер масштабируется с помощью колеса прокрутки. Оверлей будет отображать каждое разблокированное окно интерфейса и будет перемещать окна, даже если они не отображаются (Например: панель цели, если у вас нет цели).\n\nИспользуйте 'Сохранение' при внесение изменений. Щелчок 'Отменить', сбрасывает все внесенные изменения, если они небыли сохранены. Щелчок ПКМ на выбранное окно, сбрасывает в нем внесенные изменения."
L.GeneralAnchorUnlock = "UI windows"
L.GeneralCompassPins = "Шрифт Компаса"
L.GeneralPinScale = "Размер шрифта"
L.GeneralPinScaleTip = "Изменяет размер текста который идентифицирует вашу текущею цель в 'pin'. Этот размер не зависит от размера самого компаса, который может быть изменен при разблокировке UI.\n\nЗначение по умолчанию для UI\n'100'"
L.GeneralPinLabel = "Скрыть текст"
L.GeneralPinLabelTip = "Выключает отображение текста который идентифицирует вашу текущую цель в 'pin', (Например: имя маркера квеста, на которое вы в данный момент смотрите).\n\nЗначение по умолчанию для UI\n'Выкл.'"
L.General_TheftHeader = "Воровство"
L.General_TheftPrevent = "Предотвращение случайной кражи"
L.General_TheftPreventTip = "Включает предотвращение воровства предметов в мире. Это включает в себя все доспехи, оружие, пищу и т.д., Которые давали бы штраф, если вы были пойманы.\n\nПожалуйста, обратите внимание, что это не защищает от грабежей контейнеров."
L.General_TheftSafer = "Безопасное воровство предметов мира"
L.General_TheftSaferTip = "Включает предотвращение обворовывания предметов, если вы не в скрытности.\n\nОбратите внимание, что это все еще не обеспечивает защиту от обворовывания контейнеров."
L.General_CTheftSafer = "Безопасное воровство из контейнеров"
L.General_CTheftSaferTip = "Влючает предотвращение обворовывания контейнеров, если вы не в скрытности."
L.General_PTheftSafer = "Безопасные карманные кражи"
L.General_PTheftSaferTip = "Влючает предотвращение карманной кражи, если вы не в скрытности."
L.General_TheftSaferWarn = "Это технически обман!"
L.General_TheftAnnounceBlock = "Предупреждение при предотвращении кражи"
L.General_TheftAnnounceBlockTip = "Включает предупреждение, когда попытка кражи блокируется вашими настройками воровства.\n\nВ текущем окне чата появится предупреждение."
L.General_ModeChange = "Включить режим геймпада"
L.General_ModeChangeTip = "Перезагружает UI при переключении между режимами клавиатуры и геймпада. Обычно, если вы переключаете режимы, изменения положения, сделанные в Azurah для этого режима, будут постоянно перезагружаться, пока ручная перезагрузка UI."
L.GeneralNotification = "Текст уведомлений"
L.General_Notification = "Выравнивание"
L.General_NotificationTip = "Варианты выравнивание горизонтального текста для уведомлений. По умолчанию опция 'Автоматическое' выравнивнивает влево или вправо в зависимости от положения окна Notification Text."
L.General_NotificationWarn = "Изменения этого параметра требуют разблокировки и перемещения кадра Notification Text или перезагрузки UI."
L.General_MiscHeader = "Разное"
L.General_ATrackerDisable = "Скрыть отслеживание активности"
L.General_ATrackerDisableTip = "Отключает отображение статуса для таких действий, как поиск подземелий и батлграунда."

-- settings: attributes tab (2)
L.AttributesFadeMin = "Прозрачность: заполненных атрибутов"
L.AttributesFadeMinTip = "Изменяет прозрачность текущего окна атрибутов, когда они заполненны.\nПри значение '100' полосы будут полностью видны, при '0' они будут прозрачны.\n\nЗначение по умолчанию для UI\n'0'"
L.AttributesFadeMax = "Прозрачность: опустошенных атрибутов"
L.AttributesFadeMaxTip = "Изменяет прозрачность текущего окна атрибутов, когда они опустошены.\nПри значение '100' полосы будут полностью видны, при '0' они будут прозрачны.\n\nЗначение по умолчанию для UI\n'100'"
L.AttributesLockSize = "Заблокировать размер атрибутов"
L.AttributesLockSizeTip = "Отключает изменение размера атрибутов, когда вы получаете бонусное здоровье или усиление.\n\nЗначение по умолчанию для UI\n'Откл.'"
L.AttributesCombatBars = "Прозрачность: в бою"
L.AttributesCombatBarsTip = "Включает прозрачность 'опустошенных атрибутов' в бою."
L.AttributesOverlayHealth = "Здоровье"
L.AttributesOverlayMagicka = "Магия"
L.AttributesOverlayStamina = "Запас сил"
L.AttributesOverlayFormatTip = "Варианты отображения текста на панели атрибутов.\n\nЗначение по умолчанию для UI\n'Не показывать'"

-- settings: target tab (3)
L.TargetLockSize = "Заблокировать размер атрибутов"
L.TargetLockSizeTip = "Отключает изменение размера атрибутов, когда цель получает бонусное здоровье или усиление.\n\nЗначение по умолчанию для UI\n'Откл.'"
L.TargetRPName = "Скрыть UserID"
L.TargetRPNameTip = "Отключает отображение UserID других игроков.\n\nПРИМЕЧАНИЕ. Если вы включите 'Имя персонажа' в настройках игры 'Настройки > Интерфейс', это полностью скроет UserID."
L.TargetRPTitle = "Скрыть титул"
L.TargetRPTitleTip = "Отключает отображение титула других игроков."
L.TargetRPTitleWarn = "Требуется перезагрузка UI."
L.TargetRPInteract = "Скрыть взаимодействие UserID"
L.TargetRPInteractTip = "Отключает отображение UserID в окне взаимодействия."
L.TargetColourByBar = "Цветная панель"
L.TargetColourByBarTip = "Варианты окраски панели здоровья.\n'По атрибутам' \n'По уровню'"
L.TargetColourByName = "Цвет имени"
L.TargetColourByNameTip = "Варианты окраски имени.\n'По атрибутам'\n'По уровню'"
L.TargetColourByLevel = "Цвет цели"
L.TargetColourByLevelTip = "Включает окраску цели, по его сложности"
L.TargetIconClassShow = "Иконка класса"
L.TargetIconClassShowTip = "Включает отображение иконки класса."
L.TargetIconClassByName = "Переместить иконку класса "
L.TargetIconClassByNameTip = "Перемещает иконку класса слева от имени, а не слева от панели здоровья."
L.TargetIconAllianceShow = "Иконка альянса"
L.TargetIconAllianceShowTip = "Включает отображение иконки альянса."
L.TargetIconAllianceByName = "Переместить иконку альянса"
L.TargetIconAllianceByNameTip = "Перемещает иконку альянса справа от таблички имени, а не справа от панели здоровья."
L.TargetOverlayFormatTip = "Варианты отображения текста на панели цели.\n\nЗначение по умолчанию для UI\n'Не показывать'"
L.BossbarHeader = "Босс"
L.BossbarOverlayFormatTip = "Варианты отображения текста на панели босса.\n\nЗначение по умолчанию для UI\n'Не показывать'"

-- settings: action bar tab (4)
L.ActionBarHideBindBG = "Скрыть фона клавиатуры"
L.ActionBarHideBindBGTip = "Выключает отображение темного фона, на горячих клавишах, под панелью навыков."
L.ActionBarHideBindText = "Скрыть горячие клавиши"
L.ActionBarHideBindTextTip = "Выключает отображаение горячих клавиш, под панелью навыков."
L.ActionBarHideWeaponSwap = "Скрыть иконку набора"
L.ActionBarHideWeaponSwapTip = "Выключает отображение иконки экипированного набора оружия, между горячими клавишами и быстрым слотом."
L.ActionBarOverlayShow = "Показать надпись"
L.ActionBarOverlayUltValue = "Суперспособность (в очках)"
L.ActionBarOverlayUltValueShowTip = "Включает отображение уровня заряда суперспособности, в очках."
L.ActionBarOverlayUltValueShowCost = "Показывать стоимость суперспособность"
L.ActionBarOverlayUltValueShowCostTip	= "Включает отображение максимального уровня заряда для суперспособности."
L.ActionBarOverlayUltPercent = "Суперспособность (в процентах)"
L.ActionBarOverlayUltPercentShowTip = "Включает отображение уровня заряда суперспособности, в процентах."
L.ActionBarOverlayUltPercentRelative	= "Показать относительный процент"
L.ActionBarOverlayUltPercentRelativeTip	= "Измененяет вид процента, показанный на оверлее, относительно стоимости вашей суперспособности, а не в процентах от вашего максимального максимального пула 500 очков."

-- settings: experience bar tab (5)
L.ExperienceDisplayStyle = "Отображать панель"
L.ExperienceDisplayStyleTip = "Варианты отображения панели опыта.\n\nПримечание: даже когда всегда отображается, панель будет скрыта во время обработки и когда открывается Карта мира, чтобы не перекрывать другие окна."
L.ExperienceOverlayFormatTip = "Варианты отображения текста на панели опыта.\n\n\Значение по умолчанию для UI\n'Не показывать'"

-- settings: bag watcher tab (6)
L.Bag_Desc = "Контроль сумки создает окно (похожие на панель опыта по внешнему виду), которое показывает, насколько заполнен инвентарь. Он будет отображаться вкратце всякий раз, когда содержимое вашего инвентаря меняется, и при необходимости может быть установлено, чтобы всегда показывал, если ваш инвентарь почти заполнен."
L.Bag_Enable = "Отображать контроль сумки"
L.Bag_ReverseAlignment = "Инвертировать панель"
L.Bag_ReverseAlignmentTip = "Перемещает иконку на противоположную сторону панели."
L.Bag_LowSpaceLock = "Показывать при заполненном инвентаре"
L.Bag_LowSpaceLockTip = "Включает отображение окна, когда ваш инвентарь почти заполнен."
L.Bag_LowSpaceTrigger = "Заполненный инвентарь призывает спутника"
L.Bag_LowSpaceTriggerTip = "Задает количество свободных слотов, прежде чем рассматривать ваш инвентарь как заполненный."

-- settings: werewolf tab (7)
L.Werewolf_Desc = "Таймер оборотня представляет собой отдельное (подвижное) окно, которое отображает оставшееся время преобразования оборотня в секундах для более легкого способа отслеживать, сколько времени вам нужно для охоты. Он первоначально размещен справа от суперспособности."
L.Werewolf_Enable = "Отображать таймера оборотня"
L.Werewolf_Flash = "Мигать по времени"
L.Werewolf_FlashTip = "Включает кратковременное мигание иконки таймера, когда время, оставшееся при вашей преобразование, увеличивается."
L.Werewolf_IconOnRight = "Переместить иконку"
L.Werewolf_IconOnRightTip = "Перемещает иконку справа от таймера, а не слева."

-- settings: profiles tab (8)
L.Profile_Desc = "Здесь можно управлять настройками профилей, включая возможность включения профиля расширенной учетной записи, который будет применять те же настройки для ВСЕХ персонажей учетной записи. Из-за постоянства этих параметров управление должно быть включено с помощью флажка в нижней части панели."
L.Profile_UseGlobal = "Использовать профиль учетной записи"
L.Profile_UseGlobalWarn = "Переключение между локальным и глобальным профилями перезагрузит UI."
L.Profile_Copy = "Выберите профиль для копирования"
L.Profile_CopyTip = "Выберите профиль, чтобы скопировать его настройки в текущий активный профиль. Активный профиль будет отображаться как при входе на персонажа, так и в профиле учетной записи, если он включен. Существующие настройки профиля будут постоянно перезаписаны.\n\nЭто нельзя отменить!"
L.Profile_CopyButton = "Копировать профиль"
L.Profile_CopyButtonWarn = "Копирование профиля перезагрузит UI."
L.Profile_Delete = "Выберите профиль для удаления"
L.Profile_DeleteTip = "Выберите профиль, чтобы удалить его настройки из базы данных. Если этот персонаж создан ранее, и вы не используете профиль расширенной учетной записи, будут созданы новые настройки по умолчанию.\n\nНастройка профиля постоянна!"
L.Profile_DeleteButton = "Удалить профиль"
L.Profile_Guard = "Включить управление профилем"

------------------------------------------------------------------------------------------------------------------

if (GetCVar('language.2') == 'ru') then -- overwrite GetLanguage for new language
	for k, v in pairs(Azurah:GetLocale()) do
		if (not L[k]) then -- no translation for this string, use default
			L[k] = v
		end
	end
	function Azurah:GetLocale() -- set new language return
		return L
	end
end
