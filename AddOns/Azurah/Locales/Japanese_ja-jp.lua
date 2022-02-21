local Azurah							= _G['Azurah'] -- grab addon table from global
local L = {}

------------------------------------------------------------------------------------------------------------------
-- Japanese
-- (Non-indented lines still require human translation and may not make sense!)
------------------------------------------------------------------------------------------------------------------

L.Azurah								= "|c67b1e9A|c4779cezurah|r"
L.Usage									= "|c67b1e9A|c4779cezurah|r - 使用法:\n|cffc600  /azurah unlock|r |cffffff =  移動のためにUIのロックを解除します|r\n|cffc600  /azurah save|r |cffffff =  UIをロックして位置を保存します|r\n|cffc600  /azurah undo|r |cffffff =  すべての保留中の変更を元に戻す|r\n|cffc600  /azurah exit|r |cffffff =  保存せずにUIをロックする|r"
L.ThousandsSeparator					= "," -- used to separate large numbers in overlays
L.TheftBlocked							= "|c67b1e9A|c4779cezurah|r - あなたの設定のために盗難が防止されました。"

-- move window names
L.Health								= "プレイヤーヘルス"
L.HealthSiege							= "攻城兵器ヘルス"
L.Magicka								= "プレイヤーマジカ"
L.Werewolf								= "ウェアウルフタイマー"
L.Stamina								= "プレイヤースタミナ"
L.StaminaMount							= "マウントスタミナ"
L.Experience							= "経験値バー"
L.EquipmentStatus						= "機器ステータス"
L.Synergy								= "シナジー"
L.Compass								= "コンパス"
L.ReticleOver							= "ターゲットヘルス"
L.ActionBar								= "アクションバー"
L.PetGroup								= "ペットの生活のグループ"
L.Group									= "グループメンバー"
L.Raid1									= "レイドグループ１"
L.Raid2									= "レイドグループ2"
L.Raid3									= "レイドグループ3"
L.Raid4									= "レイドグループ4"
L.Raid5									= "レイドグループ5"
L.Raid6									= "レイドグループ6"
L.FocusedQuest							= "クエストトラッカー"
L.PlayerPrompt							= "プレイヤーインタラクトプロンプト"
L.AlertText								= "テキスト通知アラート"
L.CenterAnnounce						= "オンスクリーン通知"
L.InfamyMeter							= "賞金表示"
L.TelVarMeter							= "Tel Var表示"
L.ActiveCombatTips						= "アクティブ戦闘ヒント"
L.Tutorial								= "チュートリアル"
L.CaptureMeter							= "AvAキャプチャメーター"
L.BagWatcher							= "バッグ監視"
L.WerewolfTimer							= "ウェアウルフタイマー"
L.LootHistory							= "ルート履歴"
L.RamSiege								= "ラム勝利"
L.Subtitles								= "字幕"
L.PaperDoll								= "紙人形"
L.QuestTimer							= "クエストタイマー"
L.PlayerBuffs							= "プレイヤーバフ/デバフ"
L.TargetDebuffs							= "ターゲットデバフ"
L.Reticle								= "レチクル"
L.Interact								= "インタラクトテキスト"
L.BattlegroundScore						= "バトルグラウンドスコア"
L.DialogueWindow						= "対話ウィンドウ"
L.StealthIcon							= "ステルスアイコン"
L.WykkydReticle							= "Wykkyd Full Immersionによって管理されるレチクルフレームのスケール"
L.WykkydSubtitles						= "Wykkyd Full Immersionによって管理される字幕スケール"

-- --------------------------------------------
-- SETTINGS -----------------------------------
-- --------------------------------------------

-- dropdown menus
L.DropOverlay1							= "オーバーレイ無し"
L.DropOverlay2							= "全て表示"
L.DropOverlay3							= "値と最大値"
L.DropOverlay4							= "値とパーセンテージ"
L.DropOverlay5							= "値のみ"
L.DropOverlay6							= "パーセンテージのみ"
L.DropColourBy1							= "デフォルト"
L.DropColourBy2							= "反応"
L.DropColourBy3							= "レベル"
L.DropExpBarStyle1						= "デフォルト"
L.DropExpBarStyle2						= "常に表示"
L.DropExpBarStyle3						= "常に非表示"
L.DropHAlign1							= "自動"
L.DropHAlign2							= "左揃え"
L.DropHAlign3							= "右揃え"
L.DropHAlign4							= "中心"

-- tabs
L.TabButton1							= "一般"
L.TabButton2							= "能力"
L.TabButton3							= "ターゲット"
L.TabButton4							= "アクションバー"
L.TabButton5							= "経験値"
L.TabButton6							= "バッグ監視"
L.TabButton7							= "ウェアウルフ"
L.TabButton8							= "プロファイル"
L.TabHeader1							= "一般設定"
L.TabHeader2							= "プレイヤー能力設定"
L.TabHeader3							= "ターゲットウィンドウ設定"
L.TabHeader4							= "アクションバー設定"
L.TabHeader5							= "経験値バー設定"
L.TabHeader6							= "バッグ監視設定"
L.TabHeader7							= "ウェアウルフタイマー設定"
L.TabHeader8							= "プロファイル設定"

-- unlock window
L.UnlockHeader							= "UIはアンロック中"
L.ChangesPending						= "|cffffff変更が保留中です！|r\n|cffff00保存するには、'UIウィンドウをロック'をクリックします。|r\n保存されていない変更はリロード時に失われます。"
L.UnlockGridEnable						= "グリッドにスナップするのを有効化"
L.UnlockGridDisable						= "グリッドにスナップするのを無効化"
L.UnlockLockFrames						= "UIウィンドウをロック"
L.UndoChanges							= "変更を元に戻します"
L.ExitNoSave							= "セーブせずに終了する"
L.UnlockReset							= "デフォルトにリセット"
L.UnlockResetConfirm					= "リセットを確定"

-- settings: generic
L.SettingOverlayFormat					= "オーバーレイフォーマット"
L.SettingOverlayShield					= "シールド・ヘルス"
L.SettingOverlayShieldTip				= "シールドの現在の状態が含まれます。"
L.SettingOverlayFancy					= "桁区切りを表示"
L.SettingOverlayFancyTip				= "桁数が大きい場合桁区切りをオーバーレイに表示するかを設定します。\n\n例：10000は10' .. L.ThousandsSeparator .. '000になります。"
L.SettingOverlayFont					= "オーバレイテキストフォント"
L.SettingOverlayStyle					= "オーバーレイテキストカラー&スタイル"
L.SettingOverlaySize					= "オーバーレイテキストサイズ"

-- settings: general tab (1)
L.GeneralAnchorDesc						= "ロックを解除すると、マウスを使用してUIウィンドウをドラッグし、スクロールホイールを使用してサイズを調整できます。 ロックされていないUIウィンドウごとにオーバーレイが表示され、現在表示されていない場合でもウィンドウが再配置されます（ターゲットがない場合はターゲットの状態など）。\n\nロックすると変更が保存されます。 '変更を元に戻します' をクリックすると、ウィンドウがロック解除されてからのすべての変更がリセットされます。 1つのウィンドウを右クリックすると、そのウィンドウだけの変更がリセットされます。"
L.GeneralAnchorUnlock					= "UIウィンドウをアンロック"
L.GeneralCompassPins					= "コンパスピン"
L.GeneralPinScale						= "コンパスピンサイズ"
L.GeneralPinScaleTip					= "コンパスピンのどれくらいの大きさであるべきかを設定します。コンパスそのもののサイズからは独立したサイズで、ウィンドウUIがアンロックされている場合変更することができます。\n\n100はデフォルトサイズの100%を意味します。（変更なし）"
L.GeneralPinLabel						= "コンパスピンテキストを非表示"
L.GeneralPinLabelTip					= "現在のピンターゲットを識別するテキストを非表示にします。（例：現在向いているクエストマーカー名）\n\nデフォルトUI設定はOFFです。"
L.General_TheftHeader					= "窃盗"
L.General_TheftPrevent					= "ワールドアイテムを不慮に盗んでしまうのを防ぐ"
L.General_TheftPreventTip				= "世界に展示されている所有アイテムの略奪を防ぐかどうかを設定します。 これには、武器や武器、食糧など、すべての武器が含まれます。\n\nこれは略奪用容器に対する保護を提供しないことに注意してください。"
L.General_TheftSafer					= "より安全なワールドアイテムの窃盗"
L.General_TheftSaferTip					= "完全に非表示にしたときに所有アイテムの盗難を再度有効にするかどうかを設定します。\n\nこれは略奪用容器に対する保護をまだ提供していないことに注意してください。"
L.General_CTheftSafer					= "コンテナからのより安全な盗難"
L.General_CTheftSaferTip				= "完全に隠されていない限り、所有しているコンテナを開けないようにする"
L.General_PTheftSafer					= "より安全なピックポケット"
L.General_PTheftSaferTip				= "完全に隠されていない限り、略奪を防ぐことによってピックポケットをより安全にするかどうかを設定します。"
L.General_TheftSaferWarn				= "これは厳密にいえばチートになりますので使用には注意しましょう！"
L.General_TheftAnnounceBlock			= "盗難防止の発表"
L.General_TheftAnnounceBlockTip			= "泥棒の設定によって盗難がブロックされたときに通知するかどうかを設定します。\n\nアラートが現在のチャットウィンドウに表示されます。"
L.General_ModeChange					= "キーボード/ゲームパッドモードリロードの変更"
L.General_ModeChangeTip					= "キーボードとゲームパッドのモードを切り替えるときにUIをリロードします。 通常、モードを切り替えると、そのモードのAzurahで行われた位置の変更は、手動でUIを再読み込みするまで継続的にリセットされます。"
L.GeneralNotification					= "通知テキスト"
L.General_Notification					= "アライメントを設定する"
L.General_NotificationTip				= "通知テキストの水平方向の配置を選択します。 デフォルトでは、「自動」オプションは、通知テキストフレームの位置に基づいて、左または右のいずれかの位置合わせを設定します。"
L.General_NotificationWarn				= "この設定を変更するには、通知テキストフレームのロックを解除して移動するか、UIを再読み込みして有効にする必要があります。"
L.General_MiscHeader					= "その他"
L.General_ATrackerDisable				= "アクティビティトラッカーを無効にする"
L.General_ATrackerDisableTip			= "ダンジョンファインダーやバトルグラウンドなどのアクティビティのステータス表示を無効にします。"

-- settings: attributes tab (2)
L.AttributesFadeMin						= "可視性: フル時"
L.AttributesFadeMinTip					= "能力がフルの時の能力バーの透明度を設定します。100%時、バーは完全に表示され、0%時には非表示になります。\n\nデフォルトUI設定は0%です。"
L.AttributesFadeMax						= "可視性: 未フル時"
L.AttributesFadeMaxTip					= "能力がフルではない時の能力バーの透明度を設定します。 (例：ダッシュ時のスタミナ）100%時、バーは完全に表示され、0%時には非表示になります。\n\nデフォルトUI設定は100%です。"
L.AttributesLockSize					= "能力サイズをロック"
L.AttributesLockSizeTip					= "ボーナスヘルスやパワーを取得時能力値のサイズをロックするかどうかを設定します。\n\nデフォルトUI設定はOFFです。"
L.AttributesCombatBars					= "可視性: 戦闘中"
L.AttributesCombatBarsTip				= "常に使用 '未フル時' 戦闘中の可視性"
L.AttributesOverlayHealth				= "オーバーレイテキスト: ヘルス"
L.AttributesOverlayMagicka				= "オーバーレイテキスト: マジカ"
L.AttributesOverlayStamina				= "オーバーレイテキスト: スタミナ"
L.AttributesOverlayFormatTip			= "能力バーのオーバレイテキストをどのように表示するかを設定します。\n\nデフォルトUI設定は「オーバーレイ無し」です。"

-- settings: target tab (3)
L.TargetLockSize						= "ターゲットサイズをロック"
L.TargetLockSizeTip						= "ボーナスヘルスがある対象をターゲットしてもターゲットバーのサイズが変わらないようロックするかを設定します。\n\nデフォルトUI設定はOFFです。"
L.TargetRPName							= "ターゲットの@Accountnameを隠す"
L.TargetRPNameTip						= "@accountnameタグをターゲットフレームに表示しないでください。"
L.TargetRPTitle							= "ターゲットの@Accountnameを非表示"
L.TargetRPTitleTip						= "@accountnameタグをターゲットフレームに表示しません。"
L.TargetRPTitleWarn						= "UIは自動的にリロードされます。"
L.TargetRPInteract						= "@Accountnameインタラクトを非表示"
L.TargetRPInteractTip					= "@accountnameタグをプレイヤーインタラクトフレームに表示しません。"
L.TargetColourByBar						= "ターゲットヘルスバーカラー"
L.TargetColourByBarTip					= "ターゲットヘルスバーを感情（反応）で色づけるか、難易度（レベル）で色づけるかを設定します。"
L.TargetColourByName					= "ターゲット名前カラー"
L.TargetColourByNameTip					= "ターゲットネームプレートを感情（反応）で色づけるか、難易度（レベル）で色づけるかを設定します。"
L.TargetColourByLevel					= "ターゲットレベルを難易度で色付け"
L.TargetColourByLevelTip				= "ターゲットレベルを難易度（レベル）で色付けるかどうかを設定します。"
L.TargetIconClassShow					= "プレイヤーのクラスアイコンを表示"
L.TargetIconClassShowTip				= "ターゲットプレイヤーのクラスアイコンを表示するかを設定します。"
L.TargetIconClassByName					= "クラスアイコンをネームプレートの横に表示"
L.TargetIconClassByNameTip				= "クラスアイコン（表示されている場合）をターゲットヘルスバーの左ではなく、ターゲットネームプレートの左に表示します。"
L.TargetIconAllianceShow				= "プレイヤーの同盟アイコンを表示"
L.TargetIconAllianceShowTip				= "ターゲットプレイヤーの同盟アイコンを表示するかを設定します。"
L.TargetIconAllianceByName				= "同盟アイコンをネームプレートの横に表示"
L.TargetIconAllianceByNameTip			= "同盟アイコン（表示されている場合）をターゲットヘルスバーの左ではなく、ターゲットネームプレートの左に表示します。"
L.TargetOverlayFormatTip				= "ターゲットバーのオーバーレイテキストをどのように表示するかを設定します。\n\nデフォルトUI設定は「オーバーレイ無し」です。"
L.BossbarHeader							= "ボスバー設定"
L.BossbarOverlayFormatTip				= "ボスバーのオーバーレイテキストをどのように表示するかを設定します。ボスバーは全てのアクティブなボスの合計のヘルス値を表示します。\n\nデフォルトUI設定は「オーバーレイ無し」です。"

-- settings: action bar tab (4)
L.ActionBarHideBindBG					= "キーバインド背景を非表示"
L.ActionBarHideBindBGTip				= "アクションバーキーバインドが表示されている間、暗い背景を表示するかを設定します。"
L.ActionBarHideBindText					= "キーバインドテキストを非表示"
L.ActionBarHideBindTextTip				= "アクションバーが表示されている間、キーバインドテキストを下に表示するかを設定します。"
L.ActionBarHideWeaponSwap				= "武器切り替えアイコンを非表示"
L.ActionBarHideWeaponSwapTip			= "ホットキーとクイックスロットの間に武器切り替えアイコンを表示するかを設定します。"
L.ActionBarOverlayShow					= "オーバーレイを表示"
L.ActionBarOverlayUltValue				= "オーバーレイテキスト: ウルティメイト (値)"
L.ActionBarOverlayUltValueShowTip		= "ウルティメイトボタンの上に現在のウルティメイトレベルを表示するかを設定します。"
L.ActionBarOverlayUltValueShowCost		= "アビリティコストを表示"
L.ActionBarOverlayUltValueShowCostTip	= "現在のウルティメイトレベルのみかウルティメイトレベル/アビリティコストのオーバーレイを表示するかを設定します。"
L.ActionBarOverlayUltPercent			= "オーバーレイテキスト: ウルティメイト (パーセンテージ)"
L.ActionBarOverlayUltPercentShowTip		= "ウルティメイトボタンの上にウルティメイトレベルをパーセンテージ表示するかを設定します。"
L.ActionBarOverlayUltPercentRelative	= "相対パーセントを表示"
L.ActionBarOverlayUltPercentRelativeTip	= "最大ウルティメイトポイント（500）のパーセンテージではなく、設定したウルティメイトアビリティに相対するパーセンテージをオーバーレイに表示するかどうかを設定します。"

-- settings: experience bar tab (5)
L.ExperienceDisplayStyle				= "表示スタイル"
L.ExperienceDisplayStyleTip				= "経験値バーをどのように表示するかを設定します。\n\n「常に表示」時でもクラフト中やワールドマップを開いているときには、ほかのウィンドウに重ならないよう非表示になります。"
L.ExperienceOverlayFormatTip			= "経験値バーのオーバーレイテキストをどのように表示するかを設定します。\n\nデフォルトUI設定は「オーバーレイ無し」です。"

-- settings: bag watcher tab (6)
L.Bag_Desc								= "バッグ監視はどれくらい空き容量があるかを表示するバーを生成します。（経験値バーに見た目は似ています。）バッグの中身が変更されるとしばらく表示され、空き容量が少ない場合は常に表示することもできます。"
L.Bag_Enable							= "バッグ監視を有効"
L.Bag_ReverseAlignment					= "リバースバーアライメント"
L.Bag_ReverseAlignmentTip				= "バー方向を逆向きにし、右方向に増加するようにします。また、この設定を有効にするとバーの逆サイドにアイコンが設置されます。"
L.Bag_LowSpaceLock						= "空き容量低下時常に表示"
L.Bag_LowSpaceLockTip					= "空き容量が少ない場合、バッグ監視を常に表示するかを設定します。"
L.Bag_LowSpaceTrigger					= "空き容量低下閾値"
L.Bag_LowSpaceTriggerTip				= "空き容量低下として認識するスロット数を設定します。"

-- settings: werewolf tab (7)
L.Werewolf_Desc							= "ウェアウルフタイマーは狩りをするためあとどれくらいあるかを簡単にトラックできる、ウェアウルフの残り変身時間（秒）が表示される区別された（移動可）ウィンドウです。初期状態ではウルティメイトボタンのすぐ右に表示されます。"
L.Werewolf_Enable						= "ウェアウルフタイマーを有効化"
L.Werewolf_Flash						= "時間延長時フラッシュ"
L.Werewolf_FlashTip						= "変身の残り時間が延長した場合にタイマーアイコンをしばらくフラッシュさせるかどうかを設定します。"
L.Werewolf_IconOnRight					= "アイコンを右に表示"
L.Werewolf_IconOnRightTip				= "アイコンをタイマーの左ではなく右に表示するかを設定します。"

-- settings: profiles tab (8)
L.Profile_Desc							= "プロファイルを設定することができます。このアカウントの「全て」のキャラクターに同じ設定が適用されるアカウントプロファイルもここで有効することができます。これらのオプションはその永続性により、マネージャは最初にこのパネルの一番下にあるチェックボックスに有効にする必要があります。"
L.Profile_UseGlobal						= "アカウントプロファイルを使用する"
L.Profile_UseGlobalWarn					= "キャラ毎のプロファイルとアカウントプロファイルを切り替える場合、UIがリロードされます。"
L.Profile_Copy							= "コピーするプロファイルを選択"
L.Profile_CopyTip						= "現在有効なプロファイルにコピーしたいプロファイルを選択します。有効なプロファイルはログインしているキャラクターのものか、設定が有効になっていればアカウントプロファイルになります。現在のプロファイルは永久に上書きされます。\n\nこの操作は元に戻すことはできません！"
L.Profile_CopyButton					= "プロファイルをコピー"
L.Profile_CopyButtonWarn				= "プロファイルをコピーするとUIがリロードされます。"
L.Profile_Delete						= "プロファイルを選択して削除"
L.Profile_DeleteTip						= "プロファイルを選択するとそのプロファイルの設定をデータベースから削除されます。もしそのキャラクターが後にログインし、アカウントプロファイルを使用していない場合は、新しくデフォルトの設定が生成されます。\n\nプロファイルは永久に削除されます！"
L.Profile_DeleteButton					= "プロファイルを削除"
L.Profile_Guard							= "プロファイルマネージャを有効化"


if (GetCVar('language.2') == 'ja') or (GetCVar('language.2') == 'jp') then -- overwrite GetLanguage for new language
	for k, v in pairs(Azurah:GetLocale()) do
		if (not L[k]) then -- no translation for this string, use default
			L[k] = v
		end
	end
	function Azurah:GetLocale() -- set new language return
		return L
	end
end
