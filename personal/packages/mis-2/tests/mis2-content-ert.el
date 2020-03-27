;; -*- mode: emacs-lisp; lexical-binding: t -*-


;;------------------------------------misut-------------------------------------
;;--                         Make It So Unit Tests!                           --
;;----------------------------(will center on exit)-----------------------------

;; Test Helpers
(require 'mis2-ert-mock-stub)
(require 'mis2-ert-setup)

;; Test Data
;; None right now...

;; Test Requirements
(require 'mis2-themes)
(require 'mis2-settings)
(require 'mis2-contents)


;;---
;; Runner Shortcuts
;;---
;; (ert "mis2-ert/contents/.*")


;;------------------------------------------------------------------------------
;; Consts & Vars
;;------------------------------------------------------------------------------

(defvar-local mis2-ert/contents/themes/storage nil
  "mis2-ert/mis2-contents' backup and restore helpers store/retrieve a copy of
`mis2/themes' here.")

(defvar-local mis2-ert/contents/fill-column/storage fill-column
  "mis2-ert/mis2-contents' backup and restore helpers store/retrieve a copy of
`mis2/themes' here.")



;;------------------------------------------------------------------------------
;; Setup & Teardown Helpers
;;------------------------------------------------------------------------------

(defun mis2-ert/mis2-contents/setup ()
  "Calls `mis2-ert/setup' for general setup then does setup/reset
specific to this test suite."
  ;; save fill column
  (setq mis2-ert/contents/fill-column/storage fill-column)
  (mis2-ert/setup/setup))


(defun mis2-ert/mis2-contents/teardown ()
  "Calls `mis2-ert/teardown' for general setup then does setup
specific to this test suite."
  ;; reset fill column
  (setq fill-column mis2-ert/contents/fill-column/storage)
  (mis2-ert/setup/teardown))


(defun mis2-ert/mis2-contents/themes/backup ()
  "Reverts `mis2/themes' back to it's backed up value.
"
  (setq mis2-ert/contents/themes/storage (copy-sequence mis2/themes)))


(defun mis2-ert/mis2-contents/themes/restore ()
  "Reverts `mis2/themes' back to it's backed up value.
"
  (setq mis2/themes (copy-sequence mis2-ert/contents/themes/storage)))


;;------------------------------------------------------------------------------
;; Mocks
;;------------------------------------------------------------------------------


;;------------------------------------------------------------------------------
;; Test: mis2//contents/build/string
;;------------------------------------------------------------------------------
;; (defun mis2//contents/build/string (contents)

;;---
;; Test Case 000
;;---
(ert-deftest mis2-ert/contents/build/string/simple ()
  "Test that `mis2//contents/build/string' can build & return a simple string
from contents.
"
  (mis2-ert/mis2-contents/setup)

  ;; Simple string just gets returned as-is.
  (should (string= (mis2//contents/build/string '("Hello, World."))
                   "Hello, World."))

  ;; Single other thing gets formatted.
  (should (string= (mis2//contents/build/string '(:face))
                   ":face"))

  ;; Nothing in; nothing out (but it's a string now!).
  (should (string= (mis2//contents/build/string nil)
                   "nil"))

  ;; Single other thing gets formatted.
  (should (string= (mis2//contents/build/string '((1 2 3 4 5)))
                   "(1 2 3 4 5)"))

  (mis2-ert/mis2-contents/teardown))


;;---
;; Test Case 001
;;---
(ert-deftest mis2-ert/contents/build/string/formatter ()
  "Test that `mis2//contents/build/string' can build & return a simple string
from contents.
"
  (mis2-ert/mis2-contents/setup)

  ;; More than one thing in contents means first thing is formatting string.
  (should (string= (mis2//contents/build/string '("Hello, %s" "World."))
                   "Hello, World."))

  ;; Bad contents? No formatter string...
  (should-error (mis2//contents/build/string '(:keyword valueword)))

  ;; Null formatter - also bad.
  (should-error (mis2//contents/build/string '(nil "hello")))

  ;; more extra args than percents in formatter
  (should (string= (mis2//contents/build/string
                    '("Hello, %s" "World" "," "my name is..."))
                   ;; means we just don't get the rest.
                   "Hello, World"))

  (mis2-ert/mis2-contents/teardown))


;;------------------------------------------------------------------------------
;; Test: mis2//contents/build/propertize
;;------------------------------------------------------------------------------
;; (defun mis2//contents/build/propertize (message plist)

;;---
;; Test Case 000
;;---
(ert-deftest mis2-ert/contents/build/propertize/nothing ()
  "Test that `mis2//contents/build/propertize' can return an unaltered string
when no properties are there to add.
"
  (mis2-ert/mis2-contents/setup)

  ;; No mis2 plist at all is an error.
  (should-error (mis2//contents/build/propertize "Hello, World." nil))

  ;; Simple string just gets returned as-is.
  ;; Using simplest 'valid' mis2 plist we can...
  (should (string= (mis2//contents/build/propertize "Hello, World."
                                                    '(:mis2//testing))
                   "Hello, World."))

  ;; Have a mis2 plist without `:face' in style.
  (let ((plist '(:mis2//settings (:theme :default)
                 :mis2//style (:margins (">" "<"))
                 :mis2//testing)))
    (should (string= (mis2//contents/build/propertize "Hello, World."
                                                      plist)
                     "Hello, World.")))

  ;; Have a mis2 plist without `:theme' or `:face' in style.
  (let ((plist '(:mis2//settings nil
                 :mis2//style (:margins (">" "<"))
                 :mis2//testing)))
    (should (string= (mis2//contents/build/propertize "Hello, World."
                                                      plist)
                     "Hello, World.")))

  (mis2-ert/mis2-contents/teardown))


;;---
;; Test Case 001
;;---
(ert-deftest mis2-ert/contents/build/propertize/face ()
  "Test that `mis2//contents/build/propertize' can return a propertized string
when there is a face to use.
"
  (mis2-ert/mis2-contents/setup)
  (mis2-ert/mis2-contents/themes/backup)

  (setq mis2/themes '(:default (:test-face0 font-lock-keyword-face
                                :test-face1 font-lock-comment-face)
                      :fancy   (:test-face0 font-lock-string-face
                                :test-face1 font-lock-type-face)))

  ;; Have a mis2 plist with `:face' in style, but no theme in settings.
  ;; Should use `:default' theme.
  (let ((plist '(:mis2//settings nil
                 :mis2//style (:face :test-face0)
                 :mis2//testing))
        (expected-output "Hello, World.")
        message)
    (setq message (mis2//contents/build/propertize "Hello, World."
                                                   plist))
    ;; Should have our string as expected.
    (should (string= message expected-output))

    ;; And each element in it should be propertized with the face.
    (dotimes (i (length expected-output))
      (should (eq (get-text-property 0 'face message)
                  'font-lock-keyword-face))))

  ;; Same thing, but :fancy theme
  (let ((plist '(:mis2//settings (:theme :fancy)
                 :mis2//style (:face :test-face0)
                 :mis2//testing))
        (expected-output "Hello, World.")
        message)
    (setq message (mis2//contents/build/propertize "Hello, World."
                                                   plist))
    ;; Should have our string as expected.
    (should (string= message expected-output))

    ;; And each element in it should be propertized with the face.
    (dotimes (i (length expected-output))
      (should (eq (get-text-property 0 'face message)
                  'font-lock-string-face))))

  ;; :fancy & :test-face1
  (let ((plist '(:mis2//settings (:theme :fancy)
                 :mis2//style (:face :test-face1)
                 :mis2//testing))
        (expected-output "Hello, World.")
        message)
    (setq message (mis2//contents/build/propertize "Hello, World."
                                                   plist))
    ;; Should have our string as expected.
    (should (string= message expected-output))

    ;; And each element in it should be propertized with the face.
    (dotimes (i (length expected-output))
      (should (eq (get-text-property 0 'face message)
                  'font-lock-type-face))))

  ;; Done; set mis2/themes back and check that that worked too.
  (mis2-ert/mis2-contents/themes/restore)

  (should (seq-set-equal-p mis2/themes mis2-ert/contents/themes/storage))

  (mis2-ert/mis2-contents/teardown))


;;------------------------------------------------------------------------------
;; Test: mis2//contents/align
;;------------------------------------------------------------------------------
;; (defun mis2//contents/align (string plist)

;;---
;; Test Case 000
;;---
(ert-deftest mis2-ert/contents/align/left ()
  "Test that `mis2//contents/align' can return a properly aligned string
when no or `:left' alignment is supplied.
"
  (mis2-ert/mis2-contents/setup)

  ;; No mis2 plist at all is an error.
  (should-error (mis2//contents/align "Hello, World." nil))

  ;; Simple string just gets returned as-is.
  ;; Using simplest 'valid' mis2 plist we can...
  (should (string= (mis2//contents/align "Hello, World."
                                         '(:mis2//testing))
                   "Hello, World."))

  ;; With :line-width. Shouldn't affect left-aligned, but is related to
  ;; alignment.
  (should (string= (mis2//contents/align "Hello, World."
                                         '(:mis2//settings (:line-width 40)
                                           :mis2//testing))
                   "Hello, World."))

  ;; With :left, no :line-width.
  (should (string= (mis2//contents/align "Hello, World."
                                         '(:mis2//settings (:left t)
                                           :mis2//testing))
                   "Hello, World."))

  ;; With :left and :line-width.
  (should (string= (mis2//contents/align "Hello, World."
                                         '(:mis2//settings (:left t
                                                            :line-width 40)
                                           :mis2//testing))
                   "Hello, World."))

  (mis2-ert/mis2-contents/teardown))


;;---
;; Test Case 001
;;---
(ert-deftest mis2-ert/contents/align/center/no-reserve ()
  "Test that `mis2//contents/align' can return a properly aligned string
when `:center' alignment is supplied.
"
  (mis2-ert/mis2-contents/setup)

  ;; Give ourselves a known line-width.
  (let ((line-width 80)
        (string-odd "Hello, World.") ;; odd number of chararcters to center
        (string-even "Hello, Jeff.")) ;; even number of chararcters to center

    ;; :center? Nil means no.
    (should (string= (mis2//contents/align string-odd
                                           '(:mis2//style (:center nil)
                                             :mis2//testing))
                     string-odd))

    ;; Actually centered. No left/right reserved.
    (should (string= (mis2//contents/align string-odd
                                           '(:mis2//style (:center t)
                                             :mis2//testing))
                     ;; extra space is put in front of string
                     (concat
                      (make-string 34 ?\s)
                      string-odd
                      (make-string 33 ?\s))))
    (should (string= (mis2//contents/align string-even
                                           '(:mis2//style (:center t)
                                             :mis2//testing))
                     ;; extra space is put in front of string
                     (concat
                      (make-string 34 ?\s)
                      string-even
                      (make-string 34 ?\s))))

    ;; Actually centered. No left/right reserved. Line width override.
    (should (string= (mis2//contents/align string-odd
                                           '(:mis2//settings (:line-width 40)
                                             :mis2//style (:center t)
                                             :mis2//testing))
                     ;; extra space is put in front of string
                     (concat
                      (make-string 14 ?\s)
                      string-odd
                      (make-string 13 ?\s))))
    (should (string= (mis2//contents/align string-even
                                           '(:mis2//settings (:line-width 40)
                                             :mis2//style (:center t)
                                             :mis2//testing))
                     ;; extra space is put in front of string
                     (concat
                      (make-string 14 ?\s)
                      string-even
                      (make-string 14 ?\s)))))

  (mis2-ert/mis2-contents/teardown))


;;---
;; Test Case 002
;;---
(ert-deftest mis2-ert/contents/align/center/with-reserve ()
  "Test that `mis2//contents/align' can return a properly aligned string
when `:center' alignment is supplied and a reserve exists.
"
  (mis2-ert/mis2-contents/setup)

  ;; Give ourselves a known line-width.
  (let ((line-width 80)
        (string-odd "Hello, World.") ;; odd number of chararcters to center
        (string-even "Hello, Jeff.")) ;; even number of chararcters to center

    ;; Actually centered. No left/right reserved.
    (should (string= (mis2//contents/align string-odd
                                           '(:mis2//style (:center t
                                                           :margins ("xx" "xx"))
                                             :mis2//testing))
                     ;; Extra space is put in front of string. 2 chars knocked
                     ;; off front & back compared to no-reserved case.
                     (concat
                      (make-string 32 ?\s)
                      string-odd
                      (make-string 31 ?\s))))

    (should (string= (mis2//contents/align string-even
                                           '(:mis2//style (:center t
                                                           :borders ("yy" "yy"))
                                             :mis2//testing))
                     (concat
                      (make-string 32 ?\s)
                      string-even
                      (make-string 32 ?\s))))

    ;; Asymmetrical reserved.
    (should (string= (mis2//contents/align string-even
                                           '(:mis2//style (:center t
                                                           :margins (nil "xx")
                                                           :borders ("yy" "yy"))
                                             :mis2//testing))
                     ;; Less at end of string due to asymmetry.
                     (concat
                      (make-string 32 ?\s)
                      string-even
                      (make-string 30 ?\s))))

    ;; Asymmetrical reserved.
    (should (string= (mis2//contents/align string-even
                                           '(:mis2//style (:center t
                                                           :margins ("xx" nil)
                                                           :borders ("yy" "yy"))
                                             :mis2//testing))
                     ;; Less at beginning of string due to asymmetry.
                     (concat
                      (make-string 30 ?\s)
                      string-even
                      (make-string 32 ?\s)))))

  (mis2-ert/mis2-contents/teardown))


;;---
;; Test Case 003
;;---
(ert-deftest mis2-ert/contents/align/right/no-reserve ()
  "Test that `mis2//contents/align' can return a properly aligned string
when `:right' alignment is supplied.
"
  (mis2-ert/mis2-contents/setup)

  ;; Give ourselves a known line-width.
  (let ((line-width 80)
        (string-odd "Hello, World.") ;; odd number of chararcters
        (string-even "Hello, Jeff.")) ;; even number of chararcters

    ;; :right? Nil means no.
    (should (string= (mis2//contents/align string-odd
                                           '(:mis2//style (:right nil)
                                             :mis2//testing))
                     string-odd))

    ;; Actually right-aligned. No left/right reserved.
    (should (string= (mis2//contents/align string-odd
                                           '(:mis2//style (:right t)
                                             :mis2//testing))
                     ;; extra spaces are all in front of string
                     (concat
                      (make-string (- line-width (length string-odd)) ?\s)
                      string-odd)))

    (should (string= (mis2//contents/align string-even
                                           '(:mis2//style (:right t)
                                             :mis2//testing))
                     ;; extra space is put in front of string
                     (concat
                      (make-string (- line-width (length string-even)) ?\s)
                      string-even)))

    ;; Actually right-aligned. No left/right reserved. Line width override.
    (should (string= (mis2//contents/align string-odd
                                           '(:mis2//settings (:line-width 40)
                                             :mis2//style (:right t)
                                             :mis2//testing))
                     ;; extra spaces are all in front of string
                     (concat
                      (make-string (- 40 (length string-odd)) ?\s)
                      string-odd)))

    (should (string= (mis2//contents/align string-even
                                           '(:mis2//settings (:line-width 40)
                                             :mis2//style (:right t)
                                             :mis2//testing))
                     ;; extra space is put in front of string
                     (concat
                      (make-string (- 40 (length string-even)) ?\s)
                      string-even))))

  (mis2-ert/mis2-contents/teardown))


;;---
;; Test Case 004
;;---
(ert-deftest mis2-ert/contents/align/right/with-reserve ()
  "Test that `mis2//contents/align' can return a properly aligned string
when `:right' alignment is supplied and a reserve exists.
"
  (mis2-ert/mis2-contents/setup)

  ;; Give ourselves a known line-width.
  (let ((line-width 80)
        (string-odd "Hello, World.") ;; odd number of chararcters to right
        (string-even "Hello, Jeff.")) ;; even number of chararcters to right

    ;; Actually right-aligned. No left/right reserved.
    (should (string= (mis2//contents/align string-odd
                                           '(:mis2//style (:right t
                                                           :margins ("xx" "xx"))
                                             :mis2//testing))
                     (concat
                      (make-string (- line-width (length string-odd)
                                      ;; minus both margins too
                                      2 2)
                                   ?\s)
                      string-odd)))

    (should (string= (mis2//contents/align string-even
                                           '(:mis2//style (:right t
                                                           :borders ("yy" "yy"))
                                             :mis2//testing))
                     (concat
                      (make-string (- line-width (length string-even)
                                      ;; minus both margins too
                                      2 2)
                                   ?\s)
                      string-even)))

    ;; Asymmetrical reserved.
    (should (string= (mis2//contents/align string-even
                                           '(:mis2//style (:right t
                                                           :margins (nil "xx")
                                                           :borders ("yy" "yy"))
                                             :mis2//testing))
                     (concat
                      (make-string (- line-width (length string-even)
                                      ;; Minus asymmetrical margins.
                                      0 2
                                      ;; Minus borders.
                                      2 2)
                                   ?\s)
                      string-even)))

    ;; Asymmetrical reserved.
    (should (string= (mis2//contents/align string-even
                                           '(:mis2//style (:right t
                                                           :margins ("xx" nil)
                                                           :borders ("yy" "yy"))
                                             :mis2//testing))
                     (concat
                      (make-string (- line-width (length string-even)
                                      ;; Minus asymmetrical margins.
                                      2 0
                                      ;; Minus borders.
                                      2 2)
                                   ?\s)
                      string-even))))

  (mis2-ert/mis2-contents/teardown))



;;------------------------------------------------------------------------------
;; Local Test Data
;;------------------------------------------------------------------------------


;;------------------------------------------------------------------------------
;; The End.
;;------------------------------------------------------------------------------
(provide 'mis2-contents-ert)
