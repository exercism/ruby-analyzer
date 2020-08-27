$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require "analyzer"

["two-fer"].each do |slug|
  path = File.expand_path("#{__FILE__}/../../test/fixtures/#{slug}")
  statuses = Hash.new { |h, k| h[k] = 0 }
  Dir.foreach(path) do |id|
    next if [".", ".."].include?(id)

    begin
      analysis = TwoFer::Analyze.(File.read("#{path}/#{id}/two_fer.rb"))
      p id and exit if analysis[:status] == :refer_to_mentor
    rescue StandardError
      p id and exit
      statuses["exploded"] += 1
    end
  end
end
