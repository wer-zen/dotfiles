# Configure PATH to search for external command completions
$env.path = $env.path
| split row (char esep)
| append ($env.HOME | path join ".cargo" "bin")
| uniq

# Set up external completer (requires carapace)
$env.CARAPACE_LENIENT = 1
$env.CARAPACE_BRIDGES = 'zsh'
$env.config.completions.external.completer = {|spans: list<string>|
  carapace $spans.0 nushell ...$spans
  | from json
  | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

# Define extra library directories to load definitions from
const NU_LIB_DIRS = ["some/extra/lib"]
