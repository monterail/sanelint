require "sanelint/version"

require "tempfile"
module Sanelint
  class Linter < Struct.new(:root)
    def call
      raise "Not Implemented"
    end

    def lint
      call
    end

    def output
      @output ||= JSON.parse(File.read(output_file))
    end

    def output_file
      @output_file ||= Tempfile.new(["sanelint", ".json"]).path
    end
  end

  class Entry < Struct.new(:level, :file, :line, :message, :code, :link,
                            :git_commit, :git_username, :git_date)

    def initialize(attrs = {})
      super()

      attrs.each {|k,v| send("#{k}=", v) }
    end
  end
end


require "brakeman"
module Sanelint
  class Brakeman < Linter
    def call
      ::Brakeman.run(options)

      ["warnings", "errors"].inject([]) do |list, type|
        entries = output[type].map do |e|
          Entry.new(
            :level      => type,
            :file       => e["file"],
            :line       => e["line"],
            :message    => e["message"],
            :code       => e["code"],
            :link       => e["link"]
          )
        end

        list + entries
      end
    end


    def options
      {
        :app_path             => root,
        :print_report         => true,
        :interprocedural      => true,
        :summary_only         => true,
        :output_files         => [output_file]
      }
    end
  end
end


require "rails_best_practices"
module Sanelint
  class RailsBestPractices < Linter
    def call
      analyzer = ::RailsBestPractices::Analyzer.new(root, options)
      analyzer.analyze
      analyzer.output

      output.map {|e| Entry.new(e) }
    end

    def options
      {
        "with-git"      => true,
        "format"        => "html",
        "template"      => results_template_path,
        "output-file"   => output_file
      }
    end

    def results_template_path
      File.expand_path("../sanelint/rails_best_practices/results.html.erb", __FILE__)
    end
  end
end



module Sanelint
  class Runner < Struct.new(:root)
    LINTERS = [
      Sanelint::RailsBestPractices,
      Sanelint::Brakeman
    ]

    def call
      run_linters
      fill_missing_info
      print_report
      save_report
    end

    def run_linters
      @entries = LINTERS.inject([]) do |entries, linter_klazz|
        linter = linter_klazz.new(root)
        entries + linter.lint
      end
    end

    def fill_missing_info
      @entries.each do |entry|
        if info = blame(entry.file, entry.line)
          entry.git_commit    = info[:commit]
          entry.git_date      = info[:date]
          entry.git_username  = info[:user]
          entry.code          = info[:code]
        end
      end
    end

    def blame(file, line)
      line = line.to_s.split(',').first

      # taken from rails_best_practices
      info = `cd #{root} && git blame -L #{line},+1 #{file}`
      if m = info.strip.match(/^\^?([0-9a-f]+)\s\((.+)\s+(\d{4}-\d{2}-\d{2}).+?\)(.+)$/)
        {
          :commit => m[1],
          :user   => m[2],
          :date   => m[3],
          :code   => m[4]
        }
      else
        nil
      end
    end

    def git_repo
      @git_repo ||= `git remote -v`[/github\.com(?:\/|:)(.+\/.+).git/, 1]
    end

    def print_report
      long_file = @entries.map {|e| e.file.size + e.line.to_s.size }.max

      puts
      @entries.each do |entry|
        puts "%-8s %-15s %-#{long_file+2}s %-40s" % [
          entry.git_commit,
          entry.git_username,
          "#{entry.file}:#{entry.line}",
          entry.message
        ]
      end
      puts
    end

    def save_report
      renderer = ERB.new(report_template)
      report = renderer.result(binding)
      File.open(File.join(root, "sanelint.html"), "w") {|f| f.write report }
      puts "Report saved to sanelint.html"
    end

    def report_template
      File.read(File.expand_path("../sanelint/report.html.erb", __FILE__))
    end
  end

  def self.run!
    runner = Runner.new(Dir.pwd)
    runner.call
  end
end
