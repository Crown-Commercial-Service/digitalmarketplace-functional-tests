# Captures a literal value or a variable reference that gets resolved by a
# transform step into a value before being passed to the step definition
MAYBE_VAR = '((?:the )?(?:\'(?:.*)\')|(?:that (?:\w+)(?:(?:\.\w+)*)))'

Transform /^#{MAYBE_VAR}$/ do |whole_match|
  # to access the inner regex groups we have to perform the regex again with the groups captured. from what i can tell
  # Transforms don't work very well with multiple arguments, so we implement the transform itself as a single-argument
  # Transform and suck out the innards ourselves in this secondary regex matching...
  match = /^#{MAYBE_VAR.gsub("(?:", "(")}$/.match whole_match
  if match[4] # literal string
    match[4]
  else
    # get base variable name
    term = instance_variable_get("@#{match[6]}")
    # now iterate along the chain of hash keys (if any)
    (match[7]||'').split('.').each do |key|
      unless key.empty?
        term = term[key]
      end
    end
    term
  end
end
