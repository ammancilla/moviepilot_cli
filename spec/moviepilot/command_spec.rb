# 
# Test all the defined commands
# 

require 'spec_helper'

describe Moviepilot::Command do
  let(:exe) { File.expand_path('../../../bin/moviepilot', __FILE__) }

  describe "#run" do
    describe "trending" do
      it "display trending posts" do
        process = run_interactive("#{exe} trending")
        process.output

        expect(process.output).to include("TOP POSTS")
      end
    end

    describe "post" do
      context "with valid post ID" do
        it "display the post" do
          id = 3347745
          process = run_interactive("#{exe} post #{id}")
          process.output

          expect(process.output).to include("(#{id}) ***")
        end
      end

      context "with invalid post ID" do
        it "display an error message" do
          process = run_interactive("#{exe} post 1nv4l1d")
          process.output

          expect(process.output).to start_with("\nOops!") & end_with("doesn't exist.\n\n")
        end
      end
    end

    describe "search" do
      context "with results" do
        it "display the results" do
          query = 'marvel'
          process = run_interactive("#{exe} search #{query}")
          process.output

          expect(process.output).to include("results for '#{query}'")
        end
      end

      context "without results" do
        it "display an error message" do
          query = 'xx1nv4l1dqu3ryxx'
          process = run_interactive("#{exe} search #{query}")
          process.output

          expect(process.output).to include("Oops! No results found for '#{query}'")
        end
      end
    end
  end
end