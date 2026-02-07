;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Moralerspace Neon HWJPDOC" :size 16))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(setq confirm-kill-emacs nil)

(setq mac-right-option-modifier 'meta)

(map! "M-h" #'backward-kill-word
      "C-h" #'backward-delete-char-untabify)

(setq-default cursor-type 'bar)

;;; :completion ----------------------------------------------------------------
;; vertico
(after! vertico-posframe
  (setq vertico-posframe-poshandler #'posframe-poshandler-frame-top-center))

;;; :ui ------------------------------------------------------------------------
;; indent-guides
(after! indent-bars
  (setq indent-bars-no-stipple-char ?▏))

;; modeline
(after! anzu
  (global-anzu-mode +1))

;; neotree
(map! "s-b" #'neotree-toggle)
(after! neotree
  (setq neo-window-width 45)
  (setq neo-theme 'nerd-icons))

;; tabs
(after! centaur-tabs
  (map! "C-<tab>" #'centaur-tabs-forward
        "C-S-<tab>" #'centaur-tabs-backward
        "s-w" #'kill-current-buffer))

;;; :checkers ------------------------------------------------------------------
;; spell
(after! spell-fu
  (set-face-underline 'spell-fu-incorrect-face (list :style 'wave :color (doom-color 'green)))

  (setq spell-fu-word-delimit-camel-case t)

  ;; prog-mode でも全てチェックするように
  (defun spell-fu-all-faces ()
    (setq spell-fu-faces-include nil)
    (setq spell-fu-faces-exclude nil))

  (add-hook! 'spell-fu-mode-hook #'spell-fu-all-faces))

(after! ispell
  (setq ispell-dictionary "en_US"))

;;; :lang ----------------------------------------------------------------------
;; js
(after! js
  (setq js-indent-level 2))

;; web
(after! web-mode
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2)


  (setq web-mode-script-padding 0)
  (setq web-mode-style-padding 0))

;;; :config --------------------------------------------------------------------
;; default
(use-package! avy ; (use-package! avy) は無さそうだった
  :bind (:map isearch-mode-map
              ("C-'" . avy-isearch))
  :config
  ;; avy-goto-*の色をace-window風に
  (dolist (face avy-lead-faces)
    (set-face-attribute face nil
                        :foreground "red"
                        :background (face-background 'default)))
  ;; avy-isearchの色をace-window風に
  (defun my/avy-isearch-face-on ()
    (set-face-foreground 'lazy-highlight (face-foreground 'font-lock-doc-face))
    (set-face-background 'lazy-highlight (face-background 'default)))
  (defun my/avy-isearch-face-off ()
    ;; 確実に戻すためにマジックナンバーを使用
    (set-face-foreground 'lazy-highlight "#DFDFDF") ;; (face-foreground 'lazy-highlight)と同値
    (set-face-background 'lazy-highlight "#387aa7")) ;; (face-background 'lazy-highlight)と同値

  (advice-add 'avy-isearch :before #'my/avy-isearch-face-on)
  (advice-add 'avy-isearch :after #'my/avy-isearch-face-off))

;;; additional -----------------------------------------------------------------
;; mise
(use-package! mise
  :hook (typescript-ts-mode . mise-mode))

;; pulsar
;; :ui nav-flash はdeprecatedらしくpulsarに置き換わるらしい
;; (modules/ui/nav-flash/config.elより)
(use-package! pulsar
  :init
  (pulsar-global-mode 1)
  :config
  (setq pulsar-pulse-on-window-change t)
  (dolist (f '(isearch-exit avy-isearch neotree-toggle))
    (advice-add f :after #'pulsar-pulse-line)))

;; symbol-overlay
(use-package! symbol-overlay
  :config
  (setq symbol-overlay-idle-time 0.2)
  ;; isearch風に
  (set-face-foreground 'symbol-overlay-default-face (face-foreground 'lazy-highlight))
  (set-face-background 'symbol-overlay-default-face (face-background 'lazy-highlight))

  (map! "M-n" #'symbol-overlay-jump-next
        "M-p" #'symbol-overlay-jump-prev
        "M-i" #'symbol-overlay-put
        "<f8>" #'symbol-overlay-remove-all)
  :hook
  (prog-mode . symbol-overlay-mode))
