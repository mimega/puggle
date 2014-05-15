require 'colorize'

module Puggle
  class LoggingFormatter < ActiveSupport::Logger::Formatter
    include ActiveSupport::TaggedLogging::Formatter

    def call (severity, timestamp, _progname, msg)
      unless msg.blank?
        "[#{process_id}] [#{timestamp}] [#{color_severity(severity)}] #{tags_text}#{msg}\n"
      end
    end

    def color_severity (severity)
      case severity
      when "ERROR", "FATAL" then severity.red
      when "WARN" then severity.yellow
      else
        severity
      end
    end

    def process_id
      @process_id ||= Process.pid
    end
  end
end
