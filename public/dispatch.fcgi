#!/usr/bin/ruby
require File.join(File.dirname(__FILE__), '../config/environment')       
require 'rack'

## Added by scripts.mit.edu autoinstaller to reload when app code changes
Thread.abort_on_exception = true

class Rack::PathInfoRewriter
  def initialize(app)
    @app = app
  end

  def call(env)
    env["SCRIPT_NAME"] = ""
    parts = env['REQUEST_URI'].split('?')
    env['PATH_INFO'] = parts[0]
    env['QUERY_STRING'] = parts[1].to_s
    @app.call(env)
  end
end


t1 = Thread.new do
  dispatch_logger = Logger.new(File.join(Rails.root,'log/dispatcher.log'))

  begin
    Rack::Handler::FastCGI.run Rack::PathInfoRewriter.new(Rack::URLMap.new("/mitdoodle" => Mitdoodle::Application))
  rescue => e
   dispatch_logger.error(e)
   raise e
  end
end
t2 = Thread.new do
   # List of directories to watch for changes before reload.
   # You may want to also watch public or vendor, depending on your needs.
   Thread.current[:watched_dirs] = ['app', 'config', 'db', 'lib']

   # List of specific files to watch for changes.
   Thread.current[:watched_files] = ['public/dispatch.fcgi',
				     'public/.htaccess']
   # Sample filter: /(.rb|.erb)$/.  Default filter: watch all files
   Thread.current[:watched_extensions] = //
   # Iterations since last reload
   Thread.current[:iterations] = 0

   def modified(file)
     begin
       mtime = File.stat(file).mtime
     rescue
       false
     else
       if Thread.current[:iterations] == 0
         Thread.current[:modifications][file] = mtime
       end
       Thread.current[:modifications][file] != mtime
     end
   end

   # Don't symlink yourself into a loop.  Please.  Things will still work
   # (Linux limits your symlink depth) but you will be sad
   def modified_dir(dir)
     Dir.new(dir).each do |file|
       absfile = File.join(dir, file)
       if FileTest.directory? absfile
         next if file == '.' or file == '..'
         return true if modified_dir(absfile)
       else
         return true if Thread.current[:watched_extensions] =~ absfile &&
	   modified(absfile)
       end
     end
     false
   end

   def reload
     Thread.current[:modifications] = {}
     Thread.current[:iterations] = 0
     # This is a kludge, but at the same time it works.
     # Will kill the current FCGI process so that it is reloaded
     # at next request.
     raise RuntimeError
   end

   Thread.current[:modifications] = {}
   # Wait until the modify time changes, then reload.
   while true
     dir_modified = Thread.current[:watched_dirs].inject(false) {|z, dir| z || modified_dir(File.join(File.dirname(__FILE__), '..', dir))}
     file_modified = Thread.current[:watched_files].inject(false) {|z, file| z || modified(File.join(File.dirname(__FILE__), '..', file))}
     reload if dir_modified || file_modified
     Thread.current[:iterations] += 1
     sleep 1
   end
end

t1.join
t2.join
## End of scripts.mit.edu autoinstaller additions
