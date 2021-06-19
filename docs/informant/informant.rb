#!/usr/bin/env ruby

# informant by Zed Lopez begins here.

extension_repo = 'https://github.com/i7/extensions'
url_roots = { ext_root: 'blob/master', auth_root: 'tree/master' }

$conf = Hash[ url_roots.map {|k,v| [ k, [ extension_repo, v ].join('/') ] } ]

# for reference for potential future use
# raw_ext_url_root: "https://raw.githubusercontent.com/i7/extensions/master"

require 'uri'
require 'erb'
require 'pathname'

globlist = [ '*', '*.i7x' ]
if !ARGV.empty?
  if ((ARGV.count > 1) or !File.directory?(ARGV.first))
    STDERR.print("Usage: #{$0} [ extensions directory ]")
    exit
  end
  globlist.unshift(ARGV.first)
end

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
    # extension names are case-insensitive
    unless ext[:name].downcase == ext[:ext_name].downcase and ext[:author] == ext[:ext_author]
      errors[ext] = "Title or name mismatch with #{ext[:name]} by #{ext[:author]}"
      next
    end

    ext[:desc] = $1 if slurp.match(/\A[^\n\r]+\s*(?:\[[^\]]*\]\s*)*"([^"]*)"/)
    ext[:doc] = $1 if slurp.match(/---- DOCUMENTATION ----\s+(\S.*?)(\r?\n\r?\n|\Z)/i)
    ext[:text] = ext[:desc] || ext[:doc]
    
  rescue StandardError => e
    errors[ext] = e.message
    next
  end
  ext_hash[ [ext_name,ext_author] ] = ext
end

# Ruby 2.7+ blares warnings to STDERR about URI.escape's deprecation hence rolling our own
def uri_escape(str)
  str.split(//).map {|c| c.match(URI::UNSAFE) ? sprintf('%%%02x',c.ord).upcase : c }.join
end

def auth_url(ext)
  [ $conf[:auth_root], uri_escape(ext[:author])].join('/')
end

def ext_url(ext)
  [ $conf[:ext_root], uri_escape(ext[:ext_author]), uri_escape(ext[:filename])].join('/')
end

erb = ERB.new(DATA.read, nil, '-') #0, '>')
puts erb.result(binding)

__END__
<% h = CGI.method(:escapeHTML) -%>
<!doctype html>
<html lang="en"><head><meta charset="UTF-8"><title>Friends of I7 Extensions</title>
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
} 
h1.title { text-align: center; font-family: Constantia,Lucida Bright,Lucidabright,"Lucida Serif",Lucida,"DejaVu Serif","Bitstream Vera Serif","Liberation Serif",Georgia,serif; margin-top: 1rem; margin-bottom: 2rem; }
div.ext-table { line-height: 1.5; font-family: Helvetica Neue,Helvetica,Arial,sans-serif; width: 40rem; margin-bottom: 2rem; }
a.title { text-decoration-style: dotted; }
div.ext-table-body { }
hr.border { border: .05rem solid #333; margin: 1rem .5rem 1rem -1.5rem; }
div.ext-name {  white-space: nowrap; width: 100%; margin-top: .1rem; font-size: 1.25rem; text-indent: -1.5rem; }
div.ext-desc { margin-bottom: .5rem; padding-top: .25rem; }
div.empty-desc { text-align: right; margin-right: .5rem; }
a.ext { }
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
<body><main>
<h1 class="title"><a class="title" href="https://github.com/i7/extensions/">Friends of I7 Extensions</a></h1>
<div class="ext-table">
<% ext_hash.values.sort_by {|b| [ b[:name].downcase, b[:author].downcase ] }.each do |ext| -%>
  <hr class="border">
  <div class="ext-entry"><div class="ext-name">
  <a class='ext' href="<%= h.call(ext_url(ext)) %>"><span class='link'><%= h.call(ext[:name]) %> by <%= h.call(ext[:author]) %></span></a>
  <% if ext[:version] -%>
  &ensp;<span class="version">Version&nbsp;<%= h.call(ext[:version]) %></span>
  <% end -%>
  <% if ext[:limiter] -%>
  &ensp;<span class="limiter">(for&nbsp;<%= h.call(ext[:limiter]) %>&nbsp;only)</span>
  <% end -%>
  </div>
  <div class="ext-desc<% if ext[:text] %>"><%= h.call(ext[:text]) %><% else %> empty-desc"><span class="code">(I see no description here.)</span><% end %></div>
  </div>
<% end -%>
</div>

<% unless errors.empty? %>
  <div class="error">
  <h2>Errors</h2>
  <details><summary>Omitted extensions and reasons</summary>
  <% errors.keys.sort_by {|b| [ b[:ext_author], b[:filename] ] }.each do |ext| %>
    <p class="omission"><a href="<%= h.call(ext_url(ext)) %>"><%= h.call(File.join(ext[:ext_author],ext[:filename])) %></a>&emsp;<%= h.call(errors[ext]) %></p>
  <% end %>
  </details>
  </div>
<% end -%>
</main></body></html>
