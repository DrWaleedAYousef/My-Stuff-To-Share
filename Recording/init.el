;; (defun 2-windows-vertical-to-horizontal ()
;;   (let ((buffers (mapcar 'window-buffer (window-list))))
;;     (when (= 2 (length buffers))
;;       (delete-other-windows)
;;       (set-window-buffer (split-window-horizontally) (cadr buffers))
;;       (shrink-window-horizontally 20)
;;       (load-theme 'whiteboard)
;;       ))
;; )
;; (add-hook 'emacs-startup-hook '2-windows-vertical-to-horizontal)

(
 let ((buffers (mapcar 'window-buffer (window-list))))
  (delete-other-windows)
  (split-window-horizontally)
  ;;(load-theme 'whiteboard)
  (set-background-color "white")
  (shrink-window-horizontally 20)
  )





