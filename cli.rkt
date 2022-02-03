#lang cli

(require racket/format)

(help (usage "Convert bookmark directory to a single file based on given format (defaults to Firefox bookmarks)"))

(flag (fmt-file f)
      ("-f" "--formatter" "File that describes the format.")
      (fmt-file f))

(program (format-bm [src-dir "source directory"] [output "output file"])
         ; (displayln (~a "source: " src-dir))
         ; (displayln (~a "output: " output))
         ; (displayln (~a "formatter:  " (fmt-file)))
         ()
         )

(run format-bm)
