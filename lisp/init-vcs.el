;; init-vcs.el --- Initialize version control system configurations.	-*- lexical-binding: t -*-
;;
;; Author: Vincent Zhang <seagle0128@gmail.com>
;; Version: 3.3.0
;; URL: https://github.com/seagle0128/.emacs.d
;; Keywords:
;; Compatibility:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;             Version control systems, e.g. Git, SVN.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

(eval-when-compile (require 'init-const))

;; Git
(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch-popup)
         ("C-c M-g" . magit-file-popup))
  :config
  (when sys/win32p
    (setenv "GIT_ASKPASS" "git-gui--askpass"))

  ;; Github integration (require Emacs>=25)
  (when (>= emacs-major-version 25)
    (use-package magithub
      :init (magithub-feature-autoinject t)))

  ;; Gitflow externsion for Magit
  (use-package magit-gitflow
    :diminish magit-gitflow-mode
    :bind (:map magit-status-mode-map
                ("G" . magit-gitflow-popup))
    :init (add-hook 'magit-mode-hook #'turn-on-magit-gitflow)
    :config
    (magit-define-popup-action 'magit-dispatch-popup
      ?G "GitFlow" #'magit-gitflow-popup ?!))

  ;; Git-Svn extension for Magit
  (use-package magit-svn
    :diminish magit-svn-mode
    :init (add-hook 'magit-mode-hook #'magit-svn-mode))

  ;; Pretty magit
  (use-package pretty-magit
    :ensure nil
    :commands (pretty-magit)
    :after (ivy all-the-icons)
    :if (display-graphic-p)
    :init
    (pretty-magit "Feature" ? (:foreground "slate gray" :height 1.2))
    (pretty-magit "Add"     ? (:foreground "#375E97" :height 1.2))
    (pretty-magit "New"     ? (:foreground "#375E97" :height 1.2))
    (pretty-magit "Fix"     ? (:foreground "#FB6542" :height 1.2))
    (pretty-magit "Clean"   ? (:foreground "#FFBB00" :height 1.2))
    (pretty-magit "Delete"  ? (:foreground "#FFBB00" :height 1.2))
    (pretty-magit "Remove"  ? (:foreground "#FFBB00" :height 1.2))
    (pretty-magit "Docs"    ? (:foreground "#3F681C" :height 1.2))
    (pretty-magit "Refactor"? (:foreground "#1E90FF" :height 1.2))
    (pretty-magit "Format"  ? (:foreground "#1E90FF" :height 1.2))
    (pretty-magit "Update"  ? (:foreground "#1E90FF" :height 1.2))
    (pretty-magit "master"  ? (:box nil :height 1.2) t)
    (pretty-magit "origin"  ? (:box nil :height 1.2) t)))

;;; Pop up last commit information of current line
(use-package git-messenger
  :commands git-messenger:copy-message
  :bind (:map vc-prefix-map
              ("p" . git-messenger:popup-message)
              :map git-messenger-map
              ("m" . git-messenger:copy-message))
  :init
  ;; Use magit-show-commit for showing status/diff commands
  (setq git-messenger:use-magit-popup t))

;; Walk through git revisions of a file
(use-package git-timemachine
  :bind (:map vc-prefix-map
              ("t" . git-timemachine)))

;; Highlighting regions by last updated time
(use-package smeargle
  :bind (:map vc-prefix-map
              ("S" . smeargle)
              ("C" . smeargle-commits)
              ("R" . smeargle-clear)))

;; Git modes
(use-package gitattributes-mode)
(use-package gitconfig-mode)
(use-package gitignore-mode)

;; Subversion
(use-package psvn)

;; Open github/gitlab/bitbucket page
(use-package browse-at-remote)

(provide 'init-vcs)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-vcs.el ends here
