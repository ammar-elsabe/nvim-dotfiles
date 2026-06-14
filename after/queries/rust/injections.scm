; extends

;; SQL injection via content matching (same approach as go.nvim)
;; Matches string literals containing SQL keywords regardless of surrounding macro/function
([
  (string_content)
  (string_content)
] @injection.content
 (#match? @injection.content "(SELECT|select|INSERT|insert|UPDATE|update|DELETE|delete|CREATE|create|ALTER|alter|DROP|drop).+(FROM|from|INTO|into|VALUES|values|SET|set|TABLE|table|INDEX|index).*(WHERE|where|GROUP BY|group by)?")
 (#set! injection.language "sql"))
