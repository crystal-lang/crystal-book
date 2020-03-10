require "yaml"
require "file_utils"

content_folders = %w(conventions database guides overview syntax_and_semantics the_shards_command using_the_compiler)
source_folder = Path["source"]
collections_folder = source_folder.join("collections")

Dir["{#{content_folders.join(",")}}/**/*.md"].each do |source_path|
  File.open(source_path, "r") do |source|
    first_line = source.gets
    unless first_line && first_line.starts_with?("# ")
      STDERR.puts "#{source_path} does not start with headline"
      next
    end
    headline = first_line[2..].strip
    destination_path = collections_folder.join("_#{source_path}")
    FileUtils.mkdir_p(destination_path.dirname)
    File.open(destination_path, "w") do |destination|
      {
        "title" => headline
      }.to_yaml(destination)
      destination.puts "---"
      IO.copy(source, destination)
    end
  end
end
