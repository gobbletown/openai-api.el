;; (require 'openai-api)

(defun openai-prepare-data (fp)
  "This tool accepts different formats, with the only requirement that they contain a prompt
and a completion column/key. You can pass a CSV, TSV, XLSX, JSON or JSONL file, and it
will save the output into a JSONL file ready for fine-tuning, after guiding you through
the process of suggested changes."
  (cmd "openai" "tools" "fine_tunes.prepare_data" "-f" fp))


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