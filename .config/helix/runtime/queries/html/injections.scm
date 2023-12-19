; <script>
((script_element
  (start_tag (attribute
              (attribute_name) @attr.name
              (_)?)*)
  (raw_text) @injection.content)
 (#not-eq? @attr.name "type")
 (#set! injection.language "javascript"))

; <script type=...>{javascript code}</script>
((script_element
  (start_tag (attribute
              (attribute_name) @attr.name
              [(quoted_attribute_value (attribute_value) @attr.value)
               (attribute_value) @attr.value]))
  (raw_text) @injection.content)
 (#eq? @attr.name "type")
 (#match? @attr.value "^(?:module|text/javascript)$")
 (#set! injection.language "javascript"))

; <script type=...>{json config}</script>
((script_element
  (start_tag (attribute
              (attribute_name) @attr.name
              [(quoted_attribute_value (attribute_value) @attr.value)
               (attribute_value) @attr.value]))
  (raw_text) @injection.content)
 (#eq? @attr.name "type")
 (#match? @attr.value "^(?:importmap|speculationrules)$")
 (#set! injection.language "json"))

; <style>
((style_element
  (start_tag (attribute
              (attribute_name) @attr.name
              (_)?)*)
  (raw_text) @injection.content)
 (#not-eq? @attr.name "type")
 (#set! injection.language "css"))

; <style type=text/css>
((style_element
  (start_tag (attribute
              (attribute_name) @attr.name
              [(quoted_attribute_value (attribute_value) @attr.value)
               (attribute_value) @attr.value]))
  (raw_text) @injection.content)
 (#eq? @attr.name "type")
 (#eq? @attr.value "text/css")
 (#set! injection.language "css"))

((comment) @injection.content
 (#set! injection.language "comment"))

; alpinejs
((attribute
  (attribute_name) @alpine.directive
  [(quoted_attribute_value (attribute_value) @injection.content)
   (attribute_value) @injection.content])
 (#match? @alpine.directive "^(?:x-|[:@])")
 (#set! injection.language "javascript"))

