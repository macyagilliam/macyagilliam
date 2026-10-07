require "nokogiri"
require "pathname"
require "uri"
require "yaml"

root = Pathname.new(ARGV.fetch(0, "_site")).expand_path
config = YAML.safe_load_file("_config.yml")
baseurl = ENV.fetch("SITE_BASEURL", config.fetch("baseurl", "")).sub(%r{/$}, "")
site_host = URI(config.fetch("url")).host
pages = root.glob("**/*.html")
abort "No built HTML found in #{root}. Run the Jekyll build first." if pages.empty?

documents = {}
document = ->(path) { documents[path] ||= Nokogiri::HTML(path.read) }
errors = []
checked = 0

pages.each do |page|
  html = document.call(page)
  html.css("img").each do |image|
    errors << "#{page.relative_path_from(root)}: image missing alt text" unless image.key?("alt")
  end

  html.css("[href], [src]").each do |element|
    %w[href src].each do |attribute|
      reference = element[attribute]
      next if reference.nil? || reference.empty?

      begin
        uri = URI.parse(reference)
        next if uri.scheme && !%w[http https].include?(uri.scheme)
        next if uri.host && uri.host != site_host

        path = URI::DEFAULT_PARSER.unescape(uri.path.to_s)
        target = if path.empty?
          page
        elsif path.start_with?("/")
          unless path == baseurl || path.start_with?("#{baseurl}/")
            raise "path does not use baseurl #{baseurl.inspect}"
          end
          root.join(path.delete_prefix(baseurl).delete_prefix("/"))
        else
          page.dirname.join(path)
        end
        target = target.expand_path
        unless target == root || target.to_s.start_with?("#{root}/")
          raise "path is outside the generated site"
        end
        target = target.join("index.html") if target.directory?
        raise "target does not exist" unless target.file?

        if uri.fragment && !uri.fragment.empty? && target.extname == ".html"
          fragment = URI::DEFAULT_PARSER.unescape(uri.fragment)
          anchors = document.call(target).css("[id], a[name]")
          unless anchors.any? { |anchor| anchor["id"] == fragment || anchor["name"] == fragment }
            raise "fragment ##{fragment} does not exist"
          end
        end
        checked += 1
      rescue URI::InvalidURIError, RuntimeError => error
        errors << "#{page.relative_path_from(root)}: #{reference.inspect}: #{error.message}"
      end
    end
  end
end

abort errors.join("\n") unless errors.empty?
puts "Checked #{pages.length} HTML pages and #{checked} local references; no missing targets or image alt attributes."
