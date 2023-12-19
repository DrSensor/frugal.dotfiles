; alpinejs
((attribute
  (attribute_name) @alpine.directive
  [(quoted_attribute_value (attribute_value) @injection.content)
   (attribute_value) @injection.content])
 (#match? @alpine.directive "^(?:x-|[:@])")
 (#set! injection.language "javascript"))
