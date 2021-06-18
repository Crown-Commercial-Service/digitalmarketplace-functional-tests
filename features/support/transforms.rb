# Captures a literal value or a variable reference that gets resolved by a
# transform step into a value before being passed to the step definition

MAYBE_VAR_RE = '(?:the )?(?:\'(?<value>.*)\')|(?:that (?<quoted>quoted )?(?<variable>\w+)(?<attributes>(?:\.[\w-]+)*))'
MAYBE_VAR = MAYBE_VAR_RE.gsub(/<[a-z]+>/, ':')

# the following transform, used in conjunction with our habit of putting quotation marks
# *outside* our steps' capture groups, is unfortunately overzealous - causing any captured
# parameter to be possibly transformed if e.g. beginning with "that ".
# TODO we should decide what to do about this, possibly by making _all_ our outer-quoted
# capture groups use MAYBE_VAR somehow

ParameterType(
  name: 'maybe_var',
  regexp: /#{MAYBE_VAR}/,
  transformer: -> (maybe_var) {
    match = /^#{MAYBE_VAR_RE}$/.match maybe_var
    if match[:value] # literal string
      match[:value]
    else
      # get base variable name
      term = instance_variable_get("@#{match[:variable]}")
      # now iterate along the chain of hash keys (if any)
      (match[:attributes] || '').split('.').each do |key|
        unless key.empty?
          term = term[key]
        end
      end
      term = "\"#{term}\"" if match[:quoted]
      term
    end
  }
)
