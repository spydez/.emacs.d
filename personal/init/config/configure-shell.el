;; -*- emacs-lisp -*-


;; NOTE: shell and eshell are different things... apparently.


;;------------------------------------------------------------------------------
;; Shell: General Settings
;;------------------------------------------------------------------------------
;; (defun spydez/shell ()
;;   (interactive)
;;   (message "Undefined for OS: %s" system-type))

;; TODO: This seems useful maybe
;; (use-package exec-path-from-shell
;;   :config
;;   ;; Add GOPATH to shell
;;   (when (memq window-system '(mac ns))
;;     (exec-path-from-shell-copy-env "GOPATH")
;;     (exec-path-from-shell-copy-env "PYTHONPATH")
;;     (exec-path-from-shell-initialize)))

;; nhoffman's init.org has some potentially neat bash commands
;;   http://nhoffman.github.io/.emacs.d/#org18bd455
;; Not useful /right now/ as Git for Windows doesn't do a whole lot.


;;------------------------------------------------------------------------------
;; Shell: Git Bash for Windows?
;;------------------------------------------------------------------------------
;; (when (spydez/tools/os-and-tool-p 'windows-nt "bash")
;;   (defun spydez/windows/shell ()
;;     (interactive)
;;     (let* ((explicit-shell-file-name (executable-find "bash")))
;;       (shell)))
;;   (defalias 'spydez/shell 'spydez/windows/shell)
;;   )

;; [2019-07-11 Thu]
;; Garble trash on the shell prompt:
;;   ^[]0;MSYS:/c/home/user/.emacs.d^G
;;   user@host MSYS ~/.emacs.d (master)
;;   $
;; https://emacs.stackexchange.com/questions/22049/git-bash-in-emacs-on-windows
;;
;; Need to setup a .bash_profile with check for:
;;   $INSIDE_EMACS (helpfully set by emacs).
;; Have a bash_profile.emacs in docs/ with an example.

;; TODO-TODAY: Try this in if emacs part of .bash_profile?
;; Error trying to ssh where password is required:
;;   ssh_askpass: exec(/usr/lib/ssh/ssh-askpass): No such file or directory
;; https://www.reddit.com/r/emacs/comments/8i04lr/git_from_shelleshell_on_windows/dyo4ga7?utm_source=share&utm_medium=web2x
;;   "Either set env SSH_ASKPASS to the location of your askpass executable or
;; go through the pageant/plink setup from your first link. It's been forever
;; since I've been on windows, but I used pageant/plink with git/github without
;; much problem."
;;   - [deleted]
;;
;; But what to set it /to/?!
;;   https://github.com/magit/magit/wiki/Pushing-with-Magit-from-Windows#openssh-passphrase-caching-via-ssh-agent
;; Either:
;;   (setenv "SSH_ASKPASS" "git-gui--askpass")
;; Or:
;;   Something similar in that `if INSIDE_EMACS' block in .bash_profile
;; Those did not work:
;;   ssh_askpass: exec(git-gui--askpass): No such file or directory

;; TODO: figure out how to integrate this into use-tool
;; Set shell command to use git bash.
(when (use-tool-os-and-tool-p 'windows-nt "bash")
  (let ((bash-path (executable-find "bash")))
    (when bash-path
      (setq explicit-shell-file-name bash-path)
      (setq shell-file-name "bash")
      (setq explicit-bash.exe-args '("--login" "-i"))
      (setenv "SHELL" shell-file-name)
      ;; todo strip ctrl m?
      ;; todo fix error and MSYS line cruft
      ;;   - https://emacs.stackexchange.com/questions/22049/git-bash-in-emacs-on-windows
      )))


;;------------------------------------------------------------------------------
;; EShell
;;------------------------------------------------------------------------------

;; from: https://www.wisdomandwonder.com/wp-content/uploads/2014/03/C3F.html#sec-10-5
;;
;; Command completion is available. Commands input in eshell are delegated in
;; order to an alias, a built in command, an Elisp function with the same name,
;; and finally to a system call. Semicolons deparate commands. which tells you
;; what implementation will satisfy the call that you are going to make. The
;; flag eshell-prefer-lisp-functions does what it says. $$+ is the result of the
;; last command. Aliases live in `eshell-aliases-file'. History is maintained and
;; expandable. `eshell-source-file' will run scripts. Since Eshell is not a
;; terminal emulator, you need to tell it about any commands that need to run
;; using a terminal emulator, like anything using curses by adding it to to
;; `eshell-visual-commands'.

;; ...who knows how old that is but it /looks/ helpful. There is some config
;; code too if EShell becomes more popular around here.


;;------------------------------------------------------------------------------
;; dtach
;;------------------------------------------------------------------------------

;; Like Screen's 'detach' feature.
;; https://www.emacswiki.org/emacs/GnuScreen


;;------------------------------------------------------------------------------
;; Async `Shell-Command'
;;------------------------------------------------------------------------------

;; "execute" emacs package for more-than-one async command.
;; https://www.emacswiki.org/emacs/Execute.el

;; Running a Shell Command Asynchronously
;;
;;   "You can run a shell command asynchronously by adding an ampersand (&) after
;; it, if you have a UNIX or UNIX-like environment. Here is some EmacsLisp code
;; that modifies ‘shell-command’ to allow many commands to execute
;; asynchronously (and show the command at the top of the buffer):"
;;   - https://www.emacswiki.org/emacs/ExecuteExternalCommand
;; (defadvice erase-buffer (around erase-buffer-noop)
;;   "make erase-buffer do nothing")
;;
;; (defadvice shell-command (around shell-command-unique-buffer activate compile)
;;   (if (or current-prefix-arg
;;           (not (string-match "[ \t]*&[ \t]*\\'" command)) ;; background
;;           (bufferp output-buffer)
;;           (stringp output-buffer))
;;       ad-do-it ;; no behavior change
;;
;;     ;; else we need to set up buffer
;;     (let* ((command-buffer-name
;;             (format "*background: %s*"
;;                     (substring command 0 (match-beginning 0))))
;;            (command-buffer (get-buffer command-buffer-name)))
;;
;;       (when command-buffer
;;         ;; if the buffer exists, reuse it, or rename it if it's still in use
;;         (cond ((get-buffer-process command-buffer)
;;                (set-buffer command-buffer)
;;                (rename-uniquely))
;;               ('t
;;                (kill-buffer command-buffer))))
;;       (setq output-buffer command-buffer-name)
;;
;;       ;; insert command at top of buffer
;;       (switch-to-buffer-other-window output-buffer)
;;       (insert "Running command: " command
;;               "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n")
;;
;;       ;; temporarily blow away erase-buffer while doing it, to avoid
;;       ;; erasing the above
;;       (ad-activate-regexp "erase-buffer-noop")
;;       ad-do-it
;;       (ad-deactivate-regexp "erase-buffer-noop"))))


;;------------------------------------------------------------------------------
;; TODOs
;;------------------------------------------------------------------------------


;;------------------------------------------------------------------------------
;; Provide this.
;;------------------------------------------------------------------------------
(provide 'configure-shell)
