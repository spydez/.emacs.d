;; -*- mode: emacs-lisp; lexical-binding: t -*-


;;------------------------------------------------------------------------------
;; General Settings
;;------------------------------------------------------------------------------


;;-----------------------------------------------------------------------------
;; Web Bookmarks
;;-----------------------------------------------------------------------------

;; §-TODO-§ [2019-10-14]: get web bookmarks working...

;;---
;; Emacs Code
;;---

;; Original idea from org-linkz:
;;   https://github.com/p-kolacz/org-linkz
;; Well... Isn't really "from" or "derived from" anymore. That's super outdated
;; and don't go there or use that or org-mode will hate you as it hates me right
;; now... I guess "original idea from" now.

;; org-protocol set up in configure-org-mode.el

(defconst spydez/file/org/web-bookmarks
  (spydez/path/to-file spydez/dir/org-docs-secrets "web-bookmarks.org")
  "Org-Mode file for web bookmarksfile.")

;; org-linkz template was... old.
;; Does this work now?
;; https://orgmode.org/worg/org-contrib/org-protocol.html
;; https://orgmode.org/manual/Template-expansion.html#Template-expansion
(add-to-list 'org-capture-templates
             `("w" "Web Bookmark Capture" entry
               (file+headline ,spydez/file/org/web-bookmarks "INBOX")
               ,(format "* %s %s\\n\\n%s\\n  %s\\n\\n%s"
                        "%U" ;; inactive date & time stamp
                        "%a" ;; org-link of URL/Title
                        "%:description" ;; title
                        "%:link"        ;; URL
                        "%:initial")    ;; any selected text
               :immediate-finish t))
;; ...no. No it does not.
;; I get a buffer with a fucked up name that looks to be the
;; whole org-protocol link.
;; §-TODO-§ [2019-10-18]: Figure out web bookmarks. Still/again.

;; (find-file spydez/file/org/web-bookmarks)


;;---
;; Browser Bookmark
;;---

;; Something like this?
;;   https://orgmode.org/worg/org-contrib/org-protocol.html#orgeda0362
;;
;; javascript:location.href='org-protocol://capture://w/'+
;;       encodeURIComponent(location.href)+'/'+
;;       encodeURIComponent(document.title||"[untitled page]")+'/'+
;;       encodeURIComponent(window.getSelection())
;;
;; Ok. That's wrong (says outdated), but I got that from the org docs. :| WTF.

;; This one's from org-protocol.el in emacs26, so... Maybe?
;; javascript:location.href='org-protocol://capture?template=w&url='+
;;       encodeURIComponent(location.href)+'&title='+
;;       encodeURIComponent(document.title||"[untitled page]")+'&body='+
;;       encodeURIComponent(window.getSelection())
;; Sigh. No. Or yes and org-capture is fucking it up. IDK.
;; §-TODO-§ [2019-10-18]: Figure out web bookmarks. Still/again.


;;---
;; OS Integration
;;---

;; To setup OS integration, see:
;;   https://github.com/p-kolacz/org-linkz#add-org-protocol-support-to-os
;;
;; Linux:
;;   Add ~/.local/share/applications/org-protocol.desktop file with following content:
;;
;;   [Desktop Entry]
;;   Name=org-protocol
;;   Exec=emacsclient -n %u
;;   Type=Application
;;   Terminal=false
;;   Categories=System;
;;   MimeType=x-scheme-handler/org-protocol;
;;
;;   Run
;;
;;   update-desktop-database ~/.local/share/applications/
;;
;; Mac:
;;   https://github.com/xuchunyang/setup-org-protocol-on-mac
;;
;; Windows:
;;   https://orgmode.org/worg/org-contrib/org-protocol.html#orgf93bb1b
;;
;;   Windows users may register the "org-protocol" once for all by adjusting the
;;   following to their facts, save it as *.reg file and double-click it. This
;;   worked for me on Windows-XP Professional and the emasc23 from
;;   ourcomments.org (http://ourcomments.org/cgi-bin/emacsw32-dl-latest.pl). I'm
;;   no Windows user though and enhancements are more than welcome on the
;;   org-mode mailinglist. The original file is from
;;   http://kb.mozillazine.org/Register_protocol.
;;
;;     REGEDIT4
;;
;;     [HKEY_CLASSES_ROOT\org-protocol]
;;     @="URL:Org Protocol"
;;     "URL Protocol"=""
;;     [HKEY_CLASSES_ROOT\org-protocol\shell]
;;     [HKEY_CLASSES_ROOT\org-protocol\shell\open]
;;     [HKEY_CLASSES_ROOT\org-protocol\shell\open\command]
;;     @="\"C:\\Programme\\Emacs\\emacs\\bin\\emacsclientw.exe\" \"%1\""
;;
;; Or here is the file:
;; (spydez/path/to-file spydez/dir/org-docs-secrets
;;                      "setup-org-bookmark-protocol.reg")
;; NOTE: Open that and update path to emacs executable!!!


;;------------------------------------------------------------------------------
;; REST: restclient
;;------------------------------------------------------------------------------
;; https://github.com/pashky/restclient.el
;; Lots of helpful usage there.

;; Found restclient via:
;;   https://emacs.stackexchange.com/questions/2427/how-to-test-rest-api-with-emacs

;; Bare essentials blog post:
;;   https://jakemccrary.com/blog/2014/07/04/using-emacs-to-explore-an-http-api/

;; Once installed, you can prepare a text file with queries.
;;
;; restclient-mode is a major mode which does a bit of highlighting and supports a few additional keypresses:
;;
;;     C-c C-c: runs the query under the cursor, tries to pretty-print the response (if possible)
;;     C-c C-r: same, but doesn't do anything with the response, just shows the buffer
;;     C-c C-v: same as C-c C-c, but doesn't switch focus to other window
;;     C-c C-p: jump to the previous query
;;     C-c C-n: jump to the next query
;;     C-c C-.: mark the query under the cursor
;;     C-c C-u: copy query under the cursor as a curl command
;;     C-c C-g: start a helm session with sources for variables and requests (if helm is available, of course)
;;     C-c n n: narrow to region of current request (including headers)
;;     TAB: hide/show current request body, only if
;;     C-c C-a: show all collapsed regions
(use-package restclient
  ;;---
  :mode
  ;;---
  ;; Set some file extensions to use restclient in
  (("\\.http\\'" . restclient-mode)
   ("\\.restclient\\'" . restclient-mode)
   ;; restclient puts the response buffer into html mode automatically,
   ;; but sometimes I save that response as this extension.
   ("\\.restresponse\\'" . html-mode)))

;; See (spydez/path/to-file spydez/dir/personal/docs "example.restclient")
;; for an example file.
;; TODO: move that and unicode.txt into references if we get rid of other people's emacs files...

;; auto-completion for company in restclient mode
(use-package company-restclient
  :after (restclient know-your-http-well company)

  ;;---
  :init
  ;;---
  (add-to-list 'company-backends 'company-restclient))


;;------------------------------------------------------------------------------
;; Info/Help: know-your-http-well
;;------------------------------------------------------------------------------

;; https://github.com/for-GET/know-your-http-well
(use-package know-your-http-well
  :commands (http-header http-method http-relation http-status-code))
;; M-x http-header ;; content-type
;; M-x http-method ;; post | POST
;; M-x http-relation ;; describedby
;; M-x http-status-code ;; 500
;; M-x http-status-code ;; not_found | NOT_FOUND


;;------------------------------------------------------------------------------
;; Tasks, Wants, Feature Requests, etc.
;;------------------------------------------------------------------------------


;;------------------------------------------------------------------------------
;; Provide this.
;;------------------------------------------------------------------------------
(provide 'configure-web)
