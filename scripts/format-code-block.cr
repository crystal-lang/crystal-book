#!/usr/bin/env crystal
#
# This script parses output from `mkdocs build --strict` to find ill-formatted
# code blocks and applies the updated formatting (from the formatter STDOUT).

io = STDIN
docs_path = Path["docs"]

loop do
  line = io.gets || exit
  line.starts_with?("WARNING -  In file") || next
  filename = line[/(?<=')[^']+(?=')/]? || next
  filename = docs_path / filename

  io.gets # skip -------- Input --------

  input = IO::Delimited.new(io, "\n-------- Output --------\n").gets_to_end
  output = IO::Delimited.new(io, "formatting 'STDIN' produced changes\n").gets_to_end

  original_content = File.read(filename)
  content = original_content.sub input, output
  File.write(filename, content)
end
