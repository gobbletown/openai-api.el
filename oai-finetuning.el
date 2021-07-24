;; (json-encode-list '(("prompt" "completion") ("prompt2" "completion")))
;; The question is: are completions coming quick extend beyond completion and is more like transformation?
;; This is what the prompt should encode anyway, so I'll do that.
;; (json-encode-list '(("prompt" . "once upon a time") ("completion" "once upon a time there was a frog")))
;; (json-encode-list '(("prompt" . "once upon a time") ("completion" . "there was a frog")))

(defset oai-ft-training-data-testset
  '((("prompt" . "once upon a time") ("completion" . "there was a frog"))
    (("prompt" . "about a") ("completion" . "frog"))))

(defun openai-prepare-data (prompt-completion-tuples)
  "This tool accepts different formats, with the only requirement that they contain a prompt
and a completion column/key. You can pass a CSV, TSV, XLSX, JSON or JSONL file, and it
will save the output into a JSONL file ready for fine-tuning, after guiding you through
the process of suggested changes."
  (let ((fp
         (cond
          ((f-file-p prompt-completion-tuples) prompt-completion-tuples)
          ((listp prompt-completion-tuples)
           (make-temp-file
            "oai-ft-" nil txt
            (lines2str
             (loop for tp in prompt-completion-tuples collect (json-encode-alist tp))))))))
    (etv (pps prompt-completion-tuples)))
  ;; (cmd "openai" "tools" "fine_tunes.prepare_data" "-f" prompt-completion-tuples)
  )

(openai-prepare-data oai-ft-training-data-testset)

(defun openai-fine-tune-prepare (train-file-id-or-path base-model)
  "Where BASE_MODEL is the name of the base model you're starting from (ada, babbage, or
curie). Note that if you're fine-tuning a model for a classification task, you should
also set the parameter --no_packing.

Running this does several things:

1 Uploads the file using the files API (or uses an already-uploaded file)
2 Creates a fine-tune job
3 Streams events until the job is done (this often takes minutes, but can take hours if
 there are many jobs in the queue or your dataset is large)"
  (cmd "openai" "api" "fine_tunes.create" "-t" train-file-id-or-path "-m" base-model))

(provide 'oai-finetuning)