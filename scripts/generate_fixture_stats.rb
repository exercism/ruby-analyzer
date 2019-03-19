$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "analyzer"

output = []
["two-fer"].each do |slug|
  output << slug
  output << "--------"

  path = File.expand_path("#{__FILE__}/../../analysis-data/#{slug}")
  p path
  statuses = Hash.new {|h,k|h[k] = 0}
  Dir.foreach(path) do |dir|
    next if dir == "." || dir == ".."

    begin
      Analyzer.analyze(slug, "#{path}/#{dir}")
      res = JSON.parse(File.read("#{path}/#{dir}/analysis.json"))
      statuses[res['status']] += 1
    rescue
      statuses["exploded"] += 1
    end
  end

  statuses.each do |status, score|
    output << "#{status}: #{score}"
  end

  output << "\n"
end

puts output.join("\n")
