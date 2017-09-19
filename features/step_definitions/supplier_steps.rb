Given 'There is at least one framework that can be applied to' do
  response = call_api(:get, "/frameworks")
  response.code.should be(200), _error(response, "Failed getting frameworks")
  frameworks = JSON.parse(response.body)['frameworks']
  frameworks.delete_if {|framework| not ['coming', 'open'].include?(framework['status'])}
  if frameworks.empty?
    puts 'Cannot create supplier if no coming or open frameworks'
    skip_this_scenario
  end
end