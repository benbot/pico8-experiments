;;; emacsscriope.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2022 Ben Bot
;;
;; Author: Ben Bot <benj@minbot.win>
;; Maintainer: Ben Bot <benj@minbot.win>
;; Created: April 12, 2022
;; Modified: April 12, 2022
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/benbot/emacsscriope
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(defun build-to-pico ()
  (interactive)
  (write-file (buffer-name))
  (let ((buf (current-buffer))
        (cartname (car (split-string (buffer-name) "\\."))))
    (fennel-view-compilation)
    (let* ((fennelbuf (current-buffer))
           (filename (concat cartname ".p8"))
           (startpoint)
           (endpoint))
      (with-temp-buffer
        (insert-file-contents filename)
        (goto-char (point-min))
        (re-search-forward "__lua__" nil t 1)
        (forward-line 1)
        (move-to-column 0)
        (setq startpoint (point))
        (re-search-forward "__gfx__" nil t 1)
        (move-to-column 0)
        (setq endpoint (point))
        (narrow-to-region startpoint endpoint)
        (delete-region startpoint endpoint)
        (insert-buffer-substring fennelbuf)
        (goto-char endpoint)
        (forward-line -1)
        (delete-matching-lines "^return")
        (widen)
        (write-file filename))
      (kill-buffer fennelbuf))
    (set-buffer buf)))

(provide 'build-to-pico)
