# frozen_string_literal: true

Dir[
  File.join(File.dirname(__FILE__), "addic7ed/*.rb"),
  File.join(File.dirname(__FILE__), "addic7ed/services/**/*.rb"),
  File.join(File.dirname(__FILE__), "addic7ed/models/**/*.rb")
].each { |file| require file }
