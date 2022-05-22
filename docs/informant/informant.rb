#!/usr/bin/env ruby

# informant by Zed Lopez begins here.

require 'erubi'
require 'ostruct'
require 'fileutils'
extension_repo = 'https://github.com/i7/extensions'
url_roots = { ext_root: 'blob', auth_root: 'tree' }
vlist = [ '10.1', '9.3' ]
versions = { '10.1' => { filedir: 'docs', url: '..', repo: extension_repo, label: 'v10.1' } }
vlist.each do |v|
  next if versions.key?(v)
  versions[v] = { filedir: File.join('docs', v), url: v, repo: [ extension_repo, 'tree', v ].join('/') }
end
versions['9.3'][:label] = 'v9.3/6M62'

#versions = { '10.1' => { filedir: 'docs', url: '..' }, '9.3' => { filedir: File.join('docs', '9.3'), url: '9.3' } }

extension_dir = ARGV.shift || Dir.pwd


$conf = Hash[ url_roots.map {|k,v| [ k, [ extension_repo, v ].join('/') ] } ]

# for reference for potential future use
# raw_ext_url_root: "https://raw.githubusercontent.com/i7/extensions/"

require 'uri'
require 'erubi'
require 'pathname'
require 'cgi'

class Extension
  attr_reader :author, :filename, :name, :desc, :doc, :version, :limiter

def initialize(author, filename, name, desc, doc, version, limiter)
  @author = author
  @filename = filename
  @name = name
  @desc = desc
  @doc = doc
  @version = version
  @limiter = limiter
end

  def <=>(other)
    self.ext_id <=> other.ext_id
  end

  def ext_id
    [ @author, @name].map(&:downcase)
  end

def text
  @desc || @doc
end

#def auth_url(version)
#  [ $conf[:auth_root], version, uri_escape(@author)].join('/')
#end

def ext_url(version)
  [ $conf[:ext_root], version, uri_escape(@author), uri_escape(@filename)].join('/')
end

# Ruby 2.7+ blares warnings to STDERR about URI.escape's deprecation hence rolling our own
def uri_escape(str)
  str.split(//).map {|c| c.match(URI::UNSAFE) ? sprintf('%%%02x',c.ord).upcase : c }.join
end
  

end


globlist = [ '*', '*.i7x' ]

version_ext = {}

versions.keys.each do |version|
  version_ext[version] = { ext_hash: {}, errors: {} }
#if !ARGV.empty?
#  if ((ARGV.count > 1) or !File.directory?(ARGV.first))
#    STDERR.print("Usage: #{$0} [ extensions directory ]")
#    exit
#  end
#  globlist.unshift(ARGV.first)
#end
  
system("git checkout #{version}")
  
ext_hash = {}
errors = {}

Dir[File.join(globlist)].each do |path|
  ext_author, ext_filename = Pathname(path).each_filename.to_a.last(2)
  ext_name  = ext_filename.delete_suffix('.i7x')
  ext = { ext_author: ext_author, ext_name: ext_name, filename: ext_filename, desc: nil }
  slurp = File.read(path)
  begin
    line = slurp.match(/\A([^\n\r]+)/).captures.first.strip
    ext[:author] = (line.sub!(/(\s+by\s+(.+)\s+begins\s+here\s*\.)\Z/,'') ) ? $2 : nil
    ext[:limiter] = (line.sub!(/(\s*\(\s*for\s+([-\w]+)\s+only\s*\))\Z/,'') ) ?  $2.capitalize : nil
    ext[:version] = (line.sub!(/\A(\s*version\s+(.*?)\s+of\s+)/i,'') ) ?  $2 : nil
    ext[:name] = line
    identifier = [ext_author,ext_name].map(&:downcase) # extension names are case-insensitive
    unless ext[:author] == ext[:ext_author]
      version_ext[version][:errors][identifier] = "Author name mismatch with #{ext[:name]} by #{ext[:author]}"
      next
    end

    ext[:desc] = $1 if slurp.match(/\A[^\n\r]+\s*(?:\[[^\]]*\]\s*)*"([^"]*)"/)
    ext[:doc] = $1 if slurp.match(/---- DOCUMENTATION ----\s+(\S.*?)(\r?\n\r?\n|\Z)/i)
  rescue StandardError => e
    identifier = [ext_author,ext_name].map(&:downcase) # extension names are case-insensitive
    version_ext[version][:errors][ identifier ] = e.message
    next
  end
  ext_obj = Extension.new(ext[:author], ext[:filename], ext[:name], ext[:desc], ext[:doc], ext[:version], ext[:limiter])
  version_ext[version][:ext_hash][ ext_obj.ext_id ] = ext_obj
end
end

def render(tmpl, **hash)
  context = OpenStruct.new(hash).instance_eval { binding }
  eval(tmpl.src, context)
end

system("git checkout master")
#erb = ERB.new(DATA.read, nil, '-') #0, trim_mode: '>')
erubi = Erubi::Engine.new(DATA.read, escape: true)

pp version_ext
#version_ext.delete(nil) if version_ext.key?(nil)
versions.keys.each do |version|
  next unless version
  FileUtils.mkdir_p(versions[version][:filedir])
  ext_list = []
  #  version_ext[version][:ext_hash].keys.sort {|k| ext_list << version_ext[version][:ext_hash][k] }
  puts "writing #{File.join(versions[version][:filedir], 'index.html')}"
  File.open(File.join(versions[version][:filedir], 'index.html'), 'w') do |f|
    f.puts(render(erubi, ext_hash: version_ext[version][:ext_hash], errors: version_ext[version][:errors], version: version, versions: versions))
  end
end


# def uri_escape(str)
#   str.split(//).map {|c| c.match(URI::UNSAFE) ? sprintf('%%%02x',c.ord).upcase : c }.join
# end

# def auth_url(ext)
#   [ $conf[:auth_root], uri_escape(ext[:author])].join('/')
# end

# def ext_url(ext)
#   [ $conf[:ext_root], uri_escape(ext[:ext_author]), uri_escape(ext[:filename])].join('/')
# end

# <% unless errors.empty? %>
#   <div class="error">
#   <h2>Errors</h2>
#   <details><summary>Omitted extensions and reasons</summary>
#     <% errors.keys.sort.each do |ext_key| %>
#       <% ext = ext_hash[ext_key] %>
#     <p class="omission"><a href="<%= h.call(ext.ext_url) %>"><%= h.call(File.join(ext.author,ext.filename)) %></a>&emsp;<%= h.call(errors[ext_key]) %></p>
#   <% end %>
#   </details>
#   </div>
# <% end -%>



__END__
<% h = CGI.method(:escapeHTML) -%>
<!doctype html>
<html lang="en"><head><meta charset="UTF-8"><title>Friends of I7 Extensions for v<%= h.call(version) %></title>
<style>* { padding: 0; margin: 0 ; }
html { font-size: 100%; }
body { 
color: #080808; 
background-color: #FAFAFA;
color: #0A0A0A;
width: 41.5rem;
margin: auto;
font-size: 100%;
margin-bottom: 2rem;
font-family: Helvetica Neue,Helvetica,Arial,sans-serif;
} 
h1.title { text-align: center; margin-top: 1rem; margin-bottom: 2rem; }
.other-versions { font-weight: bold; }
.other-versions > ul { margin-top: 1rem; }
header { margin: auto; }
div.ext-table { line-height: 1.5; width: 40rem; margin-bottom: 2rem; }
a.title { text-decoration-style: dotted; }
hr.border { border: .05rem solid #333; margin: 1rem .5rem 1rem -1.5rem; }
div.ext-name {  white-space: nowrap; width: 100%; margin-top: .1rem; font-size: 1.25rem; text-indent: -1.5rem; }
div.ext-desc { margin-bottom: .5rem; padding-top: .25rem; }
div.empty-desc { text-align: right; margin-right: .5rem; }
span.link { font-weight: bold;} 
span.version { font-size: 1rem; }
span.limiter { font-style: italic; font-size: 1rem; }
span.code { font-family: monospace; }
div.error { margin-left: -1.5rem; }
h2 { margin-top: 1rem; margin-bottom: 1rem; }
details { border: .1rem solid black; padding: .5rem; }
summary { margin: .5rem 0 .5rem 0; }
p.omission { margin-bottom: .5rem; }
</style>
</head>
<body>
<header>
<h1 class="title"><a class="title" href="<%= versions[version][:repo] %>">Friends of I7 Extensions for <%= versions[version][:label] %></a></h1>
<div class="other-versions"><div>Looking for extensions for a different version?</div>
<ul>
<% versions.reject {|k,v| k == version }.each_pair do |vname, vhash| %>
<li><span class="link"><a href="<%= [ vhash[:url], 'index.html' ].join('/') %>">List of extensions for Inform 7 <%= versions[vname][:label] %></a></span></li>
<% end %>
</ul>
</div>
</header>
<main>
<div class="ext-table">
                                                                           <% ext_hash.keys.sort.each do |ext_key| -%>
                                                                                                                   <% ext = ext_hash[ext_key] %>
  <hr class="border">
  <div class="ext-entry"><div class="ext-name">
  <a class='ext' href="<%== ext.ext_url(version) %>"><span class='link'><%= ext.name %> by <%= ext.author %></span></a>
  <% if ext.version -%>
  &ensp;<span class="version">Version&nbsp;<%= ext.version %></span>
  <% end -%>
  <% if ext.limiter -%>
  &ensp;<span class="limiter">(for&nbsp;<%= ext.limiter %>&nbsp;only)</span>
  <% end -%>
  </div>
  <div class="ext-desc<% if ext.text %>"><%= ext.text %><% else %> empty-desc"><span class="code">(I see no description here.)</span><% end %></div>
  </div>
<% end -%>
</div>

</main></body></html>
