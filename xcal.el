;;; -*- Mode: Emacs-Lisp -*-
;;;
;;;                     xcal.el    Ver 2.01b
;;;
;;;             Copyleft (C) Shigeki Morimoto 1994-2000
;;;
;;;                 もりもと しげき ( 森本 茂樹 )
;;;                e-mail: Shigeki@Morimo.to
;;;
;;(2012/07/17:oshiro) 「海の日」と「敬老の日」でハッピーマンデー対応
;;(2011/02/28:oshiro) xcal-next-day で呼ばれるxcal-1内での next-line を forward-line へ変更（行が画面を超える場合の停止を回避）
;;(2001/01/12:oshiro) 週予定の一覧を追加
;;(2001/01/12:oshiro) 予定のコピー時に日付でなく実体を変数に保存
;;(2001/01/12:oshiro) underline 時の xcal-lookup-face-create を外した
;;(2000/11/30:jun) ハッピーマンデーに対応。xcal-alarm-filterを修正。
;;                 ↑この対応は「成人の日」と「体育の日」のみ？ oshiro 2012/7/17
;;(2000/11/30:isoyama) xcal-lookup-face-create のバグ修正(_ _)
;;(2000/11/28:mori) xcal.el Ver 2.0
;;(2000/11/27:isoyama) xcal-lookup-face-create のバグ修正
;;(99/06/14:mimpei) Meadow カラー出力,mew,Gnus 対応、スケジュール挿入関数追加
;;(98/11/08:matz)emacs 20.3対応、その他
;;(96/01/07:morimoto)Ver 1.01
;;(96/01/07:age) DOCSTRING 内の " を修正
;;(96/01/07:age) byte-compile 時の warning を修正
;;(94/11/17:isoyama)祝日の表示の時に改行していない(表示が重なってしまう)のを修正
;;(94/11/10:isoyama)xcal-alarm-prog が nil のときは alarm しないようにした
;;(94/11/10:isoyama)xcal-map-hook で部分的に key binding を変えられるようにした
;;(94/10/05;morimoto)Ver 1.00 ！ 完成 
;;(94/10/05;morimoto)underline の処理を変更
;;(94/10/04;morimoto)Ｘ使用時にアラームを表示
;;(94/10/04;morimoto)スケジュールに応じた色を表示
;;(94/10/04;morimoto)祝日と記念日の曜日の色を自由に設定できるように修正
;;(94/10/04;morimoto)曜日の色を自由に設定できるように修正
;;(94/09/28;morimoto)編集中に別の日を編集しようとしたときの処理を追加
;;(94/09/27;yoneda)xcalendar コンパチファイルモードを追加
;;(94/09/27;kawabata)月末の休日が反転しなかったのを修正
;;(94/09/21;morimoto)copy & yank を追加
;;(94/09/20;morimoto)デフォルトディレクトリを ~/Calendar に修正
;;(94/09/19;morimoto)春分・秋分の日を自動生成
;;(94/09/19;n_saitoh)祝日と記念日が重なった時の表示を修正
;;(94/09/12;morimoto)mouse オペレーションを作成(mouse-1 で移動 double-mouse-1 で編集)
;;(94/08/25;morimoto)Emacs-19 専用に変更
;;(94/08/05;morimoto)日本語文字列長さをちゃんと計算するようにした
;;                 <HANDA.93Dec2212655@etlken.etl.go.jp> を 参考にしました
;;(93/11/18;morimoto)mule用に改造した
;;(93/09/06:isoyama)calendarの今日の数字を反転させるようにした。
;;(93/08/27:isoyama)epoch用に改造した
;;(93/08/26:isoyama)月、曜日の表示を日本語にした。cal.elも同様に修正した。
;;
;;
;;    Special thanks to いそやまさん
;;        

	;
;;
;;;
;;; この software の配布、使用がいかなる結果を引き起こすことに
;;; なっても NO WARRANTY です。
;;;
;;; 配布、使用条件は GNU General Public Licence に基づきます。
;;;
;;; おかしなところを おしえてもらえると うれしいです。
;;;
;;
	;

;;
;;
;; xcal.el は xcal みたいな感じで、Emacs にカレンダーを表示します。
;; * 閏年の計算は、ややこしかったので calendar.el を使っています。
;;
;;
;; 使い方
;;
;;   M-x xcal で立ち上がります。
;;
;;   X モード
;;      移動             左ボタン       xcal-mouse-set-point
;;      編集             左ボタンダブル xcal-mouse-set-point-edit
;;
;;
;;      前月             <              xcal-before
;;      次月             >              xcal-next
;;      上               p              xcal-previous-day
;;      下               n              xcal-next-day
;;      今日             ~              xcal
;;      編集             e              xcal-edit-for-xcal
;;      週間予定         W              xcal-edit-for-xcal-week
;;      週と月の切り換え w              xcal-toggle-disp-month-and-week
;;      削除             d              xcal-delete-file
;;      終了             q              xcal-quit
;;      スクロールアップ C-v            xcal-scroll-up
;;      スクロールダウン C-z            xcal-scroll-down
;;      次の予定         N              xcal-next-schedule
;;      前の予定         P              xcal-previous-schedule
;;      祝日表示ON/OFF   t              xcal-toggle-disp-holiday
;;ミニカレンダーの表示   s              xcal-toggle-show-calendar
;;      ジャンプ         J              xcal-jump
;;      コピー           M-w            xcal-copy-schedule
;;      ヤンク           C-y            xcal-yank-schedule
;;      月初             ---            xcal-goto-top-day
;;      月末             ---            xcal-goto-last-day
;;      カレンダーの出力 ---            xcal-print-out
;;
;;    編集モードのキーバインド
;;
;;      編集終了        C-cC-c           xcal-edit-cease-edit
;;         〃           C-xC-s                   〃
;;      中止            C-cC-]           xcal-edit-abort-edit
;;
;; xcal-map-hook と xcal-edit-mode-map-hook で 好きなキーバインドに設
;; 定できます。 (設定しなくても動きます。)
;;
;;  ニュース／メールから、スケジュールを取り込むことができます。
;;  例えば
;;
;;          ---- xcal 1999/5/5 begin ----
;;                森本0x20才誕生日
;;          ---- xcal end ----
;;
;;  ってなニュース／メールを表示している時に、M-o でファイルにセーブされます。
;;  また、ニュースやメールを書いているときに、C-c ! でスケジュールの
;;  雛形を挿入することができます。
;;
;;
;; .emacs に以下の行を追加して下さい。
;;
;; (autoload 'xcal "xcal" "xcal for emacs." t)
;; (autoload 'calendar-day-of-week "calendar")
;; (autoload 'gnus-to-xcal-file "xcal")
;; (autoload 'mew-to-xcal-file "xcal")
;; (autoload 'xcal-insert-template "xcal")
;;
;;
;;  キーバインド設定の例 
;;
;;(setq xcal-map-hook
;;      '(lambda ()
;;	 (define-key xcal-map "\C-b" 'xcal-before)
;;	 (define-key xcal-map "<"    'xcal-before)
;;	 (define-key xcal-map "h"    'xcal-before)
;;	 (define-key xcal-map "H"    'xcal-before)
;;	 (define-key xcal-map ">"    'xcal-next)
;;	 (define-key xcal-map "\C-f" 'xcal-next)
;;	 (define-key xcal-map "l"    'recenter)
;;	 (define-key xcal-map "L"    'xcal-next)
;;	 (define-key xcal-map "."    'xcal-1)
;;	 (define-key xcal-map "e"    'xcal-edit-for-xcal)
;;	 (define-key xcal-map "d"    'xcal-delete-file)
;;	 (define-key xcal-map "q"    'xcal-quit)
;;
;;	 (define-key xcal-map "p"     'xcal-previous-day)
;;	 (define-key xcal-map "k"     'xcal-previous-day)
;;	 (define-key xcal-map "n"     'xcal-next-day)
;;	 (define-key xcal-map "\C-m"  'xcal-next-day)
;;	 (define-key xcal-map "j"     'xcal-next-day)
;;	 (define-key xcal-map "P"     'xcal-previous-schedule)
;;	 (define-key xcal-map "\C-p"  'xcal-previous-schedule)
;;	 (define-key xcal-map "N"     'xcal-next-schedule)
;;	 (define-key xcal-map "\C-n"  'xcal-next-schedule)
;;	 (define-key xcal-map "\C-v"  'xcal-scroll-up)
;;	 (define-key xcal-map " "     'xcal-scroll-up)
;;	 (define-key xcal-map "\C-z"  'xcal-scroll-down)
;;	 (define-key xcal-map "\C-?"  'xcal-scroll-down)
;;	 (define-key xcal-map "b"     'xcal-scroll-down)
;;	 (define-key xcal-map "\C-j"  'xcal-jump)
;;	 (define-key xcal-map "t"     'xcal-toggle-disp-holiday)
;;	 (define-key xcal-map "T"     'xcal-toggle-disp-holiday)
;;	 (define-key xcal-map "s"     'xcal-toggle-show-calendar)
;;	 (define-key xcal-map "S"     'xcal-toggle-show-calendar)
;;	 (define-key xcal-map "J"     'xcal-jump)))
;;
;;  ;gnus からスケジュールを取り込む
;;  (setq gnus-Startup-hook 
;;    '(lambda ()
;;       (define-key gnus-subject-mode-map "," 'to-osaka)
;;       (define-key gnus-summary-mode-map "\M-o" 'gnus-to-xcal-file)
;;       ;Gnus でメッセージを記述しているときにスケジュールを挿入
;;       (define-key message-mode-map "\C-c!" 'xcal-insert-template)))
;;
;;  ;mh からスケジュールを取り込む
;;  (setq mh-folder-mode-hook
;;    '(lambda ()
;;        (define-key mh-folder-mode-map "\M-o" 'mh-to-xcal-file)))
;;
;;  ;mew からスケジュールを取り込む
;;  (setq mew-summary-mode-hook
;;    '(lambda ()
;;        (define-key mew-summary-mode-map "\M-o" 'mew-to-xcal-file)))
;;  ;mew でメッセージを記述しているときに、スケジュールを挿入
;;  (setq mew-draft-mode-hook
;;    '(lambda ()
;;       (define-key mew-draft-mode-map "\C-c!" 'xcal-insert-template)))
;;
;; BUG
;;   1752 年の９月以前のカレンダーは正しくありません
;;   動作がノロいです (_ _)
;;   スケジュールを取り込む所は手抜きです。他の所も手抜きに見えるでしょうが、
;;   一所懸命 作りました....
;;   メニューの 先月・次月 の動作が２ヶ月ごとすすみます
;;

(require 'calendar)
(defvar xcal-alarm-proc nil)
(defvar xcal-alarm-prog "/usr/local/bin/xcal-alarm")
(defvar xcal-alarm-countdown "0,5,10"
  "何分前にアラームを出すか , で区切って指定する")
(defvar xcal-alarm-update "10"
  "スケージュールを読み直す間隔(秒)")


(defvar xcal-directory "~/.Calendar"
  "*xcal の カレンダーディレクトリー")
(defvar xcal-schedule-xcalndar-compatible nil
  "t に設定すると xcalendar とコンパチのスケジュールファイルをアクセスします")
(defvar xcal-print-out-command nil
  "カレンダーを出力するコマンド。標準入力から読み込むもの...
default は `lpr'")
(defvar xcal-disp-holiday t
  "カレンダーに祝日を表示するかどうか")

(defvar xcal-week-holiday '((0 "red") (6 "blue"))
  "*一週間のいつが休みか & 表示色 日曜:0 .... 土曜:6")

(defvar xcal-holiday-alist 
  '(( 1 ( 1 . "元旦"))
    ( 2 (11 . "建国記念の日"))
    ( 4 (29 . "緑の日"))
    ( 5 ( 3 . "憲法記念日")	( 4 . "国民の祝日")	( 5 . "子供の日"))
	;
	; うぉぉー 6,7,8 にも休みが欲しいぜぇ
	;
    ;( 7 (20 . "海の日"))		; できました ^_^
    ;( 9 (15 . "敬老の日"))
    (11 ( 3 . "文化の日")       (23 . "勤労感謝の日"))
    (12 (23 . "天皇誕生日")))

  "*祝日のリスト (月 (日 . \"何の日\"))
                または
                 (月 (日 . (\"何の日\" 曜日の色 名称の色)))
                 (月 (日 \"何の日\" 曜日の色 名称の色))
の形式です。")

(defvar xcal-auto-holiday-alist nil
  "春分・秋分などの自動生成した祝日のリスト")

(defvar xcal-memorial-day-alist
  '((11 (23 . "感謝祭"))
    (12 (24 . "Ｘ'mas イブ")(25 . "Ｘ'mas")))
  "*記念日のリスト")

(defvar xcal-schedule-color-list 
  '( ("休日"   "red"   nil)
     ("盆休み" "red"   nil)
     ("納期"   "green" "red")
     ("^\\*[0-9]+:[0-9].*$" nil "blue")	; *hh:mm で勤務時間を設定 (別プログラムで勤怠表作成)
     ("^.*誕生日" nil "DarkGreen")
     )
  "スケジュールの内容で 曜日の色とスケジュールの色を変更します")

;; 休日の時の曜日の色
(defvar xcal-holiday-week-color "red")

(defvar xcal-show-calendar t
  "cal.el の Calendar をひょーじするかどうか")

(defvar xcal-file nil
  "カレンダーのファイル")
(defvar xcal-days nil
  "その月が何日までか")
(defvar xcal-day-markers nil
  "日にちのマーカー")
(defvar xcal-day-schedule nil)

(defvar xcal-current-year nil)
(defvar xcal-current-month nil)
(defvar xcal-current-day nil)
(defvar xcal-month-offset 0)

(defvar xcal-map nil "XCal の キーマップ")
(defvar xcal-map-hook nil)
(defvar xcal-edit-mode-map nil "XCal の エディットモードのキーマップ")
(defvar xcal-edit-mode-map-hook nil)
(defvar xcal-keys-message nil "下に表示するキーバインド")
(defvar xcal-previous-window-configuration nil)
(defvar xcal-copy-buffer nil)
(defvar xcal-selected nil)
(defvar xcal-alarm-all-ret nil)
(defvar xcal-alarm-ret nil)
(defvar xcal-disp-week nil "週一覧表示なら t")

;;
;;
;;

(defun xcal-before ()
  "前月のひょーじ"
  (interactive)
  (xcal-1 (1- xcal-month-offset)))

(defun xcal-next ()
  "次月のひょーじ"
  (interactive)
  (xcal-1 (1+ xcal-month-offset)))

(defun xcal-toggle-disp-holiday ()
  "祝日のひょーじの ON/OFF"
  (interactive)
  (setq xcal-disp-holiday (not xcal-disp-holiday))
  (xcal-refresh))

(defun xcal-toggle-show-calendar ()
  "前後 ３ヶ月のカレンダーのひょーじ ON/OFF"
  (interactive)
  (setq xcal-show-calendar (not xcal-show-calendar))
  (xcal-refresh))

(defun xcal-edit-mode ()
  "  XCal のふぁいるのへんしゅー
\\{xcal-edit-mode-map}
"
  (if (null xcal-edit-mode-map)
      (progn
	(setq xcal-edit-mode-map (copy-keymap text-mode-map))
	(define-key xcal-edit-mode-map "\C-c\C-c" 'xcal-edit-cease-edit)
	(define-key xcal-edit-mode-map "\C-x\C-s" 'xcal-edit-cease-edit)
	(define-key xcal-edit-mode-map "\C-c\C-]" 'xcal-edit-abort-edit))
    (and xcal-edit-mode-map-hook
	 (run-hooks 'xcal-edit-mode-map-hook)))
  (use-local-map xcal-edit-mode-map)
  (setq major-mode 'xcal-edit-mode)
  (run-hooks 'text-mode-hook)
  (run-hooks 'xcal-edit-mode-hook)
  (setq mode-name "XCal Edit"))

(defun xcal-edit-for-xcal ()
  (interactive)
  (cond (xcal-disp-week
	 (setq xcal-week-select-index (1- xcal-current-day))
	 (xcal-week-select-select))
	(t
	 (xcal-day-select-select))))

(defun xcal-day-select-select ()
  (interactive)
  (if (get-buffer "*XCal Edit*")
      (progn
	(set-buffer (get-buffer "*XCal Edit*"))
	(xcal-edit-cease-edit t)))
  (set-buffer (get-buffer-create "*XCal Edit*"))
  (erase-buffer)
  (select-window (split-window-vertically (/ (window-height) 2)))
  (switch-to-buffer "*XCal Edit*")
  (xcal-edit-mode)
  (setq buffer-read-only nil)
  (set-buffer-modified-p (buffer-modified-p))
  (setq mode-line-process (format "(%d/%d/%d)" 
				  xcal-current-year
				  xcal-current-month
				  xcal-current-day))
  (setq xcal-file (xcal-file-name xcal-current-year
				  xcal-current-month
				  xcal-current-day))
  (and (file-exists-p xcal-file) (insert-file xcal-file))
  (message
   (substitute-command-keys "Editing: Type \\[xcal-edit-cease-edit] to return to XCal, \\[xcal-edit-abort-edit] to abort.")))

(defun xcal-edit-cease-edit (&optional do-not-refresh)
  (interactive)
  (goto-char (point-max))
  (delete-blank-lines)
  (if (= (point-min) (point-max)) (and (file-exists-p xcal-file)
				       (delete-file xcal-file))
    (xcal-write-region (point-min) (point-max) xcal-file))
  (let (win)
    (setq win (get-buffer-window (current-buffer)))

    (kill-buffer (current-buffer))
    (if win
	(progn
	  (select-window win)
	  (delete-window))))
  (or do-not-refresh (xcal-refresh)))


(defun xcal-edit-abort-edit ()
  (interactive)
  (kill-buffer (current-buffer))
  (delete-window)
  (pop-to-buffer "*XCal*"))

(defun xcal-quit ()
  (interactive)
  (kill-buffer "*XCal*")
  (and (get-buffer "*XCal-Calendar*")  (kill-buffer "*XCal-Calendar*"))
  (and (get-buffer "*XCal-Edit*")  (kill-buffer "*XCal-Edit*"))
  (set-window-configuration xcal-previous-window-configuration))

(defun xcal-delete-file ()
  (interactive)
  (let ((file 
	 (if xcal-disp-week (xcal-week-file-name xcal-current-day)
	   (xcal-file-name xcal-current-year
			   xcal-current-month
			   xcal-current-day))))
    (and (file-exists-p file)
	 (y-or-n-p (concat
		    (if xcal-disp-week
			(format "%s曜日"
				(nth 0 (nth (1- xcal-current-day)
					    xcal-week-schedule)))
		      (format "%s/%s/%s "
			      xcal-current-year
			      xcal-current-month
			      xcal-current-day))
		    "のスケジュールを消去します。"))
	 (progn
	   (delete-file file)
	   (xcal-refresh))))
  (xcal-show-keys))

(defun xcal-previous-day ()
  (interactive)
  (xcal-goto-day (1- xcal-current-day)))

(defun xcal-next-day ()
  (interactive)
  (xcal-goto-day (1+ xcal-current-day)))

(defun xcal-goto-top-day ()
  (interactive)
  (xcal-goto-day  1))

(defun xcal-goto-last-day ()
  (interactive)
  (xcal-goto-day xcal-days))

(defun xcal-scroll-up ()
  (interactive)
  (scroll-up)
  (let ((day 1)(p (point)))
    (while (and (<= day xcal-days)
		(< (aref xcal-day-markers day) p))
      (setq day (1+ day)))
    (xcal-goto-day day)))

(defun xcal-scroll-down ()
  (interactive)
  (scroll-down)
  (let ((day xcal-days)(p (point)))
    (while (and (<= 1 day)
		(> (aref xcal-day-markers day) p))
      (setq day (1- day)))
    (xcal-goto-day day)))

(defun xcal-mouse-set-point (event)
  (interactive "e")
  (mouse-set-point event)
  (end-of-line)
  (let ((day 1)(p (point)))
    (while (and (<= day xcal-days)
		(< (aref xcal-day-markers day) p))
      (setq day (1+ day)))
    (xcal-goto-day (1- day))))

(defun xcal-mouse-set-point-edit (event)
  (interactive "e")
  (xcal-mouse-set-point event)
  (xcal-edit-for-xcal))

(defun xcal-next-schedule ()
  (interactive)
  (let ((day (1+ xcal-current-day)))
    (while (<= day xcal-days)
      (if (aref xcal-day-schedule day)
	  (progn
	    (xcal-goto-day day)
	    (setq day (+ xcal-days 1000)))) ; ださい ？
      (setq day (1+ day)))))

(defun xcal-previous-schedule ()
  (interactive)
  (let ((day (1- xcal-current-day)))
    (while (<= 1 day)
      (if (aref xcal-day-schedule day)
	  (progn
	    (xcal-goto-day day)
	    (setq day 0)))
      (setq day (1- day)))))

(defun xcal-jump (year month day)
  (interactive (xcal-input-date))
  (let (ymd now-year now-month)
    (setq ymd (get-year-month-day))
    (setq now-year  (car ymd))
    (setq now-month (car (cdr ymd)))
    (xcal-1 (+ (* (- year now-year) 12) (- month now-month)))
    (xcal-goto-day day)))

(defun xcal-copy-schedule ()
  (interactive)
  (let (temp-buffer
	(srcFile
	 (if xcal-disp-week (xcal-week-file-name xcal-current-day)
	   (xcal-file-name
	    xcal-current-year xcal-current-month xcal-current-day))))
      (setq temp-buffer (get-buffer-create "*XCal-temp*"))
      (set-buffer temp-buffer)
      (setq buffer-read-only nil)
      (erase-buffer)

      (if (not (file-exists-p srcFile))
	  (progn
	    (message "コピー元のスケジュールがありません")
	    nil)
	(insert-file srcFile)
	(setq xcal-copy-buffer (buffer-substring (point-min) (point-max)))
	(message "スケジュールをコピーしました")
	t)))

(defun xcal-yank-schedule ()
  (interactive)
  (if (not xcal-copy-buffer)
      (error "スケジュールがコピーされていません")
    (let (year month day dstFile temp-buffer buffer-read-only)
      (setq dstFile
	    (if xcal-disp-week (xcal-week-file-name xcal-current-day)
	      (xcal-file-name
	       xcal-current-year xcal-current-month xcal-current-day)))

      (if (and (file-exists-p dstFile)
	       (y-or-n-p "上書きしますか？ (n で追加)"))
	  (delete-file dstFile))
      
      (setq temp-buffer (get-buffer-create "*XCal-temp*"))
      (set-buffer temp-buffer)
      (setq buffer-read-only nil)
      (erase-buffer)

      (insert xcal-copy-buffer "\n\n")
      (goto-char (point-max))
      (delete-blank-lines)
      (if (file-exists-p dstFile)
	  (insert-file dstFile))

      (xcal-write-region (point-min) (point-max) dstFile)
      (xcal-refresh)
      )))

(defun xcal-input-date ()
  (let (date y m d)
    (setq date (read-string "(dd) or (/mm) or (mm/dd) or (yyyy/mm/dd) ? "))
    (cond
     ((string-match "^(?\\([0-9]+\\)/\\([0-9]+\\)/\\([0-9]+\\))?$" date)
      (setq y (string-to-int (substring date (match-beginning 1)(match-end 1))))
      (setq m (string-to-int (substring date (match-beginning 2)(match-end 2))))
      (setq d (string-to-int (substring date (match-beginning 3)(match-end 3)))))
     ((string-match "^(?/\\([0-9]+\\))?$" date)
      (setq y xcal-current-year)
      (setq m (string-to-int (substring date (match-beginning 1)(match-end 1))))
      (setq d 1))
     ((string-match "^(?\\([0-9]+\\))?$" date)
      (setq y xcal-current-year)
      (setq m xcal-current-month)
      (setq d (string-to-int (substring date (match-beginning 1)(match-end 1)))))
     ((string-match "^(?\\(/?\\)\\([0-9]+\\)/\\([0-9]+\\))?$" date)
      (if (/= (match-beginning  1)(match-end 1))
	  (setq y xcal-current-year)
	(setq m (string-to-int (substring date (match-beginning 2)(match-end 2))))
	(setq d (string-to-int (substring date (match-beginning 3)(match-end 3))))
	(if (> m 12) (setq y m m d d 1)
	  (setq y (read-string (format "year: (default %d) " xcal-current-year)))
	  (if (or (null y) (string= y ""))
	      (setq y xcal-current-year)
	    (setq y (string-to-int y))))))
     (t
      (error "illegal format !")))
    (if (< y 100) (setq y (+ y 1900)))
    (if (or (< m 1)(< 12 m))
	(error (format "%d月なんかないよ！" m)))
    (if (or (< d 1)(< (calendar-last-day-of-month m y) d))
	(error (format "%d日なんかないよ！" d)))
    (list y m d)))

(defun xcal-move-schedule (year month day)
  (interactive (xcal-input-date))
  (if (xcal-copy-schedule)
      (progn
	(let ((xcal-current-year year)
	      (xcal-current-month month)
	      (xcal-current-day day))
	  (xcal-yank-schedule))
	(xcal-delete-file))))

(defun xcal-mode ()
  "\
  XCal だっ！
  X11 の xcal みたいなやつ
\\{xcal-map}
"
  (if (null xcal-map)
      (progn
	(setq xcal-map (make-keymap))
	(if window-system
	    (progn
	      (setq xcal-mouse-3-map (make-sparse-keymap "XCal"))
	      (define-key xcal-map [down-mouse-3] xcal-mouse-3-map)
	      (define-key xcal-mouse-3-map [exit-xcal]
		'("Exit" . xcal-quit))
	      (define-key xcal-mouse-3-map [scroll-backward]
		'("Scroll backward" . xcal-scroll-down))
	      (define-key xcal-mouse-3-map [scroll-forward]
		'("Scroll forward"  . xcal-scroll-up))
	      (define-key xcal-mouse-3-map [minical]
		'("Mini Calendar" . xcal-toggle-show-calendar))
	      (define-key xcal-mouse-3-map [holiday]
		'("Holiday" . xcal-toggle-disp-holiday))

	      (define-key xcal-map [menu-bar disp]
		(cons "表示" (make-sparse-keymap "display")))
	      (define-key xcal-map [menu-bar disp minical]
		'("Mini Calendar" . xcal-toggle-show-calendar))
	      (define-key xcal-map [menu-bar disp holiday]
		'("Holiday" . xcal-toggle-disp-holiday))

	      (define-key xcal-map [menu-bar next]
		'("次月" . xcal-next))
	      (define-key xcal-map [menu-bar before]
		'("先月" . xcal-before))

	      (define-key xcal-map [mouse-1] 'xcal-mouse-set-point)
	      (define-key xcal-map [double-mouse-1] 'xcal-mouse-set-point-edit)
	      ))
;	(if xcal-map-hook
;	    (run-hooks 'xcal-map-hook)
	  (define-key xcal-map "<"    'xcal-before)
	  (define-key xcal-map ">"    'xcal-next)
	  (define-key xcal-map "p"    'xcal-previous-day)
	  (define-key xcal-map "\C-p" 'xcal-previous-day)
	  (define-key xcal-map "n"    'xcal-next-day)
	  (define-key xcal-map "\C-n" 'xcal-next-day)
	  (define-key xcal-map "k"    'xcal-previous-day)
	  (define-key xcal-map "j"    'xcal-next-day)
	  (define-key xcal-map "~"    'xcal-1)
	  (define-key xcal-map "."    'xcal-1)
	  (define-key xcal-map "e"    'xcal-edit-for-xcal)
	  (define-key xcal-map " "    'xcal-edit-for-xcal)
	  (define-key xcal-map "W"    'xcal-edit-for-xcal-week)
	  (define-key xcal-map "w"    'xcal-toggle-disp-month-and-week)
	  (define-key xcal-map "d"    'xcal-delete-file)
	  (define-key xcal-map "\M-k" 'xcal-delete-file)
	  (define-key xcal-map "q"    'xcal-quit)
	  (define-key xcal-map "\C-v" 'xcal-scroll-up)
	  (define-key xcal-map "\M-v" 'xcal-scroll-down)
	  (define-key xcal-map "\C-?" 'xcal-scroll-down)
	  (define-key xcal-map "N"    'xcal-next-schedule)
	  (define-key xcal-map "P"    'xcal-previous-schedule)
	  (define-key xcal-map "t"    'xcal-toggle-disp-holiday)
	  (define-key xcal-map "\M-<" 'xcal-goto-top-day)
	  (define-key xcal-map "\M->" 'xcal-goto-last-day)
	  (define-key xcal-map "s"    'xcal-toggle-show-calendar)
	  (define-key xcal-map "J"    'xcal-jump)
	  (define-key xcal-map "\M-m" 'xcal-move-schedule)
	  (define-key xcal-map "\M-w" 'xcal-copy-schedule)
	  (define-key xcal-map "\C-y" 'xcal-yank-schedule)
	  (define-key xcal-map [left] 'xcal-before)
	  (define-key xcal-map [right] 'xcal-next)
	  (define-key xcal-map [up] 'xcal-previous-day)
	  (define-key xcal-map [down] 'xcal-next-day)
	  (define-key xcal-map [next] 'xcal-next)
	  (define-key xcal-map [prior] 'xcal-before)
	  (define-key xcal-map [home] 'xcal-goto-top-day)
	  (define-key xcal-map [end] 'xcal-goto-last-day)
	  (run-hooks 'xcal-map-hook)		;(94/11/10:isoyama)
	  ))
  (use-local-map xcal-map)
  (setq truncate-lines t)
  (setq major-mode 'xcal-mode)
  (setq mode-name "XCal"))

(defun xcal (&optional month-offset)
  "xcal みたいな感じで、Calendar を表示する。"
  (interactive "P")
  (setq xcal-previous-window-configuration (current-window-configuration))
  (and (get-buffer "*XCal-Calendar*")  (kill-buffer "*XCal-Calendar*"))
  (and (get-buffer "*XCal-Edit*")  (kill-buffer "*XCal-Edit*"))
  (and xcal-alarm-prog			;(94/11/10:isoyama)
       (eq window-system 'x) (xcal-alarm-start--proc))
  (xcal-1 month-offset))

(defun xcal-toggle-disp-month-and-week ()
  (interactive)
  (setq xcal-keys-message nil)
  (setq xcal-disp-week (not xcal-disp-week))
  (xcal-1))

(defun xcal-1 (&optional month-offset)
  "xcal の 本体"
  (interactive "P")
  (if month-offset (setq month-offset (prefix-numeric-value month-offset)))
  (set-buffer (get-buffer-create "*XCal*"))
  (switch-to-buffer "*XCal*")
  (xcal-mode)
  (delete-other-windows)
  (setq buffer-read-only t)
  
  (and xcal-show-calendar (xcal-show-calendar-vertical month-offset))
  (let* ((buffer-read-only nil) (ymd (get-year-month-day)) year month day)
    (setq year  (car ymd))
    (setq month (car (cdr ymd)))
    (setq day   (cond ((or (null month-offset)(= 0 month-offset))
		       (car (cdr (cdr ymd))))
		      (t nil)))
    (if (null month-offset)
	(setq xcal-month-offset 0)
      (setq xcal-month-offset month-offset))
    (and month-offset
	 (let ((year-month (+ (+ (* year 12) (- month 1)) month-offset)))
	   (setq month (+ (% year-month 12) 1))
	   (setq year (/ year-month 12))))
    (setq xcal-current-year year)
    (setq xcal-current-month month)
    (setq xcal-current-day (or day 1))
    (erase-buffer)
    (cond (xcal-disp-week
	   (setq mode-line-process "(Week)")
	   (if (not day) (setq day 1))
	   (let ((wday (calendar-day-of-week
			(let ((x (get-year-month-day)))
			  (append (cdr x) (list (car x)))))))
	     (xcal-generate-week wday)
	     (xcal-goto-day (1+ wday))))
	  (t
	   (setq mode-line-process
		 (format "(%d/%d)" xcal-current-year xcal-current-month))
	   (xcal-generate-month month year day)
	   (xcal-goto-day xcal-current-day))))
  (xcal-show-keys))

(defun xcal-generate-month (month year &optional today)
  "カレンダーのひょーじ"
  (let* ((week (calendar-day-of-week (list month 1 year)))
	 (last-of-month
	  (if (and (calendar-leap-year-p year) (= month 2))
	      29
	    (aref [31 28 31 30 31 30 31 31 30 31 30 31] (1- month))))
         (month-name
	;	  (aref ["January" "February" "March" "April" "May" "June"
	;		 "July" "August" "September" "October" "November" "December"]
	;		(1- month))
	  (aref ["1月" "2月" "3月" "4月" "5月" "6月"
		 "7月" "8月" "9月" "10月" "11月" "12月"]
		(1- month)) ;(isoyama)
	  )
	 info
	 msg
	 tmpMsg
	 (xcal-buffer (current-buffer))
	 (temp-buffer (get-buffer-create "*XCal-temp*")))
    (setq xcal-days last-of-month)
    (setq xcal-day-markers (make-vector (1+ xcal-days) nil))
    (setq xcal-day-schedule (make-vector (1+ xcal-days) nil))
    (setq last-of-month (1+ last-of-month))
    
    ;; 自動生成祝日リストの作成
    (if (or (null xcal-auto-holiday-alist)
	    (/= year (car xcal-auto-holiday-alist)))
	(setq xcal-auto-holiday-alist (xcal-make-auto-holiday-alist year)))
    
    (put-text-property (point-min) (point-max) 'face 'none)
    (insert-string (format "   %d年 %s\n" year month-name))

    (let ((day 1)
	  (week-face nil))
      (while (< day last-of-month)
	(xcal-make-underline)
	(aset xcal-day-markers day (make-marker))
	(cond ((setq info (or (assoc day (cdr (assoc month xcal-holiday-alist)))
			      (assoc day (cdr (assoc month xcal-auto-holiday-alist)))))
	       ;; 祝日だす
	       (if (not (listp (cdr info)))
		   (setq info (list nil (cdr info) nil xcal-holiday-week-color)))
	       (setq msg   (copy-sequence (nth 1 info)))
	       (setq week-face (xcal-lookup-face-create (or (nth 2 info) xcal-holiday-week-color)))
	       (if (nth 3 info)
		   (put-text-property 0 (length msg) 'face
				      (xcal-lookup-face-create (nth 3 info)) msg)))
	      ((assoc week xcal-week-holiday)
	       ;; 土日かも
	       (setq msg nil)
	       (setq week-face (xcal-lookup-face-create (nth 1 (assoc week xcal-week-holiday)))))
	      ((and (= week 1)
		    (or (assoc (1- day) (cdr (assoc month xcal-holiday-alist)))
			(assoc (1- day) (cdr (assoc month xcal-auto-holiday-alist)))))
	       (setq msg "振替休日")
	       (setq week-face (xcal-lookup-face-create xcal-holiday-week-color)))
	      (t
	       ;; なんもなし
	       (setq msg nil)
	       (setq week-face nil)))
	(if (setq info (assoc day (cdr (assoc month xcal-memorial-day-alist))))
	    ;; 記念日
	    (progn
	      (if (not (listp (cdr info)))
		  (setq info (list nil (cdr info) nil xcal-holiday-week-color)))
	      (setq tmpMsg (copy-sequence (nth 1 info)))
	      (setq week-face (xcal-lookup-face-create (or (nth 2 info) xcal-holiday-week-color)))
	      (if (nth 3 info)
		  (put-text-property 0 (length tmpMsg) 'face
				     (xcal-lookup-face-create (nth 3 info)) tmpMsg))
	      (setq msg (concat (or msg "") (and msg "\n") tmpMsg))))
;;	(if msg (setq msg (concat msg "\n"))) ;(94/11/17:isoyama)

	;; 祝日は表示しません
	(and (null xcal-disp-holiday)(setq msg nil))
	  
	(let (buffer-read-only file prefix x-prefix col)
	  ;; テンポラリのバッファに移る
	  (switch-to-buffer temp-buffer)
	  (setq buffer-read-only nil)
	  (erase-buffer)

	  ;; あれば その日の情報を
	  (and msg (insert msg "\n"))

	  ;; スケジュールを
	  (setq file (xcal-file-name year month day))
	  (if (file-exists-p file)
	      (progn
		(aset xcal-day-schedule day t)
		(insert-file file)
		
		;; スケジュールのマッチング処理
		(let (i regexp week-color schedule-color)
		  (setq i 0)
		  (while (< i (length xcal-schedule-color-list))
		    (setq regexp         (nth 0 (nth i xcal-schedule-color-list)))
		    (setq week-color     (nth 1 (nth i xcal-schedule-color-list)))
		    (setq schedule-color (nth 2 (nth i xcal-schedule-color-list)))
		    (while (re-search-forward regexp nil t)
		      (and schedule-color
			   (put-text-property (match-beginning 0) (match-end 0)
					      'face
					      (xcal-lookup-face-create schedule-color)))
		      (and week-color (setq week-face (xcal-lookup-face-create week-color))))
		    (setq i (1+ i))))
		))

	  ;; 最後の改行を処理
	  (goto-char (point-max))
	  (insert "\n\n")
	  (delete-blank-lines)

	  ;; 空なら "\n" を追加
	  (goto-char (point-min))
	  (if (eobp)
	      (insert "\n"))

	  ;; 日付を設定
	  (setq prefix (concat (format "%2d " day)
			       (let (str)
				 ;; 曜日表示をかえた(isoyama)
				 (setq str (copy-sequence (aref ["日" "月" "火" "水" "木" "金" "土"] week)))
				 (if week-face
				     (put-text-property 0 (length str) 'face week-face str))
				 str)
			       " "
			       (if (and today (= today day)) "*" "|")))
	  (setq x-prefix (concat (make-string (1- (clength prefix)) ? )
				 "|"))
	  (goto-char (point-min))
	  (while (not (eobp))
	    (beginning-of-line)
	    (insert prefix)
	    (setq col (current-column))
	    (setq prefix x-prefix)
	    (forward-line 1)) ; 予定文字列が画面幅を超えるとここが無限ループになっていたので，next-line を forward-line へ変更 oshiro 2011/2/28

	  (setq msg (buffer-string))
	  (switch-to-buffer xcal-buffer)
	  (save-excursion
	    (insert-string msg))
	  (move-to-column (1- col))
	  (setq marker (set-marker (aref xcal-day-markers day) (point)))
	  (goto-char (point-max))
	  )
	  
	(setq week (1+ week))
	(if (<= 7 week)
	    (setq week 0))
	(setq day (1+ day)))
      (xcal-make-underline))
    (kill-buffer temp-buffer)))

(defun xcal-generate-week (&optional wday)
  "週カレンダーのひょーじ"
  (let* (msg
	 (last-of-week 7)
	 (xcal-buffer (current-buffer))
	 (temp-buffer (get-buffer-create "*XCal-temp*")))
    (setq xcal-days last-of-week)
    (setq xcal-day-markers (make-vector (1+ xcal-days) nil))
    (setq xcal-day-schedule (make-vector (1+ xcal-days) nil))

    (put-text-property (point-min) (point-max) 'face 'none)

    (insert-string "   週の予定\n")
    (let ((week 1) (face nil))
      (while (<= week last-of-week)
	(xcal-make-underline)
	(aset xcal-day-markers week (make-marker))
	(let (buffer-read-only file prefix x-prefix col)
	  ;; テンポラリのバッファに移る
	  (switch-to-buffer temp-buffer)
	  (setq buffer-read-only nil)
	  (erase-buffer)
	  
	  ;; スケジュールを
	  (setq file (xcal-week-file-name week))
	  (if (file-exists-p file)
	      (progn
		(aset xcal-day-schedule week t)
		(insert-file file)))
	   
	  ;; 最後の改行を処理
	  (goto-char (point-max))
	  (insert "\n\n")
	  (delete-blank-lines)
	  
	  ;; 空なら "\n" を追加
	  (goto-char (point-min))
	  (if (eobp) (insert "\n"))
	  (setq prefix
		(concat
		 (aref ["日" "月" "火" "水" "木" "金" "土"] (1- week))
		 " "
		 (if (and wday (= (1- week) wday)) "*" "|")))
	  (setq x-prefix (concat (make-string (1- (clength prefix)) ? ) "|"))
	  (let ((color (nth 1 (assoc (1- week) xcal-week-holiday))))
	    (setq face (if color (xcal-lookup-face-create color) nil)))
	  (goto-char (point-min))
	  (while (not (eobp))
	    (beginning-of-line)
	    (insert
	     (concat "   "
		     (if face (put-text-property
			       0 (- (length prefix) 2)
			       'face face prefix))
		     prefix))
	    (setq col (current-column))
	    (setq prefix x-prefix)
	    (forward-line 1))
	  
	  (setq msg (buffer-string))
	  (switch-to-buffer xcal-buffer)
	  (save-excursion (insert-string msg))
	  (move-to-column (1- col))
	  (setq marker (set-marker (aref xcal-day-markers week) (point)))
	  (goto-char (point-max)))

	(setq week (1+ week)))
      (xcal-make-underline))
    (kill-buffer temp-buffer)))
  
(defun xcal-make-underline ()
  (let (start end len)
    (previous-line 1)
    (beginning-of-line)(setq start (point))
    (end-of-line)
    (setq len (clength (buffer-substring start (point))))
    (if (<= (- (window-width) 2) len)
	(setq len (- (window-width) 2)))
      
    (end-of-line)
    (insert (make-string (- (window-width) 2 len) ? ))
    (end-of-line)

    (let (s e x this face)
      (setq s start)
      (setq e (point))
      (while (< s e)
	(setq this (get-text-property s 'face))
	(setq face (if (and this (not (eq this 'underline)))
		       (cons this 'underline) 'underline))
	(setq x (or (next-single-property-change s 'face) e))
	(put-text-property s x 'face face) ;; xcal-lookup-face-create err?
	(setq s x)))
    (forward-line 1)))
 
(defun xcal-file-name (year month day)
  "年月日からファイル名を作成する。

Unix : {Calnedar}/xy{年}/xc{日}{月(文字)}{年}
       1999/1/1 -> ~/Calnedar/xy1991/xc1Jan1991
    xcal-schedule-xcalndar-compatible が設定されていれば
       1999/1/1 -> ~/Calnedar/xc1Jan1991

Dos  : {Calnedar}/xy{年}/xc{年(%04d)}{月(%02d)}.{日(%02d)}
       1991/1/1 -> ~/Calendar/xy1999/xc199901.01"
  (if (boundp 'dos-machine-type)
      (format "%s/xy%d/xc%04d%02d.%02d" xcal-directory year year month day)
    (concat xcal-directory
	    (if xcal-schedule-xcalndar-compatible
		""
	      (format "/xy%d" year))
	    (format "/xc%d%s%d"
		    day
		    (aref ["Jan" "Feb" "Mar" "Apr" "May" "Jun"
			   "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"]
			  (1- month))
		    year))))
  
(defun xcal-week-file-name (week)
  "曜日からファイル名を作成する。"
  (format "%s/%s" xcal-directory (nth 1 (nth (1- week) xcal-week-schedule))))

(defun xcal-write-region (begin end file)
  (xcal-make-directory (file-name-directory file))
  (write-region (point-min) (point-max) file))
  
(defun xcal-make-directory (directory)
  "Make DIRECTORY recursively.
gnus-make-directory そのまま"
  (let ((directory (expand-file-name directory default-directory)))
    (or (file-exists-p directory)
	(xcal-make-directory-1 "" directory))
    ))
  
(defun xcal-make-directory-1 (head tail)
  (cond ((string-match "^/\\([^/]+\\)" tail)
	 (setq head
	       (concat (file-name-as-directory head)
		       (substring tail (match-beginning 1) (match-end 1))))
	 (or (file-exists-p head)
	     (call-process "mkdir" nil nil nil head))
	 (xcal-make-directory-1 head (substring tail (match-end 1))))
	((string-equal tail "") t)
	))
  
  
(defun get-year-month-day ()
  (let (date year month day)
    (setq date (current-time-string))
    (string-match " \\([A-Z][a-z][a-z]\\) *\\([0-9]*\\) .* \\([0-9]*\\)$"
		  date)
    (setq day (string-to-int 
	       (substring date (match-beginning 2) (match-end 2))))
    (setq month
	  (cdr (assoc
		(substring date (match-beginning 1) (match-end 1))
		'(("Jan" . 1) ("Feb" . 2)  ("Mar" . 3)  ("Apr" . 4)
		  ("May" . 5) ("Jun" . 6)  ("Jul" . 7)  ("Aug" . 8)
		  ("Sep" . 9) ("Oct" . 10) ("Nov" . 11) ("Dec" . 12)))))
    (setq year (string-to-int
		(substring date (match-beginning 3) (match-end 3))))
    (list year month day)))
  
(defun xcal-insert-template ()
  (interactive)
  (let* ((ymd (get-year-month-day))
	 (now (format "%d/%d/%d"
		      (car ymd)
		      (car (cdr ymd))
		      (car (nthcdr 2 ymd))))
	 (answer (read-string (format "yyyy/mm/dd ? (%s): " now)))
	 (msg (format "---- xcal %s begin ---\n\n--- xcal end ----\n"
		      (if (equal answer "") now answer))))
    (beginning-of-line)
    (insert msg)
    (beginning-of-line -1)))

(defun xcal-refresh ()
  (let ((day xcal-current-day))
    (xcal-1 xcal-month-offset)
    (goto-char (marker-position (aref xcal-day-markers day)))
    (setq xcal-current-day day)))
  
(defun xcal-goto-day (day)
  (cond ((< day 1)
	 (progn
	   (xcal-1 (1- xcal-month-offset))
	   (setq xcal-current-day xcal-days)
	   (goto-char (marker-position (aref xcal-day-markers xcal-days)))))
	((<= day xcal-days)
	 (progn
	   (setq xcal-current-day day)
	   (goto-char (marker-position (aref xcal-day-markers day)))))
	(t (xcal-1 (1+ xcal-month-offset))
	   (setq xcal-current-day 1)
	   (goto-char (marker-position (aref xcal-day-markers 1)))))
  (xcal-show-keys))


(defun xcal-calendar-jump (event)
  (interactive "e")
  (mouse-set-point event)
  (let ((date (calendar-cursor-to-date))
	(buf (get-buffer-create "*XCal*")))
    (and date
	 (let (ymd now-year now-month year month day)
	   (setq ymd (get-year-month-day))
	   (setq now-year  (car ymd))
	   (setq now-month (car (cdr ymd)))
	   (setq year (extract-calendar-year date))
	   (setq month (extract-calendar-month date))
	   (setq day (extract-calendar-day date))
	   (xcal-1 (+ (* (- year now-year) 12) (- month now-month)))
	   (xcal-goto-day day)))))

(defvar xcal-calendar-map nil)

(defun xcal-show-calendar-vertical (&optional month-offset)
  (interactive "P")
  (setq month-offset 
	(if month-offset
	    (prefix-numeric-value month-offset)
	  0))
  (let* ((cur-win (selected-window))
	 (ymd (get-year-month-day))
	 (year  (car ymd))
	 (month (car (cdr ymd)))
	 (day   (cond ((or (null month-offset)(= 0 month-offset))
		       (car (cdr (cdr ymd))))
		      (t nil))))
    (cond
     (month-offset
      (let ((year-month (+ (+ (* year 12) (- month 1)) month-offset)))
	(setq month (+ (% year-month 12) 1))
	(setq year (/ year-month 12)))))
    (select-window (split-window-vertically (- (window-height) 9)))
    (let ((buf (get-buffer-create "*XCal-Calendar*")) pos)
      (switch-to-buffer buf)
      (generate-calendar-window month year)
      (set-buffer buf)
      (if (and (< month-offset 2) (> month-offset -2))
	  (let ((pos (point)))
	    (put-text-property (1- pos) (1+ pos) 'face 'region))))
    (if (null xcal-calendar-map)
	(progn
	  (setq xcal-calendar-map (make-keymap))
	  (define-key xcal-calendar-map "q" 'xcal-quit)
	  (define-key xcal-calendar-map [mouse-2] 'xcal-calendar-jump)
	  (define-key xcal-calendar-map [mouse-3] 'xcal-calendar-jump)))
    (use-local-map xcal-calendar-map)
    (select-window cur-win)))

(defun gnus-to-xcal-file ()
  (interactive)
;  (xxx-to-xcal-file gnus-Article-buffer)) ;; 古いバージョンの GNUS 用
  (xxx-to-xcal-file gnus-article-buffer)) ;; バージョン??以上の Gnus 用
  
(defun mh-to-xcal-file ()
  (interactive)
  (xxx-to-xcal-file mh-show-buffer))
  
(defun mew-to-xcal-file ()
  (interactive)
  (xxx-to-xcal-file (mew-buffer-message)))

(defun xxx-to-xcal-file (buf)
  (save-excursion
    (set-buffer buf)
    (goto-char (point-min))
    (let ((i 0))
      (while (xxx-to-xcal-file-foo buf)
	(setq i (1+ i)))
      (if (= 0 i)
	  (error "[XCal] Missing `---- xcal yyyy/mm/dd begin ----'")
	(message "[XCal] Done")))))

(defun xxx-to-xcal-file-foo (buf)
  (set-buffer buf)
  (if (re-search-forward "^-+[ \t]*[Xx][Cc][Aa][Ll][ \t]*\\([0-9]*\\)[ ./]\\([0-9]*\\)[ ./]\\([0-9]*\\)[ \t]*[Bb][Ee][Gg][Ii][Nn][ \t]*-+.*\n" nil t)
      (let (year month day begin file mem temp-buffer)
	(setq year  (string-to-int (buffer-substring
				    (match-beginning 1)(match-end 1))))
	(setq month (string-to-int (buffer-substring
				    (match-beginning 2)(match-end 2))))
	(setq day   (string-to-int (buffer-substring
				    (match-beginning 3)(match-end 3))))
	(setq file (xcal-file-name year month day))
	(setq begin (point))
	(if (re-search-forward "^-+[ \t]*[Xx][Cc][Aa][Ll][ \t]*[Ee][Nn][Dd][ \t]*-+" nil t)
	    t
	  (error "[XCal] Missing `---- xcal end ----'"))
	(previous-line 1)
	(end-of-line)
	(setq mem (buffer-substring begin (point)))
	(setq temp-buffer (get-buffer-create "*GNUS-to-XCal*"))
	(switch-to-buffer temp-buffer)
	(erase-buffer)
	(if (file-exists-p file)
	    (progn
	      (insert-file file)
	      (pop-to-buffer temp-buffer)
	      (if (y-or-n-p "File exist. Adding ? ")
		  (progn
		    (goto-char (point-max))
		    (if (equal "\n" 
			       (buffer-substring (1- (point-max))(point-max)))
			nil
		      (insert-string "\n"))
		    (insert-string mem)
		    (xcal-write-region (point-min) (point-max) file))))
	  (progn
	    (insert-string mem)
	    (xcal-write-region (point-min) (point-max) file)))
	(kill-buffer temp-buffer)
	t)
    nil))
  
(defun xcal-show-keys ()
  (if (null xcal-keys-message)
      (setq xcal-keys-message
	    (substitute-command-keys
	     (concat
	      (if xcal-disp-week
		  "\
月予定 \\[xcal-toggle-disp-month-and-week]  "
	     "\
先月 \\[xcal-before]  \
次月 \\[xcal-next]  \
前日 \\[xcal-previous-day]  \
明日 \\[xcal-next-day]  ")
"編集 \\[xcal-edit-for-xcal]  \
削除 \\[xcal-delete-file]  \
終了 \\[xcal-quit]"))))
  (message xcal-keys-message))
  
(defun xcal-print-out ()
  (interactive)
  (if (yes-or-no-p (format "%d 月のスケジュールを出力しますか ?"
			   xcal-current-month))
      (call-process-region (point-min) (point-max)
			   (or xcal-print-out-command "lpr")
			   nil nil)))
  
  
  
(defvar xcal-week-select-index nil)
;;                                      1         2         3         4         5
;;                             1234567890123456789012345678901234567890123456789012
  
(defvar xcal-week-schedule '(("日" "xwSun")
			     ("月" "xwMon")
			     ("火" "xwTue")
			     ("水" "xwWed")
			     ("木" "xwThu")
			     ("金" "xwFri")
			     ("土" "xwSat")))
  
(setq xcal-select-minibuffer-map (make-keymap))
(suppress-keymap xcal-select-minibuffer-map)
(define-key xcal-select-minibuffer-map "\C-p" 'xcal-week-select-prev)
(define-key xcal-select-minibuffer-map "p"    'xcal-week-select-prev)
(define-key xcal-select-minibuffer-map "P"    'xcal-week-select-prev)
(define-key xcal-select-minibuffer-map "\C-b" 'xcal-week-select-prev)
(define-key xcal-select-minibuffer-map "b"    'xcal-week-select-prev)
(define-key xcal-select-minibuffer-map "B"    'xcal-week-select-prev)
(define-key xcal-select-minibuffer-map "h"    'xcal-week-select-prev)
(define-key xcal-select-minibuffer-map "H"    'xcal-week-select-prev)
(define-key xcal-select-minibuffer-map "\C-n" 'xcal-week-select-next)
(define-key xcal-select-minibuffer-map "n"    'xcal-week-select-next)
(define-key xcal-select-minibuffer-map "N"    'xcal-week-select-next)
(define-key xcal-select-minibuffer-map "\C-f" 'xcal-week-select-next)
(define-key xcal-select-minibuffer-map "f"    'xcal-week-select-next)
(define-key xcal-select-minibuffer-map "F"    'xcal-week-select-next)
(define-key xcal-select-minibuffer-map "l"    'xcal-week-select-next)
(define-key xcal-select-minibuffer-map "L"    'xcal-week-select-next)
(define-key xcal-select-minibuffer-map "\C-m" '(lambda () 
						 (interactive)
						 (setq xcal-selected t)
						 (exit-minibuffer)))
(define-key xcal-select-minibuffer-map "e"    '(lambda () 
						 (interactive)
						 (setq xcal-selected t)
						 (exit-minibuffer)))
(define-key xcal-select-minibuffer-map "E"    '(lambda () 
						 (interactive)
						 (setq xcal-selected t)
						 (exit-minibuffer)))
(define-key xcal-select-minibuffer-map "q"    'exit-minibuffer)
(define-key xcal-select-minibuffer-map "Q"    'exit-minibuffer)
(define-key xcal-select-minibuffer-map "\C-g" 'exit-minibuffer)
  
(defun nop ()
  (interactive))
  
(defun xcal-edit-for-xcal-week ()
  (interactive)
  (let ((save-minibuffer-map minibuffer-local-map) inpt)
    (setq xcal-week-select-index 1)
    (setq unread-command-char ?p) ; 何かいい方法は？
    (setq xcal-selected nil)
    (unwind-protect
	(progn
	  (setq minibuffer-local-map xcal-select-minibuffer-map)
	  (read-string "" ""))
      (setq minibuffer-local-map save-minibuffer-map))
    (and xcal-selected (xcal-week-select-select))))
  
(defun xcal-week-select-prev ()
  (interactive)
  (setq xcal-week-select-index (1- xcal-week-select-index))
  (if (< xcal-week-select-index 0)
      (setq xcal-week-select-index (1- (length xcal-week-schedule))))
  (xcal-disp-select-week))
  
(defun xcal-week-select-next ()
  (interactive)
  (setq xcal-week-select-index (1+ xcal-week-select-index))
  (if (<= (length xcal-week-schedule) xcal-week-select-index)
      (setq xcal-week-select-index 0))
  (xcal-disp-select-week))
  
(defun xcal-disp-select-week ()
  (let (p i)
    (erase-buffer)
    (insert "何曜日のスケジュールですか？  ")
    (setq i 0)
    (while (< i (length xcal-week-schedule))
      (if (eq i xcal-week-select-index)
	  (progn
	    (setq p (point))
	    (insert (format "[%s]" (nth 0 (nth i xcal-week-schedule)))))
	(insert (format " %s " (nth 0 (nth i xcal-week-schedule)))))
      (setq i (1+ i)))
    (goto-char (1+ p))))
  
(defun xcal-week-select-select ()
  (interactive)
  (set-buffer (get-buffer-create "*XCal Edit*"))
  (erase-buffer)
  (select-window (split-window-vertically (/ (window-height) 2)))
  (switch-to-buffer "*XCal Edit*")
  (xcal-edit-mode)
  (setq buffer-read-only nil)
  (set-buffer-modified-p (buffer-modified-p))
  (setq mode-line-process (concat " "
				  (nth 0 (nth xcal-week-select-index xcal-week-schedule))
				  "曜日のスケジュール"))
  (setq xcal-file (xcal-week-file-name (1+ xcal-week-select-index)))
  (and (file-exists-p xcal-file) (insert-file xcal-file))
  (message
   (substitute-command-keys "Editing: Type \\[xcal-edit-cease-edit] to return to XCal, \\[xcal-edit-abort-edit] to abort.")))

(defun xcal-make-auto-holiday-alist (year)
  (list year
	(list 1 (xcal-day-of-seijin year))
        (list 3 (xcal-day-of-syunbun year))
        (list 7 (xcal-day-of-umi year))
        (list 9 (xcal-day-of-syuubun year) (xcal-day-of-keirou year))
	(list 10 (xcal-day-of-taiiku year))))

(defun xcal-nth-wday-day (year month wday nth)
  "year年のmonth月の第nthのwday曜日は何日か"
  (+ (+ 1 (mod (- 1 (calendar-day-of-week (list month 1 year))) 7))
     (* 7 (- nth 1))))

(defun xcal-day-of-seijin (year)
  (cons (if (< year 2000)
	    15
	  (xcal-nth-wday-day year 1 1 2)) ; 1月の第2月曜
	"成人の日"))

(defun xcal-day-of-umi (year)
  (cons (if (< year 2003)
	    20
	  (xcal-nth-wday-day year 7 1 3)) ; 7月の第3月曜
	"海の日"))

(defun xcal-day-of-keirou (year)
  (cons (if (< year 2003)
	    15
	  (xcal-nth-wday-day year 9 1 3)) ; 9月の第3月曜
	"敬老の日"))

(defun xcal-day-of-taiiku (year)
  (cons (if (< year 2000)
	    10
	  (xcal-nth-wday-day year 10 1 2)) ; 10月の第2月曜
	"体育の日"))

(defun xcal-day-of-syunbun (year)
  (cons (- (/ (+ (* 8 year) 1182) 33) (/ year 4))
	"春分の日"))

(defun xcal-day-of-syuubun (year)
  (cons (- (/ (+ (* 8 year) 1261) 33) (/ year 4))
	"秋分の日"))

(if (string< emacs-version "20.3")
    (defun clength (str)
      (let ((idx 0)(width 0))
	(while (< idx (length str))
	  (setq width (+ width (char-width (sref str idx))))
	  (setq idx (+ idx (char-bytes (sref str idx)))))
	width))
  (defun clength (str)
    (let ((idx 0)(width 0))
      (while (< idx (length str))
	(setq width (+ width (char-width (aref str idx))))
	(setq idx (+ idx 1)))
      width)))

(defun xcal-lookup-face-create (face)
  (cond
   ((not (and (or (eq window-system 'x)
		  (eq window-system 'w32))
	      (x-display-color-p)))
    (if (listp face) 'underline 'highlight))
   ((symbolp face) face)
   ((stringp face)
    (let ((color face))
      (setq face (intern color))
      (make-face face)
      (set-face-foreground face color)
      face))
   ((listp face)
    (let (new-face color)
      (setq color (symbol-name (car face)))
      (setq new-face (intern (concat color "-underline")))
      (make-face new-face)
      (set-face-underline-p new-face t)
      (set-face-foreground new-face color)
      new-face))))
;;
;; アラーム関係の関数
;;

(setq xcal-alarm-keymap (make-keymap))
(define-key xcal-alarm-keymap "q" '(lambda ()
				     (interactive)
				     (kill-buffer (current-buffer))
				     (delete-frame)))

(defun xcal-alarm-start--proc ()
  (if (or (null xcal-alarm-proc)
	  (not (eq (process-status xcal-alarm-proc) 'run)))
      (progn
	(if (not (file-exists-p xcal-alarm-prog))
	    (error (format "xcal program [%s] not found." xcal-alarm-prog)))
	(setq xcal-alarm-proc (start-process "xcal-alarm" nil
					     xcal-alarm-prog
					     "-d" (expand-file-name xcal-directory)
					     "-c" xcal-alarm-countdown
					     "-u" xcal-alarm-update))
	(setq xcal-alarm-all-ret "")
	(setq xcal-alarm-ret "")
	(set-process-filter xcal-alarm-proc 'xcal-alarm-filter)
	(set-process-sentinel xcal-alarm-proc 'xcal-alarm-sentinel-filter)
	(process-kill-without-query xcal-alarm-proc))))

(defun xcal-alarm-filter (process out)
  (setq xcal-alarm-all-ret (concat xcal-alarm-all-ret out))
  (setq xcal-alarm-ret (concat xcal-alarm-ret out))
  (if (string-match "^SOT\n" xcal-alarm-ret)
      (setq xcal-alarm-ret (substring xcal-alarm-ret (match-end 0))))
  (if (string-match "^EOT\n" xcal-alarm-ret)
      (progn
	(xcal-alarm-has-come (substring xcal-alarm-ret 0 (match-beginning 0)))
	(setq xcal-alarm-ret ""))))

(defun xcal-alarm-sentinel-filter (process signal)
  (error (format "Process %s recived the msg %s" xcal-alarm-proc signal)))

(defun xcal-alarm-has-come (msg)
  (let (buffer-read-only new frame buf)
    (setq new (not (get-buffer " *XCal alarm*")))
	
    (setq buf (set-buffer (get-buffer-create " *XCal alarm*")))
    (setq buffer-read-only nil)
    (erase-buffer)
    (insert "< Please type `q' for quit >")
    (put-text-property (point-min) (point-max) 'face 'region)
    (insert "\n")
    (insert msg)
    (setq buffer-read-only t)
    (use-local-map xcal-alarm-keymap)

    (if new
	(progn
	  (setq frame (make-frame '((name   . "Alarm")
				    (height . 10)
				    (width  . 30))))
	  (set-window-buffer (frame-selected-window frame) buf)))
    (ding)))
