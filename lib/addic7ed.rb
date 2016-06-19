Dir[
  File.expand_path("lib/addic7ed/*.rb"),
  File.expand_path("lib/addic7ed/services/**/*.rb"),
  File.expand_path("lib/addic7ed/models/**/*.rb")
].each { |file| require file }
