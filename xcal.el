;;; -*- Mode: Emacs-Lisp -*-
;;;
;;;                     xcal.el    Ver 2.01b
;;;
;;;             Copyleft (C) Shigeki Morimoto 1994-2000
;;;
;;;                 ����� ������ ( ���� �м� )
;;;                e-mail: Shigeki@Morimo.to
;;;
;;(2012/07/17:oshiro) �ֳ������פȡַ�Ϸ�����פǥϥåԡ��ޥ�ǡ��б�
;;(2011/02/28:oshiro) xcal-next-day �ǸƤФ��xcal-1��Ǥ� next-line �� forward-line ���ѹ��ʹԤ����̤�Ķ���������ߤ�����
;;(2001/01/12:oshiro) ��ͽ��ΰ������ɲ�
;;(2001/01/12:oshiro) ͽ��Υ��ԡ��������դǤʤ����Τ��ѿ�����¸
;;(2001/01/12:oshiro) underline ���� xcal-lookup-face-create �򳰤���
;;(2000/11/30:jun) �ϥåԡ��ޥ�ǡ����б���xcal-alarm-filter������
;;                 �������б��ϡ����ͤ����פȡ��ΰ�����פΤߡ� oshiro 2012/7/17
;;(2000/11/30:isoyama) xcal-lookup-face-create �ΥХ�����(_ _)
;;(2000/11/28:mori) xcal.el Ver 2.0
;;(2000/11/27:isoyama) xcal-lookup-face-create �ΥХ�����
;;(99/06/14:mimpei) Meadow ���顼����,mew,Gnus �б����������塼�������ؿ��ɲ�
;;(98/11/08:matz)emacs 20.3�б�������¾
;;(96/01/07:morimoto)Ver 1.01
;;(96/01/07:age) DOCSTRING ��� " ����
;;(96/01/07:age) byte-compile ���� warning ����
;;(94/11/17:isoyama)������ɽ���λ��˲��Ԥ��Ƥ��ʤ�(ɽ�����ŤʤäƤ��ޤ�)�Τ���
;;(94/11/10:isoyama)xcal-alarm-prog �� nil �ΤȤ��� alarm ���ʤ��褦�ˤ���
;;(94/11/10:isoyama)xcal-map-hook ����ʬŪ�� key binding ���Ѥ�����褦�ˤ���
;;(94/10/05;morimoto)Ver 1.00 �� ���� 
;;(94/10/05;morimoto)underline �ν������ѹ�
;;(94/10/04;morimoto)�ػ��ѻ��˥��顼���ɽ��
;;(94/10/04;morimoto)�������塼��˱���������ɽ��
;;(94/10/04;morimoto)�����ȵ�ǰ���������ο���ͳ������Ǥ���褦�˽���
;;(94/10/04;morimoto)�����ο���ͳ������Ǥ���褦�˽���
;;(94/09/28;morimoto)�Խ�����̤������Խ����褦�Ȥ����Ȥ��ν������ɲ�
;;(94/09/27;yoneda)xcalendar ����ѥ��ե�����⡼�ɤ��ɲ�
;;(94/09/27;kawabata)�����ε�����ȿž���ʤ��ä��Τ���
;;(94/09/21;morimoto)copy & yank ���ɲ�
;;(94/09/20;morimoto)�ǥե���ȥǥ��쥯�ȥ�� ~/Calendar �˽���
;;(94/09/19;morimoto)��ʬ����ʬ������ư����
;;(94/09/19;n_saitoh)�����ȵ�ǰ�����Ťʤä�����ɽ������
;;(94/09/12;morimoto)mouse ���ڥ졼���������(mouse-1 �ǰ�ư double-mouse-1 ���Խ�)
;;(94/08/25;morimoto)Emacs-19 ���Ѥ��ѹ�
;;(94/08/05;morimoto)���ܸ�ʸ����Ĺ��������ȷ׻�����褦�ˤ���
;;                 <HANDA.93Dec2212655@etlken.etl.go.jp> �� ���ͤˤ��ޤ���
;;(93/11/18;morimoto)mule�Ѥ˲�¤����
;;(93/09/06:isoyama)calendar�κ����ο�����ȿž������褦�ˤ�����
;;(93/08/27:isoyama)epoch�Ѥ˲�¤����
;;(93/08/26:isoyama)�������ɽ�������ܸ�ˤ�����cal.el��Ʊ�ͤ˽���������
;;
;;
;;    Special thanks to ������ޤ���
;;        

	;
;;
;;;
;;; ���� software �����ۡ����Ѥ������ʤ��̤�������������Ȥ�
;;; �ʤäƤ� NO WARRANTY �Ǥ���
;;;
;;; ���ۡ����Ѿ��� GNU General Public Licence �˴�Ť��ޤ���
;;;
;;; �������ʤȤ���� �������Ƥ�館��� ���줷���Ǥ���
;;;
;;
	;

;;
;;
;; xcal.el �� xcal �ߤ����ʴ����ǡ�Emacs �˥���������ɽ�����ޤ���
;; * ��ǯ�η׻��ϡ���䤳�����ä��Τ� calendar.el ��ȤäƤ��ޤ���
;;
;;
;; �Ȥ���
;;
;;   M-x xcal ��Ω���夬��ޤ���
;;
;;   X �⡼��
;;      ��ư             ���ܥ���       xcal-mouse-set-point
;;      �Խ�             ���ܥ�����֥� xcal-mouse-set-point-edit
;;
;;
;;      ����             <              xcal-before
;;      ����             >              xcal-next
;;      ��               p              xcal-previous-day
;;      ��               n              xcal-next-day
;;      ����             ~              xcal
;;      �Խ�             e              xcal-edit-for-xcal
;;      ����ͽ��         W              xcal-edit-for-xcal-week
;;      ���ȷ���ڤ괹�� w              xcal-toggle-disp-month-and-week
;;      ���             d              xcal-delete-file
;;      ��λ             q              xcal-quit
;;      �������륢�å� C-v            xcal-scroll-up
;;      ������������� C-z            xcal-scroll-down
;;      ����ͽ��         N              xcal-next-schedule
;;      ����ͽ��         P              xcal-previous-schedule
;;      ����ɽ��ON/OFF   t              xcal-toggle-disp-holiday
;;�ߥ˥���������ɽ��   s              xcal-toggle-show-calendar
;;      ������         J              xcal-jump
;;      ���ԡ�           M-w            xcal-copy-schedule
;;      ���           C-y            xcal-yank-schedule
;;      ���             ---            xcal-goto-top-day
;;      ����             ---            xcal-goto-last-day
;;      ���������ν��� ---            xcal-print-out
;;
;;    �Խ��⡼�ɤΥ����Х����
;;
;;      �Խ���λ        C-cC-c           xcal-edit-cease-edit
;;         ��           C-xC-s                   ��
;;      ���            C-cC-]           xcal-edit-abort-edit
;;
;; xcal-map-hook �� xcal-edit-mode-map-hook �� �����ʥ����Х���ɤ���
;; ��Ǥ��ޤ��� (���ꤷ�ʤ��Ƥ�ư���ޤ���)
;;
;;  �˥塼�����᡼�뤫�顢�������塼�������ळ�Ȥ��Ǥ��ޤ���
;;  �㤨��
;;
;;          ---- xcal 1999/5/5 begin ----
;;                ����0x20��������
;;          ---- xcal end ----
;;
;;  �äƤʥ˥塼�����᡼���ɽ�����Ƥ�����ˡ�M-o �ǥե�����˥����֤���ޤ���
;;  �ޤ����˥塼����᡼���񤤤Ƥ���Ȥ��ˡ�C-c ! �ǥ������塼���
;;  �������������뤳�Ȥ��Ǥ��ޤ���
;;
;;
;; .emacs �˰ʲ��ιԤ��ɲä��Ʋ�������
;;
;; (autoload 'xcal "xcal" "xcal for emacs." t)
;; (autoload 'calendar-day-of-week "calendar")
;; (autoload 'gnus-to-xcal-file "xcal")
;; (autoload 'mew-to-xcal-file "xcal")
;; (autoload 'xcal-insert-template "xcal")
;;
;;
;;  �����Х����������� 
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
;;  ;gnus ���饹�����塼��������
;;  (setq gnus-Startup-hook 
;;    '(lambda ()
;;       (define-key gnus-subject-mode-map "," 'to-osaka)
;;       (define-key gnus-summary-mode-map "\M-o" 'gnus-to-xcal-file)
;;       ;Gnus �ǥ�å������򵭽Ҥ��Ƥ���Ȥ��˥������塼�������
;;       (define-key message-mode-map "\C-c!" 'xcal-insert-template)))
;;
;;  ;mh ���饹�����塼��������
;;  (setq mh-folder-mode-hook
;;    '(lambda ()
;;        (define-key mh-folder-mode-map "\M-o" 'mh-to-xcal-file)))
;;
;;  ;mew ���饹�����塼��������
;;  (setq mew-summary-mode-hook
;;    '(lambda ()
;;        (define-key mew-summary-mode-map "\M-o" 'mew-to-xcal-file)))
;;  ;mew �ǥ�å������򵭽Ҥ��Ƥ���Ȥ��ˡ��������塼�������
;;  (setq mew-draft-mode-hook
;;    '(lambda ()
;;       (define-key mew-draft-mode-map "\C-c!" 'xcal-insert-template)))
;;
;; BUG
;;   1752 ǯ�Σ�������Υ�������������������ޤ���
;;   ư��Υ��Ǥ� (_ _)
;;   �������塼���������ϼ�ȴ���Ǥ���¾�ν���ȴ���˸�����Ǥ��礦����
;;   ����̿ ���ޤ���....
;;   ��˥塼�� ������ ��ư�������Ȥ����ߤޤ�
;;

(require 'calendar)
(defvar xcal-alarm-proc nil)
(defvar xcal-alarm-prog "/usr/local/bin/xcal-alarm")
(defvar xcal-alarm-countdown "0,5,10"
  "��ʬ���˥��顼���Ф��� , �Ƕ��ڤäƻ��ꤹ��")
(defvar xcal-alarm-update "10"
  "���������塼����ɤ�ľ���ֳ�(��)")


(defvar xcal-directory "~/.Calendar"
  "*xcal �� ���������ǥ��쥯�ȥ꡼")
(defvar xcal-schedule-xcalndar-compatible nil
  "t �����ꤹ��� xcalendar �ȥ���ѥ��Υ������塼��ե�����򥢥��������ޤ�")
(defvar xcal-print-out-command nil
  "������������Ϥ��륳�ޥ�ɡ�ɸ�����Ϥ����ɤ߹�����...
default �� `lpr'")
(defvar xcal-disp-holiday t
  "���������˽�����ɽ�����뤫�ɤ���")

(defvar xcal-week-holiday '((0 "red") (6 "blue"))
  "*�콵�֤Τ��Ĥ��٤ߤ� & ɽ���� ����:0 .... ����:6")

(defvar xcal-holiday-alist 
  '(( 1 ( 1 . "��ö"))
    ( 2 (11 . "����ǰ����"))
    ( 4 (29 . "�Ф���"))
    ( 5 ( 3 . "��ˡ��ǰ��")	( 4 . "��̱�ν���")	( 5 . "�Ҷ�����"))
	;
	; �������� 6,7,8 �ˤ�٤ߤ��ߤ�������
	;
    ;( 7 (20 . "������"))		; �Ǥ��ޤ��� ^_^
    ;( 9 (15 . "��Ϸ����"))
    (11 ( 3 . "ʸ������")       (23 . "��ϫ���դ���"))
    (12 (23 . "ŷ��������")))

  "*�����Υꥹ�� (�� (�� . \"������\"))
                �ޤ���
                 (�� (�� . (\"������\" �����ο� ̾�Το�)))
                 (�� (�� \"������\" �����ο� ̾�Το�))
�η����Ǥ���")

(defvar xcal-auto-holiday-alist nil
  "��ʬ����ʬ�ʤɤμ�ư�������������Υꥹ��")

(defvar xcal-memorial-day-alist
  '((11 (23 . "���պ�"))
    (12 (24 . "��'mas ����")(25 . "��'mas")))
  "*��ǰ���Υꥹ��")

(defvar xcal-schedule-color-list 
  '( ("����"   "red"   nil)
     ("�ߵ٤�" "red"   nil)
     ("Ǽ��"   "green" "red")
     ("^\\*[0-9]+:[0-9].*$" nil "blue")	; *hh:mm �Ƕ�̳���֤����� (�̥ץ����Ƕ���ɽ����)
     ("^.*������" nil "DarkGreen")
     )
  "�������塼������Ƥ� �����ο��ȥ������塼��ο����ѹ����ޤ�")

;; �����λ��������ο�
(defvar xcal-holiday-week-color "red")

(defvar xcal-show-calendar t
  "cal.el �� Calendar ��Ҥ硼�����뤫�ɤ���")

(defvar xcal-file nil
  "���������Υե�����")
(defvar xcal-days nil
  "���η�����ޤǤ�")
(defvar xcal-day-markers nil
  "���ˤ��Υޡ�����")
(defvar xcal-day-schedule nil)

(defvar xcal-current-year nil)
(defvar xcal-current-month nil)
(defvar xcal-current-day nil)
(defvar xcal-month-offset 0)

(defvar xcal-map nil "XCal �� �����ޥå�")
(defvar xcal-map-hook nil)
(defvar xcal-edit-mode-map nil "XCal �� ���ǥ��åȥ⡼�ɤΥ����ޥå�")
(defvar xcal-edit-mode-map-hook nil)
(defvar xcal-keys-message nil "����ɽ�����륭���Х����")
(defvar xcal-previous-window-configuration nil)
(defvar xcal-copy-buffer nil)
(defvar xcal-selected nil)
(defvar xcal-alarm-all-ret nil)
(defvar xcal-alarm-ret nil)
(defvar xcal-disp-week nil "������ɽ���ʤ� t")

;;
;;
;;

(defun xcal-before ()
  "����ΤҤ硼��"
  (interactive)
  (xcal-1 (1- xcal-month-offset)))

(defun xcal-next ()
  "����ΤҤ硼��"
  (interactive)
  (xcal-1 (1+ xcal-month-offset)))

(defun xcal-toggle-disp-holiday ()
  "�����ΤҤ硼���� ON/OFF"
  (interactive)
  (setq xcal-disp-holiday (not xcal-disp-holiday))
  (xcal-refresh))

(defun xcal-toggle-show-calendar ()
  "���� ������Υ��������ΤҤ硼�� ON/OFF"
  (interactive)
  (setq xcal-show-calendar (not xcal-show-calendar))
  (xcal-refresh))

(defun xcal-edit-mode ()
  "  XCal �Τդ�����Τؤ󤷤塼
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
			(format "%s����"
				(nth 0 (nth (1- xcal-current-day)
					    xcal-week-schedule)))
		      (format "%s/%s/%s "
			      xcal-current-year
			      xcal-current-month
			      xcal-current-day))
		    "�Υ������塼���õ�ޤ���"))
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
	    (setq day (+ xcal-days 1000)))) ; ������ ��
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
	    (message "���ԡ����Υ������塼�뤬����ޤ���")
	    nil)
	(insert-file srcFile)
	(setq xcal-copy-buffer (buffer-substring (point-min) (point-max)))
	(message "�������塼��򥳥ԡ����ޤ���")
	t)))

(defun xcal-yank-schedule ()
  (interactive)
  (if (not xcal-copy-buffer)
      (error "�������塼�뤬���ԡ�����Ƥ��ޤ���")
    (let (year month day dstFile temp-buffer buffer-read-only)
      (setq dstFile
	    (if xcal-disp-week (xcal-week-file-name xcal-current-day)
	      (xcal-file-name
	       xcal-current-year xcal-current-month xcal-current-day)))

      (if (and (file-exists-p dstFile)
	       (y-or-n-p "��񤭤��ޤ����� (n ���ɲ�)"))
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
	(error (format "%d��ʤ󤫤ʤ��衪" m)))
    (if (or (< d 1)(< (calendar-last-day-of-month m y) d))
	(error (format "%d���ʤ󤫤ʤ��衪" d)))
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
  XCal ���á�
  X11 �� xcal �ߤ����ʤ��
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
		(cons "ɽ��" (make-sparse-keymap "display")))
	      (define-key xcal-map [menu-bar disp minical]
		'("Mini Calendar" . xcal-toggle-show-calendar))
	      (define-key xcal-map [menu-bar disp holiday]
		'("Holiday" . xcal-toggle-disp-holiday))

	      (define-key xcal-map [menu-bar next]
		'("����" . xcal-next))
	      (define-key xcal-map [menu-bar before]
		'("���" . xcal-before))

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
  "xcal �ߤ����ʴ����ǡ�Calendar ��ɽ�����롣"
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
  "xcal �� ����"
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
  "���������ΤҤ硼��"
  (let* ((week (calendar-day-of-week (list month 1 year)))
	 (last-of-month
	  (if (and (calendar-leap-year-p year) (= month 2))
	      29
	    (aref [31 28 31 30 31 30 31 31 30 31 30 31] (1- month))))
         (month-name
	;	  (aref ["January" "February" "March" "April" "May" "June"
	;		 "July" "August" "September" "October" "November" "December"]
	;		(1- month))
	  (aref ["1��" "2��" "3��" "4��" "5��" "6��"
		 "7��" "8��" "9��" "10��" "11��" "12��"]
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
    
    ;; ��ư���������ꥹ�Ȥκ���
    (if (or (null xcal-auto-holiday-alist)
	    (/= year (car xcal-auto-holiday-alist)))
	(setq xcal-auto-holiday-alist (xcal-make-auto-holiday-alist year)))
    
    (put-text-property (point-min) (point-max) 'face 'none)
    (insert-string (format "   %dǯ %s\n" year month-name))

    (let ((day 1)
	  (week-face nil))
      (while (< day last-of-month)
	(xcal-make-underline)
	(aset xcal-day-markers day (make-marker))
	(cond ((setq info (or (assoc day (cdr (assoc month xcal-holiday-alist)))
			      (assoc day (cdr (assoc month xcal-auto-holiday-alist)))))
	       ;; ��������
	       (if (not (listp (cdr info)))
		   (setq info (list nil (cdr info) nil xcal-holiday-week-color)))
	       (setq msg   (copy-sequence (nth 1 info)))
	       (setq week-face (xcal-lookup-face-create (or (nth 2 info) xcal-holiday-week-color)))
	       (if (nth 3 info)
		   (put-text-property 0 (length msg) 'face
				      (xcal-lookup-face-create (nth 3 info)) msg)))
	      ((assoc week xcal-week-holiday)
	       ;; ��������
	       (setq msg nil)
	       (setq week-face (xcal-lookup-face-create (nth 1 (assoc week xcal-week-holiday)))))
	      ((and (= week 1)
		    (or (assoc (1- day) (cdr (assoc month xcal-holiday-alist)))
			(assoc (1- day) (cdr (assoc month xcal-auto-holiday-alist)))))
	       (setq msg "���ص���")
	       (setq week-face (xcal-lookup-face-create xcal-holiday-week-color)))
	      (t
	       ;; �ʤ��ʤ�
	       (setq msg nil)
	       (setq week-face nil)))
	(if (setq info (assoc day (cdr (assoc month xcal-memorial-day-alist))))
	    ;; ��ǰ��
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

	;; ������ɽ�����ޤ���
	(and (null xcal-disp-holiday)(setq msg nil))
	  
	(let (buffer-read-only file prefix x-prefix col)
	  ;; �ƥ�ݥ��ΥХåե��˰ܤ�
	  (switch-to-buffer temp-buffer)
	  (setq buffer-read-only nil)
	  (erase-buffer)

	  ;; ����� �������ξ����
	  (and msg (insert msg "\n"))

	  ;; �������塼���
	  (setq file (xcal-file-name year month day))
	  (if (file-exists-p file)
	      (progn
		(aset xcal-day-schedule day t)
		(insert-file file)
		
		;; �������塼��Υޥå��󥰽���
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

	  ;; �Ǹ�β��Ԥ����
	  (goto-char (point-max))
	  (insert "\n\n")
	  (delete-blank-lines)

	  ;; ���ʤ� "\n" ���ɲ�
	  (goto-char (point-min))
	  (if (eobp)
	      (insert "\n"))

	  ;; ���դ�����
	  (setq prefix (concat (format "%2d " day)
			       (let (str)
				 ;; ����ɽ���򤫤���(isoyama)
				 (setq str (copy-sequence (aref ["��" "��" "��" "��" "��" "��" "��"] week)))
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
	    (forward-line 1)) ; ͽ��ʸ���󤬲�������Ķ����Ȥ�����̵�¥롼�פˤʤäƤ����Τǡ�next-line �� forward-line ���ѹ� oshiro 2011/2/28

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
  "�����������ΤҤ硼��"
  (let* (msg
	 (last-of-week 7)
	 (xcal-buffer (current-buffer))
	 (temp-buffer (get-buffer-create "*XCal-temp*")))
    (setq xcal-days last-of-week)
    (setq xcal-day-markers (make-vector (1+ xcal-days) nil))
    (setq xcal-day-schedule (make-vector (1+ xcal-days) nil))

    (put-text-property (point-min) (point-max) 'face 'none)

    (insert-string "   ����ͽ��\n")
    (let ((week 1) (face nil))
      (while (<= week last-of-week)
	(xcal-make-underline)
	(aset xcal-day-markers week (make-marker))
	(let (buffer-read-only file prefix x-prefix col)
	  ;; �ƥ�ݥ��ΥХåե��˰ܤ�
	  (switch-to-buffer temp-buffer)
	  (setq buffer-read-only nil)
	  (erase-buffer)
	  
	  ;; �������塼���
	  (setq file (xcal-week-file-name week))
	  (if (file-exists-p file)
	      (progn
		(aset xcal-day-schedule week t)
		(insert-file file)))
	   
	  ;; �Ǹ�β��Ԥ����
	  (goto-char (point-max))
	  (insert "\n\n")
	  (delete-blank-lines)
	  
	  ;; ���ʤ� "\n" ���ɲ�
	  (goto-char (point-min))
	  (if (eobp) (insert "\n"))
	  (setq prefix
		(concat
		 (aref ["��" "��" "��" "��" "��" "��" "��"] (1- week))
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
  "ǯ��������ե�����̾��������롣

Unix : {Calnedar}/xy{ǯ}/xc{��}{��(ʸ��)}{ǯ}
       1999/1/1 -> ~/Calnedar/xy1991/xc1Jan1991
    xcal-schedule-xcalndar-compatible �����ꤵ��Ƥ����
       1999/1/1 -> ~/Calnedar/xc1Jan1991

Dos  : {Calnedar}/xy{ǯ}/xc{ǯ(%04d)}{��(%02d)}.{��(%02d)}
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
  "��������ե�����̾��������롣"
  (format "%s/%s" xcal-directory (nth 1 (nth (1- week) xcal-week-schedule))))

(defun xcal-write-region (begin end file)
  (xcal-make-directory (file-name-directory file))
  (write-region (point-min) (point-max) file))
  
(defun xcal-make-directory (directory)
  "Make DIRECTORY recursively.
gnus-make-directory ���Τޤ�"
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
;  (xxx-to-xcal-file gnus-Article-buffer)) ;; �Ť��С������� GNUS ��
  (xxx-to-xcal-file gnus-article-buffer)) ;; �С������??�ʾ�� Gnus ��
  
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
��ͽ�� \\[xcal-toggle-disp-month-and-week]  "
	     "\
��� \\[xcal-before]  \
���� \\[xcal-next]  \
���� \\[xcal-previous-day]  \
���� \\[xcal-next-day]  ")
"�Խ� \\[xcal-edit-for-xcal]  \
��� \\[xcal-delete-file]  \
��λ \\[xcal-quit]"))))
  (message xcal-keys-message))
  
(defun xcal-print-out ()
  (interactive)
  (if (yes-or-no-p (format "%d ��Υ������塼�����Ϥ��ޤ��� ?"
			   xcal-current-month))
      (call-process-region (point-min) (point-max)
			   (or xcal-print-out-command "lpr")
			   nil nil)))
  
  
  
(defvar xcal-week-select-index nil)
;;                                      1         2         3         4         5
;;                             1234567890123456789012345678901234567890123456789012
  
(defvar xcal-week-schedule '(("��" "xwSun")
			     ("��" "xwMon")
			     ("��" "xwTue")
			     ("��" "xwWed")
			     ("��" "xwThu")
			     ("��" "xwFri")
			     ("��" "xwSat")))
  
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
    (setq unread-command-char ?p) ; ����������ˡ�ϡ�
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
    (insert "�������Υ������塼��Ǥ�����  ")
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
				  "�����Υ������塼��"))
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
  "yearǯ��month�����nth��wday�����ϲ�����"
  (+ (+ 1 (mod (- 1 (calendar-day-of-week (list month 1 year))) 7))
     (* 7 (- nth 1))))

(defun xcal-day-of-seijin (year)
  (cons (if (< year 2000)
	    15
	  (xcal-nth-wday-day year 1 1 2)) ; 1�����2����
	"���ͤ���"))

(defun xcal-day-of-umi (year)
  (cons (if (< year 2003)
	    20
	  (xcal-nth-wday-day year 7 1 3)) ; 7�����3����
	"������"))

(defun xcal-day-of-keirou (year)
  (cons (if (< year 2003)
	    15
	  (xcal-nth-wday-day year 9 1 3)) ; 9�����3����
	"��Ϸ����"))

(defun xcal-day-of-taiiku (year)
  (cons (if (< year 2000)
	    10
	  (xcal-nth-wday-day year 10 1 2)) ; 10�����2����
	"�ΰ����"))

(defun xcal-day-of-syunbun (year)
  (cons (- (/ (+ (* 8 year) 1182) 33) (/ year 4))
	"��ʬ����"))

(defun xcal-day-of-syuubun (year)
  (cons (- (/ (+ (* 8 year) 1261) 33) (/ year 4))
	"��ʬ����"))

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
;; ���顼��ط��δؿ�
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
