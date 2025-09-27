; extends

;; sqlx::query!/query_as!/query_scalar! with a qualified path (sqlx::...)
((macro_invocation
  (scoped_identifier
    path: (identifier) @_path
    name: (identifier) @_name)
  (token_tree
    (string_literal (string_content) @injection.content)))
 (#eq? @_path "sqlx")
 (#match? @_name "^query(_as|_scalar)?$")
 (#set! injection.language "sql"))
 (#set! injection.combined)

((macro_invocation
  (scoped_identifier
    path: (identifier) @_path
    name: (identifier) @_name)
  (token_tree
    (raw_string_literal (string_content) @injection.content)))
 (#eq? @_path "sqlx")
 (#match? @_name "^query(_as|_scalar)?$")
 (#set! injection.language "sql"))
 (#set! injection.combined)

;; Unqualified macro after `use sqlx::query;` etc.
((macro_invocation
  (identifier) @_name
  (token_tree
    (string_literal (string_content) @injection.content)))
 (#match? @_name "^query(_as|_scalar)?$")
 (#set! injection.language "sql"))
 (#set! injection.combined)

((macro_invocation
  (identifier) @_name
  (token_tree
    (raw_string_literal (string_content) @injection.content)))
 (#match? @_name "^query(_as|_scalar)?$")
 (#set! injection.language "sql"))
 (#set! injection.combined)
