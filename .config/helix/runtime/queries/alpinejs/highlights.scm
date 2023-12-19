; alpinejs
((attribute_name) @attr.name
 (#match? @attr.name "^x-")) @keyword
((attribute_name) @attr.name
 (#match? @attr.name "^[:@]")) @variable
