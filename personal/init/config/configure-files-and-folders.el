;; -*- emacs-lisp -*-

;; TODO: configure-text, configure-point-and-mark, configure-dev-env, configure-files-and-folders...
;; check to see if they've got the correct pieces

;;------------------------------------------------------------------------------
;; Dired
;;------------------------------------------------------------------------------
;; TODO: note for this:
;; `C-x d' for dired
;; TODO: add a shortcut for `find-dired'?
;; `C-x C-d' maybe?

;; TODO: windows doesn't seem to like this `find-dired'?
;; "By default Emacs will pass -exec to find and that makes it very slow. It is
;; better to collate the matches and then use xargs to run the command. To do
;; this instead add this to your .emacs."
;;   - https://www.masteringemacs.org/article/working-multiple-files-dired
;; Trial [2019-01-29]
(require 'find-dired)
(setq find-ls-option '("-print0 | xargs -0 ls -ld" . "-ld"))

;;---
;; peep-dired
;;---
;; For quick look into files at point in dired buffer.
;; https://github.com/asok/peep-dired
;; Trial [2019-01-29]
(use-package peep-dired
  ;; TODO: some config settings maybe?
  ;;   - peep-dired-cleanup-eagerly seems good...
  ;;   - also this (setq peep-dired-ignored-extensions '("mkv" "iso" "mp4"))

  ;; TODO: do we want these shortcuts or not?
  ;; :bind (:map peep-dired-mode-map 
  ;;        ("SPC" . nil)            ;; scroll peeped file down
  ;;        ("<backspace>" . nil))   ;; scroll peeped file up
  )
;; TODO: [2019-01-29] This... doesn't seem to be working?


;;------------------------------------------------------------------------------
;; recentf for recent files
;;------------------------------------------------------------------------------

;; From http://pages.sachachua.com/.emacs.d/Sacha.html#org0676afd
(require 'recentf)
(setq recentf-max-saved-items 200
      recentf-max-menu-items 15)
;; Recentf and TRAMP need some peace-keeping to get along.
;; https://lists.gnu.org/archive/html/bug-gnu-emacs/2007-07/msg00019.html
(add-to-list 'recentf-keep 'file-remote-p)
(recentf-mode)

;; may want to exclude more? idk.
(unless (spydez/dir/self-policing-p)
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory))

;; More config:
;;   periodically save list of files: https://www.emacswiki.org/emacs/RecentFiles#toc1
;;
;;   Helm: https://www.emacswiki.org/emacs/RecentFiles#toc11
;;     - ‘M-x helm-recentf’ will show only recently opened files (from recentf).


;;------------------------------------------------------------------------------
;; Copy Filename
;;------------------------------------------------------------------------------
;; This (or similar (prelude-copy-file-name-to-clipboard)) used to be in Prelude emacs.
;; https://github.com/bbatsov/prelude/issues/764
;; But they use easy-kill.el now for stuff, and I'm not sure I want all of it.
;; Trial [2019-01-30]
(defun spydez/copy-file-name-to-clipboard ()
  "Copy the current file name to the clipboard"
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (with-temp-buffer
        (insert filename)
        (clipboard-kill-region (point-min) (point-max)))
      (message "Copied buffer file name '%s' to the clipboard." filename)
      )))


;; This is more complex. Can do buffer file path or dired. C-u for folder instead of file.
;; http://ergoemacs.org/emacs/emacs_copy_file_path.html
;; Trial [2019-01-30]
(defun xah-copy-file-path (&optional @dir-path-only-p)
  "Copy the current buffer's file path or dired path to `kill-ring'.
Result is full path.
If `universal-argument' is called first, copy only the dir path.

If in dired, copy the file/dir cursor is on, or marked files.

If a buffer is not file and not dired, copy value of `default-directory' (which is usually the “current” dir when that buffer was created)

URL `http://ergoemacs.org/emacs/emacs_copy_file_path.html'
Version 2017-09-01"
  (interactive "P")
  (let (($fpath
         (if (string-equal major-mode 'dired-mode)
             (progn
               (let (($result (mapconcat 'identity (dired-get-marked-files) "\n")))
                 (if (equal (length $result) 0)
                     (progn default-directory )
                   (progn $result))))
           (if (buffer-file-name)
               (buffer-file-name)
             (expand-file-name default-directory)))))
    (kill-new
     (if @dir-path-only-p
         (progn
           (message "Directory path copied: 「%s」" (file-name-directory $fpath))
           (file-name-directory $fpath))
       (progn
         (message "File path copied: 「%s」" $fpath)
         $fpath )))))


;;------------------------------------------------------------------------------
;; Open files externally
;;------------------------------------------------------------------------------
;; This doesn't have a use for me right now, but I might want it eventually.
;; Would have to figure out the windows case of it:
;; https://emacsredux.com/blog/2013/03/27/open-file-in-external-program/


;;------------------------------------------------------------------------------
;; Smartscan
;;------------------------------------------------------------------------------
;; here or configure-text? text right now.


;;------------------------------------------------------------------------------
;; TODO: these. Parenthesis, bells?
;;------------------------------------------------------------------------------
;; here or configure-text? text right now.


;;------------------------------------------------------------------------------
;; Provide this.
;;------------------------------------------------------------------------------
(provide 'configure-files-and-folders)