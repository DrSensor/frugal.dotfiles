(tag_name) @tag
(erroneous_end_tag_name) @tag.error
(doctype) @constant
(attribute_name) @attribute
(attribute_value) @string
(comment) @comment
["<" ">" "</" "/>"] @punctuation.bracket

; alpinejs
((attribute_name) @attr.name
 (#match? @attr.name "^x-")) @keyword
((attribute_name) @attr.name
 (#match? @attr.name "^[:@]")) @variable
